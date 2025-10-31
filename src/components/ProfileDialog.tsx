import React, { useEffect, useMemo, useState } from 'react';
import { Dialog, DialogContent, DialogDescription, DialogHeader, DialogTitle } from '@/components/ui/dialog';
import { Button } from '@/components/ui/button';
import { Input } from '@/components/ui/input';
import { Label } from '@/components/ui/label';
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from '@/components/ui/select';
import { supabase } from '@/integrations/supabase/client';
import { useAuth } from '@/hooks/useAuth';
import { useToast } from '@/hooks/use-toast';
import { useLang } from '@/hooks/useLang';
import { KannadaKeyboard } from '@/components/ui/KannadaKeyboard';

type Props = {
  open: boolean;
  onOpenChange: (v: boolean) => void;
};

export default function ProfileDialog({ open, onOpenChange }: Props) {
  const { userProfile, refreshUserProfile } = useAuth();
  const { toast } = useToast();
  const { t, lang } = useLang();
  const isTeacher = userProfile?.role === 'teacher';

  const [fullName, setFullName] = useState('');
  const [gender, setGender] = useState<'male' | 'female' | ''>('');
  const [goal, setGoal] = useState('');
  const [school, setSchool] = useState('');
  const [avatarFile, setAvatarFile] = useState<File | null>(null);
  const [password, setPassword] = useState('');
  const [saving, setSaving] = useState(false);
  const [meta, setMeta] = useState<{ email?: string | null; mobile?: string | null; state?: string; className?: string; teacherName?: string }>();

  useEffect(() => {
    if (!userProfile?.id) return;
    console.log('🔄 ProfileDialog: Loading user profile data:', userProfile);
    setFullName(userProfile.full_name || '');
    setGender((userProfile as any).gender || '');
    setGoal((userProfile as any).career_goals || '');
    setSchool((userProfile as any).school || '');
    // Load state label and contact
    (async () => {
      try {
        const studentRes = await supabase
          .from('students')
          .select('class_id, classes(name, states(state_name)), teachers:teacher_id(users:user_id(full_name))')
          .eq('user_id', userProfile.id)
          .maybeSingle();
        const teacherRes = await supabase
          .from('teachers')
          .select('state_id, class_id, states(state_name), classes(name)')
          .eq('user_id', userProfile.id)
          .maybeSingle();
        const userStateRes = await supabase
          .from('users')
          .select('state_id, states(state_name)')
          .eq('id', userProfile.id)
          .maybeSingle();
        setMeta({
          email: (userProfile as any).email || null,
          mobile: (userProfile as any).mobile || null,
          state:
            studentRes.data?.classes?.states?.state_name ||
            teacherRes.data?.states?.state_name ||
            (userStateRes.data as any)?.states?.state_name ||
            '',
          className: studentRes.data?.classes?.name || teacherRes.data?.classes?.name || '',
          teacherName: (studentRes.data as any)?.teachers?.users?.full_name || '',
        });
      } catch (e) {
        // swallow optional meta fetch errors
      }
    })();
  }, [userProfile?.id, userProfile?.full_name, userProfile?.gender, userProfile?.school, userProfile?.career_goals, userProfile?.profile_picture_url]);

  const contactLabel = useMemo(() => meta?.email || meta?.mobile || '', [meta]);

  // Refresh profile data when dialog opens
  useEffect(() => {
    if (open && userProfile?.id) {
      console.log('🔄 ProfileDialog opened - refreshing profile data');
      refreshUserProfile();
    }
  }, [open, userProfile?.id]);

  const saveProfile = async () => {
    if (!userProfile?.id) return;
    setSaving(true);
    try {
      // avatar upload
      let avatarUrl = (userProfile as any).profile_picture_url || null;
      if (avatarFile) {
        try {
          const path = `${userProfile.id}/${Date.now()}_${avatarFile.name}`;
          const { error: upErr } = await supabase.storage.from('avatars').upload(path, avatarFile, { upsert: true });
          if (upErr) {
            console.error('Avatar upload error:', upErr);
            if (upErr.message?.includes('Bucket not found')) {
              throw new Error('Storage bucket not configured. Please contact support to set up file storage.');
            }
            throw upErr;
          }
          const { data } = supabase.storage.from('avatars').getPublicUrl(path);
          avatarUrl = data.publicUrl;
        } catch (uploadError) {
          console.error('Avatar upload failed:', uploadError);
          throw new Error(`Failed to upload profile picture: ${uploadError instanceof Error ? uploadError.message : 'Unknown error'}`);
        }
      }
      // update users row
      const updateData = { 
        full_name: fullName, 
        gender: gender || null,
        school: school || null,
        profile_picture_url: avatarUrl,
        career_goals: isTeacher ? (userProfile as any).career_goals || null : goal || null
      };
      
      console.log('🔄 Updating user profile with data:', updateData);
      
      const { data: updateResult, error } = await supabase
        .from('users')
        .update(updateData)
        .eq('id', userProfile.id)
        .select();
        
      if (error) {
        console.error('❌ Database update error:', error);
        throw error;
      }
      
      console.log('✅ Database update successful:', updateResult);
      // password change
      if (password) {
        if (!isTeacher) {
          // Custom-auth students: update student_auth_credentials
          console.log('Updating student password for user:', userProfile.id);
          
          const { error: credErr } = await supabase
            .from('student_auth_credentials')
            .update({
              password_hash: password,
              is_active: true
            })
            .eq('user_id', userProfile.id);
          
          if (credErr) {
            console.error('Password update error:', credErr);
            throw new Error(`Failed to update password: ${credErr.message}`);
          }
          
          console.log('Student password updated successfully');
          toast({
            title: lang === 'kn' ? "ಪಾಸ್ವರ್ಡ್ ನವೀಕರಿಸಲಾಗಿದೆ! 🔐" : "Password Updated! 🔐",
            description: lang === 'kn' ? "ನಿಮ್ಮ ಪಾಸ್ವರ್ಡ್ ಯಶಸ್ವಿಯಾಗಿ ಬದಲಾಯಿಸಲಾಗಿದೆ. ಈಗ ನೀವು ನಿಮ್ಮ ಹೊಸ ಪಾಸ್ವರ್ಡ್‌ನೊಂದಿಗೆ ಲಾಗಿನ್ ಮಾಡಬಹುದು." : "Your password has been changed successfully. You can now login with your new password.",
          });
        } else {
          // Supabase-auth users (teachers/admins)
          const { error: pwErr } = await supabase.auth.updateUser({ password });
          if (pwErr) {
            console.error('Password update error:', pwErr);
            throw new Error(`Failed to update password: ${pwErr.message}`);
          }
          toast({
            title: lang === 'kn' ? "ಪಾಸ್ವರ್ಡ್ ನವೀಕರಿಸಲಾಗಿದೆ! 🔐" : "Password Updated! 🔐",
            description: lang === 'kn' ? "ನಿಮ್ಮ ಪಾಸ್ವರ್ಡ್ ಯಶಸ್ವಿಯಾಗಿ ಬದಲಾಯಿಸಲಾಗಿದೆ." : "Your password has been changed successfully.",
          });
        }
      }
      
      // Show success message
      toast({
        title: lang === 'kn' ? "ಪ್ರೊಫೈಲ್ ನವೀಕರಿಸಲಾಗಿದೆ! ✨" : "Profile Updated! ✨",
        description: lang === 'kn' ? "ನಿಮ್ಮ ಪ್ರೊಫೈಲ್ ಯಶಸ್ವಿಯಾಗಿ ನವೀಕರಿಸಲಾಗಿದೆ." : "Your profile has been updated successfully.",
      });
      
      // Small delay to ensure database update is complete
      await new Promise(resolve => setTimeout(resolve, 1000));
      
      // Refresh user profile to show updated picture
      console.log('🔄 Refreshing user profile after update...');
      await refreshUserProfile();
      
      // Force re-render of profile dialog with fresh data
      console.log('🔄 Profile dialog will re-render with fresh data');
      
      onOpenChange(false);
    } catch (err: any) {
      console.error('Profile save error:', err);
      toast({
        title: lang === 'kn' ? "ನವೀಕರಣ ವಿಫಲವಾಗಿದೆ" : "Update Failed",
        description: err.message || (lang === 'kn' ? "ಪ್ರೊಫೈಲ್ ಅನ್ನು ನವೀಕರಿಸಲು ವಿಫಲವಾಗಿದೆ. ದಯವಿಟ್ಟು ಮತ್ತೆ ಪ್ರಯತ್ನಿಸಿ." : "Failed to update profile. Please try again."),
        variant: "destructive",
      });
    } finally {
      setSaving(false);
    }
  };

  return (
    <Dialog open={open} onOpenChange={onOpenChange}>
      <DialogContent className="max-w-xl" lang={lang} dir="auto">
        <DialogHeader>
          <DialogTitle>{lang === 'kn' ? 'ನನ್ನ ಪ್ರೊಫೈಲ್' : 'My Profile'}</DialogTitle>
          <DialogDescription>{lang === 'kn' ? 'ನಿಮ್ಮ ಪ್ರೊಫೈಲ್ ಮಾಹಿತಿಯನ್ನು ನವೀಕರಿಸಿ' : 'Update your profile information'}</DialogDescription>
        </DialogHeader>
        <div className="space-y-4">
          <div>
            <Label>{lang === 'kn' ? 'ಪೂರ್ಣ ಹೆಸರು' : 'Full Name'}</Label>
            <Input 
              lang={lang}
              value={fullName} 
              onChange={(e)=> setFullName(e.target.value)} 
            />
          </div>
          <div>
            <Label>{lang === 'kn' ? 'ಫೋನ್ / ಇಮೇಲ್' : 'Phone / Email'}</Label>
            <Input value={contactLabel} disabled />
          </div>
          <div>
            <Label>{lang === 'kn' ? 'ಲಿಂಗ' : 'Gender'}</Label>
            <Select value={gender} onValueChange={(v: any)=> setGender(v)}>
              <SelectTrigger><SelectValue placeholder={lang === 'kn' ? 'ಲಿಂಗವನ್ನು ಆಯ್ಕೆಮಾಡಿ' : 'Select gender'} /></SelectTrigger>
              <SelectContent>
                <SelectItem value="male">{lang === 'kn' ? 'ಪುರುಷ' : 'Male'}</SelectItem>
                <SelectItem value="female">{lang === 'kn' ? 'ಸ್ತ್ರೀ' : 'Female'}</SelectItem>
              </SelectContent>
            </Select>
          </div>
          {/* State and School - Side by side */}
          <div className="grid grid-cols-1 md:grid-cols-2 gap-3">
            <div>
              <Label>{lang === 'kn' ? 'ರಾಜ್ಯ' : 'State'}</Label>
              <Input value={meta?.state || ''} disabled />
            </div>
            <div>
              <Label>{lang === 'kn' ? 'ಶಾಲೆ' : 'School'}</Label>
              <Input 
                lang={lang}
                value={school} 
                onChange={(e) => setSchool(e.target.value)} 
                placeholder={lang === 'kn' ? 'ನಿಮ್ಮ ಶಾಲೆಯ ಹೆಸರನ್ನು ನಮೂದಿಸಿ' : 'Enter your school name'}
              />
            </div>
          </div>
          {!isTeacher && (
            <div className="grid grid-cols-1 md:grid-cols-2 gap-3">
              <div>
                <Label>{lang === 'kn' ? 'ಶಿಕ್ಷಕ' : 'Teacher'}</Label>
                <Input value={meta?.teacherName || ''} disabled />
              </div>
              <div>
                <Label>{lang === 'kn' ? 'ತರಗತಿ' : 'Class'}</Label>
                <Input value={meta?.className || ''} disabled />
              </div>
            </div>
          )}
          {!isTeacher && (
            <div>
              <Label>{lang === 'kn' ? 'ಆಸೆ / ವೃತ್ತಿ ಗುರಿ' : 'Aspiration / Career Goal'}</Label>
              <Input 
                lang={lang}
                value={goal} 
                onChange={(e)=> setGoal(e.target.value)} 
                placeholder={lang === 'kn' ? 'ನಿಮ್ಮ ವೃತ್ತಿ ಗುರಿ' : 'Your career goal'} 
              />
            </div>
          )}
          <div>
            <Label>{lang === 'kn' ? 'ಪ್ರೊಫೈಲ್ ಚಿತ್ರ' : 'Profile Picture'}</Label>
            <Input type="file" accept="image/*" onChange={(e)=> setAvatarFile(e.target.files?.[0] || null)} />
          </div>
          <div>
            <Label>{lang === 'kn' ? 'ಪಾಸ್ವರ್ಡ್ ಬದಲಾಯಿಸಿ' : 'Change Password'}</Label>
            <Input 
              type="password" 
              value={password} 
              onChange={(e)=> setPassword(e.target.value)} 
              placeholder={lang === 'kn' ? 'ಹೊಸ ಪಾಸ್ವರ್ಡ್' : 'New password'} 
            />
          </div>
          
          <div className="flex justify-end gap-2 pt-2">
            <Button variant="outline" onClick={()=> onOpenChange(false)}>
              {lang === 'kn' ? 'ಮುಚ್ಚಿ' : 'Close'}
            </Button>
            <Button className="bg-green-600 hover:bg-green-700" onClick={saveProfile} disabled={saving}>
              {saving ? (lang === 'kn' ? 'ಉಳಿಸಲಾಗುತ್ತಿದೆ…' : 'Saving…') : (lang === 'kn' ? 'ಉಳಿಸಿ' : 'Save')}
            </Button>
          </div>
        </div>
        {lang === 'kn' && <KannadaKeyboard lang={lang} />}
      </DialogContent>
    </Dialog>
  );
}


