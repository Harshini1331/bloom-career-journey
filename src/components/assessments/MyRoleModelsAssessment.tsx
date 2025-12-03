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
  Users,
  Heart,
  Star,
  Target,
  Lightbulb,
  TrendingUp,
  UserCheck,
  MessageCircle,
  Award,
  BookOpen,
  Save
} from 'lucide-react';
import { useToast } from '@/hooks/use-toast';
import { useNavigate, useSearchParams } from 'react-router-dom';
import { useLang } from '@/hooks/useLang';
import { ArrowLeft } from 'lucide-react';
import { Tooltip, TooltipContent, TooltipProvider, TooltipTrigger } from '@/components/ui/tooltip';
import { KannadaKeyboard } from '@/components/ui/KannadaKeyboard';
import { checkAssessmentUnlock } from '@/utils/assessmentUnlock';

interface RoleModel {
  name: string;
  relationship: string;
  admirationReasons: string;
  profession: string;
  desiredQualities: string;
  careerDiscussed: string;
  opinion: string;
  willingToHelp: string;
  helpLookingFor: string;
  similarities: string;
  incorporatePlan: string;
}

interface RoleModelsAssessmentResponse {
  roleModel1: RoleModel;
  roleModel2: RoleModel;
  roleModel3: RoleModel;
  question12: string; // Similarities between personality traits
  question13: string; // How to cultivate and incorporate qualities
}

export default function MyRoleModelsAssessment() {
  const { userProfile } = useAuth();
  const { t, lang } = useLang();
  const { toast } = useToast();
  const navigate = useNavigate();
  const [searchParams] = useSearchParams();
  const readOnlyView = ['1','true'].includes((searchParams.get('readonly')||searchParams.get('view')||'').toLowerCase());
  const [responses, setResponses] = useState<RoleModelsAssessmentResponse>({
    roleModel1: {
      name: '',
      relationship: '',
      admirationReasons: '',
      profession: '',
      desiredQualities: '',
      careerDiscussed: '',
      opinion: '',
      willingToHelp: '',
      helpLookingFor: '',
      similarities: '',
      incorporatePlan: ''
    },
    roleModel2: {
      name: '',
      relationship: '',
      admirationReasons: '',
      profession: '',
      desiredQualities: '',
      careerDiscussed: '',
      opinion: '',
      willingToHelp: '',
      helpLookingFor: '',
      similarities: '',
      incorporatePlan: ''
    },
    roleModel3: {
      name: '',
      relationship: '',
      admirationReasons: '',
      profession: '',
      desiredQualities: '',
      careerDiscussed: '',
      opinion: '',
      willingToHelp: '',
      helpLookingFor: '',
      similarities: '',
      incorporatePlan: ''
    },
    question12: '',
    question13: ''
  });
  const [loading, setLoading] = useState(true);
  const [submitting, setSubmitting] = useState(false);
  const [isCompleted, setIsCompleted] = useState(false);
  const [currentTab, setCurrentTab] = useState<'roleModel1' | 'roleModel2' | 'roleModel3'>('roleModel1');
  const [saving, setSaving] = useState(false);
  const [savedTabs, setSavedTabs] = useState<Partial<Record<keyof RoleModelsAssessmentResponse, string>>>({});
  const [q, setQ] = useState<Record<string, string>>({});

  // Check if assessment is unlocked
  useEffect(() => {
    const checkUnlock = async () => {
      if (!userProfile) return;

      let studentId = userProfile.studentProfile?.id as string | undefined;
      if (!studentId) {
        const { data } = await supabase.from('students').select('id').eq('user_id', userProfile.id).maybeSingle();
        studentId = data?.id;
      }
      if (!studentId) return;

      const unlockResult = await checkAssessmentUnlock(studentId, 'role_models');
      
      if (!unlockResult.isUnlocked) {
        toast({
          title: lang === 'kn' ? 'ಮೌಲ್ಯಮಾಪನ ಲಾಕ್ ಮಾಡಲಾಗಿದೆ' : lang === 'ta' ? 'செயல் பூட்டப்பட்டுள்ளது' : 'Assessment Locked',
          description: lang === 'kn' 
            ? `ದಯವಿಟ್ಟು ಮೊದಲು "${unlockResult.missingPrerequisites.join(', ')}" ಪೂರ್ಣಗೊಳಿಸಿ.`
            : lang === 'ta'
            ? `"${unlockResult.missingPrerequisites.join(', ')}" செயல்களை முதலில் முடித்தால் இந்த பகுதி திறக்கும்.`
            : `Please complete "${unlockResult.missingPrerequisites.join(', ')}" first.`,
          variant: 'destructive',
        });
        navigate('/student');
      }
    };

    checkUnlock();
  }, [userProfile, navigate, toast, lang]);

  useEffect(() => {
    checkExistingResponse();
  }, []);

  useEffect(() => {
    const loadI18n = async () => {
      try {
        const { data } = await supabase.rpc('get_role_models_questions_i18n', { p_lang: lang } as any);
        const arr = Array.isArray(data) ? data : (data?.data || []);
        const map: Record<string, string> = {};
        (arr || []).forEach((row: any) => { if (row?.key) map[row.key] = row.text; });
        setQ(map);
      } catch {}
    };
    loadI18n();
  }, [lang]);

  // Keep URL ?lang in sync without re-rendering
  useEffect(() => {
    try {
      const url = new URL(window.location.href);
      const current = url.searchParams.get('lang');
      if (current !== lang) {
        url.searchParams.set('lang', lang);
        const next = `${url.pathname}?${url.searchParams.toString()}${url.hash}`;
        const now = `${window.location.pathname}${window.location.search}${window.location.hash}`;
        if (next !== now) window.history.replaceState(window.history.state, '', next);
      }
    } catch {}
  }, [lang]);

  // Auto-save drafts on changes (debounced)
  useEffect(() => {
    if (loading || isCompleted) return;
    const t = setTimeout(async () => {
      try {
        if (!userProfile?.id) return;
        let studentId = userProfile.studentProfile?.id as string | undefined;
        if (!studentId) {
          const { data: row } = await supabase.from('students').select('id').eq('user_id', userProfile.id).maybeSingle();
          studentId = row?.id;
        }
        if (!studentId) return;
        await supabase.from('assessment_responses').upsert({
          student_id: studentId,
          assessment_type: 'role_models',
          assessment_title: 'My Role Models',
          responses,
          updated_at: new Date().toISOString(),
          completed_at: null
        });
      } catch {}
    }, 800);
    return () => clearTimeout(t);
  }, [responses, loading, isCompleted, userProfile]);

  const checkExistingResponse = async () => {
    if (!userProfile) return;

    // Resolve student_id from students table; do not fallback to users.id
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

    try {
      const { data, error } = await supabase
        .from('assessment_responses')
        .select('*')
        .eq('student_id', studentId)
        .eq('assessment_type', 'role_models')
        .eq('assessment_title', 'My Role Models')
        .order('updated_at', { ascending: false })
        .limit(1)
        .maybeSingle();

      if (data && !error) {
        setIsCompleted(!!data.completed_at);
        const loadedResponses = data.responses as any || {};
        setResponses({
          roleModel1: { ...responses.roleModel1, ...(loadedResponses.roleModel1 || {}) },
          roleModel2: { ...responses.roleModel2, ...(loadedResponses.roleModel2 || {}) },
          roleModel3: { ...responses.roleModel3, ...(loadedResponses.roleModel3 || {}) },
          question12: loadedResponses.question12 || '',
          question13: loadedResponses.question13 || ''
        });
      }
    } catch (error) {
      // No existing response found, which is fine
    } finally {
      setLoading(false);
    }
  };

  const isRoleModelComplete = (key: keyof RoleModelsAssessmentResponse) => {
    if (key === 'question12' || key === 'question13') {
      return responses[key].trim() !== '';
    }
    const roleModel = responses[key] as RoleModel;
    return Object.values(roleModel).every(v => v.trim() !== '');
  };

  const isRoleModelSaved = (key: keyof RoleModelsAssessmentResponse) => {
    return !!savedTabs[key];
  };

  const saveCurrentRoleModel = async () => {
    if (!userProfile) return;
    // Resolve student_id from students table; do not fallback to users.id
    let studentId = userProfile.studentProfile?.id as string | undefined;
    if (!studentId) {
      const { data: studentRow } = await supabase
        .from('students')
        .select('id')
        .eq('user_id', userProfile.id)
        .maybeSingle();
      studentId = studentRow?.id;
    }
    if (!studentId) {
      toast({ title: 'Error', description: 'Student profile not found.', variant: 'destructive' });
      return;
    }

    setSaving(true);
    try {
      const { error } = await supabase
        .from('assessment_responses')
        .upsert({
          student_id: studentId,
          assessment_type: 'role_models',
          assessment_title: 'My Role Models',
          responses,
          updated_at: new Date().toISOString(),
          completed_at: null
        });
      if (error) throw error;
      const label = currentTab === 'roleModel1' 
        ? 'Role Model -1 (Preferably Closely Known Person)' 
        : currentTab === 'roleModel2' 
        ? 'Role Model -2 (Known Person)' 
        : 'Role Model -3 (Known/Famous Person)';
      toast({ title: 'Progress Saved', description: `${label} progress saved successfully.` });
      setSavedTabs(prev => ({ ...prev, [currentTab]: new Date().toISOString() }));
    } catch (e) {
      toast({ title: 'Error', description: 'Failed to save progress. Please try again.', variant: 'destructive' });
    } finally {
      setSaving(false);
    }
  };

  const handleRoleModelChange = (roleModelKey: keyof RoleModelsAssessmentResponse, field: keyof RoleModel, value: string) => {
    setResponses(prev => {
      const current = (prev[roleModelKey] as RoleModel) || {};
      return {
        ...prev,
        [roleModelKey]: {
          ...current,
          [field]: value,
        },
      };
    });
  };

  const handleGeneralQuestionChange = (questionKey: 'question12' | 'question13', value: string) => {
    setResponses(prev => ({
      ...prev,
      [questionKey]: value
    }));
  };

  const getProgressPercentage = () => {
    const totalQuestions = 35; // 11 questions × 3 role models + 2 general questions
    let answeredQuestions = 0;
    
    // Count answered questions for each role model
    ['roleModel1', 'roleModel2', 'roleModel3'].forEach(key => {
      const roleModel = responses[key as keyof RoleModelsAssessmentResponse] as RoleModel;
      answeredQuestions += Object.values(roleModel).filter(v => v.trim() !== '').length;
    });
    
    // Count general questions
    if (responses.question12.trim() !== '') answeredQuestions++;
    if (responses.question13.trim() !== '') answeredQuestions++;
    
    return totalQuestions > 0 ? (answeredQuestions / totalQuestions) * 100 : 0;
  };

  const canSubmit = () => {
    // Check all role models are complete
    const allRoleModelsComplete = ['roleModel1', 'roleModel2', 'roleModel3'].every(key => {
      const roleModel = responses[key as keyof RoleModelsAssessmentResponse] as RoleModel;
      return Object.values(roleModel).every(v => v.trim() !== '');
    });
    
    // Check general questions are complete
    const generalQuestionsComplete = responses.question12.trim() !== '' && responses.question13.trim() !== '';
    
    return allRoleModelsComplete && generalQuestionsComplete;
  };

  const submitAssessment = async () => {
    if (!userProfile) {
      toast({
        title: "Error",
        description: "User profile not found. Please try logging in again.",
        variant: "destructive",
      });
      return;
    }

    // Resolve student_id from students table; do not fallback to users.id
    let studentId = userProfile.studentProfile?.id as string | undefined;
    if (!studentId) {
      const { data: studentRow } = await supabase
        .from('students')
        .select('id')
        .eq('user_id', userProfile.id)
        .maybeSingle();
      studentId = studentRow?.id;
    }

    if (!studentId) {
      toast({
        title: "Error",
        description: "Student profile not found. Please contact your teacher or support.",
        variant: "destructive",
      });
      return;
    }

    setSubmitting(true);
    try {
      const { data: assessmentData, error } = await supabase
        .from('assessment_responses')
        .upsert({
          student_id: studentId,
          assessment_type: 'role_models',
          assessment_title: 'My Role Models',
          responses: responses,
          completed_at: new Date().toISOString(),
          updated_at: new Date().toISOString()
        })
        .select()
        .single();

      if (error) throw error;

      toast({
        title: "Role Models Assessment Completed! ❤️",
        description: "Your role models and inspirations have been captured successfully!",
      });

      setIsCompleted(true);

      // Generate AI summary in the background
      try {
        const { aiSummaryService } = await import('@/services/aiSummaryService');
        const summaryDatabaseService = (await import('@/services/summaryDatabaseService')).summaryDatabaseService;
        
        if (aiSummaryService.isConfigured() && assessmentData?.id) {
          console.log('🤖 Generating AI summary for Role Models assessment:', assessmentData.id);
          const summaryResult = await aiSummaryService.generateRoleModelsSummary(responses);

          if (summaryResult.success && summaryResult.summary) {
            // Save summary to database
            const saveResult = await summaryDatabaseService.createAISummary(
              assessmentData.id,
              summaryResult.summary,
              userProfile.id
            );

            if (saveResult.success) {
              console.log('✅ AI summary saved successfully:', saveResult.summaryId);
              toast({
                title:
                  lang === 'kn'
                    ? 'ಸಾರಾಂಶ ಸಿದ್ಧವಾಗಿದೆ! 📝'
                    : lang === 'ta'
                      ? 'சுருக்கம் உருவாக்கப்பட்டது! 📝'
                      : 'Summary Generated! 📝',
                description:
                  lang === 'kn'
                    ? 'ನಿಮ್ಮ ಆದರ್ಶ ವ್ಯಕ್ತಿಗಳ ಬಗ್ಗೆ ಬರೆದ ಉತ್ತರಗಳ ಸಾರಾಂಶ ಸಿದ್ಧವಾಗಿದೆ. ನಿಮ್ಮ ಶಿಕ್ಷಕರು ಅದನ್ನು ಪರಿಶೀಲಿಸುತ್ತಾರೆ.'
                    : lang === 'ta'
                      ? 'உங்கள் முன்னுதாரணங்கள் பற்றிய சுருக்கம் உருவாக்கப்பட்டுள்ளது. உங்கள் ஆசிரியா் அதைப் பார்த்து மதிப்பாய்வு செய்வார்.'
                      : 'Your role models summary has been generated. Your teacher will review it.',
              });

              // Notify teacher(s) assigned to this student
              try {
                const { notificationService } = await import('@/services/notificationService');
                
                // Find teacher(s) for this student
                if (studentId) {
                  const { data: studentRow } = await supabase
                    .from('students')
                    .select('teachers:teacher_id(user_id, users:user_id(full_name))')
                    .eq('id', studentId)
                    .maybeSingle();
                  
                  const teacherUserId = (studentRow as any)?.teachers?.user_id;
                  if (teacherUserId) {
                    await notificationService.create({
                      userId: teacherUserId,
                      type: 'assessment_submitted',
                      title: `${userProfile?.full_name || 'Student'} completed My Role Models assessment`,
                      message: 'A new My Role Models assessment summary is ready for review.',
                      link: '/teacher/ai-summary-review'
                    });
                  }
                }
              } catch (notifError) {
                console.error('Error notifying teacher:', notifError);
                // Don't fail the whole submission if notification fails
              }
            } else {
              console.error('Failed to save summary:', saveResult.error);
              toast({
                title: "Summary Generation Issue",
                description: "Your assessment is saved, but summary generation needs attention.",
                variant: "destructive",
              });
            }
          } else {
            console.error('Failed to generate summary:', summaryResult.error);
            toast({
              title: "Summary Generation Issue",
              description: "Your assessment is saved. Summary will be generated later.",
              variant: "destructive",
            });
          }
        } else {
          console.warn('⚠️ Gemini API not configured, skipping summary generation');
        }
      } catch (summaryError) {
        console.error('Error in summary generation:', summaryError);
        // Don't fail the entire submission if summary generation fails
      }
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

  if (loading) {
    const loadingText =
      lang === 'kn'
        ? 'ನಿಮ್ಮ ಆದರ್ಶ ವ್ಯಕ್ತಿಗಳ ಮೌಲ್ಯಮಾಪನವನ್ನು ಲೋಡ್ ಮಾಡಲಾಗುತ್ತಿದೆ...'
        : lang === 'ta'
          ? 'உங்கள் முன்மாதிரிகள் மதிப்பீடு ஏற்றப்படுகிறது...'
          : 'Loading your role models assessment...';

    return (
      <div className="min-h-screen flex items-center justify-center bg-gradient-to-br from-purple-50 to-pink-100">
        <div className="text-center">
          <div className="animate-spin rounded-full h-12 w-12 border-b-4 border-purple-600 mx-auto"></div>
          <p className="mt-4 text-lg text-gray-600">{loadingText}</p>
        </div>
      </div>
    );
  }

  if (isCompleted && !readOnlyView) {
    return (
      <div className="min-h-screen bg-gradient-to-br from-purple-50 to-pink-50 py-8">
        <div className="container mx-auto px-4">
          <Card className="max-w-2xl mx-auto border-0 shadow-lg">
            <CardHeader className="text-center bg-gradient-to-r from-purple-50 to-pink-50">
              <Users className="w-16 h-16 text-purple-500 mx-auto mb-4" />
              <CardTitle className="text-2xl text-purple-800">
                {lang === 'kn'
                  ? 'ಆದರ್ಶ ವ್ಯಕ್ತಿಗಳ ಮೌಲ್ಯಮಾಪನ ಪೂರ್ಣಗೊಂಡಿದೆ! 🎯'
                  : lang === 'ta'
                    ? 'முன்மாதிரி மதிப்பீடு முடிந்துவிட்டது! 🎯'
                    : 'Role Models Assessment Completed! 🎯'}
              </CardTitle>
              <CardDescription className="text-purple-600">
                {lang === 'kn'
                  ? 'ನೀವು ನಿಮ್ಮ ಆದರ್ಶ ವ್ಯಕ್ತಿಗಳನ್ನು ಗುರುತಿಸಿ, ಅವರ ಬಗ್ಗೆ ಮನನ ಮಾಡಿದ್ದಾರೆ.'
                  : lang === 'ta'
                    ? 'நீங்கள் உங்கள் முன்மாதிரி நபர்களை சிந்தித்து தேர்வு செய்து வெற்றிகரமாகப் பதிவு செய்துள்ளீர்கள்.'
                    : "You've successfully identified and analyzed your role models"}
              </CardDescription>
            </CardHeader>
            <CardContent className="p-6">
              <div className="text-center space-y-4">
                <p className="text-gray-600">
                  {lang === 'kn'
                    ? 'ನಿಮ್ಮ ಆದರ್ಶ ವ್ಯಕ್ತಿಗಳ ಬಗ್ಗೆ ನಿಮ್ಮ ಆಲೋಚನೆಗಳನ್ನು ಹಂಚಿಕೊಂಡಿದ್ದಕ್ಕಾಗಿ ಧನ್ಯವಾದಗಳು! ನಿಮ್ಮ ಉತ್ತರಗಳನ್ನು ಉಳಿಸಲಾಗಿದೆ ಮತ್ತು ಈಗ ನಿಮ್ಮ ಶಿಕ್ಷಕರು ಅವನ್ನು ಓದಿ ನಿಮ್ಮ ಭವಿಷ್ಯದ ಬೆಳವಣಿಗೆಗೆ ಮಾರ್ಗದರ್ಶನ ನೀಡಬಹುದು.'
                    : lang === 'ta'
                      ? 'உங்கள் முன்மாதிரி நபர்கள் பற்றிய உங்கள் எண்ணங்களை நேர்மையாக பகிர்ந்ததற்கு நன்றி! உங்கள் பதில்கள் அனைத்தும் சேமிக்கப்பட்டுள்ளன, இப்போது உங்கள் ஆசிரியை அவற்றைப் பார்த்து உங்கள் வளர்ச்சிக்கு உதவும் வழிகாட்டுதலை வழங்க முடியும்.'
                      : 'Thank you for sharing your role model insights! Your responses have been saved and your teacher can now review them to help guide your personal development.'}
                </p>
                <div className="flex justify-center gap-4">
                  <Button 
                    variant="outline" 
                    onClick={() => {
                      const params = new URLSearchParams(searchParams.toString());
                      params.set('readonly', '1');
                      navigate(`/student/assessment/role-models?${params.toString()}`);
                    }}
                    className="border-purple-200 text-purple-700 hover:bg-purple-50"
                  >
                    {lang === 'kn' ? 'ನನ್ನ ಉತ್ತರಗಳನ್ನು ವೀಕ್ಷಿಸಿ' : lang === 'ta' ? 'என் பதில்களை பார்' : 'View My Answers'}
                  </Button>
                  <Button 
                    onClick={() => navigate('/student')}
                    className="bg-purple-600 hover:bg-purple-700"
                  >
                    {lang === 'kn' ? 'ಡ್ಯಾಶ್‌ಬೋರ್ಡ್‌ಗೆ ಹಿಂತಿರುಗಿ' : lang === 'ta' ? 'முதல் பக்கத்திற்கு போ' : 'Back to Dashboard'}
                  </Button>
                </div>
              </div>
            </CardContent>
          </Card>
        </div>
      </div>
    );
  }

  return (
    <div className="min-h-screen bg-gradient-to-br from-purple-50 via-white to-pink-50 py-8" lang={lang} dir="auto">
      <div className="container mx-auto px-4">
        <TooltipProvider>
        {/* Header */}
        <div className="text-center mb-8">
          <div className="text-left mb-2">
            <Button variant="ghost" onClick={() => navigate('/student')} className="text-purple-700 hover:text-purple-800 hover:bg-purple-50">
              <ArrowLeft className="w-4 h-4 mr-2" />{t('backToDashboard')}
            </Button>
          </div>
          <h1 className="text-3xl font-bold text-purple-800 mb-4">
            {lang === 'kn'
              ? '🎯 6. ನನ್ನ ಆದರ್ಶ ವ್ಯಕ್ತಿಗಳು'
              : lang === 'ta'
                ? '🎯 6. என் முன்மாதிரிகள்'
                : '🎯 6. My Role Models'}
          </h1>
          <div className="text-left max-w-4xl mx-auto space-y-4 text-gray-700">
            <p className="text-base leading-relaxed">
              {lang === 'kn'
                ? 'ನಮ್ಮ ಜೀವನದಲ್ಲಿ, ನಾವು ಹಲವರಿಗೆ ಅವರ ಗುಣಗಳು ಮತ್ತು ವ್ಯಕ್ತಿತ್ವದ ಕಾರಣದಿಂದಾಗಿ ಆದರ್ಶ ವ್ಯಕ್ತಿಗಳೆಂದು ನೋಡುತ್ತೇವೆ. ಇಂತಹ ವ್ಯಕ್ತಿಗಳು – ಕುಟುಂಬದವರು, ಶಿಕ್ಷಕರು, ಅಥವಾ ಪ್ರೇರಣಾದಾಯಕ ವ್ಯಕ್ತಿಗಳು – ನಮ್ಮ ಸ್ವಭಾವ ಮತ್ತು ಆಲೋಚನೆಗಳನ್ನು ರೂಪಿಸುವಲ್ಲಿ ದೊಡ್ಡ ಪಾತ್ರವಹಿಸುತ್ತಾರೆ.'
                : lang === 'ta'
                  ? 'நம் வாழ்க்கையில் சிலரை அவர்களின் குணநலன்களாலும் நடத்தைகளாலும் முன்னுதாரணமாக பார்க்கிறோம். குடும்பத்தினர், ஆசிரியர்கள், தெரிந்தவர்கள் அல்லது பிரபல நபர்கள் என்றாலும், அவர்கள் நம்முடைய சிந்தனை மற்றும் பண்புகளை உருவாக்க பெரும் தாக்கம் செலுத்துகிறார்கள்.'
                  : 'In our lives, we often admire individuals for their personality traits, viewing them as role models. These individuals, be they influencers, inspiring figures, or those we know personally, contribute significantly to shaping our character.'}
            </p>
            <p className="text-base leading-relaxed">
              {lang === 'kn'
                ? 'ಈ பகுதியಲ್ಲಿ, ನಿಮ್ಮ ವ್ಯಕ್ತಿತ್ವವನ್ನು ರೂಪಿಸಲು ಮಹತ್ವವಾದ ಪ್ರಭಾವ ಬೀರಿದ ವ್ಯಕ್ತಿಗಳ ಬಗ್ಗೆ ಆಲೋಚಿಸುತ್ತೀರಿ. ಇವರು ನಿಮ್ಮ ಬೆಳವಣಿಗೆಯ ಮೇಲೆ ತುಂಬಾ ಪ್ರಭಾವ ಬೀರಿದ್ದಾರೆ. ಅವರನ್ನು ನೀವು ಹತ್ತಿರದಿಂದ ನೋಡಲು ಸಾಧ್ಯವಾದರೆ ಇನ್ನೂ ಉತ್ತಮ; ಇಲ್ಲದಿದ್ದರೆ ಪ್ರೇರಣಾದಾಯಕ ವ್ಯಕ್ತಿಗಳು ಕೂಡ ನಿಮ್ಮ ಕಲಿಕೆಗೆ ಮಾದರಿಯಾಗಬಹುದು.'
                : lang === 'ta'
                  ? 'இந்த பகுதியில், உங்கள் வாழ்க்கை மற்றும் நற்பண்புகளைக் கட்டியெழுப்ப முக்கிய பங்கு வகித்த முன்மாதிரி நபர்களைப் பற்றி சிந்திக்கப் போகிறீர்கள். அவர்களின் பயணம், போராட்டங்கள் மற்றும் வெற்றிகள், உங்களுக்கும் ஒரு வழிகாட்டியாக இருக்கலாம்.'
                  : 'In this segment of our reflection, we will delve into the influential figures who have played a significant role in shaping our personalities. These individuals have contributed immensely to our development. If you happen to know such people personally, it\'s advantageous as you can observe them closely. Alternatively, you can also consider inspirational personalities as a source of inspiration and learning.'}
            </p>
            <p className="text-purple-600 italic mt-4">
              <strong>
                {lang === 'kn'
                  ? 'ಸೂಚನೆ:'
                  : lang === 'ta'
                    ? 'குறிப்பு:'
                    : 'Suggestion:'}
              </strong>{' '}
              {lang === 'kn'
                ? 'ನೀವು ಆಸಕ್ತಿ ಹೊಂದಿರುವ ವೃತ್ತಿಯನ್ನು ಅನುಸರಿಸಿದ ಆದರ್ಶ ವ್ಯಕ್ತಿಯನ್ನು ಆಯ್ಕೆ ಮಾಡಿದರೆ ಉತ್ತಮ. ಅವರ ಅನುಭವಗಳು ಮತ್ತು ಪ್ರಯಾಣ ನಿಮ್ಮ ಭವಿಷ್ಯಕ್ಕೆ ಮಾರ್ಗದರ್ಶನ ಮತ್ತು ಪ್ರೇರಣೆ ನೀಡಬಹುದು.'
                : lang === 'ta'
                  ? 'நீங்கள் விரும்பும் தொழிலை தொடர்ந்து சென்ற ஒருவர் உங்கள் முன்மாதிரியாக இருப்பது சிறந்தது. அவர்களின் பயணம், அனுபவங்கள் மற்றும் முடிவுகள், உங்கள் எதிர்காலத் தேர்வுகளுக்கு நல்ல வழிகாட்டியாக இருக்கும்.'
                  : 'If possible, it might be beneficial to select a role model who has pursued the profession you\'re interested in. Their journey could provide valuable insights and inspiration for your own path.'}
            </p>
            <p className="text-gray-700 mt-3 font-medium">
              {lang === 'kn'
                ? 'ಪ್ರಶ್ನೆಗಳಿಗೆ ಉತ್ತರಿಸುವಾಗ, ಅವರ ಗುಣಗಳು, ವರ್ತನೆಗಳು ಮತ್ತು ಪ್ರತಿಭೆಗಳ ಮೇಲೆ ವಿಶೇಷವಾಗಿ ಗಮನ ನೀಡಿ.'
                : lang === 'ta'
                  ? 'கேள்விகளுக்குப் பதில் எழுதும்போது, அவர்கள் கொண்டிருக்கும் நல்ல குணங்கள், திறன்கள் மற்றும் முன்னுதாரணமான நடத்தைகளைப் பற்றி குறிப்பாக எழுதுங்கள்.'
                  : 'When responding to the questions provided, focus on highlighting their qualities, traits, and talents.'}
            </p>
          </div>
        </div>

        {/* Progress Bar */}
        <Card className="mb-6 border-0 shadow-lg">
          <CardContent className="p-6">
            <div className="flex items-center justify-between mb-4">
              <h2 className="text-lg font-semibold text-gray-800">{t('yourProgress')}</h2>
              <Badge variant="secondary">{Math.round(getProgressPercentage())}% {t('completeSuffix')}</Badge>
            </div>
            <Progress value={getProgressPercentage()} className="h-3" />
            <div className="flex justify-between text-sm text-gray-600 mt-2">
              <span>
                {lang === 'kn'
                  ? '3 ಆದರ್ಶ ವ್ಯಕ್ತಿಗಳು • ಪ್ರತಿ ವ್ಯಕ್ತಿಗೆ 11 ಪ್ರಶ್ನೆಗಳು • 2 ಸಾಮಾನ್ಯ ಪ್ರಶ್ನೆಗಳು'
                  : lang === 'ta'
                    ? '3 முன்மாதிரிகள் • ஒவ்வொருவருக்கும் 11 கேள்விகள் • 2 பொது கேள்விகள்'
                    : '3 Role Models • 11 questions each • 2 General Questions'}
              </span>
              <span>{Math.round(getProgressPercentage())}% {t('completeSuffix')}</span>
            </div>
          </CardContent>
        </Card>

        {/* Tabs Navigation */}
        <div className="flex justify-center mb-6">
          <div className="flex bg-white rounded-lg p-1 shadow-md gap-1">
            <button
              onClick={() => setCurrentTab('roleModel1')}
              className={`px-3 py-2 rounded-md transition-all text-xs text-center min-w-[140px] ${
                currentTab === 'roleModel1'
                  ? 'bg-purple-600 text-white shadow-md'
                  : 'text-gray-600 hover:text-purple-600'
              }`}
            >
              <div>
                {lang === 'kn' ? 'ಮಾದರಿ ವ್ಯಕ್ತಿ -1' : lang === 'ta' ? 'முன்மாதிரி -1' : 'Role Model -1'}
              </div>
              <div className="text-[10px] mt-0.5">
                {lang === 'kn'
                  ? '(ಹತ್ತಿರದಿಂದ ಪರಿಚಿತರಾದ ವ್ಯಕ್ತಿ)'
                  : lang === 'ta'
                    ? '(அறிமுகமான / நெருக்கமாக அறிந்த நபர்)'
                    : '(Preferably Closely Known Person)'}
              </div>
            </button>
            <button
              onClick={() => setCurrentTab('roleModel2')}
              className={`px-3 py-2 rounded-md transition-all text-xs text-center min-w-[140px] ${
                currentTab === 'roleModel2'
                  ? 'bg-purple-600 text-white shadow-md'
                  : 'text-gray-600 hover:text-purple-600'
              }`}
            >
              <div>
                {lang === 'kn' ? 'ಮಾದರಿ ವ್ಯಕ್ತಿ -2' : lang === 'ta' ? 'முன்மாதிரி -2' : 'Role Model -2'}
              </div>
              <div className="text-[10px] mt-0.5">
                {lang === 'kn'
                  ? '(ಪರಿಚಿತ ವ್ಯಕ್ತಿ)'
                  : lang === 'ta'
                    ? '(நீங்கள் நன்கு அறிந்த நபர்)'
                    : '(Known Person)'}
              </div>
            </button>
            <button
              onClick={() => setCurrentTab('roleModel3')}
              className={`px-3 py-2 rounded-md transition-all text-xs text-center min-w-[140px] ${
                currentTab === 'roleModel3'
                  ? 'bg-purple-600 text-white shadow-md'
                  : 'text-gray-600 hover:text-purple-600'
              }`}
            >
              <div>
                {lang === 'kn' ? 'ಮಾದರಿ ವ್ಯಕ್ತಿ -3' : lang === 'ta' ? 'முன்மாதிரி -3' : 'Role Model -3'}
              </div>
              <div className="text-[10px] mt-0.5">
                {lang === 'kn'
                  ? '(ಪರಿಚಿತ / ಪ್ರಸಿದ್ಧ ವ್ಯಕ್ತಿ)'
                  : lang === 'ta'
                    ? '(நீங்கள் அறிந்த / பிரபலமான நபர்)'
                    : '(Known/Famous Person)'}
              </div>
            </button>
          </div>
        </div>

        {/* Current Tab Content */}
        <Card className="border-0 shadow-lg">
            <CardHeader className="bg-gradient-to-r from-purple-50 to-pink-50">
              <CardTitle className="text-xl text-purple-800">
                {currentTab === 'roleModel1'
                  ? lang === 'kn'
                    ? 'ಮಾದರಿ ವ್ಯಕ್ತಿ -1 (ಹತ್ತಿರದಿಂದ ಪರಿಚಿತರಾದ ವ್ಯಕ್ತಿ)'
                    : lang === 'ta'
                      ? 'முன்மாதிரி -1 (அறிமுகமான / நெருக்கமாக அறிந்த நபர்)'
                      : 'Role Model -1 (Preferably Closely Known Person)'
                  : currentTab === 'roleModel2'
                  ? lang === 'kn'
                    ? 'ಮಾದರಿ ವ್ಯಕ್ತಿ -2 (ಪರಿಚಿತ ವ್ಯಕ್ತಿ)'
                    : lang === 'ta'
                      ? 'முன்மாதிரி -2 (நீங்கள் நன்கு அறிந்த நபர்)'
                      : 'Role Model -2 (Known Person)'
                  : lang === 'kn'
                    ? 'ಮಾದರಿ ವ್ಯಕ್ತಿ -3 (ಪರಿಚಿತ / ಪ್ರಸಿದ್ಧ ವ್ಯಕ್ತಿ)'
                    : lang === 'ta'
                      ? 'முன்மாதிரி -3 (நீங்கள் அறிந்த / பிரபலமான நபர்)'
                      : 'Role Model -3 (Known/Famous Person)'}
              </CardTitle>
              <CardDescription className="text-purple-600">
                {lang === 'kn'
                  ? 'ಈ ಮಾದರಿ ವ್ಯಕ್ತಿ ಕುರಿತಾಗಿ ಎಲ್ಲಾ 11 ಪ್ರಶ್ನೆಗಳಿಗೆ ಉತ್ತರಿಸಿ.'
                  : lang === 'ta'
                    ? 'இந்த முன்மாதிரி நபரைப் பற்றி உள்ள 11 கேள்விகளுக்கும் பதில் எழுதுங்கள்.'
                    : 'Answer all 11 questions for this role model'}
              </CardDescription>
            </CardHeader>
            <CardContent className="p-6">
              <div className="space-y-8">
                  <div className="grid gap-4 md:grid-cols-2">
                    <div>
                      <label className="block text-sm font-medium text-gray-700 mb-2 flex items-center gap-2">
                        {q['rm_q1'] || '1. Name your role model.'}
                        <Tooltip>
                          <TooltipTrigger asChild>
                            <button type="button" className="text-purple-600">💬</button>
                          </TooltipTrigger>
                          <TooltipContent>
                            {lang === 'kn'
                              ? 'ನಿಮ್ಮ ಆದರ್ಶ ವ್ಯಕ್ತಿಯ ಪೂರ್ಣ ಹೆಸರನ್ನು ಬರೆಯಿರಿ. ಅವರು ನಿಮಗೆ ಪರಿಚಿತರಾಗಿರಬಹುದು ಅಥವಾ ಪ್ರಸಿದ್ಧ ವ್ಯಕ್ತಿಯಾಗಿರಬಹುದು.'
                              : lang === 'ta'
                                ? 'உங்களை ஊக்கப்படுத்தும் முன்மாதிரி நபரின் முழு பெயரை எழுதுங்கள். அவர் நீங்கள் அறிந்த நபராகவோ அல்லது பிரபலமான நபராகவோ இருக்கலாம்.'
                                : 'Enter the full name of your role model. This can be a person you know personally or a well-known figure who inspires you.'}
                          </TooltipContent>
                        </Tooltip>
                      </label>
                      <Input
                        placeholder={
                          lang === 'kn'
                            ? 'ನಿಮ್ಮ ಆದರ್ಶ ವ್ಯಕ್ತಿಯ ಪೂರ್ಣ ಹೆಸರು...'
                            : lang === 'ta'
                              ? 'உங்கள் முன்மாதிரியின் முழு பெயரை எழுதுங்கள்...'
                              : 'Enter the full name of your role model'
                        }
                        value={responses[currentTab].name}
                        onChange={(e) => handleRoleModelChange(currentTab, 'name', e.target.value)}
                        className="border-purple-200 focus:border-purple-400"
                      />
                    </div>
                    <div>
                      <label className="block text-sm font-medium text-gray-700 mb-2 flex items-center gap-2">
                        {q['rm_q2'] || '2. Are you personally related to this individual? If so, do they belong to your family, relatives, school, a broader community, or are they a familiar acquaintance?'}
                        <Tooltip>
                          <TooltipTrigger asChild>
                            <button type="button" className="text-purple-600">💬</button>
                          </TooltipTrigger>
                          <TooltipContent>
                            {lang === 'kn'
                              ? 'ಈ ವ್ಯಕ್ತಿ ನಿಮ್ಮಿಗೆ ಯಾರು ಎಂದು ಬರೆಯಿರಿ – ಕುಟುಂಬದವರು, ಸಂಬಂಧಿ, ಶಾಲೆಯವರು, ಸಮುದಾಯದವರು ಅಥವಾ ಪರಿಚಿತ ವ್ಯಕ್ತಿ. ಪ್ರಸಿದ್ಧ ವ್ಯಕ್ತಿಯಾಗಿದ್ದರೆ, ಅದನ್ನೂ ಹೇಳಬಹುದು.'
                              : lang === 'ta'
                                ? 'இந்த நபர் உங்களுடன் என்ன தொடர்பு கொண்டவர் என்பதை எழுதுங்கள். குடும்பம், உறவினர், பள்ளி, சமூகம் அல்லது உங்கள் தெரிந்தவர் என்பதைக் குறிப்பிடலாம். அவர் பிரபல நபராக இருந்தால், அதையும் எழுதலாம்.'
                                : 'Describe your relationship with this person. Indicate if they are family, a relative, someone from school, part of your community, or a familiar acquaintance. If they are a public figure or celebrity you don\'t know personally, you can mention that as well.'}
                          </TooltipContent>
                        </Tooltip>
                      </label>
                      <Input
                        placeholder={
                          lang === 'kn'
                            ? 'ಕುಟುಂಬ, ಸಂಬಂಧಿ, ಶಾಲೆ, ಸಮುದಾಯ, ಪರಿಚಿತ / ಪ್ರಸಿದ್ಧ ವ್ಯಕ್ತಿ...'
                            : lang === 'ta'
                              ? 'குடும்பம், உறவினர், பள்ளி, சமூகம், தெரிந்தவர் அல்லது பிரபல நபர்...'
                              : 'Family, relatives, school, community, acquaintance, or public figure...'
                        }
                        value={responses[currentTab].relationship}
                        onChange={(e) => handleRoleModelChange(currentTab, 'relationship', e.target.value)}
                        className="border-purple-200 focus:border-purple-400"
                      />
                    </div>
                    <div className="md:col-span-2">
                      <label className="block text-sm font-medium text-gray-700 mb-2 flex items-center gap-2">
                        {q['rm_q3'] || '3. What qualities about your role model do you admire the most? Please list the specific qualities that you appreciate, and also share what makes them special in your eyes.'}
                        <Tooltip>
                          <TooltipTrigger asChild>
                            <button type="button" className="text-purple-600">💬</button>
                          </TooltipTrigger>
                          <TooltipContent>
                            {lang === 'kn'
                              ? 'ದಯೆ, ಪರಿಶ್ರಮ, ಪ್ರಾಮಾಣಿಕತೆ, ನಾಯಕತ್ವ, ಕ್ರಿಯಾತ್ಮಕತೆ ಮುಂತಾದ ನಿಮ್ಮಿಗೆ ಇಷ್ಟವಾದ ಗುಣಗಳನ್ನು ಪಟ್ಟಿ ಮಾಡಿ. ಈ ಗುಣಗಳು ನಿಮಗೆ ಏಕೆ ವಿಶೇಷವಾಗಿ ಕಾಣಿಸುತ್ತವೆ ಎಂದು ವಿವರಿಸಿ.'
                              : lang === 'ta'
                                ? 'உங்கள் முன்மாதிரியில் நீங்கள் மிகவும் விரும்பும் குணங்களை பட்டியலிடுங்கள் – உதாரணமாக, அன்பு, நேர்மை, கடின உழைப்பு, தலைமைத்துவம், படைப்பாற்றல் போன்றவை. இந்த குணங்கள் ஏன் உங்களுக்கு சிறப்பாகத் தோன்றுகின்றன என்பதைச் சுருக்கமாக எழுதுங்கள்.'
                                : 'List specific traits such as kindness, resilience, intelligence, leadership, creativity, honesty, compassion, determination, or any other qualities. Explain why these qualities stand out to you and what makes this person unique and special in your eyes.'}
                          </TooltipContent>
                        </Tooltip>
                      </label>
                      <Textarea
                        placeholder={
                          lang === 'kn'
                            ? 'ನಿಮ್ಮ ಆದರ್ಶ ವ್ಯಕ್ತಿಯಲ್ಲಿ ನೀವು ಮೆಚ್ಚಿದ ವಿಶೇಷ ಗುಣಗಳನ್ನು ಬರೆಯಿರಿ...'
                            : lang === 'ta'
                              ? 'நீங்கள் மிகவும் விரும்பும் குணங்களை மற்றும் அவை ஏன் சிறப்பு என நினைக்கிறீர்கள் என்பதை எழுதுங்கள்...'
                              : 'List specific qualities you admire and explain what makes them special...'
                        }
                        value={responses[currentTab].admirationReasons}
                        onChange={(e) => handleRoleModelChange(currentTab, 'admirationReasons', e.target.value)}
                        rows={3}
                        className="border-purple-200 focus:border-purple-400"
                      />
                    </div>
                    <div>
                      <label className="block text-sm font-medium text-gray-700 mb-2 flex items-center gap-2">
                        {q['rm_q4'] || '4. What is their occupation or profession?'}
                        <Tooltip>
                          <TooltipTrigger asChild>
                            <button type="button" className="text-purple-600">💬</button>
                          </TooltipTrigger>
                          <TooltipContent>
                            {lang === 'kn'
                              ? 'ಅವರು ಯಾವ ಕೆಲಸ/ವೃತ್ತಿಯಲ್ಲಿ ಇದ್ದಾರೆ ಎಂದು ಬರೆಯಿರಿ. ನಿವೃತ್ತರಾಗಿದ್ದರೆ, ಹಿಂದೆ ಏನು ಮಾಡುತ್ತಿದ್ದರು ಎಂದು ಹೇಳಿ.'
                              : lang === 'ta'
                                ? 'இந்த நபர் என்ன தொழில் அல்லது வேலை செய்கிறார் என்பதை எழுதுங்கள். ஓய்வு பெற்றவர் என்றால், முன்பு செய்த வேலையையும் குறிப்பிடலாம்.'
                                : 'Describe their job or profession. If they are retired, mention what they used to do. If they are a student or in a different stage of life, describe their current role or career path.'}
                          </TooltipContent>
                        </Tooltip>
                      </label>
                      <Input
                        placeholder={
                          lang === 'kn'
                            ? 'ಅವರ ವೃತ್ತಿ / ಕೆಲಸವನ್ನು ವಿವರಿಸಿ...'
                            : lang === 'ta'
                              ? 'அவர்கள் செய்யும் தொழில் / வேலையை எழுதுங்கள்...'
                              : 'Describe their occupation or profession...'
                        }
                        value={responses[currentTab].profession}
                        onChange={(e) => handleRoleModelChange(currentTab, 'profession', e.target.value)}
                        className="border-purple-200 focus:border-purple-400"
                      />
                    </div>
                    <div>
                      <label className="block text-sm font-medium text-gray-700 mb-2 flex items-center gap-2">
                        {q['rm_q5'] || '5. What talents or skills do you aspire to develop based on the abilities demonstrated by your role models?'}
                        <Tooltip>
                          <TooltipTrigger asChild>
                            <button type="button" className="text-purple-600">💬</button>
                          </TooltipTrigger>
                          <TooltipContent>
                            {lang === 'kn'
                              ? 'ನಿಮ್ಮ ಆದರ್ಶ ವ್ಯಕ್ತಿಯಲ್ಲಿರುವ ಯಾವ ಪ್ರತಿಭೆಗಳನ್ನು ಅಥವಾ ಕೌಶಲ್ಯಗಳನ್ನು ನೀವು ನಿಮ್ಮಲ್ಲೂ ಬೆಳೆಸಲು ಬಯಸುತ್ತೀರಿ ಎಂಬುದನ್ನು ಯೋಚಿಸಿ ಮತ್ತು ಬರೆಯಿರಿ.'
                              : lang === 'ta'
                                ? 'உங்கள் முன்மாதிரியின் திறமைகள் மற்றும் திறன்களில் எதை நீங்கள் உங்கள் வாழ்க்கையில் வளர்த்துக்கொள்ள விரும்புகிறீர்கள் என்று எழுதுங்கள்.'
                                : 'Think about the specific talents, skills, or abilities your role model possesses that you would like to develop in yourself.'}
                          </TooltipContent>
                        </Tooltip>
                      </label>
                      <Input
                        placeholder={
                          lang === 'kn'
                            ? 'ನೀವು ಬೆಳೆಸಲು ಬಯಸುವ ಪ್ರತಿಭೆಗಳು / ಕೌಶಲ್ಯಗಳನ್ನು ಬರೆಯಿರಿ...'
                            : lang === 'ta'
                              ? 'நீங்கள் வளர்த்துக்கொள்ள விரும்பும் திறமைகள் மற்றும் திறன்களை எழுதுங்கள்...'
                              : 'List the talents or skills you want to develop...'
                        }
                        value={responses[currentTab].desiredQualities}
                        onChange={(e) => handleRoleModelChange(currentTab, 'desiredQualities', e.target.value)}
                        className="border-purple-200 focus:border-purple-400"
                      />
                    </div>
                    <div className="md:col-span-2">
                      <label className="block text-sm font-medium text-gray-700 mb-2 flex items-center gap-2">
                        {q['rm_q6'] || '6. Have you had conversations with any of your role models regarding your career aspirations? If so, what have you discussed?'}
                        <Tooltip>
                          <TooltipTrigger asChild>
                            <button type="button" className="text-purple-600">💬</button>
                          </TooltipTrigger>
                          <TooltipContent>
                            {lang === 'kn'
                              ? 'ನಿಮ್ಮ ಭವಿಷ್ಯದ ವೃತ್ತಿ ಬಗ್ಗೆ ನೀವು ಯಾವಾದರೂ ಆದರ್ಶ ವ್ಯಕ್ತಿಯೊಂದಿಗೆ ಮಾತುಕತೆ ನಡೆಸಿದ್ದೀರಾ? ಮಾತನಾಡಿದ್ದರೆ, ಅವರು ನೀಡಿದ ಸಲಹೆಗಳು ಮತ್ತು ಮಾರ್ಗದರ್ಶನವನ್ನು ಸಂಕ್ಷಿಪ್ತವಾಗಿ ಬರೆಯಿರಿ.'
                              : lang === 'ta'
                                ? 'உங்கள் கனவு தொழிலைப் பற்றி உங்கள் முன்மாதிரி நபருடன் நீங்கள் பேசியிருந்தால், அந்த உரையாடலில் அவர்கள் கூறிய ஆலோசனைகள் மற்றும் கருத்துகளை சுருக்கமாக எழுதுங்கள்.'
                                : 'If you have talked to your role model about your career goals or aspirations, describe those conversations and the advice they provided.'}
                          </TooltipContent>
                        </Tooltip>
                      </label>
                      <Textarea
                        placeholder={
                          lang === 'kn'
                            ? 'ನೀವು ನಡೆಸಿದ ಮಾತುಕತೆಗಳ ಬಗ್ಗೆ ಅಥವಾ ಇನ್ನೂ ಮಾತುಕತೆ ನಡೆಸದಿದ್ದರೆ ಅದನ್ನೂ ಬರೆಯಿರಿ...'
                            : lang === 'ta'
                              ? 'நீங்கள் நடத்திய உரையாடலை அல்லது இன்னும் பேசவில்லை என்றால் அதையும் எழுதுங்கள்...'
                              : "Describe your conversations about career aspirations, or mention if you haven't discussed this yet..."
                        }
                        value={responses[currentTab].careerDiscussed}
                        onChange={(e) => handleRoleModelChange(currentTab, 'careerDiscussed', e.target.value)}
                        rows={2}
                        className="border-purple-200 focus:border-purple-400"
                      />
                    </div>
                  </div>
            {/* Q7–Q11 for current tab */}
            <div>
              <label className="block text-sm font-medium text-gray-700 mb-2 flex items-center gap-2">
                {q['rm_q7'] || '7. If not, have you thought about getting their opinion on your dream career?'}
                <Tooltip>
                  <TooltipTrigger asChild>
                    <button type="button" className="text-purple-600">💬</button>
                  </TooltipTrigger>
                  <TooltipContent>
                    {lang === 'kn'
                      ? 'ನೀವು ಇನ್ನೂ ಮಾತುಕತೆ ನಡೆಸಿರದಿದ್ದರೆ, ಅವರ ಅಭಿಪ್ರಾಯವನ್ನು ಕೇಳುವುದು ಉಪಯುಕ್ತವೇ ಎಂದು ಆಲೋಚಿಸಿ. ಅವರು ನೀಡಬಹುದಾದ ಮಾರ್ಗದರ್ಶನದ ಬಗ್ಗೆ ಬರೆಯಿರಿ.'
                      : lang === 'ta'
                        ? 'இன்னும் நீங்கள் அவர்களுடன் இதைப் பற்றி பேசவில்லை என்றால், அவர்களிடம் கருத்து கேட்பது உங்களுக்கு எப்படி உதவும் என்று சிந்தித்து எழுதுங்கள்.'
                        : 'If you haven\'t discussed your career aspirations with them yet, think about whether you would like to seek their opinion and why.'}
                  </TooltipContent>
                </Tooltip>
              </label>
              <Textarea
                placeholder={
                  lang === 'kn'
                    ? 'ನಿಮ್ಮ ಕನಸಿನ ವೃತ್ತಿ ಕುರಿತು ಅವರ ಅಭಿಪ್ರಾಯವನ್ನು ಕೇಳುವ ಬಗ್ಗೆ ನಿಮ್ಮ ಆಲೋಚನೆಗಳನ್ನು ಬರೆಯಿರಿ...'
                    : lang === 'ta'
                      ? 'உங்கள் கனவு தொழிலைப் பற்றி அவர்களின் கருத்தை கேட்பது பற்றி நீங்கள் நினைப்பதை எழுதுங்கள்...'
                      : 'Share your thoughts about seeking their opinion on your dream career...'
                }
                value={responses[currentTab].opinion}
                onChange={(e) => handleRoleModelChange(currentTab, 'opinion', e.target.value)}
                rows={3}
                className="border-purple-200 focus:border-purple-400"
              />
            </div>

            <div>
              <label className="block text-sm font-medium text-gray-700 mb-2 flex items-center gap-2">
                {q['rm_q8'] || '8. What is their perspective on your dream job or career aspiration?'}
                <Tooltip>
                  <TooltipTrigger asChild>
                    <button type="button" className="text-purple-600">💬</button>
                  </TooltipTrigger>
                  <TooltipContent>
                    {lang === 'kn'
                      ? 'ನಿಮ್ಮ ಕನಸಿನ ವೃತ್ತಿ ಕುರಿತು ಅವರು ಹೇಗೆ ಆಲೋಚಿಸ್ತಾರೆ, ಅವರು ನೀಡಿದ ಸಲಹೆ ಅಥವಾ ಪ್ರೋತ್ಸಾಹವನ್ನು ಸಂಕ್ಷಿಪ್ತವಾಗಿ ಬರೆಯಿರಿ.'
                      : lang === 'ta'
                        ? 'உங்கள் கனவு தொழிலைப் பற்றி உங்கள் முன்மாதிரி என்ன நினைக்கிறார், அவர் கூறிய ஆலோசனை அல்லது ஊக்கத்தைச் சுருக்கமாக எழுதுங்கள்.'
                        : 'Share what your role model thinks about your career aspirations, including any advice or encouragement they have given.'}
                  </TooltipContent>
                </Tooltip>
              </label>
              <Textarea
                placeholder={
                  lang === 'kn'
                    ? 'ನಿಮ್ಮ ಕನಸಿನ ವೃತ್ತಿ ಬಗ್ಗೆ ಅವರ ಅಭಿಪ್ರಾಯವನ್ನು ಬರೆಯಿರಿ...'
                    : lang === 'ta'
                      ? 'உங்கள் கனவு தொழிலைப் பற்றி அவர்களின் கருத்தை எழுதுங்கள்...'
                      : 'Share their perspective on your dream job or career aspiration...'
                }
                value={responses[currentTab].willingToHelp}
                onChange={(e) => handleRoleModelChange(currentTab, 'willingToHelp', e.target.value)}
                rows={3}
                className="border-purple-200 focus:border-purple-400"
              />
            </div>

            <div>
              <label className="block text-sm font-medium text-gray-700 mb-2 flex items-center gap-2">
                {q['rm_q9'] || '9. Is there a possibility for any of your role models to assist you in choosing your career aspiration or profession?'}
                <Tooltip>
                  <TooltipTrigger asChild>
                    <button type="button" className="text-purple-600">💬</button>
                  </TooltipTrigger>
                  <TooltipContent>
                    {lang === 'kn'
                      ? 'ನಿಮ್ಮ ಕನಸಿನ ವೃತ್ತಿಯನ್ನು ಆಯ್ಕೆ ಮಾಡುವಲ್ಲಿ ಅವರು ನಿಮಗೆ ಹೇಗೆ ಸಹಾಯ ಮಾಡಬಹುದು ಎಂದು ಯೋಚಿಸಿ ಮತ್ತು ಹೌದು/ಇಲ್ಲ/ಬಹುದಾದರೆ ಎಂದು ಉತ್ತರಿಸಿ.'
                      : lang === 'ta'
                        ? 'உங்கள் தொழில் தேர்வில் அவர்கள் உங்களை வழிநடத்த முடியுமா என்பதை யோசித்து, ஆம் / இல்லை / இருக்கலாம் என்று காரணத்துடன் எழுதுங்கள்.'
                        : 'Consider whether your role model could help guide you in your career choices. Answer yes, no, or maybe and explain your reasoning.'}
                  </TooltipContent>
                </Tooltip>
              </label>
              <Textarea
                placeholder={
                  lang === 'kn'
                    ? 'ಹೌದು / ಇಲ್ಲ / ಬಹುದಾದರೆ – ಕಾರಣವನ್ನು ವಿವರಿಸಿ...'
                    : lang === 'ta'
                      ? 'ஆம் / இல்லை / இருக்கலாம் – உங்கள் காரணத்தை எழுதுங்கள்...'
                      : 'Yes/No/Maybe - explain your reasoning...'
                }
                value={responses[currentTab].helpLookingFor}
                onChange={(e) => handleRoleModelChange(currentTab, 'helpLookingFor', e.target.value)}
                rows={2}
                className="border-purple-200 focus:border-purple-400"
              />
            </div>

            <div>
              <label className="block text-sm font-medium text-gray-700 mb-2 flex items-center gap-2">
                {q['rm_q10'] || '10. If your answer is yes to the above question, how do you think they can help your career choice?'}
                <Tooltip>
                  <TooltipTrigger asChild>
                    <button type="button" className="text-purple-600">💬</button>
                  </TooltipTrigger>
                  <TooltipContent>
                    {lang === 'kn'
                      ? 'ಮಾರ್ಗದರ್ಶನ, ಅನುಭವ ಹಂಚಿಕೆ, ಪರಿಚಯಗಳು, ಅಥವಾ ಅವಕಾಶಗಳನ್ನು ತೋರಿಸುವ ಮೂಲಕ ಅವರು ಹೇಗೆ ಸಹಾಯ ಮಾಡಬಹುದು ಎಂಬುದನ್ನು ಉದಾಹರಣೆಯೊಂದಿಗೆ ಬರೆಯಿರಿ.'
                      : lang === 'ta'
                        ? 'அவர்கள் உங்களுக்கு எப்படி உதவ முடியும் என்று எழுதுங்கள் – உதாரணமாக, வழிகாட்டுதல், அனுபவங்களை பகிர்தல், வேலை வாய்ப்புகளை அறிமுகப்படுத்துதல் போன்றவை.'
                        : 'If your role model can assist you, describe the specific ways they could help, such as mentoring or sharing opportunities.'}
                  </TooltipContent>
                </Tooltip>
              </label>
              <Textarea
                placeholder={
                  lang === 'kn'
                    ? 'ಅವರು ನಿಮ್ಮ ವೃತ್ತಿ ಆಯ್ಕೆಗಾಗಿ ಹೇಗೆ ನೆರವಾಗಬಹುದು ಎಂಬುದನ್ನು ವಿವರಿಸಿ...'
                    : lang === 'ta'
                      ? 'உங்கள் தொழில் தேர்வில் அவர்கள் எப்படி உதவ முடியும் என்பதை எழுதுங்கள்...'
                      : 'Describe the specific ways they could help your career choice...'
                }
                value={responses[currentTab].similarities}
                onChange={(e) => handleRoleModelChange(currentTab, 'similarities', e.target.value)}
                rows={3}
                className="border-purple-200 focus:border-purple-400"
              />
            </div>

            <div>
              <label className="block text-sm font-medium text-gray-700 mb-2 flex items-center gap-2">
                {q['rm_q11'] || '11. Anything that you want to mention apart from above questions.'}
                <Tooltip>
                  <TooltipTrigger asChild>
                    <button type="button" className="text-purple-600">💬</button>
                  </TooltipTrigger>
                  <TooltipContent>
                    {lang === 'kn'
                      ? 'ಹಿಂದಿನ ಪ್ರಶ್ನೆಗಳಲ್ಲಿ ಬರೆಯದ ನಿಮ್ಮ ಆದರ್ಶ ವ್ಯಕ್ತಿಯ ಬಗ್ಗೆ ಇನ್ನೂ ಯಾವುದಾದರೂ ಅನುಭವಗಳು ಅಥವಾ ವಿಚಾರಗಳು ಇದ್ದರೆ ಇಲ್ಲಿ ಹಂಚಿಕೊಳ್ಳಿ.'
                      : lang === 'ta'
                        ? 'மேலுள்ள கேள்விகளில் சேர்க்காத, உங்கள் முன்மாதிரி பற்றிய கூடுதல் அனுபவங்கள் அல்லது எண்ணங்களை இங்கே பகிரலாம்.'
                        : 'Share any additional thoughts, stories, experiences, or insights about your role model that you haven\'t covered in the previous questions.'}
                  </TooltipContent>
                </Tooltip>
              </label>
              <Textarea
                placeholder={
                  lang === 'kn'
                    ? 'ನಿಮ್ಮ ಆದರ್ಶ ವ್ಯಕ್ತಿಯ ಬಗ್ಗೆ ಹೆಚ್ಚುವರಿ ಆಲೋಚನೆಗಳನ್ನು ಇಲ್ಲಿ ಬರೆಯಿರಿ...'
                    : lang === 'ta'
                      ? 'உங்கள் முன்மாதிரி பற்றிய கூடுதல் எண்ணங்களை இங்கே எழுதுங்கள்...'
                      : 'Share any additional thoughts or insights about your role model...'
                }
                value={responses[currentTab].incorporatePlan}
                onChange={(e) => handleRoleModelChange(currentTab, 'incorporatePlan', e.target.value)}
                rows={3}
                className="border-purple-200 focus:border-purple-400"
              />
            </div>
          </div>
        </CardContent>
      </Card>

        {/* Navigation and Submit */}
        <div className="flex justify-between items-center mt-8">
          <Button
            variant="outline"
            onClick={() => setCurrentTab(currentTab === 'roleModel1' ? 'roleModel3' : currentTab === 'roleModel2' ? 'roleModel1' : 'roleModel2')}
            className="border-purple-200 text-purple-700 hover:bg-purple-50"
          >
            {currentTab === 'roleModel1'
              ? (lang === 'kn'
                  ? '← ಹಿಂದಿನದು: ಮಾದರಿ ವ್ಯಕ್ತಿ -3 (ಪರಿಚಿತ / ಪ್ರಸಿದ್ಧ ವ್ಯಕ್ತಿ)'
                  : lang === 'ta'
                    ? '← முந்தையது: முன்மாதிரி -3 (அறிந்த / பிரபல நபர்)'
                    : '← Previous: Role Model -3 (Known/Famous Person)')
              : currentTab === 'roleModel2'
              ? (lang === 'kn'
                  ? '← ಹಿಂದಿನದು: ಮಾದರಿ ವ್ಯಕ್ತಿ -1 (ಹತ್ತಿರದಿಂದ ಪರಿಚಿತರಾದ ವ್ಯಕ್ತಿ)'
                  : lang === 'ta'
                    ? '← முந்தையது: முன்மாதிரி -1 (அறிமுகமான / நெருக்கமாக அறிந்த நபர்)'
                    : '← Previous: Role Model -1 (Preferably Closely Known Person)')
              : (lang === 'kn'
                  ? '← ಹಿಂದಿನದು: ಮಾದರಿ ವ್ಯಕ್ತಿ -2 (ಪರಿಚಿತ ವ್ಯಕ್ತಿ)'
                  : lang === 'ta'
                    ? '← முந்தையது: முன்மாதிரி -2 (நீங்கள் நன்கு அறிந்த நபர்)'
                    : '← Previous: Role Model -2 (Known Person)')}
          </Button>

            {/* Save Role Model progress button only (no status pill) */}
            <div className="flex items-center">
              <Button
                onClick={saveCurrentRoleModel}
                disabled={!isRoleModelComplete(currentTab) || saving || isRoleModelSaved(currentTab)}
                variant="outline"
                className="border-green-200 text-green-700 hover:bg-green-50"
              >
                {saving ? (
                  <>
                    <div className="animate-spin rounded-full h-4 w-4 border-b-2 border-green-600 mr-2"></div>
                    {t('saving')}
                  </>
                ) : isRoleModelSaved(currentTab) ? (
                  <>
                    <Save className="w-4 h-4 mr-2" />
                    {t('saved')}
                  </>
                ) : (
                  <>
                    <Save className="w-4 h-4 mr-2" />
                    {t('saveProgress') || 'Save Progress'}
                  </>
                )}
              </Button>
            </div>
            {currentTab !== 'roleModel3' && (
              <Button
                onClick={() => setCurrentTab(currentTab === 'roleModel1' ? 'roleModel2' : 'roleModel3')}
                className="bg-purple-600 hover:bg-purple-700"
              >
                {lang === 'kn'
                  ? currentTab === 'roleModel1'
                    ? 'ಮುಂದಿನದು: ಮಾದರಿ ವ್ಯಕ್ತಿ -2 (ಪರಿಚಿತ ವ್ಯಕ್ತಿ) →'
                    : 'ಮುಂದಿನದು: ಮಾದರಿ ವ್ಯಕ್ತಿ -3 (ಪರಿಚಿತ / ಪ್ರಸಿದ್ಧ ವ್ಯಕ್ತಿ) →'
                  : lang === 'ta'
                    ? currentTab === 'roleModel1'
                      ? 'அடுத்து: முன்மாதிரி -2 (நீங்கள் நன்கு அறிந்த நபர்) →'
                      : 'அடுத்து: முன்மாதிரி -3 (அறிந்த / பிரபல நபர்) →'
                    : `Next: ${
                        currentTab === 'roleModel1'
                          ? 'Role Model -2 (Known Person)'
                          : 'Role Model -3 (Known/Famous Person)'
                      } →`}
              </Button>
            )}

          </div>

          {/* General Questions Section (Questions 12 & 13) */}
          {currentTab === 'roleModel3' && (
            <Card className="border-0 shadow-lg mt-8">
              <CardHeader className="bg-gradient-to-r from-purple-50 to-pink-50">
                <CardTitle className="text-xl text-purple-800">
                  {lang === 'kn'
                    ? 'ಸಾಮಾನ್ಯ ಪ್ರತಿಬಿಂಬದ ಪ್ರಶ್ನೆಗಳು'
                    : lang === 'ta'
                      ? 'பொதுவான சிந்தனை கேள்விகள்'
                      : 'General Reflection Questions'}
                </CardTitle>
                <CardDescription className="text-purple-600">
                  {lang === 'kn'
                    ? 'ನಿಮ್ಮ ಎಲ್ಲಾ ಆದರ್ಶ ವ್ಯಕ್ತಿಗಳನ್ನು ಒಟ್ಟಾಗಿ ಯೋಚಿಸಿ, ಈ ಪ್ರಶ್ನೆಗಳಿಗೆ ಉತ್ತರಿಸಿ.'
                    : lang === 'ta'
                      ? 'உங்கள் அனைத்து முன்மாதிரி நபர்களையும் ஒன்றாக நினைத்து, இந்த கேள்விகளுக்கு பதில் எழுதுங்கள்.'
                      : 'Answer these questions about all your role models'}
                </CardDescription>
              </CardHeader>
              <CardContent className="p-6">
                <div className="space-y-8">
                  <div>
                    <label className="block text-sm font-medium text-gray-700 mb-2 flex items-center gap-2">
                      {q['rm_q12'] || '12. Do you notice any similarities between your personality traits and those of your role models?'}
                      <Tooltip>
                        <TooltipTrigger asChild>
                          <button type="button" className="text-purple-600">💬</button>
                        </TooltipTrigger>
                        <TooltipContent>
                          {lang === 'kn'
                            ? 'ನಿಮ್ಮ ಸ್ವಭಾವ, ಮೌಲ್ಯಗಳು, ಆಸಕ್ತಿಗಳು ಮತ್ತು ವರ್ತನೆಗಳಲ್ಲಿ ನಿಮ್ಮ ಆದರ್ಶ ವ್ಯಕ್ತಿಗಳ ಜೊತೆ ಏನಾದರೂ ಸಾಮ್ಯತೆಗಳಿವೆಯೇ ಎಂದು ಯೋಚಿಸಿ ಮತ್ತು ಬರೆಯಿರಿ.'
                            : lang === 'ta'
                              ? 'உங்கள் குணநலன்கள், மதிப்புகள், ஆர்வங்கள் மற்றும் நடத்தைகளில் உங்கள் முன்மாதிரி நபர்களுடன் ஏதேனும் ஒற்றுமைகள் உள்ளனவா என்று சிந்தித்து எழுதுங்கள்.'
                              : 'Reflect on whether you see similarities between your personality, values, interests, or behaviors and those of your role models.'}
                        </TooltipContent>
                      </Tooltip>
                    </label>
                    <Textarea
                      placeholder={
                        lang === 'kn'
                          ? 'ನಿಮ್ಮ ಮತ್ತು ನಿಮ್ಮ ಆದರ್ಶ ವ್ಯಕ್ತಿಗಳ ಗುಣಗಳಲ್ಲಿ ಇರುವ ಸಾಮ್ಯತೆಗಳನ್ನು ಇಲ್ಲಿ ಬರೆಯಿರಿ...'
                          : lang === 'ta'
                            ? 'உங்களுக்கும் உங்கள் முன்மாதிரி நபர்களுக்கும் உள்ள ஒற்றுமைகளை எழுதுங்கள்...'
                            : 'Reflect on similarities between your personality traits and those of your role models...'
                      }
                      value={responses.question12}
                      onChange={(e) => handleGeneralQuestionChange('question12', e.target.value)}
                      rows={5}
                      className="border-purple-200 focus:border-purple-400"
                    />
                  </div>

                  <div>
                    <label className="block text-sm font-medium text-gray-700 mb-2 flex items-center gap-2">
                      {q['rm_q13'] || '13. How do you intend to cultivate and incorporate some of the qualities exhibited by your role models into your own life?'}
                      <Tooltip>
                        <TooltipTrigger asChild>
                          <button type="button" className="text-purple-600">💬</button>
                        </TooltipTrigger>
                        <TooltipContent>
                          {lang === 'kn'
                            ? 'ನಿಮ್ಮ ಆದರ್ಶ ವ್ಯಕ್ತಿಗಳಲ್ಲಿ ನೀವು ಮೆಚ್ಚಿದ ಗುಣಗಳನ್ನು ನಿಮ್ಮ ಜೀವನದಲ್ಲಿ ಅಳವಡಿಸಲು ನೀವು ತೆಗೆದುಕೊಳ್ಳುವ ನಿರ್ದಿಷ್ಟ ಹೆಜ್ಜೆಗಳು ಅಥವಾ ಯೋಜನೆಯನ್ನು ಬರೆಯಿರಿ.'
                            : lang === 'ta'
                              ? 'உங்கள் முன்மாதிரியின் நல்ல குணங்களை உங்கள் வாழ்க்கையில் வளர்த்துக் கொள்ள நீங்கள் எடுக்க விருக்கும் குறிப்பான நடவடிக்கைகளை எழுதுங்கள்.'
                              : 'Describe your specific plan or steps to develop and practice the qualities you admire in your role models.'}
                        </TooltipContent>
                      </Tooltip>
                    </label>
                    <Textarea
                      placeholder={
                        lang === 'kn'
                          ? 'ನಿಮ್ಮ ಆದರ್ಶ ವ್ಯಕ್ತಿಯ ಗುಣಗಳನ್ನು ನಿಮ್ಮ ಜೀವನದಲ್ಲಿ ಹೇಗೆ ಹೇರಿಕೊಳ್ಳಲು ಯೋಜಿಸಿದ್ದೀರಿ ಎಂಬುದನ್ನು ವಿವರಿಸಿ...'
                          : lang === 'ta'
                            ? 'உங்கள் முன்மாதிரியின் குணங்களை உங்கள் வாழ்க்கையில் எப்படி கொண்டு வரப் போகிறீர்கள் என்பதை எழுதுங்கள்...'
                            : 'Describe how you plan to cultivate and incorporate the qualities of your role models into your life...'
                      }
                      value={responses.question13}
                      onChange={(e) => handleGeneralQuestionChange('question13', e.target.value)}
                      rows={5}
                      className="border-purple-200 focus:border-purple-400"
                    />
                  </div>
                </div>
              </CardContent>
            </Card>
          )}

          {/* Submit Button Section */}
          {currentTab === 'roleModel3' && (
            <div className="flex justify-end items-center mt-8">
              <Button
                onClick={submitAssessment}
                disabled={!canSubmit() || submitting}
                className="bg-purple-600 hover:bg-purple-700"
              >
                {submitting ? (
                  <>
                    <div className="animate-spin rounded-full h-4 w-4 border-b-2 border-white mr-2"></div>
                    {t('submitting')}
                  </>
                ) : (
                  <>
                    <Users className="w-4 h-4 mr-2" />
                    {t('submitAssessment')}
                  </>
                )}
              </Button>
            </div>
          )}
        </TooltipProvider>
      </div>
      <KannadaKeyboard lang={lang} />
    </div>
  );
}
