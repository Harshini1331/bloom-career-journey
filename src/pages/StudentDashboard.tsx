import { useState, useEffect } from 'react';
import { useAuth } from '@/hooks/useAuth';
import { supabase } from '@/integrations/supabase/client';
import { useNavigate } from 'react-router-dom';
import { Button } from '@/components/ui/button';
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from '@/components/ui/card';
import { Badge } from '@/components/ui/badge';
import { Progress } from '@/components/ui/progress';
import {
  Zap,
  Activity,
  Sparkles,
  School,
  Users,
  Palette,
  Lock,
  CheckCircle,
  Play,
  Star,
  BookOpen,
  Heart,
  Target
} from 'lucide-react';
import { useToast } from '@/hooks/use-toast';
import React from 'react'; // Added missing import for React

export default function StudentDashboard() {
  const { userProfile } = useAuth();
  const navigate = useNavigate();
  const { toast } = useToast();
  
  // Assessment progress states
  const [assessmentProgress, setAssessmentProgress] = useState<any>(null);
  const [dreamsProgress, setDreamsProgress] = useState<any>(null);
  const [schoolLearningProgress, setSchoolLearningProgress] = useState<any>(null);
  const [roleModelsProgress, setRoleModelsProgress] = useState<any>(null);
  const [hobbiesProgress, setHobbiesProgress] = useState<any>(null);

  // Assessment completion status
  const [inspirationCompleted, setInspirationCompleted] = useState(false);
  const [dreamsCompleted, setDreamsCompleted] = useState(false);
  const [schoolLearningCompleted, setSchoolLearningCompleted] = useState(false);
  const [roleModelsCompleted, setRoleModelsCompleted] = useState(false);
  const [hobbiesCompleted, setHobbiesCompleted] = useState(false);

  useEffect(() => {
    fetchData();
    checkAssessmentProgress();
    checkDreamsProgress();
    checkSchoolLearningProgress();
    checkRoleModelsProgress();
    checkHobbiesProgress();
  }, []);

  // Update completion status when progress changes
  useEffect(() => {
    setInspirationCompleted(!!assessmentProgress);
    setDreamsCompleted(!!dreamsProgress);
    setSchoolLearningCompleted(!!schoolLearningProgress);
    setRoleModelsCompleted(!!roleModelsProgress);
    setHobbiesCompleted(!!hobbiesProgress);
  }, [assessmentProgress, dreamsProgress, schoolLearningProgress, roleModelsProgress, hobbiesProgress]);

  const fetchData = async () => {
    if (!userProfile?.id) return;

    try {
      // Fetch student data
      const { data: studentData, error: studentError } = await supabase
        .from('students')
        .select(`
          *,
          classes:class_id(name, schools:school_id(name)),
          teachers:teacher_id(users:user_id(full_name))
        `)
        .eq('user_id', userProfile.id)
        .single();

      if (studentError) throw studentError;
    } catch (error) {
      console.error('Error fetching student data:', error);
    }
  };

  // Helper function to get student ID
  const getStudentId = () => {
    if (!userProfile) return null;
    return userProfile.studentProfile?.id || userProfile.id;
  };

  const checkAssessmentProgress = async () => {
    const studentId = getStudentId();
    if (!studentId) return;

    try {
      const { data, error } = await supabase
        .from('assessment_responses')
        .select('*')
        .eq('student_id', studentId)
        .eq('assessment_type', 'inspiration')
        .eq('assessment_title', 'My Inspiration')
        .single();

      if (data && !error) {
        setAssessmentProgress(data);
      }
    } catch (error) {
      // No existing response found, which is fine
    }
  };

  const checkDreamsProgress = async () => {
    const studentId = getStudentId();
    if (!studentId) return;

    try {
      const { data, error } = await supabase
        .from('assessment_responses')
        .select('*')
        .eq('student_id', studentId)
        .eq('assessment_type', 'dreams')
        .eq('assessment_title', 'My Dreams')
        .single();

      if (data && !error) {
        setDreamsProgress(data);
      }
    } catch (error) {
      // No existing response found, which is fine
    }
  };

  const checkSchoolLearningProgress = async () => {
    const studentId = getStudentId();
    if (!studentId) return;

    try {
      const { data, error } = await supabase
        .from('assessment_responses')
        .select('*')
        .eq('student_id', studentId)
        .eq('assessment_type', 'school_learning')
        .eq('assessment_title', 'My School, My Learning and I')
        .single();

      if (data && !error) {
        setSchoolLearningProgress(data);
      }
    } catch (error) {
      // No existing response found, which is fine
    }
  };

  const checkRoleModelsProgress = async () => {
    const studentId = getStudentId();
    if (!studentId) return;

    try {
      const { data, error } = await supabase
        .from('assessment_responses')
        .select('*')
        .eq('student_id', studentId)
        .eq('assessment_type', 'role_models')
        .eq('assessment_title', 'My Role Models')
        .single();

      if (data && !error) {
        setRoleModelsProgress(data);
      }
    } catch (error) {
      // No existing response found, which is fine
    }
  };

  const checkHobbiesProgress = async () => {
    const studentId = getStudentId();
    if (!studentId) return;

    try {
      const { data, error } = await supabase
        .from('assessment_responses')
        .select('*')
        .eq('student_id', studentId)
        .eq('assessment_type', 'hobbies')
        .eq('assessment_title', 'My Hobbies')
        .single();

      if (data && !error) {
        setHobbiesProgress(data);
      }
    } catch (error) {
      // No existing response found, which is fine
    }
  };

  // Check if assessment is unlocked based on previous completion
  const isAssessmentUnlocked = (assessmentType: string) => {
    switch (assessmentType) {
      case 'inspiration':
        return true; // Always unlocked
      case 'dreams':
        return inspirationCompleted;
      case 'school_learning':
        return inspirationCompleted && dreamsCompleted;
      case 'role_models':
        return inspirationCompleted && dreamsCompleted && schoolLearningCompleted;
      case 'hobbies':
        return inspirationCompleted && dreamsCompleted && schoolLearningCompleted && roleModelsCompleted;
      default:
        return false;
    }
  };

  // Get assessment status and styling
  const getAssessmentStatus = (assessmentType: string) => {
    const isUnlocked = isAssessmentUnlocked(assessmentType);
    const isCompleted = getCompletionStatus(assessmentType);
    
    if (isCompleted) {
      return {
        status: 'completed',
        icon: CheckCircle,
        className: 'bg-gradient-to-br from-green-50 to-emerald-100 border-green-200 hover:shadow-lg transition-all duration-200 cursor-pointer',
        iconColor: 'text-green-600',
        textColor: 'text-green-800',
        descriptionColor: 'text-green-600'
      };
    } else if (isUnlocked) {
      return {
        status: 'unlocked',
        icon: getAssessmentIcon(assessmentType),
        className: 'bg-gradient-to-br from-blue-50 to-indigo-100 border-blue-200 hover:shadow-lg transition-all duration-200 cursor-pointer',
        iconColor: 'text-blue-600',
        textColor: 'text-blue-800',
        descriptionColor: 'text-blue-600'
      };
    } else {
      return {
        status: 'locked',
        icon: Lock,
        className: 'bg-gradient-to-br from-gray-50 to-gray-100 border-gray-200 opacity-60 cursor-not-allowed',
        iconColor: 'text-gray-400',
        textColor: 'text-gray-500',
        descriptionColor: 'text-gray-500'
      };
    }
  };

  // Get completion status for an assessment
  const getCompletionStatus = (assessmentType: string) => {
    switch (assessmentType) {
      case 'inspiration':
        return !!assessmentProgress;
      case 'dreams':
        return !!dreamsProgress;
      case 'school_learning':
        return !!schoolLearningProgress;
      case 'role_models':
        return !!roleModelsProgress;
      case 'hobbies':
        return !!hobbiesProgress;
      default:
        return false;
    }
  };

  // Get assessment icon
  const getAssessmentIcon = (assessmentType: string) => {
    switch (assessmentType) {
      case 'inspiration':
        return Play;
      case 'dreams':
        return Star;
      case 'school_learning':
        return BookOpen;
      case 'role_models':
        return Heart;
      case 'hobbies':
        return Target;
      default:
        return Activity;
    }
  };

  const startAssessment = (assessmentType: string) => {
    if (!isAssessmentUnlocked(assessmentType)) {
      toast({
        title: "Assessment Locked",
        description: "Complete the previous assessment to unlock this one.",
        variant: "destructive",
      });
      return;
    }

    if (assessmentType === 'inspiration') {
      navigate('/assessment/inspiration');
    } else if (assessmentType === 'dreams') {
      navigate('/assessment/dreams');
    } else if (assessmentType === 'school_learning') {
      navigate('/assessment/school-learning');
    } else if (assessmentType === 'role_models') {
      navigate('/assessment/role-models');
    } else if (assessmentType === 'hobbies') {
      navigate('/assessment/hobbies');
    }
  };

  // Calculate overall progress
  const getOverallProgress = () => {
    const totalAssessments = 5;
    const completedAssessments = [inspirationCompleted, dreamsCompleted, schoolLearningCompleted, roleModelsCompleted, hobbiesCompleted]
      .filter(Boolean).length;
    return (completedAssessments / totalAssessments) * 100;
  };

  return (
    <div className="min-h-screen bg-gradient-to-br from-blue-50 via-white to-indigo-50 py-8">
      <div className="container mx-auto px-4">
        {/* Header */}
        <div className="text-center mb-8">
          <h1 className="text-4xl font-bold text-gray-800 mb-4">Welcome to Your Career Journey</h1>
          <p className="text-xl text-gray-600">
            Complete assessments in sequence to unlock your full potential
          </p>
        </div>

        {/* Overall Progress */}
        <Card className="mb-8 border-0 shadow-lg">
          <CardContent className="p-6">
            <div className="flex items-center justify-between mb-4">
              <h2 className="text-xl font-semibold text-gray-800">Your Journey Progress</h2>
              <Badge variant="secondary">{Math.round(getOverallProgress())}% Complete</Badge>
            </div>
            <Progress value={getOverallProgress()} className="h-3" />
            <div className="flex justify-between text-sm text-gray-600 mt-2">
              <span>5 Assessments Total</span>
              <span>{Math.round(getOverallProgress())}% Complete</span>
            </div>
          </CardContent>
        </Card>

        {/* Assessment Cards - Sequential Unlocking */}
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-5 gap-6 mb-8">
          {/* 1. My Inspiration - Always Unlocked */}
          <Card
            className={getAssessmentStatus('inspiration').className}
            onClick={() => startAssessment('inspiration')}
          >
            <CardContent className="p-6 text-center">
              {React.createElement(getAssessmentStatus('inspiration').icon, {
                className: `w-12 h-12 ${getAssessmentStatus('inspiration').iconColor} mx-auto mb-3`
              })}
              <h3 className={`font-semibold ${getAssessmentStatus('inspiration').textColor} mb-2`}>
                1. My Inspiration
              </h3>
              <p className={`text-sm ${getAssessmentStatus('inspiration').descriptionColor} mb-2`}>
                Discover what inspires you
              </p>
              {getCompletionStatus('inspiration') && (
                <Badge variant="default" className="mt-2 bg-green-600">Completed ✓</Badge>
              )}
              {!getCompletionStatus('inspiration') && (
                <Badge variant="secondary" className="mt-2">Start Here</Badge>
              )}
            </CardContent>
          </Card>

          {/* 2. My Dreams - Unlocked after Inspiration */}
          <Card
            className={getAssessmentStatus('dreams').className}
            onClick={() => startAssessment('dreams')}
          >
            <CardContent className="p-6 text-center">
              {React.createElement(getAssessmentStatus('dreams').icon, {
                className: `w-12 h-12 ${getAssessmentStatus('dreams').iconColor} mx-auto mb-3`
              })}
              <h3 className={`font-semibold ${getAssessmentStatus('dreams').textColor} mb-2`}>
                2. My Dreams
              </h3>
              <p className={`text-sm ${getAssessmentStatus('dreams').descriptionColor} mb-2`}>
                Explore your future aspirations
              </p>
              {getCompletionStatus('dreams') && (
                <Badge variant="default" className="mt-2 bg-green-600">Completed ✓</Badge>
              )}
              {!getCompletionStatus('dreams') && isAssessmentUnlocked('dreams') && (
                <Badge variant="secondary" className="mt-2">Available</Badge>
              )}
              {!isAssessmentUnlocked('dreams') && (
                <Badge variant="outline" className="mt-2">Locked 🔒</Badge>
              )}
            </CardContent>
          </Card>

          {/* 3. My School & Learning - Unlocked after Dreams */}
          <Card
            className={getAssessmentStatus('school_learning').className}
            onClick={() => startAssessment('school_learning')}
          >
            <CardContent className="p-6 text-center">
              {React.createElement(getAssessmentStatus('school_learning').icon, {
                className: `w-12 h-12 ${getAssessmentStatus('school_learning').iconColor} mx-auto mb-3`
              })}
              <h3 className={`font-semibold ${getAssessmentStatus('school_learning').textColor} mb-2`}>
                3. My School & Learning
              </h3>
              <p className={`text-sm ${getAssessmentStatus('school_learning').descriptionColor} mb-2`}>
                Reflect on your learning journey
              </p>
              {getCompletionStatus('school_learning') && (
                <Badge variant="default" className="mt-2 bg-green-600">Completed ✓</Badge>
              )}
              {!getCompletionStatus('school_learning') && isAssessmentUnlocked('school_learning') && (
                <Badge variant="secondary" className="mt-2">Available</Badge>
              )}
              {!isAssessmentUnlocked('school_learning') && (
                <Badge variant="outline" className="mt-2">Locked 🔒</Badge>
              )}
            </CardContent>
          </Card>

          {/* 4. My Role Models - Unlocked after School Learning */}
          <Card
            className={getAssessmentStatus('role_models').className}
            onClick={() => startAssessment('role_models')}
          >
            <CardContent className="p-6 text-center">
              {React.createElement(getAssessmentStatus('role_models').icon, {
                className: `w-12 h-12 ${getAssessmentStatus('role_models').iconColor} mx-auto mb-3`
              })}
              <h3 className={`font-semibold ${getAssessmentStatus('role_models').textColor} mb-2`}>
                4. My Role Models
              </h3>
              <p className={`text-sm ${getAssessmentStatus('role_models').descriptionColor} mb-2`}>
                Identify your inspiring role models
              </p>
              {getCompletionStatus('role_models') && (
                <Badge variant="default" className="mt-2 bg-green-600">Completed ✓</Badge>
              )}
              {!getCompletionStatus('role_models') && isAssessmentUnlocked('role_models') && (
                <Badge variant="secondary" className="mt-2">Available</Badge>
              )}
              {!isAssessmentUnlocked('role_models') && (
                <Badge variant="outline" className="mt-2">Locked 🔒</Badge>
              )}
            </CardContent>
          </Card>

          {/* 5. My Hobbies - Unlocked after Role Models */}
          <Card
            className={getAssessmentStatus('hobbies').className}
            onClick={() => startAssessment('hobbies')}
          >
            <CardContent className="p-6 text-center">
              {React.createElement(getAssessmentStatus('hobbies').icon, {
                className: `w-12 h-12 ${getAssessmentStatus('hobbies').iconColor} mx-auto mb-3`
              })}
              <h3 className={`font-semibold ${getAssessmentStatus('hobbies').textColor} mb-2`}>
                5. My Hobbies
              </h3>
              <p className={`text-sm ${getAssessmentStatus('hobbies').descriptionColor} mb-2`}>
                Discover career paths from your interests
              </p>
              {getCompletionStatus('hobbies') && (
                <Badge variant="default" className="mt-2 bg-green-600">Completed ✓</Badge>
              )}
              {!getCompletionStatus('hobbies') && isAssessmentUnlocked('hobbies') && (
                <Badge variant="secondary" className="mt-2">Available</Badge>
              )}
              {!isAssessmentUnlocked('hobbies') && (
                <Badge variant="outline" className="mt-2">Locked 🔒</Badge>
              )}
            </CardContent>
          </Card>
        </div>

        {/* Progress Summary */}
        <Card className="border-0 shadow-lg">
          <CardHeader>
            <CardTitle className="text-xl text-gray-800">Assessment Progress Summary</CardTitle>
            <CardDescription>
              Track your completion status across all assessments
            </CardDescription>
          </CardHeader>
          <CardContent>
            <div className="space-y-3">
              <div className="flex items-center justify-between p-3 bg-green-50 rounded-lg">
                <span className="font-medium text-green-800">1. My Inspiration</span>
                <Badge variant={inspirationCompleted ? "default" : "secondary"}>
                  {inspirationCompleted ? "Completed ✓" : "Not Started"}
                </Badge>
              </div>
              <div className="flex items-center justify-between p-3 bg-blue-50 rounded-lg">
                <span className="font-medium text-blue-800">2. My Dreams</span>
                <Badge variant={dreamsCompleted ? "default" : (inspirationCompleted ? "secondary" : "outline")}>
                  {dreamsCompleted ? "Completed ✓" : (inspirationCompleted ? "Available" : "Locked 🔒")}
                </Badge>
              </div>
              <div className="flex items-center justify-between p-3 bg-purple-50 rounded-lg">
                <span className="font-medium text-purple-800">3. My School & Learning</span>
                <Badge variant={schoolLearningCompleted ? "default" : (dreamsCompleted ? "secondary" : "outline")}>
                  {schoolLearningCompleted ? "Completed ✓" : (dreamsCompleted ? "Available" : "Locked 🔒")}
                </Badge>
              </div>
              <div className="flex items-center justify-between p-3 bg-pink-50 rounded-lg">
                <span className="font-medium text-pink-800">4. My Role Models</span>
                <Badge variant={roleModelsCompleted ? "default" : (schoolLearningCompleted ? "secondary" : "outline")}>
                  {roleModelsCompleted ? "Completed ✓" : (schoolLearningCompleted ? "Available" : "Locked 🔒")}
                </Badge>
              </div>
              <div className="flex items-center justify-between p-3 bg-orange-50 rounded-lg">
                <span className="font-medium text-orange-800">5. My Hobbies</span>
                <Badge variant={hobbiesCompleted ? "default" : (roleModelsCompleted ? "secondary" : "outline")}>
                  {hobbiesCompleted ? "Completed ✓" : (roleModelsCompleted ? "Available" : "Locked 🔒")}
                </Badge>
              </div>
            </div>
          </CardContent>
        </Card>
      </div>
    </div>
  );
}