import { useState, useEffect } from 'react';
import { useAuth } from '@/hooks/useAuth';
import { supabase } from '@/integrations/supabase/client';
import { Button } from '@/components/ui/button';
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from '@/components/ui/card';
import { Tabs, TabsContent, TabsList, TabsTrigger } from '@/components/ui/tabs';
import { Badge } from '@/components/ui/badge';
import { Progress } from '@/components/ui/progress';
import { 
  BookOpen, 
  MessageCircle, 
  User, 
  Lock, 
  CheckCircle, 
  Circle, 
  LogOut, 
  Trophy, 
  Target, 
  TrendingUp, 
  Star,
  Award,
  Calendar,
  Clock,
  Play,
  Eye,
  BarChart3,
  Phone,
  Lightbulb,
  Compass,
  Zap,
  Activity
} from 'lucide-react';
import { useToast } from '@/hooks/use-toast';

interface Activity {
  id: string;
  title: string;
  description: string;
  sequence_number: number;
}

interface ActivityProgress {
  activity_id: string;
  status: string;
  results?: string;
  completed_at?: string;
}

export default function StudentDashboard() {
  const { userProfile, signOut } = useAuth();
  const { toast } = useToast();
  const [activities, setActivities] = useState<Activity[]>([]);
  const [progress, setProgress] = useState<ActivityProgress[]>([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    fetchData();
  }, []);

  const fetchData = async () => {
    try {
      // Fetch all activities
      const { data: activitiesData, error: activitiesError } = await supabase
        .from('activities')
        .select('*')
        .order('sequence_number');

      if (activitiesError) throw activitiesError;

      // Fetch student progress (only if studentProfile exists)
      if (userProfile?.studentProfile?.id) {
        const { data: progressData, error: progressError } = await supabase
          .from('student_activity_progress')
          .select('*')
          .eq('student_id', userProfile.studentProfile.id);

        if (progressError) throw progressError;

        setProgress(progressData || []);
      } else {
        console.warn('No student profile found, skipping progress fetch');
        setProgress([]);
      }

      setActivities(activitiesData || []);
    } catch (error) {
      console.error('Error fetching data:', error);
      toast({
        title: "Error",
        description: "Failed to load dashboard data",
        variant: "destructive",
      });
    } finally {
      setLoading(false);
    }
  };

  const getActivityProgress = (activityId: string): ActivityProgress => {
    return progress.find(p => p.activity_id === activityId) || 
           { activity_id: activityId, status: 'locked' };
  };

  const getProgressPercentage = () => {
    const completed = progress.filter(p => p.status === 'completed').length;
    return activities.length > 0 ? (completed / activities.length) * 100 : 0;
  };

  const getCompletedCount = () => {
    return progress.filter(p => p.status === 'completed').length;
  };

  const getStreakDays = () => {
    // Mock streak calculation - in real app, calculate based on completion dates
    return Math.floor(Math.random() * 7) + 1;
  };

  const getCareerPathsExplored = () => {
    // Mock data - in real app, count unique career paths from assessments
    return Math.floor(Math.random() * 5) + 2;
  };

  const getChatSessions = () => {
    // Mock data - in real app, count chat sessions with CareerLM
    return Math.floor(Math.random() * 10) + 3;
  };

  const startActivity = async (activity: Activity) => {
    const activityProgress = getActivityProgress(activity.id);
    
    if (activityProgress.status === 'locked') {
      toast({
        title: "Activity Locked 🔒",
        description: "Complete previous activities first to unlock this one!",
        variant: "destructive",
      });
      return;
    }

    if (activityProgress.status === 'completed') {
      toast({
        title: "Activity Completed! 🎉",
        description: "You have already completed this activity",
      });
      return;
    }

    // Mock activity completion - in real app, this would navigate to activity page
    const results = `Completed ${activity.title} assessment`;
    
    if (!userProfile?.studentProfile?.id) {
      toast({
        title: "Error",
        description: "Student profile not found",
        variant: "destructive",
      });
      return;
    }
    
    try {
      const { error } = await supabase
        .from('student_activity_progress')
        .upsert({
          student_id: userProfile.studentProfile.id,
          activity_id: activity.id,
          status: 'completed',
          results,
          completed_at: new Date().toISOString(),
        });

      if (error) throw error;

      toast({
        title: "🎯 Activity Completed!",
        description: `Great job completing ${activity.title}! Keep going!`,
      });

      fetchData(); // Refresh data
    } catch (error) {
      console.error('Error completing activity:', error);
      toast({
        title: "Error",
        description: "Failed to complete activity",
        variant: "destructive",
      });
    }
  };

  const ActivityIcon = ({ status }: { status: string }) => {
    if (status === 'completed') return <CheckCircle className="w-6 h-6 text-green-500" />;
    if (status === 'unlocked') return <Circle className="w-6 h-6 text-blue-500" />;
    return <Lock className="w-6 h-6 text-gray-400" />;
  };

  if (loading) {
    return (
      <div className="min-h-screen flex items-center justify-center bg-gradient-to-br from-blue-50 to-indigo-100">
        <div className="text-center">
          <div className="animate-spin rounded-full h-12 w-12 border-b-4 border-blue-600 mx-auto"></div>
          <p className="mt-4 text-lg text-gray-600">Loading your learning journey...</p>
        </div>
      </div>
    );
  }

  return (
    <div className="min-h-screen bg-gradient-to-br from-blue-50 via-white to-indigo-50">
      {/* Header with gradient background */}
      <header className="bg-gradient-to-r from-blue-600 to-indigo-700 text-white shadow-lg">
        <div className="container mx-auto px-4 py-6">
          <div className="flex justify-between items-center">
            <div>
              <h1 className="text-3xl font-bold">🎓 Welcome, {userProfile?.full_name}!</h1>
              <p className="text-blue-100 text-lg mt-1">
                {userProfile?.studentProfile?.classes?.name} • {userProfile?.studentProfile?.classes?.schools?.name}
              </p>
              <p className="text-blue-200 text-base mt-2">
                Track your progress and discover your perfect career path! 🚀
              </p>
            </div>
            <Button variant="outline" onClick={signOut} className="border-white text-white hover:bg-white hover:text-blue-600">
              <LogOut className="w-4 h-4 mr-2" />
              Sign Out
            </Button>
          </div>
        </div>
      </header>

      <main className="container mx-auto px-4 py-8">
        {/* Statistics Cards */}
        <div className="grid grid-cols-1 md:grid-cols-4 gap-6 mb-8">
          <Card className="bg-gradient-to-br from-green-50 to-green-100 border-green-200">
            <CardContent className="p-6">
              <div className="flex items-center justify-between">
                <div>
                  <p className="text-sm font-medium text-green-600">Assessments Completed</p>
                  <p className="text-2xl font-bold text-green-700">{getCompletedCount()}</p>
                </div>
                <TrendingUp className="w-8 h-8 text-green-600" />
              </div>
            </CardContent>
          </Card>

          <Card className="bg-gradient-to-br from-blue-50 to-blue-100 border-blue-200">
            <CardContent className="p-6">
              <div className="flex items-center justify-between">
                <div>
                  <p className="text-sm font-medium text-blue-600">Career Paths Explored</p>
                  <p className="text-2xl font-bold text-blue-700">{getCareerPathsExplored()}</p>
                </div>
                <Compass className="w-8 h-8 text-blue-600" />
              </div>
            </CardContent>
          </Card>

          <Card className="bg-gradient-to-br from-purple-50 to-purple-100 border-purple-200">
            <CardContent className="p-6">
              <div className="flex items-center justify-between">
                <div>
                  <p className="text-sm font-medium text-purple-600">Activities Completed</p>
                  <p className="text-2xl font-bold text-purple-700">{getCompletedCount()}</p>
                </div>
                <CheckCircle className="w-8 h-8 text-purple-600" />
              </div>
            </CardContent>
          </Card>

          <Card className="bg-gradient-to-br from-orange-50 to-orange-100 border-orange-200">
            <CardContent className="p-6">
              <div className="flex items-center justify-between">
                <div>
                  <p className="text-sm font-medium text-orange-600">Chat Sessions</p>
                  <p className="text-2xl font-bold text-orange-700">{getChatSessions()}</p>
                </div>
                <MessageCircle className="w-8 h-8 text-orange-600" />
              </div>
            </CardContent>
          </Card>
        </div>

        {/* Progress Bar */}
        <Card className="mb-8 border-0 shadow-lg bg-white">
          <CardContent className="p-6">
            <div className="flex items-center justify-between mb-4">
              <h2 className="text-xl font-bold text-gray-800">Your Learning Journey</h2>
              <Badge variant="secondary" className="text-sm px-3 py-1">
                {getCompletedCount()} of {activities.length} completed
              </Badge>
            </div>
            <Progress value={getProgressPercentage()} className="h-3 bg-gray-200" />
            <div className="flex justify-between text-sm text-gray-600 mt-2">
              <span>Start</span>
              <span>Finish</span>
            </div>
          </CardContent>
        </Card>

        {/* Quick Actions Grid */}
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6 mb-8">
          <Card className="bg-gradient-to-br from-blue-50 to-blue-100 border-blue-200 hover:shadow-lg transition-all duration-200 cursor-pointer">
            <CardContent className="p-6 text-center">
              <Target className="w-12 h-12 text-blue-600 mx-auto mb-3" />
              <h3 className="font-semibold text-blue-800 mb-2">Self-Discovery Quiz</h3>
              <p className="text-sm text-blue-600">Take personality & career assessments</p>
            </CardContent>
          </Card>

          <Card className="bg-gradient-to-br from-purple-50 to-purple-100 border-purple-200 hover:shadow-lg transition-all duration-200 cursor-pointer">
            <CardContent className="p-6 text-center">
              <MessageCircle className="w-12 h-12 text-purple-600 mx-auto mb-3" />
              <h3 className="font-semibold text-purple-800 mb-2">CareerLM Chat</h3>
              <p className="text-sm text-purple-600">Get AI career guidance</p>
            </CardContent>
          </Card>

          <Card className="bg-gradient-to-br from-green-50 to-green-100 border-green-200 hover:shadow-lg transition-all duration-200 cursor-pointer">
            <CardContent className="p-6 text-center">
              <Compass className="w-12 h-12 text-green-600 mx-auto mb-3" />
              <h3 className="font-semibold text-green-800 mb-2">View Career Paths</h3>
              <p className="text-sm text-green-600">Explore different career options</p>
            </CardContent>
          </Card>

          <Card className="bg-gradient-to-br from-orange-50 to-orange-100 border-orange-200 hover:shadow-lg transition-all duration-200 cursor-pointer">
            <CardContent className="p-6 text-center">
              <BarChart3 className="w-12 h-12 text-orange-600 mx-auto mb-3" />
              <h3 className="font-semibold text-orange-800 mb-2">Track Progress</h3>
              <p className="text-sm text-orange-600">Monitor your development</p>
            </CardContent>
          </Card>
        </div>

        <div className="grid grid-cols-1 lg:grid-cols-3 gap-8">
          {/* Main Content - Activities */}
          <div className="lg:col-span-2">
            <Card className="border-0 shadow-lg">
              <CardHeader className="bg-gradient-to-r from-blue-50 to-indigo-50">
                <CardTitle className="text-xl text-blue-800">🚀 Your Career Discovery Journey</CardTitle>
                <CardDescription className="text-blue-600">
                  Complete assessments to unlock your potential and discover your career path
                </CardDescription>
              </CardHeader>
              <CardContent className="p-6">
                <div className="grid gap-4">
                  {activities.map((activity, index) => {
                    const activityProgress = getActivityProgress(activity.id);
                    const isUnlocked = index === 0 || 
                      progress.some(p => p.activity_id === activities[index - 1]?.id && p.status === 'completed');
                    
                    const currentStatus = isUnlocked ? 
                      (activityProgress.status === 'locked' ? 'unlocked' : activityProgress.status) : 
                      'locked';

                    return (
                      <Card key={activity.id} className={`transition-all duration-300 hover:shadow-lg ${
                        currentStatus === 'completed' ? 'bg-gradient-to-r from-green-50 to-green-100 border-green-300' :
                        currentStatus === 'unlocked' ? 'bg-white hover:shadow-xl border-blue-200' :
                        'bg-gray-50 border-gray-200'
                      }`}>
                        <CardHeader className="pb-4">
                          <div className="flex items-center justify-between">
                            <div className="flex items-center gap-4">
                              <div className={`p-3 rounded-full ${
                                currentStatus === 'completed' ? 'bg-green-100' :
                                currentStatus === 'unlocked' ? 'bg-blue-100' :
                                'bg-gray-100'
                              }`}>
                                <ActivityIcon status={currentStatus} />
                              </div>
                              <div>
                                <CardTitle className="text-xl text-gray-800">{activity.title}</CardTitle>
                                <CardDescription className="text-gray-600 text-base">{activity.description}</CardDescription>
                                <div className="flex items-center gap-4 mt-2">
                                  <Badge variant={
                                    currentStatus === 'completed' ? 'default' : 'secondary'
                                  } className="text-sm">
                                    {currentStatus === 'completed' ? '✅ Completed' :
                                     currentStatus === 'unlocked' ? '🎯 Ready to Start' :
                                     '🔒 Locked'}
                                  </Badge>
                                  {currentStatus === 'completed' && (
                                    <div className="flex items-center gap-1 text-sm text-green-600">
                                      <Star className="w-4 h-4" />
                                      <span>+10 points earned</span>
                                    </div>
                                  )}
                                </div>
                              </div>
                            </div>
                          </div>
                        </CardHeader>
                        <CardContent>
                          <Button
                            onClick={() => startActivity(activity)}
                            disabled={currentStatus === 'locked'}
                            variant={currentStatus === 'completed' ? 'secondary' : 'default'}
                            className={`w-full h-12 text-lg font-semibold ${
                              currentStatus === 'completed' ? 'bg-green-600 hover:bg-green-700' :
                              currentStatus === 'unlocked' ? 'bg-blue-600 hover:bg-blue-700' :
                              'bg-gray-400 cursor-not-allowed'
                            }`}
                          >
                            {currentStatus === 'completed' ? (
                              <>
                                <Eye className="w-5 h-5 mr-2" />
                                View Results
                              </>
                            ) : currentStatus === 'unlocked' ? (
                              <>
                                <Play className="w-5 h-5 mr-2" />
                                Start Assessment
                              </>
                            ) : (
                              <>
                                <Lock className="w-5 h-5 mr-2" />
                                Complete Previous First
                              </>
                            )}
                          </Button>
                        </CardContent>
                      </Card>
                    );
                  })}
                </div>
              </CardContent>
            </Card>
          </div>

          {/* Right Sidebar */}
          <div className="space-y-6">
            {/* Recent Activities Panel */}
            <Card className="border-0 shadow-lg">
              <CardHeader className="bg-gradient-to-r from-green-50 to-emerald-50">
                <CardTitle className="text-lg text-green-800 flex items-center gap-2">
                  <Activity className="w-5 h-5" />
                  Recent Activities
                </CardTitle>
              </CardHeader>
              <CardContent className="p-4">
                <div className="space-y-3">
                  {progress.slice(0, 5).map((prog, index) => {
                    const activity = activities.find(a => a.id === prog.activity_id);
                    if (!activity) return null;
                    
                    return (
                      <div key={prog.activity_id} className="flex items-center gap-3 p-2 rounded-lg bg-gray-50">
                        <div className={`w-2 h-2 rounded-full ${
                          prog.status === 'completed' ? 'bg-green-500' : 'bg-blue-500'
                        }`} />
                        <div className="flex-1">
                          <p className="text-sm font-medium text-gray-800">{activity.title}</p>
                          <p className="text-xs text-gray-500">
                            {prog.status === 'completed' ? 'Completed' : 'In Progress'}
                          </p>
                        </div>
                        <Clock className="w-4 h-4 text-gray-400" />
                      </div>
                    );
                  })}
                  {progress.length === 0 && (
                    <p className="text-sm text-gray-500 text-center py-4">
                      No activities yet. Start your journey!
                    </p>
                  )}
                </div>
              </CardContent>
            </Card>

            {/* Career Insights Panel */}
            <Card className="border-0 shadow-lg">
              <CardHeader className="bg-gradient-to-r from-purple-50 to-pink-50">
                <CardTitle className="text-lg text-purple-800 flex items-center gap-2">
                  <Lightbulb className="w-5 h-5" />
                  Career Insights
                </CardTitle>
              </CardHeader>
              <CardContent className="p-4">
                <div className="space-y-4">
                  <div>
                    <h4 className="font-medium text-gray-800 mb-2">🎯 Learning Path Focus</h4>
                    <p className="text-sm text-gray-600">Based on your assessments, focus on:</p>
                    <ul className="text-sm text-gray-600 mt-1 space-y-1">
                      <li>• Problem-solving skills</li>
                      <li>• Creative thinking</li>
                      <li>• Team collaboration</li>
                    </ul>
                  </div>
                  
                  <div>
                    <h4 className="font-medium text-gray-800 mb-2">💼 Recommended Careers</h4>
                    <div className="space-y-2">
                      <Badge variant="secondary" className="w-full justify-center">Software Engineer</Badge>
                      <Badge variant="secondary" className="w-full justify-center">Data Analyst</Badge>
                      <Badge variant="secondary" className="w-full justify-center">Product Manager</Badge>
                    </div>
                  </div>
                </div>
              </CardContent>
            </Card>
          </div>
        </div>
      </main>
    </div>
  );
}

function Label({ children, className }: { children: React.ReactNode; className?: string }) {
  return <div className={className}>{children}</div>;
}