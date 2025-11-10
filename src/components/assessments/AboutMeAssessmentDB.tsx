import { useState, useEffect } from 'react';
import { useAuth } from '@/hooks/useAuth';
import { supabase } from '@/integrations/supabase/client';
import { Button } from '@/components/ui/button';
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from '@/components/ui/card';
import { Textarea } from '@/components/ui/textarea';
import { Badge } from '@/components/ui/badge';
import { Progress } from '@/components/ui/progress';
import { Input } from '@/components/ui/input';
import { 
  CheckCircle, 
  User,
  Heart,
  Star,
  Target,
  ArrowLeft,
  Save,
  AlertTriangle
} from 'lucide-react';
import { useToast } from '@/hooks/use-toast';
import { useNavigate } from 'react-router-dom';
import { Tooltip, TooltipContent, TooltipProvider, TooltipTrigger } from '@/components/ui/tooltip';
import { AssessmentService, AssessmentTemplate } from '@/services/assessmentService';
import { handleDatabaseError, validateApiResponse } from '@/utils/errorHandler';

interface AboutMeResponse {
  [key: string]: string;
}

export default function AboutMeAssessmentDB() {
  const { userProfile } = useAuth();
  const { toast } = useToast();
  const [assessmentTemplate, setAssessmentTemplate] = useState<AssessmentTemplate | null>(null);
  const [responses, setResponses] = useState<AboutMeResponse>({});
  const [loading, setLoading] = useState(true);
  const [submitting, setSubmitting] = useState(false);
  const [isCompleted, setIsCompleted] = useState(false);
  const [helpOpen, setHelpOpen] = useState<Record<string, boolean>>({});
  const navigate = useNavigate();

  const helpKey = (questionIndex: number) => `question${questionIndex}`;
  const toggleHelp = (k: string) => setHelpOpen(prev => ({ ...prev, [k]: !prev[k] }));

  // Load assessment data from database
  useEffect(() => {
    const loadAssessmentData = async () => {
      try {
        setLoading(true);
        console.log('🔄 Loading About Me questions from database...');
        
        const { data, error } = await supabase.rpc('get_about_me_questions');
        
        if (error) {
          handleDatabaseError(error, 'AboutMeAssessment');
          throw error;
        }
        
        if (validateApiResponse(data, 'AboutMeAssessment')) {
          console.log('✅ Database questions loaded:', data.length, 'questions');
          
          // Create a simple template structure for compatibility
          const template: AssessmentTemplate = {
            template_id: 'about_me',
            title: 'About Me Assessment',
            description: 'Think about yourself — what are things you do well and need help with?',
            instructions: 'Complete all questions to finish your assessment',
            sections: [{
              id: 'about_me_section',
              title: 'About Me Questions',
              description: 'Answer these questions about yourself',
              sequence_number: 1,
              questions: data.map((q: any, index: number) => ({
                id: `question${index + 1}`,
                question_text: q.question_text,
                question_type: 'textarea' as const,
                help_text: q.help_text,
                is_required: true,
                sequence_number: q.sequence_number,
                options: []
              }))
            }]
          };
          
          setAssessmentTemplate(template);
          
          // Initialize responses structure
          const initialResponses: AboutMeResponse = {};
          template.sections[0].questions.forEach((question, questionIndex) => {
            const questionKey = `question${questionIndex + 1}`;
            initialResponses[questionKey] = '';
          });
          setResponses(initialResponses);
        } else {
          console.log('⚠️ No questions found in database, using fallback');
        }
      } catch (error) {
        console.error('Error loading assessment data:', error);
        toast({
          title: "Error",
          description: "Failed to load assessment data. Please try again.",
          variant: "destructive",
        });
      } finally {
        setLoading(false);
      }
    };

    loadAssessmentData();
  }, []);

  // Check for existing responses on load
  useEffect(() => {
    const checkExistingResponse = async () => {
      if (!userProfile || loading) return;
      
      try {
        let studentId = userProfile.studentProfile?.id as string | undefined;
        if (!studentId) {
          const { data: studentRow } = await supabase
            .from('students')
            .select('id')
            .eq('user_id', userProfile.id)
            .maybeSingle();
          studentId = studentRow?.id;
        }
        if (!studentId) return;

        const { data: existing } = await supabase
          .from('assessment_responses')
          .select('responses, completed_at')
          .eq('student_id', studentId)
          .eq('assessment_type', 'personality')
          .eq('assessment_title', 'About Me')
          .order('updated_at', { ascending: false })
          .limit(1)
          .maybeSingle();

        if (existing) {
          if (existing.responses) {
            setResponses(existing.responses);
          }
          if (existing.completed_at) {
            setIsCompleted(true);
          }
        }
      } catch (error) {
        console.error('Error checking existing response:', error);
      }
    };

    checkExistingResponse();
  }, [userProfile, loading]);

  // Auto-save draft on changes (debounced)
  useEffect(() => {
    if (loading || isCompleted) return;
    const t = setTimeout(async () => {
      try {
        if (!userProfile?.id) return;
        let studentId = userProfile.studentProfile?.id as string | undefined;
        if (!studentId) {
          const { data: studentRow } = await supabase
            .from('students')
            .select('id')
            .eq('user_id', userProfile.id)
            .maybeSingle();
          studentId = studentRow?.id;
        }
        if (!studentId) return;
        await supabase.from('assessment_responses').upsert({
          student_id: studentId,
          assessment_type: 'personality',
          assessment_title: 'About Me',
          responses,
          updated_at: new Date().toISOString(),
          completed_at: null
        });
      } catch {}
    }, 800);
    return () => clearTimeout(t);
  }, [responses, loading, isCompleted, userProfile]);

  const handleResponseChange = (questionKey: string, value: string) => {
    setResponses(prev => ({
      ...prev,
      [questionKey]: value
    }));
  };

  const handleSubmit = async () => {
    if (!userProfile) return;

    setSubmitting(true);
    try {
      let studentId = userProfile.studentProfile?.id as string | undefined;
      if (!studentId) {
        const { data: studentRow } = await supabase
          .from('students')
          .select('id')
          .eq('user_id', userProfile.id)
          .maybeSingle();
        studentId = studentRow?.id;
      }
      if (!studentId) throw new Error('Student ID not found');

      await supabase.from('assessment_responses').upsert({
        student_id: studentId,
        assessment_type: 'personality',
        assessment_title: 'About Me',
        responses,
        completed_at: new Date().toISOString(),
        updated_at: new Date().toISOString()
      });

      setIsCompleted(true);
      toast({
        title: "Assessment Completed",
        description: "Your About Me assessment has been submitted successfully.",
      });
    } catch (error) {
      console.error('Error submitting assessment:', error);
      toast({
        title: "Error",
        description: "Failed to submit assessment. Please try again.",
        variant: "destructive",
      });
    } finally {
      setSubmitting(false);
    }
  };

  const isComplete = () => {
    if (!assessmentTemplate) return false;
    
    return assessmentTemplate.sections.every(section => 
      section.questions.every((_, questionIndex) => {
        const questionKey = `question${questionIndex + 1}`;
        const response = responses[questionKey];
        return response && response.trim() !== '';
      })
    );
  };

  if (loading) {
    return (
      <div className="min-h-screen bg-gradient-to-br from-blue-50 to-indigo-100 flex items-center justify-center">
        <div className="text-center">
          <div className="animate-spin rounded-full h-12 w-12 border-b-2 border-blue-600 mx-auto mb-4"></div>
          <p className="text-gray-600">Loading assessment...</p>
        </div>
      </div>
    );
  }

  if (isCompleted) {
    return (
      <div className="min-h-screen bg-gradient-to-br from-blue-50 to-indigo-100 flex items-center justify-center">
        <Card className="w-full max-w-2xl mx-4">
          <CardContent className="p-8 text-center">
            <CheckCircle className="h-16 w-16 text-green-500 mx-auto mb-4" />
            <h2 className="text-2xl font-bold text-gray-900 mb-2">Assessment Completed!</h2>
            <p className="text-gray-600 mb-6">
              Thank you for completing the About Me Assessment. Your responses have been saved.
            </p>
            <Button onClick={() => navigate('/student-dashboard')} className="w-full">
              Return to Dashboard
            </Button>
          </CardContent>
        </Card>
      </div>
    );
  }

  if (!assessmentTemplate) {
    return (
      <div className="min-h-screen bg-gradient-to-br from-blue-50 to-indigo-100 flex items-center justify-center">
        <div className="text-center">
          <p className="text-gray-600">Failed to load assessment data.</p>
        </div>
      </div>
    );
  }

  return (
    <div className="min-h-screen bg-gradient-to-br from-blue-50 to-indigo-100">
      <div className="container mx-auto px-4 py-8">
        {/* Header */}
        <div className="mb-8">
          <Button
            variant="ghost"
            onClick={() => navigate('/student-dashboard')}
            className="mb-4"
          >
            <ArrowLeft className="h-4 w-4 mr-2" />
            Back to Dashboard
          </Button>
          
          <div className="flex items-center justify-between mb-4">
            <div>
              <h1 className="text-3xl font-bold text-gray-900">About Me Assessment</h1>
              <p className="text-gray-600 mt-2">
                {assessmentTemplate.description}
              </p>
            </div>
            <Badge variant="outline" className="text-sm">
              Self Reflection
            </Badge>
          </div>
        </div>

        <div className="max-w-4xl mx-auto">
          <Card>
            <CardHeader>
              <CardTitle className="flex items-center gap-2">
                <User className="h-5 w-5" />
                Tell us about yourself
              </CardTitle>
              <CardDescription>
                Share your thoughts and experiences to help us understand you better.
              </CardDescription>
              <p className="mt-3 text-sm text-gray-700 leading-relaxed">
                The goal is to uncover your strengths, areas for growth, passions, challenges, opinions, and emotions. This process aids in self-discovery, providing valuable insights into your character. Seeking guidance from family, friends, teachers, and mentors can offer additional clarity, enhancing your understanding of yourself.
              </p>
            </CardHeader>
            <CardContent className="space-y-6">
              {assessmentTemplate.sections.map((section, sectionIndex) => (
                <div key={section.id} className="space-y-6">
                  <div className="border-b pb-4">
                    <h3 className="text-lg font-semibold text-gray-800 mb-2">
                      {section.title}
                    </h3>
                    {section.description && (
                      <p className="text-gray-600 text-sm">{section.description}</p>
                    )}
                  </div>
                  
                  {section.questions.map((question, questionIndex) => {
                    const questionKey = `question${questionIndex + 1}`;
                    const currentResponse = responses[questionKey] || '';
                    const helpKeyValue = helpKey(questionIndex);
                    const isHelpOpen = helpOpen[helpKeyValue];

                    return (
                      <div key={question.id} className="space-y-3">
                        <div className="flex items-start justify-between">
                          <label className="text-sm font-medium text-gray-700">
                            {question.question_text}
                          </label>
                          {question.help_text && (
                            <TooltipProvider>
                              <Tooltip>
                                <TooltipTrigger asChild>
                                  <Button
                                    variant="ghost"
                                    size="sm"
                                    onClick={() => toggleHelp(helpKeyValue)}
                                    className="h-6 w-6 p-0"
                                  >
                                    <AlertTriangle className="h-4 w-4" />
                                  </Button>
                                </TooltipTrigger>
                                <TooltipContent>
                                  <p>Click for help text</p>
                                </TooltipContent>
                              </Tooltip>
                            </TooltipProvider>
                          )}
                        </div>

                        {isHelpOpen && question.help_text && (
                          <div className="p-3 bg-blue-50 border border-blue-200 rounded-md">
                            <p className="text-sm text-blue-800">{question.help_text}</p>
                          </div>
                        )}

                        <Textarea
                          value={currentResponse}
                          onChange={(e) => handleResponseChange(questionKey, e.target.value)}
                          placeholder="Share your thoughts..."
                          className="min-h-[100px]"
                        />
                      </div>
                    );
                  })}
                </div>
              ))}

              {/* Submit Button */}
              <div className="flex justify-center pt-6 border-t">
                <div className="flex gap-4">
                  <Button
                    variant="outline"
                    onClick={() => toast({ title: "Draft Saved", description: "Your progress has been saved." })}
                  >
                    <Save className="h-4 w-4 mr-2" />
                    Save Draft
                  </Button>
                  
                  <Button
                    onClick={handleSubmit}
                    disabled={submitting || !isComplete()}
                    size="lg"
                  >
                    {submitting ? 'Submitting...' : 'Complete Assessment'}
                  </Button>
                </div>
              </div>
            </CardContent>
          </Card>
        </div>
      </div>
    </div>
  );
}
