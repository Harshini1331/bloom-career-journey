import React, { useState } from 'react';
import { Dialog, DialogContent, DialogDescription, DialogHeader, DialogTitle } from '@/components/ui/dialog';
import { Button } from '@/components/ui/button';
import { Input } from '@/components/ui/input';
import { Textarea } from '@/components/ui/textarea';
import { Label } from '@/components/ui/label';
import { supabase } from '@/integrations/supabase/client';
import { useAuth } from '@/hooks/useAuth';

type ContactIlpDialogProps = {
  open: boolean;
  onOpenChange: (open: boolean) => void;
};

export default function ContactIlpDialog({ open, onOpenChange }: ContactIlpDialogProps) {
  const { userProfile } = useAuth();
  const [subject, setSubject] = useState('');
  const [message, setMessage] = useState('');
  const [submitting, setSubmitting] = useState(false);
  const [notice, setNotice] = useState<string | null>(null);

  const canSubmit = subject.trim().length > 0 && message.trim().length > 0 && !submitting;

  const handleSubmit = async () => {
    if (!canSubmit) return;
    setSubmitting(true);
    setNotice(null);
    try {
      const payload = {
        teacher_user_id: userProfile?.id || null,
        subject,
        message,
        status: 'open' as const,
      };
      const { error } = await supabase.from('ilp_queries').insert(payload as any);
      if (error) throw error;
      setNotice('Your query has been submitted. The ILP team will respond.');
      setSubject('');
      setMessage('');
    } catch (err) {
      setNotice('Failed to submit. Please try again later.');
    } finally {
      setSubmitting(false);
    }
  };

  return (
    <Dialog open={open} onOpenChange={onOpenChange}>
      <DialogContent className="max-w-lg">
        <DialogHeader>
          <DialogTitle>Contact ILP</DialogTitle>
          <DialogDescription>Submit a question to the ILP Career Counselling team.</DialogDescription>
        </DialogHeader>
        <div className="space-y-3">
          <div>
            <Label>Subject</Label>
            <Input value={subject} onChange={(e)=> setSubject(e.target.value)} placeholder="Short summary" />
          </div>
          <div>
            <Label>Message</Label>
            <Textarea value={message} onChange={(e)=> setMessage(e.target.value)} placeholder="Describe your question or issue" rows={5} />
          </div>
          {notice && <div className="text-sm text-gray-600">{notice}</div>}
          <div className="flex justify-end gap-2">
            <Button variant="outline" onClick={()=> onOpenChange(false)} disabled={submitting}>Close</Button>
            <Button className="bg-green-600 hover:bg-green-700" onClick={handleSubmit} disabled={!canSubmit}>{submitting ? 'Submitting…' : 'Submit'}</Button>
          </div>
        </div>
      </DialogContent>
    </Dialog>
  );
}


