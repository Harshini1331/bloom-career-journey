import { useAuth } from '@/hooks/useAuth';
import { Navigate, useLocation } from 'react-router-dom';
import { LoaderCircle } from 'lucide-react';

interface ProtectedRouteProps {
  children: React.ReactNode;
  allowedRoles?: ('admin' | 'teacher' | 'student')[];
}

export default function ProtectedRoute({ children, allowedRoles }: ProtectedRouteProps) {
  const { user, loading, userProfile } = useAuth();
  const location = useLocation();

  // Debug logging
  console.log('🔒 ProtectedRoute check:', {
    loading,
    hasUser: !!user,
    hasUserProfile: !!userProfile,
    userRole: userProfile?.role,
    allowedRoles,
    currentPath: location.pathname,
    timestamp: new Date().toISOString(),
    userDetails: user ? {
      id: user.id,
      email: user.email,
      metadata: user.user_metadata
    } : null,
    profileDetails: userProfile ? {
      id: userProfile.id,
      role: userProfile.role,
      full_name: userProfile.full_name
    } : null
  });

  if (loading) {
    console.log('🔒 ProtectedRoute: Still loading...');
    return (
      <div className="min-h-screen flex items-center justify-center bg-background">
        <LoaderCircle className="w-8 h-8 animate-spin text-primary" />
      </div>
    );
  }

  if (!user || !userProfile) {
    console.log('🔒 ProtectedRoute: Missing user or userProfile, redirecting to auth');
    console.log('🔒 User:', user);
    console.log('🔒 UserProfile:', userProfile);
    console.log('🔒 Loading state:', loading);
    console.log('🔒 Current path:', location.pathname);
    console.log('🔒 Allowed roles:', allowedRoles);
    
    // Add a small delay to prevent rapid redirects
    setTimeout(() => {
      console.log('🔒 Redirecting to auth after delay');
    }, 100);
    
    return <Navigate to="/auth" state={{ from: location }} replace />;
  }

  if (allowedRoles && !allowedRoles.includes(userProfile.role)) {
    console.log('🔒 ProtectedRoute: Role mismatch, redirecting to appropriate dashboard');
    // Redirect to appropriate dashboard based on role
    const redirectPath = userProfile.role === 'admin' ? '/admin' 
                        : userProfile.role === 'teacher' ? '/teacher'
                        : '/student';
    return <Navigate to={redirectPath} replace />;
  }

  console.log('🔒 ProtectedRoute: Access granted');
  return <>{children}</>;
}