// SummaryViewDialog - Student view and edit component for approved summaries

import { useState, useEffect } from 'react';
import { Dialog, DialogContent, DialogDescription, DialogHeader, DialogTitle } from '@/components/ui/dialog';
import { Button } from '@/components/ui/button';
import { Textarea } from '@/components/ui/textarea';
import { Badge } from '@/components/ui/badge';
import { Card, CardContent, CardHeader, CardTitle } from '@/components/ui/card';
import { Label } from '@/components/ui/label';
import { 
  Lightbulb, 
  AlertCircle, 
  Users, 
  Edit3, 
  Save, 
  X, 
  CheckCircle,
  Sparkles
} from 'lucide-react';
import { useToast } from '@/hooks/use-toast';
import { useLang } from '@/hooks/useLang';
import { KannadaKeyboard } from '@/components/ui/KannadaKeyboard';
import { 
  AssessmentSummary, 
  SummaryQuestions, 
  getDisplaySummary,
  canStudentEdit,
  getSummaryStatusColor,
  getSummaryStatusLabel
} from '@/types/assessmentSummary';
import { summaryDatabaseService } from '@/services/summaryDatabaseService';

interface SummaryViewDialogProps {
  open: boolean;
  onOpenChange: (open: boolean) => void;
  summary: AssessmentSummary | null;
  studentUserId: string;
  onSummaryUpdated?: () => void;
}

export default function SummaryViewDialog({
  open,
  onOpenChange,
  summary,
  studentUserId,
  onSummaryUpdated
}: SummaryViewDialogProps) {
  const { toast } = useToast();
  const { t, lang } = useLang();
  const [isEditing, setIsEditing] = useState(false);
  const [saving, setSaving] = useState(false);
  const [editedSummary, setEditedSummary] = useState<SummaryQuestions>({
    question1: '',
    question2: '',
    question3: ''
  });

  // Load current summary content when dialog opens or summary changes
  useEffect(() => {
    if (summary && open) {
      const displaySummary = getDisplaySummary(summary);
      setEditedSummary({
        question1: displaySummary.question1,
        question2: displaySummary.question2,
        question3: displaySummary.question3
      });
      setIsEditing(false);
    }
  }, [summary, open]);

  const handleEdit = () => {
    setIsEditing(true);
  };

  const handleCancel = () => {
    if (summary) {
      const displaySummary = getDisplaySummary(summary);
      setEditedSummary({
        question1: displaySummary.question1,
        question2: displaySummary.question2,
        question3: displaySummary.question3
      });
    }
    setIsEditing(false);
  };

  const handleSave = async () => {
    if (!summary) return;

    // Validate that all fields have content
    if (!editedSummary.question1.trim() || !editedSummary.question2.trim() || !editedSummary.question3.trim()) {
      toast({
        title: lang === 'kn' ? "ಅಪೂರ್ಣ ಸಾರಾಂಶ" : "Incomplete Summary",
        description: lang === 'kn' ? "ಉಳಿಸುವ ಮೊದಲು ಎಲ್ಲಾ ಮೂರು ಪ್ರಶ್ನೆಗಳನ್ನು ಭರ್ತಿ ಮಾಡಿ." : "Please fill in all three questions before saving.",
        variant: "destructive"
      });
      return;
    }

    setSaving(true);
    try {
      const result = await summaryDatabaseService.updateStudentSummary(
        summary.id,
        studentUserId,
        editedSummary
      );

      if (result.success) {
        toast({
          title: lang === 'kn' ? "ಸಾರಾಂಶ ನವೀಕರಿಸಲಾಗಿದೆ! ✨" : "Summary Updated! ✨",
          description: lang === 'kn' ? "ನಿಮ್ಮ ಪ್ರತಿಬಿಂಬ ಸಾರಾಂಶ ಯಶಸ್ವಿಯಾಗಿ ಉಳಿಸಲಾಗಿದೆ." : "Your reflection summary has been saved successfully."
        });
        setIsEditing(false);
        onSummaryUpdated?.();
      } else {
        throw new Error(result.error || 'Failed to update summary');
      }
    } catch (error) {
      console.error('Error saving summary:', error);
      toast({
        title: lang === 'kn' ? "ದೋಷ" : "Error",
        description: lang === 'kn' ? "ನಿಮ್ಮ ಬದಲಾವಣೆಗಳನ್ನು ಉಳಿಸಲು ವಿಫಲವಾಗಿದೆ. ದಯವಿಟ್ಟು ಮತ್ತೆ ಪ್ರಯತ್ನಿಸಿ." : "Failed to save your changes. Please try again.",
        variant: "destructive"
      });
    } finally {
      setSaving(false);
    }
  };

  if (!summary) {
    return (
      <Dialog open={open} onOpenChange={onOpenChange}>
      <DialogContent className="max-w-4xl max-h-[90vh] overflow-y-auto" lang={lang} dir="auto">
        <DialogHeader>
          <DialogTitle>{lang === 'kn' ? 'ಪ್ರತಿಬಿಂಬ ಸಾರಾಂಶ' : 'Reflection Summary'}</DialogTitle>
          <DialogDescription>
            {lang === 'kn' ? 'ನಿಮ್ಮ ಪ್ರತಿಬಿಂಬ ಸಾರಾಂಶ ಇನ್ನೂ ಲಭ್ಯವಿಲ್ಲ.' : 'Your reflection summary is not yet available.'}
          </DialogDescription>
        </DialogHeader>
          <div className="p-8 text-center">
            <AlertCircle className="h-16 w-16 text-yellow-500 mx-auto mb-4" />
            <p className="text-gray-600">
              {lang === 'kn' ? 'ನಿಮ್ಮ ಸಾರಾಂಶವನ್ನು ನಿಮ್ಮ ಶಿಕ್ಷಕರು ವಿಮರ್ಶೆ ಮಾಡುತ್ತಿದ್ದಾರೆ ಮತ್ತು ಶೀಘ್ರದಲ್ಲೇ ಲಭ್ಯವಾಗುತ್ತದೆ.' : 'Your summary is being reviewed by your teacher and will be available soon.'}
            </p>
          </div>
        </DialogContent>
      </Dialog>
    );
  }

  const displaySummary = getDisplaySummary(summary);
  const canEdit = canStudentEdit(summary);
  const isStudentEdited = summary.summary_type === 'student_edited';

  return (
    <Dialog open={open} onOpenChange={onOpenChange}>
      <DialogContent className="max-w-4xl max-h-[90vh] overflow-y-auto" lang={lang} dir="auto">
        <DialogHeader>
          <div className="flex items-center justify-between">
            <div>
              <DialogTitle className="flex items-center gap-2">
                <Sparkles className="h-5 w-5 text-purple-600" />
                {lang === 'kn' ? 'ನನ್ನನ್ನು ಪ್ರೇರೇಪಿಸಿದ ವಿಷಯಗಳು' : 'Things I Was Inspired By'}
              </DialogTitle>
              <DialogDescription>
                {lang === 'kn' ? 'ಪ್ರೇರಣಾದಾಯಕ ವೀಡಿಯೊಗಳು ಮತ್ತು ಅನುಭವಗಳ ಬಗ್ಗೆ ನಿಮ್ಮ ಪ್ರತಿಬಿಂಬ' : 'Your reflection on inspirational videos and experiences'}
              </DialogDescription>
            </div>
            <div className="flex items-center gap-2">
              <Badge className={getSummaryStatusColor(summary.approval_status)}>
                {getSummaryStatusLabel(summary.approval_status)}
              </Badge>
              {isStudentEdited && (
                <Badge variant="outline" className="bg-blue-50">
                  <Edit3 className="h-3 w-3 mr-1" />
                  {lang === 'kn' ? 'ನೀವು ಸಂಪಾದಿಸಿದ್ದೀರಿ' : 'Edited by You'}
                </Badge>
              )}
              {summary.summary_type === 'teacher_edited' && (
                <Badge variant="outline" className="bg-purple-50">
                  <CheckCircle className="h-3 w-3 mr-1" />
                  {lang === 'kn' ? 'ಶಿಕ್ಷಕರು ವಿಮರ್ಶಿಸಿದ್ದಾರೆ' : 'Reviewed by Teacher'}
                </Badge>
              )}
            </div>
          </div>
        </DialogHeader>

        <div className="space-y-6 mt-4">
          {/* Question 1 */}
          <Card>
            <CardHeader>
              <CardTitle className="flex items-center gap-2 text-lg">
                <Lightbulb className="h-5 w-5 text-yellow-600" />
                {lang === 'kn' ? '1. ನಿಮ್ಮನ್ನು ಏನು ಪ್ರೇರೇಪಿಸಿತು?' : '1. What Inspired You?'}
              </CardTitle>
            </CardHeader>
            <CardContent>
              <Label className="text-sm text-gray-600 mb-2 block">
                {lang === 'kn' ? 'ಈ ವೀಡಿಯೊಗಳಿಂದ ಮತ್ತು ನಿಮ್ಮ ಸ್ವಂತ ಅನುಭವಗಳಿಂದ ನಿಮ್ಮನ್ನು ಪ್ರೇರೇಪಿಸಿದ ವಿಷಯಗಳನ್ನು ಪಟ್ಟಿ ಮಾಡಿ.' : 'List the things that inspired you from these videos and from your own experiences.'}
              </Label>
              {isEditing ? (
                <Textarea
                  lang={lang}
                  value={editedSummary.question1}
                  onChange={(e) => setEditedSummary({ ...editedSummary, question1: e.target.value })}
                  placeholder={lang === 'kn' ? 'ನಿಮ್ಮನ್ನು ಏನು ಪ್ರೇರೇಪಿಸಿತು ಎಂದು ಬರೆಯಿರಿ...' : 'Write about what inspired you...'}
                  className="min-h-[150px] text-base"
                />
              ) : (
                <div className="prose prose-sm max-w-none">
                  <p className="text-gray-700 whitespace-pre-wrap">{displaySummary.question1}</p>
                </div>
              )}
            </CardContent>
          </Card>

          {/* Question 2 */}
          <Card>
            <CardHeader>
              <CardTitle className="flex items-center gap-2 text-lg">
                <AlertCircle className="h-5 w-5 text-red-600" />
                {lang === 'kn' ? '2. ತಪ್ಪಿಸಬೇಕಾದ ನಡವಳಿಕೆಗಳು' : '2. Behaviors to Avoid'}
              </CardTitle>
            </CardHeader>
            <CardContent>
              <Label className="text-sm text-gray-600 mb-2 block">
                {lang === 'kn' ? 'ಈ ಎಲ್ಲಾ ವೀಡಿಯೊಗಳನ್ನು ನೋಡಿದ ನಂತರ, ನೀವು ತಪ್ಪಿಸಬೇಕಾದ ನಡವಳಿಕೆಗಳು ಯಾವುವು?' : 'After watching all these videos, which behaviors do you feel you should avoid?'}
              </Label>
              {isEditing ? (
                <Textarea
                  lang={lang}
                  value={editedSummary.question2}
                  onChange={(e) => setEditedSummary({ ...editedSummary, question2: e.target.value })}
                  placeholder={lang === 'kn' ? 'ತಪ್ಪಿಸಬೇಕಾದ ನಡವಳಿಕೆಗಳ ಬಗ್ಗೆ ಬರೆಯಿರಿ...' : 'Write about behaviors to avoid...'}
                  className="min-h-[150px] text-base"
                />
              ) : (
                <div className="prose prose-sm max-w-none">
                  <p className="text-gray-700 whitespace-pre-wrap">{displaySummary.question2}</p>
                </div>
              )}
            </CardContent>
          </Card>

          {/* Question 3 */}
          <Card>
            <CardHeader>
              <CardTitle className="flex items-center gap-2 text-lg">
                <Users className="h-5 w-5 text-blue-600" />
                {lang === 'kn' ? '3. ಪ್ರೇರಣೆಗಳ ನಡುವಿನ ಹೋಲಿಕೆಗಳು' : '3. Similarities Between Inspirations'}
              </CardTitle>
            </CardHeader>
            <CardContent>
              <Label className="text-sm text-gray-600 mb-2 block">
                {lang === 'kn' ? 'ನಿಮ್ಮನ್ನು ಪ್ರೇರೇಪಿಸಿದ ಈ ವೀಡಿಯೊಗಳಲ್ಲಿನ ಪಾತ್ರಗಳು ಮತ್ತು ನಿಜ ಜೀವನದಲ್ಲಿ ನಿಮ್ಮನ್ನು ಪ್ರೇರೇಪಿಸಿದ ಜನರ ನಡುವಿನ ಹೋಲಿಕೆಗಳನ್ನು ಚರ್ಚಿಸಿ.' : 'Discuss the similarities between the characters in these videos who inspired you, and the people who have inspired you in real life.'}
              </Label>
              {isEditing ? (
                <Textarea
                  lang={lang}
                  value={editedSummary.question3}
                  onChange={(e) => setEditedSummary({ ...editedSummary, question3: e.target.value })}
                  placeholder={lang === 'kn' ? 'ಹೋಲಿಕೆಗಳ ಬಗ್ಗೆ ಬರೆಯಿರಿ...' : 'Write about the similarities...'}
                  className="min-h-[150px] text-base"
                />
              ) : (
                <div className="prose prose-sm max-w-none">
                  <p className="text-gray-700 whitespace-pre-wrap">{displaySummary.question3}</p>
                </div>
              )}
            </CardContent>
          </Card>

          {/* Action Buttons */}
          <div className="flex items-center justify-between pt-4 border-t">
            <div className="text-sm text-gray-500">
              {summary.approved_at && (
                <span>{lang === 'kn' ? 'ಅನುಮೋದಿಸಲಾಗಿದೆ' : 'Approved'} {new Date(summary.approved_at).toLocaleDateString()}</span>
              )}
              {isStudentEdited && summary.updated_at && (
                <span className="ml-4">
                  {lang === 'kn' ? 'ಕೊನೆಯ ಬಾರಿ ಸಂಪಾದಿಸಲಾಗಿದೆ' : 'Last edited'}: {new Date(summary.updated_at).toLocaleDateString()}
                </span>
              )}
            </div>
            <div className="flex gap-2">
              {isEditing ? (
                <>
                  <Button
                    variant="outline"
                    onClick={handleCancel}
                    disabled={saving}
                  >
                    <X className="h-4 w-4 mr-2" />
                    {lang === 'kn' ? 'ರದ್ದುಮಾಡಿ' : 'Cancel'}
                  </Button>
                  <Button
                    onClick={handleSave}
                    disabled={saving}
                    className="bg-green-600 hover:bg-green-700"
                  >
                    {saving ? (
                      <>{lang === 'kn' ? 'ಉಳಿಸಲಾಗುತ್ತಿದೆ...' : 'Saving...'}</>
                    ) : (
                      <>
                        <Save className="h-4 w-4 mr-2" />
                        {lang === 'kn' ? 'ಬದಲಾವಣೆಗಳನ್ನು ಉಳಿಸಿ' : 'Save Changes'}
                      </>
                    )}
                  </Button>
                </>
              ) : (
                <>
                  <Button variant="outline" onClick={() => onOpenChange(false)}>
                    {lang === 'kn' ? 'ಮುಚ್ಚಿ' : 'Close'}
                  </Button>
                  {canEdit && (
                    <Button onClick={handleEdit} className="bg-blue-600 hover:bg-blue-700">
                      <Edit3 className="h-4 w-4 mr-2" />
                      {lang === 'kn' ? 'ನನ್ನ ಸಾರಾಂಶವನ್ನು ಸಂಪಾದಿಸಿ' : 'Edit My Summary'}
                    </Button>
                  )}
                </>
              )}
            </div>
          </div>
        </div>
        {lang === 'kn' && <KannadaKeyboard lang={lang} />}
      </DialogContent>
    </Dialog>
  );
}

