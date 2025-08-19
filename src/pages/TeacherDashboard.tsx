import { useState, useEffect } from 'react';
import { useAuth } from '@/hooks/useAuth';
import { supabase } from '@/integrations/supabase/client';
import { Button } from '@/components/ui/button';
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from '@/components/ui/card';
import { Tabs, TabsContent, TabsList, TabsTrigger } from '@/components/ui/tabs';
import { Badge } from '@/components/ui/badge';
import { Progress } from '@/components/ui/progress';
import { Input } from '@/components/ui/input';
import { Textarea } from '@/components/ui/textarea';
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from '@/components/ui/select';
import { 
  Users, 
  MessageCircle, 
  BookOpen, 
  Settings, 
  LogOut, 
  Search,
  CheckCircle,
  Clock,
  Lock,
  Send,
  Phone,
  Mail,
  TrendingUp,
  AlertTriangle,
  Award,
  Calendar,
  BarChart3,
  Target,
  Lightbulb,
  Star,
  Eye,
  Plus,
  Filter,
  Download,
  Bell,
  Shield,
  Heart,
  FileText
} from 'lucide-react';
import { useToast } from '@/hooks/use-toast';
import AssessmentResponsesView from '@/components/teacher/AssessmentResponsesView';

interface Student {
  id: string;
  users: {
    id: string;
    full_name: string;
    mobile: string;
  };
  classes: {
    name: string;
  };
  progress?: Array<{
    activity_id: string;
    status: string;
    activities: {
      title: string;
      sequence_number: number;
    };
  }>;
}

interface Activity {
  id: string;
  title: string;
  description: string;
  sequence_number: number;
}

export default function TeacherDashboard() {
  const { userProfile, signOut } = useAuth();
  const { toast } = useToast();
  const [students, setStudents] = useState<Student[]>([]);
  const [activities, setActivities] = useState<Activity[]>([]);
  const [loading, setLoading] = useState(true);
  const [searchTerm, setSearchTerm] = useState('');
  const [selectedStudent, setSelectedStudent] = useState<string>('');
  const [selectedActivity, setSelectedActivity] = useState<string>('');
  const [supportMessage, setSupportMessage] = useState('');
  const [filterStatus, setFilterStatus] = useState<string>('all');

  useEffect(() => {
    fetchData();
  }, []);

  const fetchData = async () => {
    try {
      if (!userProfile?.teacherProfile?.id) {
        console.warn('No teacher profile found, skipping data fetch');
        setLoading(false);
        return;
      }

      // Fetch students assigned to this teacher
      const { data: studentsData, error: studentsError } = await supabase
        .from('students')
        .select(`
          id,
          users:user_id(id, full_name, mobile),
          classes:class_id(name)
        `)
        .eq('teacher_id', userProfile.teacherProfile.id);

      if (studentsError) throw studentsError;

      // Fetch activities
      const { data: activitiesData, error: activitiesError } = await supabase
        .from('activities')
        .select('*')
        .order('sequence_number');

      if (activitiesError) throw activitiesError;

      // Fetch progress for all students
      const studentIds = studentsData?.map(s => s.id) || [];
      if (studentIds.length > 0) {
        const { data: progressData, error: progressError } = await supabase
          .from('student_activity_progress')
          .select(`
            *,
            activities:activity_id(title, sequence_number)
          `)
          .in('student_id', studentIds);

        if (progressError) throw progressError;

        // Group progress by student
        const progressByStudent = progressData?.reduce((acc, p) => {
          if (!acc[p.student_id]) acc[p.student_id] = [];
          acc[p.student_id].push(p);
          return acc;
        }, {} as Record<string, any[]>) || {};

        // Add progress to students
        const studentsWithProgress = studentsData?.map(student => ({
          ...student,
          progress: progressByStudent[student.id] || []
        })) || [];

        setStudents(studentsWithProgress);
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

  const unlockActivity = async (studentId: string, activityId: string) => {
    try {
      const { error } = await supabase
        .from('student_activity_progress')
        .upsert({
          student_id: studentId,
          activity_id: activityId,
          status: 'unlocked'
        });

      if (error) throw error;

      toast({
        title: "Activity Unlocked",
        description: "Student can now access this activity",
      });

      fetchData(); // Refresh data
    } catch (error) {
      console.error('Error unlocking activity:', error);
      toast({
        title: "Error",
        description: "Failed to unlock activity",
        variant: "destructive",
      });
    }
  };

  const getStudentProgress = (student: Student) => {
    const completed = student.progress?.filter(p => p.status === 'completed').length || 0;
    return activities.length > 0 ? (completed / activities.length) * 100 : 0;
  };

  const getOverallStats = () => {
    const totalStudents = students.length;
    const activeStudents = students.filter(s => getStudentProgress(s) > 0).length;
    const highPerformers = students.filter(s => getStudentProgress(s) >= 80).length;
    const needsAttention = students.filter(s => getStudentProgress(s) < 30).length;

    return { totalStudents, activeStudents, highPerformers, needsAttention };
  };

  const filteredStudents = students.filter(student => {
    const matchesSearch = student.users.full_name.toLowerCase().includes(searchTerm.toLowerCase());
    const matchesFilter = filterStatus === 'all' || 
      (filterStatus === 'high' && getStudentProgress(student) >= 80) ||
      (filterStatus === 'medium' && getStudentProgress(student) >= 30 && getStudentProgress(student) < 80) ||
      (filterStatus === 'low' && getStudentProgress(student) < 30);
    
    return matchesSearch && matchesFilter;
  });

  const sendSupportMessage = () => {
    toast({
      title: "Message Sent",
      description: "Your support request has been sent to ILP support team",
    });
    setSupportMessage('');
  };

  const StatusIcon = ({ status }: { status: string }) => {
    if (status === 'completed') return <CheckCircle className="w-4 h-4 text-green-500" />;
    if (status === 'unlocked') return <Clock className="w-4 h-4 text-blue-500" />;
    return <Lock className="w-4 h-4 text-gray-400" />;
  };

  if (loading) {
    return (
      <div className="min-h-screen flex items-center justify-center bg-gradient-to-br from-green-50 to-emerald-100">
        <div className="text-center">
          <div className="animate-spin rounded-full h-12 w-12 border-b-4 border-green-600 mx-auto"></div>
          <p className="mt-4 text-lg text-gray-600">Loading your teaching dashboard...</p>
        </div>
      </div>
    );
  }

  const stats = getOverallStats();

  return (
    <div className="min-h-screen bg-gradient-to-br from-green-50 via-white to-emerald-50">
      {/* Header with gradient background */}
      <header className="bg-gradient-to-r from-green-600 to-emerald-700 text-white shadow-lg">
        <div className="container mx-auto px-4 py-6">
          <div className="flex justify-between items-center">
            <div>
              <h1 className="text-3xl font-bold">👨‍🏫 Teacher Dashboard</h1>
              <p className="text-green-100 text-lg mt-1">
                Welcome, {userProfile?.full_name} - {userProfile?.teacherProfile?.schools?.name}
              </p>
              <p className="text-green-200 text-base mt-2">
                Guide your students on their career discovery journey! 🌟
              </p>
            </div>
            <div className="flex items-center gap-4">
              <Button variant="outline" className="border-white text-white hover:bg-white hover:text-green-600">
                <Bell className="w-4 h-4 mr-2" />
                Notifications
              </Button>
              <Button variant="outline" onClick={signOut} className="border-white text-white hover:bg-white hover:text-green-600">
                <LogOut className="w-4 h-4 mr-2" />
                Sign Out
              </Button>
            </div>
          </div>
        </div>
      </header>

      <main className="container mx-auto px-4 py-8">
        {/* Statistics Cards */}
        <div className="grid grid-cols-1 md:grid-cols-4 gap-6 mb-8">
          <Card className="bg-gradient-to-br from-blue-50 to-blue-100 border-blue-200">
            <CardContent className="p-6">
              <div className="flex items-center justify-between">
                <div>
                  <p className="text-sm font-medium text-blue-600">Total Students</p>
                  <p className="text-2xl font-bold text-blue-700">{stats.totalStudents}</p>
                </div>
                <Users className="w-8 h-8 text-blue-600" />
              </div>
            </CardContent>
          </Card>

          <Card className="bg-gradient-to-br from-green-50 to-green-100 border-green-200">
            <CardContent className="p-6">
              <div className="flex items-center justify-between">
                <div>
                  <p className="text-sm font-medium text-green-600">Active Students</p>
                  <p className="text-2xl font-bold text-green-700">{stats.activeStudents}</p>
                </div>
                <TrendingUp className="w-8 h-8 text-green-600" />
              </div>
            </CardContent>
          </Card>

          <Card className="bg-gradient-to-br from-purple-50 to-purple-100 border-purple-200">
            <CardContent className="p-6">
              <div className="flex items-center justify-between">
                <div>
                  <p className="text-sm font-medium text-purple-600">High Performers</p>
                  <p className="text-2xl font-bold text-purple-700">{stats.highPerformers}</p>
                </div>
                <Award className="w-8 h-8 text-purple-600" />
              </div>
            </CardContent>
          </Card>

          <Card className="bg-gradient-to-br from-orange-50 to-orange-100 border-orange-200">
            <CardContent className="p-6">
              <div className="flex items-center justify-between">
                <div>
                  <p className="text-sm font-medium text-orange-600">Need Attention</p>
                  <p className="text-2xl font-bold text-orange-700">{stats.needsAttention}</p>
                </div>
                <AlertTriangle className="w-8 h-8 text-orange-600" />
              </div>
            </CardContent>
          </Card>
        </div>

        {/* Quick Actions */}
        <div className="grid grid-cols-1 md:grid-cols-3 gap-6 mb-8">
          <Card className="bg-gradient-to-br from-blue-50 to-blue-100 border-blue-200 hover:shadow-lg transition-all duration-200 cursor-pointer">
            <CardContent className="p-6 text-center">
              <Plus className="w-12 h-12 text-blue-600 mx-auto mb-3" />
              <h3 className="font-semibold text-blue-800 mb-2">Add New Student</h3>
              <p className="text-sm text-blue-600">Enroll new students to your class</p>
            </CardContent>
          </Card>

          <Card className="bg-gradient-to-br from-green-50 to-green-100 border-green-200 hover:shadow-lg transition-all duration-200 cursor-pointer">
            <CardContent className="p-6 text-center">
              <Download className="w-12 h-12 text-green-600 mx-auto mb-3" />
              <h3 className="font-semibold text-green-800 mb-2">Export Reports</h3>
              <p className="text-sm text-green-600">Download student progress reports</p>
            </CardContent>
          </Card>

          <Card className="bg-gradient-to-br from-purple-50 to-purple-100 border-purple-200 hover:shadow-lg transition-all duration-200 cursor-pointer">
            <CardContent className="p-6 text-center">
              <Settings className="w-12 h-12 text-purple-600 mx-auto mb-3" />
              <h3 className="font-semibold text-purple-800 mb-2">Class Settings</h3>
              <p className="text-sm text-purple-600">Configure class preferences</p>
            </CardContent>
          </Card>
        </div>

        <Tabs defaultValue="students" className="space-y-6">
          <TabsList className="grid w-full grid-cols-6 bg-white shadow-md">
            <TabsTrigger value="students" className="flex items-center gap-2">
              <Users className="w-4 h-4" />
              My Students
            </TabsTrigger>
            <TabsTrigger value="assessments" className="flex items-center gap-2">
              <FileText className="w-4 h-4" />
              Assessments
            </TabsTrigger>
            <TabsTrigger value="analytics" className="flex items-center gap-2">
              <BarChart3 className="w-4 h-4" />
              Analytics
            </TabsTrigger>
            <TabsTrigger value="resources" className="flex items-center gap-2">
              <BookOpen className="w-4 h-4" />
              Resources
            </TabsTrigger>
            <TabsTrigger value="chat" className="flex items-center gap-2">
              <MessageCircle className="w-4 h-4" />
              CareerLM
            </TabsTrigger>
            <TabsTrigger value="support" className="flex items-center gap-2">
              <Heart className="w-4 h-4" />
              Support
            </TabsTrigger>
          </TabsList>

          <TabsContent value="students" className="space-y-4">
            <Card className="border-0 shadow-lg">
              <CardHeader className="bg-gradient-to-r from-blue-50 to-indigo-50">
                <CardTitle className="text-xl text-blue-800">Student Management</CardTitle>
                <CardDescription className="text-blue-600">
                  Monitor and guide your students' career development progress
                </CardDescription>
              </CardHeader>
              <CardContent className="p-6">
                <div className="flex gap-4 mb-6">
                  <div className="flex-1">
                    <div className="relative">
                      <Search className="absolute left-3 top-3 h-4 w-4 text-muted-foreground" />
                      <Input
                        placeholder="Search students by name..."
                        value={searchTerm}
                        onChange={(e) => setSearchTerm(e.target.value)}
                        className="pl-10"
                      />
                    </div>
                  </div>
                  <Select value={filterStatus} onValueChange={setFilterStatus}>
                    <SelectTrigger className="w-48">
                      <Filter className="w-4 h-4 mr-2" />
                      <SelectValue placeholder="Filter by progress" />
                    </SelectTrigger>
                    <SelectContent>
                      <SelectItem value="all">All Students</SelectItem>
                      <SelectItem value="high">High Performers (80%+)</SelectItem>
                      <SelectItem value="medium">Medium Progress (30-79%)</SelectItem>
                      <SelectItem value="low">Need Attention (&lt;30%)</SelectItem>
                    </SelectContent>
                  </Select>
                </div>

                <div className="grid gap-4">
                  {filteredStudents.map(student => (
                    <Card key={student.id} className="p-4 hover:shadow-md transition-all duration-200">
                      <div className="flex items-center justify-between mb-3">
                        <div className="flex items-center gap-3">
                          <div className="w-10 h-10 bg-gradient-to-br from-blue-500 to-purple-600 rounded-full flex items-center justify-center text-white font-semibold">
                            {student.users.full_name.charAt(0)}
                          </div>
                          <div>
                            <h3 className="font-semibold text-lg">{student.users.full_name}</h3>
                            <p className="text-sm text-muted-foreground">
                              {student.classes.name} • {student.users.mobile}
                            </p>
                          </div>
                        </div>
                        <div className="text-right">
                          <Badge variant={
                            getStudentProgress(student) >= 80 ? 'default' :
                            getStudentProgress(student) >= 30 ? 'secondary' : 'destructive'
                          }>
                            {Math.round(getStudentProgress(student))}% Complete
                          </Badge>
                        </div>
                      </div>
                      
                      <Progress value={getStudentProgress(student)} className="mb-3" />
                      
                      <div className="grid grid-cols-1 md:grid-cols-3 gap-2">
                        {activities.map(activity => {
                          const progress = student.progress?.find(p => p.activity_id === activity.id);
                          const status = progress?.status || 'locked';
                          
                          return (
                            <div key={activity.id} className="flex items-center justify-between p-2 rounded border bg-gray-50">
                              <div className="flex items-center gap-2">
                                <StatusIcon status={status} />
                                <span className="text-sm font-medium">{activity.title}</span>
                              </div>
                              {status === 'locked' && (
                                <Button
                                  size="sm"
                                  variant="outline"
                                  onClick={() => unlockActivity(student.id, activity.id)}
                                  className="text-xs"
                                >
                                  Unlock
                                </Button>
                              )}
                            </div>
                          );
                        })}
                      </div>
                    </Card>
                  ))}
                  
                  {filteredStudents.length === 0 && (
                    <div className="text-center py-12 text-muted-foreground">
                      <Users className="w-16 h-16 mx-auto mb-4 opacity-50" />
                      <p>No students found matching your criteria</p>
                    </div>
                  )}
                </div>
              </CardContent>
            </Card>
          </TabsContent>

          <TabsContent value="assessments" className="space-y-4">
            <AssessmentResponsesView />
          </TabsContent>

          <TabsContent value="analytics" className="space-y-4">
            <div className="grid gap-6 md:grid-cols-2">
              <Card className="border-0 shadow-lg">
                <CardHeader className="bg-gradient-to-r from-green-50 to-emerald-50">
                  <CardTitle className="text-lg text-green-800">Progress Distribution</CardTitle>
                </CardHeader>
                <CardContent className="p-6">
                  <div className="space-y-4">
                    <div className="flex items-center justify-between">
                      <span className="text-sm font-medium">High Performers (80%+)</span>
                      <Badge variant="default">{stats.highPerformers}</Badge>
                    </div>
                    <div className="flex items-center justify-between">
                      <span className="text-sm font-medium">Medium Progress (30-79%)</span>
                      <Badge variant="secondary">{stats.activeStudents - stats.highPerformers}</Badge>
                    </div>
                    <div className="flex items-center justify-between">
                      <span className="text-sm font-medium">Need Attention (&lt;30%)</span>
                      <Badge variant="destructive">{stats.needsAttention}</Badge>
                    </div>
                  </div>
                </CardContent>
              </Card>

              <Card className="border-0 shadow-lg">
                <CardHeader className="bg-gradient-to-r from-blue-50 to-indigo-50">
                  <CardTitle className="text-lg text-blue-800">Activity Completion</CardTitle>
                </CardHeader>
                <CardContent className="p-6">
                  <div className="space-y-3">
                    {activities.map(activity => {
                      const completedCount = students.filter(student => 
                        student.progress?.some(p => p.activity_id === activity.id && p.status === 'completed')
                      ).length;
                      const completionRate = students.length > 0 ? (completedCount / students.length) * 100 : 0;
                      
                      return (
                        <div key={activity.id} className="flex items-center justify-between">
                          <span className="text-sm font-medium">{activity.title}</span>
                          <div className="flex items-center gap-2">
                            <Progress value={completionRate} className="w-20 h-2" />
                            <span className="text-sm text-muted-foreground">{Math.round(completionRate)}%</span>
                          </div>
                        </div>
                      );
                    })}
                  </div>
                </CardContent>
              </Card>
            </div>
          </TabsContent>

          <TabsContent value="resources" className="space-y-4">
            <div className="grid gap-4 md:grid-cols-2 lg:grid-cols-3">
              <Card className="bg-gradient-to-br from-blue-50 to-blue-100 border-blue-200 hover:shadow-lg transition-all duration-200">
                <CardHeader>
                  <CardTitle className="text-blue-800">Career Charts</CardTitle>
                  <CardDescription className="text-blue-600">Visual career pathway guides</CardDescription>
                </CardHeader>
                <CardContent>
                  <div className="text-center py-8 text-blue-600">
                    <Target className="w-12 h-12 mx-auto mb-3 opacity-70" />
                    <p>Career charts coming soon...</p>
                  </div>
                </CardContent>
              </Card>

              <Card className="bg-gradient-to-br from-green-50 to-green-100 border-green-200 hover:shadow-lg transition-all duration-200">
                <CardHeader>
                  <CardTitle className="text-green-800">Video Library</CardTitle>
                  <CardDescription className="text-green-600">Educational career videos</CardDescription>
                </CardHeader>
                <CardContent>
                  <div className="text-center py-8 text-green-600">
                    <BookOpen className="w-12 h-12 mx-auto mb-3 opacity-70" />
                    <p>Video library coming soon...</p>
                  </div>
                </CardContent>
              </Card>

              <Card className="bg-gradient-to-br from-purple-50 to-purple-100 border-purple-200 hover:shadow-lg transition-all duration-200">
                <CardHeader>
                  <CardTitle className="text-purple-800">Slide Decks</CardTitle>
                  <CardDescription className="text-purple-600">Presentation materials</CardDescription>
                </CardHeader>
                <CardContent>
                  <div className="text-center py-8 text-purple-600">
                    <BookOpen className="w-12 h-12 mx-auto mb-3 opacity-70" />
                    <p>Slide decks coming soon...</p>
                  </div>
                </CardContent>
              </Card>
            </div>
          </TabsContent>

          <TabsContent value="chat" className="space-y-4">
            <Card className="bg-gradient-to-br from-purple-50 to-purple-100 border-purple-200">
              <CardHeader>
                <CardTitle className="text-2xl text-purple-800">🤖 CareerLM AI Assistant</CardTitle>
                <CardDescription className="text-purple-700 text-lg">
                  Get AI-powered insights to better guide your students
                </CardDescription>
              </CardHeader>
              <CardContent>
                <div className="text-center py-12 text-purple-600">
                  <MessageCircle className="w-24 h-24 mx-auto mb-6 opacity-70" />
                  <h3 className="text-xl font-semibold mb-2">AI Chat Coming Soon!</h3>
                  <p className="text-lg mb-4">Your AI teaching assistant will help you:</p>
                  <div className="grid grid-cols-1 md:grid-cols-3 gap-4 text-sm">
                    <div className="bg-white/50 p-3 rounded-lg">
                      <Lightbulb className="w-8 h-8 mx-auto mb-2" />
                      <p>Understand student needs</p>
                    </div>
                    <div className="bg-white/50 p-3 rounded-lg">
                      <Target className="w-8 h-8 mx-auto mb-2" />
                      <p>Create learning plans</p>
                    </div>
                    <div className="bg-white/50 p-3 rounded-lg">
                      <Star className="w-8 h-8 mx-auto mb-2" />
                      <p>Track progress effectively</p>
                    </div>
                  </div>
                </div>
              </CardContent>
            </Card>
          </TabsContent>

          <TabsContent value="support" className="space-y-4">
            <Card className="border-0 shadow-lg">
              <CardHeader className="bg-gradient-to-r from-pink-50 to-rose-50">
                <CardTitle className="text-xl text-pink-800">Contact ILP Support</CardTitle>
                <CardDescription className="text-pink-600">
                  Get help from our dedicated support team
                </CardDescription>
              </CardHeader>
              <CardContent className="p-6 space-y-6">
                <div className="grid gap-4 md:grid-cols-2">
                  <Card className="bg-gradient-to-br from-blue-50 to-blue-100 border-blue-200">
                    <CardContent className="pt-6">
                      <div className="flex items-center gap-3 mb-3">
                        <Phone className="w-5 h-5 text-blue-600" />
                        <h3 className="font-semibold">Phone Support</h3>
                      </div>
                      <p className="text-sm text-muted-foreground mb-2">Call us for immediate assistance</p>
                      <p className="font-mono text-sm">+91 1800-XXX-XXXX</p>
                    </CardContent>
                  </Card>

                  <Card className="bg-gradient-to-br from-green-50 to-green-100 border-green-200">
                    <CardContent className="pt-6">
                      <div className="flex items-center gap-3 mb-3">
                        <Mail className="w-5 h-5 text-green-600" />
                        <h3 className="font-semibold">Email Support</h3>
                      </div>
                      <p className="text-sm text-muted-foreground mb-2">Send us your queries</p>
                      <p className="font-mono text-sm">support@ilp.org</p>
                    </CardContent>
                  </Card>
                </div>

                <div className="space-y-3">
                  <h3 className="font-semibold text-lg">Send a Message</h3>
                  <Textarea
                    placeholder="Describe your issue or question..."
                    value={supportMessage}
                    onChange={(e) => setSupportMessage(e.target.value)}
                    rows={4}
                  />
                  <Button onClick={sendSupportMessage} disabled={!supportMessage.trim()}>
                    <Send className="w-4 h-4 mr-2" />
                    Send Message
                  </Button>
                </div>
              </CardContent>
            </Card>
          </TabsContent>
        </Tabs>
      </main>
    </div>
  );
}