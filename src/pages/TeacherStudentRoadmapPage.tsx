import React, { useState, useEffect } from 'react';
import { useNavigate, useParams } from 'react-router-dom';
import { supabase } from '@/integrations/supabase/client';
import { Button } from '@/components/ui/button';
import { ArrowLeft, Loader2, Lock } from 'lucide-react';

type MilestoneKey =
  | 'beginning_9th' | 'midterm_9th' | 'end_9th' | 'beginning_10th'
  | 'midterm_10th' | 'post_exam_10th' | 'before_results_10th' | 'final_decision';

interface MilestoneConfig {
  key: MilestoneKey;
  labelEn: string;
  labelKn: string;
  labelTa: string;
  labelHi: string;
  editable: boolean;
}

const MILESTONES: MilestoneConfig[] = [
  { key: 'beginning_9th', labelEn: 'Beginning of 9th Standard', labelKn: '9ನೇ ತರಗತಿಯ ಆರಂಭ', labelTa: '9ஆம் வகுப்பின் ஆரம்பம்', labelHi: '9वीं कक्षा की शुरुआत', editable: true },
  { key: 'midterm_9th', labelEn: 'Midterm of 9th Standard', labelKn: '9ನೇ ತರಗತಿಯ ಮಧ್ಯಾವಧಿ', labelTa: '9ஆம் வகுப்பின் இடைப்பருவம்', labelHi: '9वीं कक्षा का मध्यावधि', editable: true },
  { key: 'end_9th', labelEn: 'End of 9th Standard', labelKn: '9ನೇ ತರಗತಿಯ ಅಂತ್ಯ', labelTa: '9ஆம் வகுப்பின் முடிவு', labelHi: '9वीं कक्षा का अंत', editable: true },
  { key: 'beginning_10th', labelEn: 'Beginning of 10th Standard', labelKn: '10ನೇ ತರಗತಿಯ ಆರಂಭ', labelTa: '10ஆம் வகுப்பின் ஆரம்பம்', labelHi: '10वीं कक्षा की शुरुआत', editable: false },
  { key: 'midterm_10th', labelEn: 'Mid-term of 10th Standard', labelKn: '10ನೇ ತರಗತಿಯ ಮಧ್ಯಾವಧಿ', labelTa: '10ஆம் வகுப்பின் இடைப்பருவம்', labelHi: '10वीं कक्षा का मध्यावधि', editable: false },
  { key: 'post_exam_10th', labelEn: 'Post exams of 10th Standard', labelKn: '10ನೇ ತರಗತಿ ಪರೀಕ್ಷೆಗಳ ನಂತರ', labelTa: '10ஆம் வகுப்பு தேர்வுக்குப் பிறகு', labelHi: '10वीं कक्षा की परीक्षा के बाद', editable: false },
  { key: 'before_results_10th', labelEn: 'Before results of 10th Standard', labelKn: '10ನೇ ತರಗತಿ ಫಲಿತಾಂಶಗಳ ಮೊದಲು', labelTa: '10ஆம் வகுப்பு தேர்வு முடிவுகளுக்கு முன்', labelHi: '10वीं कक्षा के परिणाम से पहले', editable: false },
  { key: 'final_decision', labelEn: 'Finally decided Career choices', labelKn: 'ಅಂತಿಮವಾಗಿ ನಿರ್ಧರಿಸಿದ ವೃತ್ತಿ ಆಯ್ಕೆಗಳು', labelTa: 'இறுதியாக முடிவு செய்த தொழில் தேர்வுகள்', labelHi: 'अंतिम रूप से तय किए गए करियर विकल्प', editable: false },
];

const COLUMN_LABELS: Record<string, { milestone: string; planA: string; planB: string; planC: string }> = {
  en: { milestone: 'Milestone', planA: 'Plan A', planB: 'Plan B', planC: 'Plan C' },
  kn: { milestone: 'ಮೈಲಿಗಲ್ಲು', planA: 'ಯೋಜನೆ A', planB: 'ಯೋಜನೆ B', planC: 'ಯೋಜನೆ C' },
  ta: { milestone: 'நிலை', planA: 'திட்டம் A', planB: 'திட்டம் B', planC: 'திட்டம் C' },
  hi: { milestone: 'पड़ाव', planA: 'योजना A', planB: 'योजना B', planC: 'योजना C' },
};

type RoadmapRow = { plan_a: string; plan_b: string; plan_c: string };

export default function TeacherStudentRoadmapPage() {
  const navigate = useNavigate();
  const { studentId } = useParams<{ studentId: string }>();
  const [rows, setRows] = useState<Record<MilestoneKey, RoadmapRow>>(() => {
    const init: Record<string, RoadmapRow> = {};
    for (const m of MILESTONES) init[m.key] = { plan_a: '', plan_b: '', plan_c: '' };
    return init as Record<MilestoneKey, RoadmapRow>;
  });
  const [loading, setLoading] = useState(true);
  const [studentName, setStudentName] = useState('');
  const [studentLang, setStudentLang] = useState<string>('en');

  useEffect(() => {
    if (!studentId) return;
    (async () => {
      setLoading(true);
      // Fetch student name
      const { data: student } = await supabase
        .from('students').select('user_id, users:user_id(full_name, preferred_language)')
        .eq('id', studentId).maybeSingle();
      setStudentName((student as any)?.users?.full_name || 'Student');
      setStudentLang((student as any)?.users?.preferred_language || 'en');

      // Fetch roadmap — career_roadmap.student_id references users.id, not students.id
      const userId = (student as any)?.user_id;
      if (!userId) { setLoading(false); return; }
      const { data } = await supabase
        .from('career_roadmap')
        .select('milestone, plan_a, plan_b, plan_c')
        .eq('student_id', userId);
      if (data) {
        setRows(prev => {
          const next = { ...prev };
          for (const row of data) {
            const key = row.milestone as MilestoneKey;
            if (next[key]) next[key] = { plan_a: row.plan_a || '', plan_b: row.plan_b || '', plan_c: row.plan_c || '' };
          }
          return next;
        });
      }
      setLoading(false);
    })();
  }, [studentId]);

  const getMilestoneLabel = (m: MilestoneConfig) => {
    if (studentLang === 'kn') return m.labelKn;
    if (studentLang === 'ta') return m.labelTa;
    if (studentLang === 'hi') return m.labelHi;
    return m.labelEn;
  };

  const cols = COLUMN_LABELS[studentLang] || COLUMN_LABELS['en'];

  if (loading) {
    return (
      <div className="min-h-screen flex items-center justify-center bg-gray-50">
        <Loader2 className="h-8 w-8 animate-spin text-indigo-600" />
      </div>
    );
  }

  return (
    <div className="min-h-screen bg-gray-50">
      <div className="bg-gradient-to-r from-indigo-600 via-indigo-700 to-purple-700 text-white">
        <div className="container mx-auto px-4 py-10">
          <div className="flex items-center gap-3">
            <Button variant="ghost" size="icon" className="text-white/80 hover:text-white hover:bg-white/10" onClick={() => navigate(-1)}>
              <ArrowLeft className="h-5 w-5" />
            </Button>
            <div>
              <h1 className="text-xl md:text-2xl font-bold">Career Roadmap</h1>
              <p className="text-white/70 text-sm">{studentName}</p>
            </div>
          </div>
        </div>
      </div>
      <div className="container mx-auto px-4 py-6">
        <div className="overflow-x-auto rounded-xl shadow-sm bg-white border border-gray-200">
          <table className="w-full text-sm">
            <thead>
              <tr className="bg-gray-800 text-white">
                <th className="text-left px-6 py-4 font-semibold rounded-tl-xl w-48">{cols.milestone}</th>
                <th className="text-left px-6 py-4 font-semibold">{cols.planA}</th>
                <th className="text-left px-6 py-4 font-semibold">{cols.planB}</th>
                <th className="text-left px-6 py-4 font-semibold rounded-tr-xl">{cols.planC}</th>
              </tr>
            </thead>
            <tbody className="divide-y divide-gray-100">
              {MILESTONES.map(m => {
                const row = rows[m.key];
                return (
                  <tr key={m.key} className={m.editable ? 'border-l-4 border-l-blue-400' : 'border-l-4 border-l-gray-200 bg-gray-50'}>
                    <td className="px-6 py-4 bg-gray-50 font-medium text-gray-800 align-top w-48">
                      <div className="flex items-center gap-2">
                        {!m.editable && <Lock className="h-3.5 w-3.5 text-gray-400 shrink-0" />}
                        <span className={!m.editable ? 'text-gray-500' : ''}>{getMilestoneLabel(m)}</span>
                      </div>
                    </td>
                    {(['plan_a', 'plan_b', 'plan_c'] as const).map(field => (
                      <td key={field} className="px-4 py-3 align-top">
                        <div className="p-2 text-sm text-gray-700 min-h-[40px]">
                          {row[field] || <span className="text-gray-400 italic">—</span>}
                        </div>
                      </td>
                    ))}
                  </tr>
                );
              })}
            </tbody>
          </table>
        </div>
      </div>
    </div>
  );
}
