import { useState, useEffect } from 'react';
import { useAuth } from '@/hooks/useAuth';
import { supabase } from '@/integrations/supabase/client';
import { Button } from '@/components/ui/button';
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from '@/components/ui/card';
import { Textarea } from '@/components/ui/textarea';
import { Badge } from '@/components/ui/badge';
import { Progress } from '@/components/ui/progress';
import { Checkbox } from '@/components/ui/checkbox';
import { School, Save, CheckCircle, ArrowLeft } from 'lucide-react';
import { useToast } from '@/hooks/use-toast';
import { useNavigate, useSearchParams } from 'react-router-dom';
import { useLang } from '@/hooks/useLang';
import { fetchTranslations } from '@/services/translationService';
import { Tooltip, TooltipContent, TooltipProvider, TooltipTrigger } from '@/components/ui/tooltip';
import { KannadaKeyboard } from '@/components/ui/KannadaKeyboard';
import { checkAssessmentUnlock } from '@/utils/assessmentUnlock';

interface SchoolLearningAssessmentResponse {
  section1: {
    question1: string;
    question2: string;
    question3: string;
    question4: string;
  };
  section2: {
    question5: string;
    question6: string;
    question7: string;
    question8: string;
  };
  section3: {
    question9: string;
    question10: string;
    question11: {
      visual: boolean;
      reading: boolean;
      listening: boolean;
      experimenting: boolean;
      discuss: boolean;
      groupDiscussions: boolean;
      writing: boolean;
      readingByheart: boolean;
      teaching: boolean;
      other: string;
    };
    question12: string;
  };
  section4: {
    question13: string;
    question14: string;
    question15: string;
    question16: string;
  };
  section5: {
    question17: string;
    question18: string;
    question19: string;
    question20: string;
    question21: string;
  };
}

export default function MySchoolLearningAssessment() {
  const { userProfile } = useAuth();
  const { t, lang } = useLang();
  const { toast } = useToast();
  const [responses, setResponses] = useState<SchoolLearningAssessmentResponse>({
    section1: {
      question1: '',
      question2: '',
      question3: '',
      question4: ''
    },
    section2: {
      question5: '',
      question6: '',
      question7: '',
      question8: ''
    },
    section3: {
      question9: '',
      question10: '',
      question11: {
        visual: false,
        reading: false,
        listening: false,
        experimenting: false,
        discuss: false,
        groupDiscussions: false,
        writing: false,
        readingByheart: false,
        teaching: false,
        other: ''
      },
      question12: ''
    },
    section4: {
      question13: '',
      question14: '',
      question15: '',
      question16: ''
    },
    section5: {
      question17: '',
      question18: '',
      question19: '',
      question20: '',
      question21: ''
    }
  });
  const [loading, setLoading] = useState(true);
  const [submitting, setSubmitting] = useState(false);
  const [savingSection, setSavingSection] = useState<string | null>(null);
  const [isCompleted, setIsCompleted] = useState(false);
  const [currentSection, setCurrentSection] = useState<'section1' | 'section2' | 'section3' | 'section4' | 'section5'>('section1');
  const navigate = useNavigate();
  const [searchParams] = useSearchParams();
  const viewParam = (searchParams.get('readonly') || searchParams.get('view') || '').toLowerCase();
  const readOnlyView = viewParam === '1' || viewParam === 'true';
  const isReadOnly = isCompleted || readOnlyView;
  const [helpTranslations, setHelpTranslations] = useState<Record<string, string>>({});

  // Load localized help text from content_translations (school_help)
  useEffect(() => {
    const loadHelpTranslations = async () => {
      try {
        const keys = Array.from({ length: 21 }, (_, i) => `question${i + 1}`);
        const map = await fetchTranslations('school_help', keys, lang);
        setHelpTranslations(map);
      } catch (error) {
        console.warn('MySchoolLearningAssessment: failed to load help translations', error);
        setHelpTranslations({});
      }
    };

    loadHelpTranslations();
  }, [lang]);

  const getHelpText = (id: number, fallback: string) => {
    const key = `question${id}`;
    return helpTranslations[key] || fallback;
  };

  const getLearningMethodLabel = (key: string): string => {
    if (lang === 'kn') {
      switch (key) {
        case 'visual':
          return 'ವೀಡಿಯೋಗಳನ್ನು ನೋಡುವುದು ಅಥವಾ ಚಿತ್ರಗಳನ್ನು ನೋಡಿ ಕಲಿಯುವುದು (ದೃಶ್ಯ)';
        case 'reading':
          return 'ಓದುವುದು';
        case 'listening':
          return 'ಕೇಳುವುದು (ಆಡಿಯೋ)';
        case 'experimenting':
          return 'ಪ್ರಯೋಗ ಮಾಡುವುದು';
        case 'discuss':
          return 'ಚರ್ಚೆ / ಚಿಂತನೆ ಹಂಚಿಕೊಳ್ಳುವುದು';
        case 'groupDiscussions':
          return 'ಗುಂಪು ಚರ್ಚೆಗಳು';
        case 'writing':
          return 'ಬರೆಯುವುದು';
        case 'readingByheart':
          return 'ಓದಿ ಮನಪಾಠ ಮಾಡುವುದು';
        case 'teaching':
          return 'ಇತರರಿಗೆ ಕಲಿಸುವ ಮೂಲಕ ಅಥವಾ ಯಾರಾದರೂ ನನ್ನ ಮಾತು ಕೇಳುವುದರಿಂದ ನಾನು ಚೆನ್ನಾಗಿ ಕಲಿಯುತ್ತೇನೆ';
        default:
          return key;
      }
    }
    if (lang === 'ta') {
      switch (key) {
        case 'visual':
          return 'காணொளி/படங்களைப் பார்த்து கற்றல் (காண்பது மூலம் கற்றல்)';
        case 'reading':
          return 'வாசித்து கற்றல்';
        case 'listening':
          return 'கேட்டு கற்றல் (ஒலிப்பதிவு, உரை முதலியன)';
        case 'experimenting':
          return 'செய்முறை செய்து கற்றல் (பரிசோதனை)';
        case 'discuss':
          return 'விவாதம் / சேர்ந்து யோசித்து கற்றல்';
        case 'groupDiscussions':
          return 'குழு விவாதங்கள் மூலம் கற்றல்';
        case 'writing':
          return 'எழுதிக் கொண்டு கற்றல்';
        case 'readingByheart':
          return 'வாசித்து மனப்பாடம் செய்து கற்றல்';
        case 'teaching':
          return 'பிறருக்கு கற்றுக்கொடுப்பதன் மூலம் அல்லது யாராவது கவனமாக கேட்கும்போது நான் நன்றாக கற்றுக்கொள்கிறேன்';
        default:
          return key;
      }
    }
    // default English labels
    switch (key) {
      case 'visual':
        return 'Watching videos or relating to pictures (visual)';
      case 'reading':
        return 'Reading';
      case 'listening':
        return 'Listening (audio)';
      case 'experimenting':
        return 'Experimenting';
      case 'discuss':
        return 'Discuss / Brainstorming';
      case 'groupDiscussions':
        return 'Group discussions';
      case 'writing':
        return 'Writing';
      case 'readingByheart':
        return 'Reading & byheart';
      case 'teaching':
        return 'I learn by teaching others, or I like someone to listen to me';
      default:
        return key;
    }
  };

  // Helper to get Tamil question labels while preserving existing English structure
  const qLabel = (id: number, en: string): string => {
    if (lang === 'ta') {
      switch (id) {
        case 1:
          return '1. உங்களுக்கு பள்ளிக்கு வருவது பிடிக்கிறதா? ஏன்?';
        case 2:
          return '2. பள்ளியில் நீங்கள் என்ன கற்றுக்கொள்ள விரும்புகிறீர்கள்?';
        case 3:
          return '3. பள்ளியில் படிப்பது உங்களுக்கு பிடிக்காமல் இருக்கக் காரணங்கள் ஏதேனும் உள்ளனவா?';
        case 4:
          return '4. பள்ளியில் உங்கள் மிக நெருக்கமான நண்பர்கள் யார்? அவர்கள் எந்த குணங்கள்/அனுபவங்கள் காரணமாக உங்கள் நல்ல நண்பர்களாக இருக்கிறார்கள்?';
        case 5:
          return '5. நீங்கள் கற்றுக்கொள்ள விரும்பும் பாடங்கள்/தலைப்புகள் எவை? எழுதுங்கள்.';
        case 6:
          return '6. இந்த பாடங்கள் அல்லது தலைப்புகள் உங்களை ஏன் ஈர்க்கின்றன? காரணங்களை எழுதுங்கள்.';
        case 7:
          return '7. நீங்கள் கற்றுக்கொள்ள விரும்பாத பாடங்கள் எவை?';
        case 8:
          return '8. மேலே குறிப்பிடப்பட்ட பாடங்களில் உங்களுக்கு குறைந்த ஆர்வம் இருப்பதற்கு காரணம் என்ன? அவற்றை கற்றுக்கொள்ளும்போது எந்த சிரமங்களை எதிர்கொள்கிறீர்கள்?';
        case 9:
          return '9. நீங்கள் எத்தகைய பாடங்களில் நல்ல மதிப்பெண்கள் பெறுகிறீர்கள்?';
        case 10:
          return '10. எந்த பாடங்களில் அதிக மதிப்பெண்கள் பெறுவது உங்களுக்கு கஷ்டமாக இருக்கிறது?';
        case 11:
          return '11. கீழே கொடுக்கப்பட்டுள்ள எந்த வகை கற்றல் முறைகள் உங்களை அதிகம் ஈர்க்கின்றன? (உங்களுக்கு பொருந்தும் அனைத்தையும் ✔ வைத்து குறியிடுங்கள்)';
        case 12:
          return '12. நீங்கள் தனியாக படிப்பதற்கு விரும்புகிறீர்களா அல்லது குழுவில் படிப்பதற்கு விரும்புகிறீர்களா? ஏன்?';
        case 13:
          return '13. பள்ளியில் உங்கள் நண்பர்களிடமிருந்து நீங்கள் கற்றுக்கொள்கிறீர்களா? சமீபத்தில் அவர்களிடமிருந்து நீங்கள் கற்றுக் கொண்ட சில விஷயங்களை எழுதுங்கள்.';
        case 14:
          return '14. பாடங்களைக் காட்டிலும், பள்ளியில் உங்களுக்கு மிகவும் பிடித்த விஷயங்கள் எவை?';
        case 15:
          return '15. உங்களுக்கு மிகவும் பிடித்த ஆசிரியர் யார்? ஏன்? இந்த ஆசிரியர் உங்களை எப்படி பாதித்து உதவியுள்ளார்?';
        case 16:
          return '16. பள்ளியில் நீங்கள் மிகவும் வெற்றி பெற்றதாக அல்லது பெருமை பட்டதாக உணர்ந்த ஒரு நிகழ்வு இருந்ததா? அது என்ன?';
        case 17:
          return '17. பள்ளியில் நீங்கள் கற்றுக் கொண்ட விஷயங்கள் உங்கள் கனவுகள் மற்றும் இலக்குகளை அடைய எப்படி உதவும்? விளக்குங்கள்.';
        case 18:
          return '18. உங்கள் பள்ளியில் மாற்ற வேண்டும் என்று நீங்கள் விரும்பும் ஒரு விஷயம் என்ன? காரணங்களைக் குறிப்பிடுங்கள்.';
        case 19:
          return '19. உங்களுக்கு படிப்பு/பயிற்சி செய்ய தனி இடம் இருக்கிறதா? இருந்தால் அது ஏன் அவசியம் என்று நினைக்கிறீர்கள்?';
        case 20:
          return '20. உங்கள் வாழ்க்கையில் கற்றலுக்கு பள்ளி ஒரு முக்கிய பங்கு வகிக்கிறதா? உங்கள் கருத்தை எழுதுங்கள்.';
        case 21:
          return '21. பள்ளி செயல்பாடுகள் மற்றும் நீங்கள் கற்றுக் கொண்ட விஷயங்களைப் பற்றி உங்கள் பெற்றோருடன் பேச நீங்கள் விரும்புகிறீர்களா? அவர்களுடன் எந்த விஷயங்களைப் பற்றி பேசுகிறீர்கள்?';
        default:
          return en;
      }
    }
    return en;
  };

  useEffect(() => {
    const checkUnlock = async () => {
      if (!userProfile) return;
      let studentId = userProfile.studentProfile?.id as string | undefined;
      if (!studentId) {
        const { data } = await supabase.from('students').select('id').eq('user_id', userProfile.id).maybeSingle();
        studentId = data?.id;
      }
      if (!studentId) return;
      const unlockResult = await checkAssessmentUnlock(studentId, 'school_learning');
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
    if (userProfile) {
      checkExistingResponse();
    }
  }, [userProfile]);

  const checkExistingResponse = async () => {
    if (!userProfile) {
      setLoading(false);
      return;
    }
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
      setLoading(false);
      return;
    }
    try {
      // Get the most recent record (handle multiple records)
      const { data: records, error } = await supabase
        .from('assessment_responses')
        .select('*')
        .eq('student_id', studentId)
        .eq('assessment_type', 'school_learning')
        // Support both new and legacy titles
        .in('assessment_title', ['My School, My Learning and I', 'My School Learning'] as any)
        .order('updated_at', { ascending: false })
        .limit(1);
      
      const data = records && records.length > 0 ? records[0] : null;
      console.log('📥 Loading existing response:', { data, error, recordsCount: records?.length });
      
      if (data && !error && data.responses) {
        // Only set completed if completed_at exists
        if (data.completed_at) {
          setIsCompleted(true);
        }
        // Merge saved responses with current structure
        const savedResponses = data.responses as any;
        console.log('📋 Saved responses:', savedResponses);
        
        const mergedResponses: SchoolLearningAssessmentResponse = {
          section1: {
            question1: savedResponses.section1?.question1 || savedResponses.part1?.question1 || '',
            question2: savedResponses.section1?.question2 || savedResponses.part1?.question2 || '',
            question3: savedResponses.section1?.question3 || savedResponses.part1?.question3 || '',
            question4: savedResponses.section1?.question4 || savedResponses.part1?.question4 || ''
          },
          section2: {
            question5: savedResponses.section2?.question5 || savedResponses.part2?.question5 || '',
            question6: savedResponses.section2?.question6 || savedResponses.part2?.question6 || '',
            question7: savedResponses.section2?.question7 || savedResponses.part2?.question7 || '',
            question8: savedResponses.section2?.question8 || savedResponses.part2?.question8 || ''
          },
          section3: {
            question9: savedResponses.section3?.question9 || savedResponses.part2?.question9 || '',
            question10: savedResponses.section3?.question10 || savedResponses.part2?.question10 || '',
            question11: {
              visual: savedResponses.section3?.question11?.visual || savedResponses.part2?.question11?.lookingAtPictures || false,
              reading: savedResponses.section3?.question11?.reading || savedResponses.part2?.question11?.reading || false,
              listening: savedResponses.section3?.question11?.listening || savedResponses.part2?.question11?.listening || false,
              experimenting: savedResponses.section3?.question11?.experimenting || savedResponses.part2?.question11?.experiment || false,
              discuss: savedResponses.section3?.question11?.discuss || savedResponses.part2?.question11?.discussions || false,
              groupDiscussions: savedResponses.section3?.question11?.groupDiscussions || savedResponses.part2?.question11?.groupSessions || false,
              writing: savedResponses.section3?.question11?.writing || false,
              readingByheart: savedResponses.section3?.question11?.readingByheart || false,
              teaching: savedResponses.section3?.question11?.teaching || false,
              other: savedResponses.section3?.question11?.other || savedResponses.part2?.question11?.others || ''
            },
            question12: savedResponses.section3?.question12 || savedResponses.part2?.question12 || ''
          },
          section4: {
            question13: savedResponses.section4?.question13 || savedResponses.part3?.question13 || '',
            question14: savedResponses.section4?.question14 || savedResponses.part3?.question14 || '',
            question15: savedResponses.section4?.question15 || savedResponses.part3?.question15 || '',
            question16: savedResponses.section4?.question16 || savedResponses.part3?.question16 || ''
          },
          section5: {
            question17: savedResponses.section5?.question17 || savedResponses.part3?.question17 || '',
            question18: savedResponses.section5?.question18 || '',
            question19: savedResponses.section5?.question19 || '',
            question20: savedResponses.section5?.question20 || '',
            question21: savedResponses.section5?.question21 || ''
          }
        };
        
        console.log('✅ Merged responses:', mergedResponses);
        setResponses(mergedResponses);
      } else {
        console.log('ℹ️ No existing response found');
      }
    } catch (error) {
      console.error('❌ Error loading existing response:', error);
    } finally {
      setLoading(false);
    }
  };

  const handleResponseChange = (section: keyof SchoolLearningAssessmentResponse, questionKey: string, value: string) => {
    setResponses(prev => ({
      ...prev,
      [section]: {
        ...prev[section],
        [questionKey]: value
      }
    }));
  };

  const handleLearningMethodChange = (method: string, checked: boolean) => {
    if (isReadOnly) return;
    setResponses(prev => ({
      ...prev,
      section3: {
        ...prev.section3,
        question11: {
          ...prev.section3.question11,
          [method]: checked
        }
      }
    }));
  };

  const saveSection = async (section: 'section1' | 'section2' | 'section3' | 'section4' | 'section5') => {
    if (!userProfile || isReadOnly) return;
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

    setSavingSection(section);
    try {
      console.log('💾 Saving section:', section, 'with responses:', responses);
      
      // First, check if a record exists - get the most recent one
      const { data: existingRecords, error: fetchError } = await supabase
        .from('assessment_responses')
        .select('id, responses')
        .eq('student_id', studentId)
        .eq('assessment_type', 'school_learning')
        .eq('assessment_title', 'My School, My Learning and I')
        .order('updated_at', { ascending: false })
        .limit(1);

      if (fetchError) {
        console.error('❌ Error fetching existing record:', fetchError);
        throw fetchError;
      }

      const existing = existingRecords && existingRecords.length > 0 ? existingRecords[0] : null;
      console.log('📋 Existing record:', existing);

      if (existing) {
        // Update existing record, merge responses
        const existingResponses = existing.responses as any || {};
        const mergedResponses = {
          ...existingResponses,
          ...responses
        };

        console.log('🔄 Merging responses:', { existing: existingResponses, current: responses, merged: mergedResponses });

        const { error } = await supabase
          .from('assessment_responses')
          .update({
            responses: mergedResponses,
            updated_at: new Date().toISOString()
          })
          .eq('id', existing.id);
        
        if (error) {
          console.error('❌ Error updating record:', error);
          throw error;
        }
        console.log('✅ Successfully updated existing record');
      } else {
        // Create new record
        console.log('📝 Creating new record with responses:', responses);
        const { error } = await supabase
          .from('assessment_responses')
          .insert({
            student_id: studentId,
            assessment_type: 'school_learning',
            assessment_title: 'My School, My Learning and I',
            responses,
            updated_at: new Date().toISOString(),
            completed_at: null
          });
        
        if (error) {
          console.error('❌ Error inserting new record:', error);
          throw error;
        }
        console.log('✅ Successfully created new record');
      }

      toast({
        title:
          lang === 'kn'
            ? 'ಭಾಗವು ಉಳಿಸಲಾಗಿದೆ! ✅'
            : lang === 'ta'
              ? 'பகுதி சேமிக்கப்பட்டது! ✅'
              : 'Section Saved! ✅',
        description:
          lang === 'kn'
            ? `ನಿಮ್ಮ ${section.replace('section', 'ಭಾಗ ')} ಉತ್ತರಗಳನ್ನು ಉಳಿಸಲಾಗಿದೆ.`
            : lang === 'ta'
              ? `உங்கள் ${section.replace('section', 'பகுதி ')} பதில்கள் சேமிக்கப்பட்டுள்ளன.`
              : `Your ${section.replace('section', 'Section ')} responses have been saved.`,
      });
    } catch (error) {
      console.error('Error saving section:', error);
      toast({
        title:
          lang === 'kn'
            ? 'ದೋಷ'
            : lang === 'ta'
              ? 'பிழை'
              : 'Error',
        description:
          lang === 'kn'
            ? 'ಭಾಗವನ್ನು ಉಳಿಸಲು ಸಾಧ್ಯವಾಗಲಿಲ್ಲ. ದಯವಿಟ್ಟು ಮತ್ತೆ ಪ್ರಯತ್ನಿಸಿ.'
            : lang === 'ta'
              ? 'பகுதியை சேமிக்க முடியவில்லை. மீண்டும் முயற்சிக்கவும்.'
              : 'Failed to save section. Please try again.',
        variant: 'destructive',
      });
    } finally {
      setSavingSection(null);
    }
  };

  const getProgressPercentage = () => {
    const totalQuestions = 21;
    let answeredQuestions = 0;
    Object.values(responses.section1).forEach(v => { if (typeof v === 'string' && v.trim()) answeredQuestions++; });
    Object.values(responses.section2).forEach(v => { if (typeof v === 'string' && v.trim()) answeredQuestions++; });
    Object.values(responses.section3).forEach((v, i) => {
      if (i === 2) {
        const methods = responses.section3.question11;
        if (Object.values(methods).some(val => val === true || (typeof val === 'string' && val.trim()))) answeredQuestions++;
      } else if (typeof v === 'string' && v.trim()) answeredQuestions++;
    });
    Object.values(responses.section4).forEach(v => { if (typeof v === 'string' && v.trim()) answeredQuestions++; });
    Object.values(responses.section5).forEach(v => { if (typeof v === 'string' && v.trim()) answeredQuestions++; });
    return totalQuestions > 0 ? (answeredQuestions / totalQuestions) * 100 : 0;
  };

  const canSubmit = () => {
    if (isReadOnly) return false;
    
    // Helper to safely check if a question is answered
    const isAnswered = (value: any): boolean => {
      if (value === null || value === undefined) return false;
      if (typeof value === 'string') return value.trim() !== '';
      return false;
    };
    
    // Check section 1 (4 questions)
    const section1Complete = 
      isAnswered(responses.section1.question1) &&
      isAnswered(responses.section1.question2) &&
      isAnswered(responses.section1.question3) &&
      isAnswered(responses.section1.question4);
    
    // Check section 2 (4 questions)
    const section2Complete = 
      isAnswered(responses.section2.question5) &&
      isAnswered(responses.section2.question6) &&
      isAnswered(responses.section2.question7) &&
      isAnswered(responses.section2.question8);
    
    // Check section 3 (4 items: question9, question10, question11, question12)
    const section3Q11Complete = Object.values(responses.section3.question11).some(val => 
      val === true || (typeof val === 'string' && val.trim() !== '')
    );
    const section3Complete = 
      isAnswered(responses.section3.question9) &&
      isAnswered(responses.section3.question10) &&
      section3Q11Complete &&
      isAnswered(responses.section3.question12);
    
    // Check section 4 (4 questions)
    const section4Complete = 
      isAnswered(responses.section4.question13) &&
      isAnswered(responses.section4.question14) &&
      isAnswered(responses.section4.question15) &&
      isAnswered(responses.section4.question16);
    
    // Check section 5 (5 questions)
    const section5Complete = 
      isAnswered(responses.section5.question17) &&
      isAnswered(responses.section5.question18) &&
      isAnswered(responses.section5.question19) &&
      isAnswered(responses.section5.question20) &&
      isAnswered(responses.section5.question21);
    
    const allSectionsComplete = section1Complete && section2Complete && section3Complete && section4Complete && section5Complete;
    
    if (!allSectionsComplete) {
      console.log('📋 Submission check:', {
        section1: section1Complete,
        section1Details: {
          q1: isAnswered(responses.section1.question1),
          q2: isAnswered(responses.section1.question2),
          q3: isAnswered(responses.section1.question3),
          q4: isAnswered(responses.section1.question4)
        },
        section2: section2Complete,
        section2Details: {
          q5: isAnswered(responses.section2.question5),
          q6: isAnswered(responses.section2.question6),
          q7: isAnswered(responses.section2.question7),
          q8: isAnswered(responses.section2.question8)
        },
        section3: section3Complete,
        section3Details: {
          q9: isAnswered(responses.section3.question9),
          q10: isAnswered(responses.section3.question10),
          q11: section3Q11Complete,
          q12: isAnswered(responses.section3.question12)
        },
        section4: section4Complete,
        section4Details: {
          q13: isAnswered(responses.section4.question13),
          q14: isAnswered(responses.section4.question14),
          q15: isAnswered(responses.section4.question15),
          q16: isAnswered(responses.section4.question16)
        },
        section5: section5Complete,
        section5Details: {
          q17: isAnswered(responses.section5.question17),
          q18: isAnswered(responses.section5.question18),
          q19: isAnswered(responses.section5.question19),
          q20: isAnswered(responses.section5.question20),
          q21: isAnswered(responses.section5.question21)
        }
      });
    } else {
      console.log('✅ All sections complete! Submit button should be enabled.');
    }
    
    return allSectionsComplete;
  };

  const submitAssessment = async () => {
    if (isReadOnly || !userProfile) return;
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
        description: "Student profile not found.",
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
          assessment_type: 'school_learning',
          assessment_title: 'My School, My Learning and I',
          responses: responses,
          completed_at: new Date().toISOString(),
          updated_at: new Date().toISOString()
        })
        .select()
        .single();

      if (error) throw error;

      toast({
        title:
          lang === 'kn'
            ? 'ಮೌಲ್ಯಮಾಪನ ಪೂರ್ಣಗೊಂಡಿದೆ! 📚'
            : lang === 'ta'
              ? 'மதிப்பீடு முடிந்துவிட்டது! 📚'
              : 'Assessment Completed! 📚',
        description:
          lang === 'kn'
            ? 'ನಿಮ್ಮ ಉತ್ತರಗಳನ್ನು ಯಶಸ್ವಿಯಾಗಿ ಉಳಿಸಲಾಗಿದೆ!'
            : lang === 'ta'
              ? 'உங்கள் பதில்கள் வெற்றிகரமாக சேமிக்கப்பட்டுள்ளன!'
              : 'Your responses have been saved successfully!',
      });

      setIsCompleted(true);

      try {
        const { aiSummaryService } = await import('@/services/aiSummaryService');
        const summaryDatabaseService = (await import('@/services/summaryDatabaseService')).summaryDatabaseService;
        
        if (aiSummaryService.isConfigured() && assessmentData?.id) {
          console.log('🤖 Generating AI summary for School Learning assessment:', assessmentData.id);
          const summaryResult = await aiSummaryService.generateSchoolLearningSummary(responses);

          if (summaryResult.success && summaryResult.summary) {
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
                    ? 'ನಿಮ್ಮ “ನನ್ನ ಶಾಲೆ, ನನ್ನ ಕಲಿಕೆ ಮತ್ತು ನಾನು” ಮೌಲ್ಯಮಾಪನದ ಸಾರಾಂಶವನ್ನು ನಿಮ್ಮ ಶಿಕ್ಷಕರು ಪರಿಶೀಲಿಸಲಿದ್ದಾರೆ.'
                    : lang === 'ta'
                      ? '“என் பள்ளி, என் படிப்பு மற்றும் நான்” மதிப்பீட்டின் சுருக்கத்தை உங்கள் ஆசிரியா் விரைவில் பார்வையிடுவார்.'
                      : 'Your teacher will review it.',
              });

              try {
                const { notificationService } = await import('@/services/notificationService');
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
                      title: `${userProfile?.full_name || 'Student'} completed My School, My Learning and I assessment`,
                      message: 'A new assessment summary is ready for review.',
                      link: '/teacher/ai-summary-review'
                    });
                  }
                }
              } catch (notifError) {
                console.error('Error notifying teacher:', notifError);
              }
            }
          }
        }
      } catch (summaryError) {
        console.error('Error in summary generation:', summaryError);
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
        ? '"ನನ್ನ ಶಾಲೆ, ನನ್ನ ಕಲಿಕೆ ಮತ್ತು ನಾನು" ಮೌಲ್ಯಮಾಪನವನ್ನು ಲೋಡ್ ಮಾಡಲಾಗುತ್ತಿದೆ...'
        : lang === 'ta'
          ? '"என் பள்ளி, என் கற்றல் மற்றும் நான்" மதிப்பீடு ஏற்றப்படுகிறது...'
          : 'Loading your school learning assessment...';

    return (
      <div className="min-h-screen flex items-center justify-center bg-gradient-to-br from-green-50 to-emerald-100">
        <div className="text-center">
          <div className="animate-spin rounded-full h-12 w-12 border-b-4 border-green-600 mx-auto"></div>
          <p className="mt-4 text-lg text-gray-600">{loadingText}</p>
        </div>
      </div>
    );
  }

  if (isCompleted && !readOnlyView) {
    return (
      <div className="min-h-screen bg-gradient-to-br from-green-50 to-emerald-50 py-8">
        <div className="container mx-auto px-4">
          <Card className="max-w-2xl mx-auto border-0 shadow-lg">
            <CardHeader className="text-center bg-gradient-to-r from-green-50 to-emerald-50">
              <School className="w-16 h-16 text-green-500 mx-auto mb-4" />
              <CardTitle className="text-2xl text-green-800">
                {lang === 'kn'
                  ? 'ಮೌಲ್ಯಮಾಪನ ಪೂರ್ಣಗೊಂಡಿದೆ! 🏫'
                  : lang === 'ta'
                    ? 'மதிப்பீடு முடிந்துவிட்டது! 🏫'
                    : 'Assessment Completed! 🏫'}
              </CardTitle>
            </CardHeader>
            <CardContent className="p-6">
              <div className="text-center space-y-4">
                <p className="text-gray-600">
                  {lang === 'kn'
                    ? 'ನಿಮ್ಮ ಆಲೋಚನೆಗಳನ್ನು ಹಂಚಿಕೊಂಡಿದ್ದಕ್ಕಾಗಿ ಧನ್ಯವಾದಗಳು!'
                    : lang === 'ta'
                      ? 'உங்கள் எண்ணங்களை எங்களுடன் பகிர்ந்ததற்கு நன்றி!'
                      : 'Thank you for sharing your thoughts!'}
                </p>
                <div className="flex justify-center gap-4">
                  <Button
                    variant="outline"
                    onClick={() => {
                      const params = new URLSearchParams(searchParams.toString());
                      params.set('readonly', '1');
                      navigate(`/student/assessment/school-learning?${params.toString()}`);
                    }}
                  >
                    {lang === 'kn'
                      ? 'ನನ್ನ ಉತ್ತರಗಳನ್ನು ನೋಡಿ'
                      : lang === 'ta'
                        ? 'என் பதில்களை காண'
                        : 'View My Answers'}
                  </Button>
                  <Button onClick={() => navigate('/student')} className="bg-green-600 hover:bg-green-700">
                    {lang === 'kn'
                      ? 'ಡ್ಯಾಶ್‌ಬೋರ್ಡ್‌ಗೆ ಹಿಂತಿರುಗಿ'
                      : lang === 'ta'
                        ? 'டாஷ்போர்டுக்கு திரும்ப செல்ல'
                        : 'Back to Dashboard'}
                  </Button>
                </div>
              </div>
            </CardContent>
          </Card>
        </div>
      </div>
    );
  }

  const sectionNames = {
    section1: 'School Experience',
    section2: 'Subjects & Learning Preferences',
    section3: 'Academic Performance & Learning Methods',
    section4: 'School Relationships & Experiences',
    section5: 'Future & Reflection'
  };

  return (
    <div className="min-h-screen bg-gradient-to-br from-green-50 via-white to-emerald-50 py-8" lang={lang} dir="auto">
      <div className="container mx-auto px-4 max-w-4xl">
        <TooltipProvider>
          <div className="text-center mb-8">
            <div className="text-left mb-2">
              <Button variant="ghost" onClick={() => navigate('/student')} className="text-green-700 hover:text-green-800">
                <ArrowLeft className="w-4 h-4 mr-2" />{t('backToDashboard')}
              </Button>
            </div>
            <h1 className="text-3xl font-bold text-green-800 mb-2">
              {lang === 'kn'
                ? '🏫 ನನ್ನ ಶಾಲೆ, ನನ್ನ ಕಲಿಕೆ ಮತ್ತು ನಾನು'
                : lang === 'ta'
                  ? '🏫 என் பள்ளி, என் படிப்பு மற்றும் நான்'
                  : '🏫 My School, My Learning and I'}
            </h1>
            <p className="text-gray-700 mt-4">
              {lang === 'kn'
                ? 'ಶಾಲೆ, ಕಲಿಕೆ ಮತ್ತು ನಿಮ್ಮ ಅನುಭವಗಳ ಬಗ್ಗೆ ನಿಮ್ಮ ಆಲೋಚನೆಗಳನ್ನು ಹಂಚಿಕೊಳ್ಳಿ. ನಿಧಾನವಾಗಿ ಯೋಚಿಸಿ, ಸತ್ಯವಾಗಿ ಉತ್ತರಿಸಿ.'
                : lang === 'ta'
                  ? 'பள்ளி, படிப்பு மற்றும் உங்கள் அனுபவங்களைப் பற்றி உங்கள் எண்ணங்களை பகிருங்கள். மெதுவாக யோசித்து நேர்மையாக பதில் எழுதுங்கள்.'
                  : 'Share your thoughts about school, learning, and your experiences. Take your time and answer honestly.'}
            </p>
          </div>

          <Card className="mb-6 border-0 shadow-lg">
            <CardContent className="p-6">
              <div className="flex items-center justify-between mb-4">
                <h2 className="text-lg font-semibold text-gray-800">{t('yourProgress')}</h2>
                <Badge variant="secondary">
                  {Math.round(getProgressPercentage())}% {t('completeSuffix')}
                </Badge>
              </div>
              <Progress value={getProgressPercentage()} className="h-3" />
            </CardContent>
          </Card>

          <div className="flex justify-center mb-6 gap-2 flex-wrap">
            {(['section1', 'section2', 'section3', 'section4', 'section5'] as const).map((section) => {
              const sectionNumber = Number(section.replace('section', ''));
              const label =
                lang === 'kn'
                  ? `ಭಾಗ ${sectionNumber}`
                  : lang === 'ta'
                    ? `பகுதி ${sectionNumber}`
                    : `Section ${sectionNumber}`;
              return (
                <button
                  key={section}
                  onClick={() => setCurrentSection(section)}
                  className={`px-4 py-2 rounded-md transition-all text-sm ${
                    currentSection === section
                      ? 'bg-green-600 text-white shadow-md'
                      : 'bg-white text-gray-600 hover:text-green-600 border border-gray-200'
                  }`}
                >
                  {label}
                </button>
              );
            })}
          </div>

          {currentSection === 'section1' && (
            <Card className="border-0 shadow-lg mb-4">
              <CardHeader className="bg-gradient-to-r from-green-50 to-emerald-50">
                <CardTitle className="text-xl text-green-800">
                  {lang === 'kn'
                    ? 'ಭಾಗ 1: ಶಾಲಾ ಅನುಭವ'
                    : lang === 'ta'
                      ? 'பகுதி 1: பள்ளி அனுபவம்'
                      : 'Section 1: School Experience'}
                </CardTitle>
              </CardHeader>
              <CardContent className="p-6 space-y-6">
                <div>
                  <label className="block text-sm font-medium text-gray-700 mb-2 flex items-center gap-2">
                    {qLabel(1, '1. Do you like coming to school? Why?')}
                    <Tooltip>
                      <TooltipTrigger asChild>
                        <button type="button" className="text-green-700 hover:text-green-800">💬</button>
                      </TooltipTrigger>
                      <TooltipContent>
                        {getHelpText(1, 'Say Yes or No, then explain why. Example: "Yes, because I like meeting my friends and learning new things."')}
                      </TooltipContent>
                    </Tooltip>
                  </label>
                  <Textarea
                    placeholder={getHelpText(1, 'Example: Yes, because I enjoy learning and spending time with friends...')}
                    value={responses.section1.question1}
                    onChange={(e) => handleResponseChange('section1', 'question1', e.target.value)}
                    rows={3}
                    readOnly={isReadOnly}
                    className="border-green-200 focus:border-green-400"
                  />
                </div>

                <div>
                  <label className="block text-sm font-medium text-gray-700 mb-2 flex items-center gap-2">
                    {qLabel(2, '2. What do you like to learn at school?')}
                    <Tooltip>
                      <TooltipTrigger asChild>
                        <button type="button" className="text-green-700 hover:text-green-800">💬</button>
                      </TooltipTrigger>
                      <TooltipContent>
                        {getHelpText(2, 'Write about the topics or subjects you enjoy. Example: "I like learning about science experiments and stories in English."')}
                      </TooltipContent>
                    </Tooltip>
                  </label>
                  <Textarea
                    placeholder={getHelpText(2, 'Example: I enjoy learning about science, mathematics, and stories...')}
                    value={responses.section1.question2}
                    onChange={(e) => handleResponseChange('section1', 'question2', e.target.value)}
                    rows={3}
                    readOnly={isReadOnly}
                    className="border-green-200 focus:border-green-400"
                  />
                </div>

                <div>
                  <label className="block text-sm font-medium text-gray-700 mb-2 flex items-center gap-2">
                    {qLabel(3, "3. Are there reasons why you don't like learning at school?")}
                    <Tooltip>
                      <TooltipTrigger asChild>
                        <button type="button" className="text-green-700 hover:text-green-800">💬</button>
                      </TooltipTrigger>
                      <TooltipContent>
                        {getHelpText(3, 'If you have any problems with learning, write them here. Example: "Sometimes the teacher goes too fast and I can\'t understand."')}
                      </TooltipContent>
                    </Tooltip>
                  </label>
                  <Textarea
                    placeholder={getHelpText(3, 'Example: Sometimes I find it hard to understand when the teacher explains too quickly...')}
                    value={responses.section1.question3}
                    onChange={(e) => handleResponseChange('section1', 'question3', e.target.value)}
                    rows={3}
                    readOnly={isReadOnly}
                    className="border-green-200 focus:border-green-400"
                  />
                </div>

                <div>
                  <label className="block text-sm font-medium text-gray-700 mb-2 flex items-center gap-2">
                    {qLabel(4, '4. Who are your best friends at school, and what qualities or shared experiences make them your best friends?')}
                    <Tooltip>
                      <TooltipTrigger asChild>
                        <button type="button" className="text-green-700 hover:text-green-800">💬</button>
                      </TooltipTrigger>
                      <TooltipContent>
                        {getHelpText(4, 'Write your friend\'s name and what makes them special. Example: "Ravi is my best friend because he helps me with studies and we play together."')}
                      </TooltipContent>
                    </Tooltip>
                  </label>
                  <Textarea
                    placeholder={getHelpText(4, 'Example: My best friend is Priya. She is kind, helps me with homework, and we enjoy playing together...')}
                    value={responses.section1.question4}
                    onChange={(e) => handleResponseChange('section1', 'question4', e.target.value)}
                    rows={3}
                    readOnly={isReadOnly}
                    className="border-green-200 focus:border-green-400"
                  />
                </div>

                <Button
                  onClick={() => saveSection('section1')}
                  disabled={savingSection === 'section1' || isReadOnly}
                  className="w-full bg-green-600 hover:bg-green-700"
                >
                  {savingSection === 'section1' ? (
                    <>Saving...</>
                  ) : (
                    <>
                      <Save className="w-4 h-4 mr-2" />
                      {lang === 'kn'
                        ? 'ಭಾಗ 1 ಅನ್ನು ಉಳಿಸಿ'
                        : lang === 'ta'
                          ? 'பகுதி 1ஐ சேமிக்கவும்'
                          : 'Save Section 1'}
                    </>
                  )}
                </Button>
              </CardContent>
            </Card>
          )}

          {currentSection === 'section2' && (
            <Card className="border-0 shadow-lg mb-4">
              <CardHeader className="bg-gradient-to-r from-blue-50 to-indigo-50">
                <CardTitle className="text-xl text-blue-800">
                  {lang === 'kn'
                    ? 'ಭಾಗ 2: ವಿಷಯಗಳು ಮತ್ತು ಕಲಿಕೆಯ ಮೆಚ್ಚುಗೆಗಳು'
                    : lang === 'ta'
                      ? 'பகுதி 2: பாடங்கள் மற்றும் கற்றல் விருப்பங்கள்'
                      : 'Section 2: Subjects & Learning Preferences'}
                </CardTitle>
              </CardHeader>
              <CardContent className="p-6 space-y-6">
                <div>
                  <label className="block text-sm font-medium text-gray-700 mb-2 flex items-center gap-2">
                    {qLabel(5, '5. Which topics/subjects do you enjoy learning? Write.')}
                    <Tooltip>
                      <TooltipTrigger asChild>
                        <button type="button" className="text-blue-700 hover:text-blue-800">💬</button>
                      </TooltipTrigger>
                      <TooltipContent>
                        {getHelpText(5, 'List the subjects you like. Example: "I enjoy Mathematics, Science, and English."')}
                      </TooltipContent>
                    </Tooltip>
                  </label>
                  <Textarea
                    placeholder={getHelpText(5, 'Example: I enjoy Mathematics, Science, English, and Social Studies...')}
                    value={responses.section2.question5}
                    onChange={(e) => handleResponseChange('section2', 'question5', e.target.value)}
                    rows={3}
                    readOnly={isReadOnly}
                    className="border-blue-200 focus:border-blue-400"
                  />
                </div>

                <div>
                  <label className="block text-sm font-medium text-gray-700 mb-2 flex items-center gap-2">
                    {qLabel(6, '6. What specifically draws you towards these topics/subjects? Write the reasons.')}
                    <Tooltip>
                      <TooltipTrigger asChild>
                        <button type="button" className="text-blue-700 hover:text-blue-800">💬</button>
                      </TooltipTrigger>
                      <TooltipContent>
                        {getHelpText(6, 'Explain why you like these subjects. Example: "I like Science because we do experiments and it\'s fun to see how things work."')}
                      </TooltipContent>
                    </Tooltip>
                  </label>
                  <Textarea
                    placeholder={getHelpText(6, 'Example: I like Science because we do experiments and I find it interesting to learn how things work...')}
                    value={responses.section2.question6}
                    onChange={(e) => handleResponseChange('section2', 'question6', e.target.value)}
                    rows={3}
                    readOnly={isReadOnly}
                    className="border-blue-200 focus:border-blue-400"
                  />
                </div>

                <div>
                  <label className="block text-sm font-medium text-gray-700 mb-2 flex items-center gap-2">
                    {qLabel(7, '7. Which subjects do you dislike learning?')}
                    <Tooltip>
                      <TooltipTrigger asChild>
                        <button type="button" className="text-blue-700 hover:text-blue-800">💬</button>
                      </TooltipTrigger>
                      <TooltipContent>
                        {getHelpText(7, 'Write the subjects you don\'t like. Example: "I don\'t like History because there are too many dates to remember."')}
                      </TooltipContent>
                    </Tooltip>
                  </label>
                  <Textarea
                    placeholder={getHelpText(7, 'Example: I find History difficult because there are many dates and events to remember...')}
                    value={responses.section2.question7}
                    onChange={(e) => handleResponseChange('section2', 'question7', e.target.value)}
                    rows={3}
                    readOnly={isReadOnly}
                    className="border-blue-200 focus:border-blue-400"
                  />
                </div>

                <div>
                  <label className="block text-sm font-medium text-gray-700 mb-2 flex items-center gap-2">
                    {qLabel(8, '8. Why do you have less interest in the above mentioned subjects? What challenges do you find in learning those subjects?')}
                    <Tooltip>
                      <TooltipTrigger asChild>
                        <button type="button" className="text-blue-700 hover:text-blue-800">💬</button>
                      </TooltipTrigger>
                      <TooltipContent>
                        {getHelpText(8, 'Explain what makes these subjects hard for you. Example: "History is difficult because I forget dates and names easily."')}
                      </TooltipContent>
                    </Tooltip>
                  </label>
                  <Textarea
                    placeholder={getHelpText(8, 'Example: I find it hard to remember dates and names in History. The teacher explains too fast sometimes...')}
                    value={responses.section2.question8}
                    onChange={(e) => handleResponseChange('section2', 'question8', e.target.value)}
                    rows={3}
                    readOnly={isReadOnly}
                    className="border-blue-200 focus:border-blue-400"
                  />
                </div>

                <Button
                  onClick={() => saveSection('section2')}
                  disabled={savingSection === 'section2' || isReadOnly}
                  className="w-full bg-blue-600 hover:bg-blue-700"
                >
                  {savingSection === 'section2' ? (
                    <>Saving...</>
                  ) : (
                    <>
                      <Save className="w-4 h-4 mr-2" />
                      {lang === 'kn'
                        ? 'ಭಾಗ 2 ಅನ್ನು ಉಳಿಸಿ'
                        : lang === 'ta'
                          ? 'பகுதி 2ஐ சேமிக்கவும்'
                          : 'Save Section 2'}
                    </>
                  )}
                </Button>
              </CardContent>
            </Card>
          )}

          {currentSection === 'section3' && (
            <Card className="border-0 shadow-lg mb-4">
              <CardHeader className="bg-gradient-to-r from-purple-50 to-pink-50">
                <CardTitle className="text-xl text-purple-800">
                  {lang === 'kn'
                    ? 'ಭಾಗ 3: ಶೈಕ್ಷಣಿಕ ಸಾಧನೆ ಮತ್ತು ಕಲಿಕೆಯ ವಿಧಾನಗಳು'
                    : lang === 'ta'
                      ? 'பகுதி 3: கல்வி முன்னேற்றம் மற்றும் கற்றல் முறைகள்'
                      : 'Section 3: Academic Performance & Learning Methods'}
                </CardTitle>
              </CardHeader>
              <CardContent className="p-6 space-y-6">
                <div>
                  <label className="block text-sm font-medium text-gray-700 mb-2 flex items-center gap-2">
                    {qLabel(9, '9. In which subjects do you score/get marks well?')}
                    <Tooltip>
                      <TooltipTrigger asChild>
                        <button type="button" className="text-purple-700 hover:text-purple-800">💬</button>
                      </TooltipTrigger>
                      <TooltipContent>
                        {getHelpText(9, 'Write subjects where you get good marks. Example: "I score well in Mathematics and Science."')}
                      </TooltipContent>
                    </Tooltip>
                  </label>
                  <Textarea
                    placeholder={getHelpText(9, 'Example: I usually get good marks in Mathematics, Science, and English...')}
                    value={responses.section3.question9}
                    onChange={(e) => handleResponseChange('section3', 'question9', e.target.value)}
                    rows={3}
                    readOnly={isReadOnly}
                    className="border-purple-200 focus:border-purple-400"
                  />
                </div>

                <div>
                  <label className="block text-sm font-medium text-gray-700 mb-2 flex items-center gap-2">
                    {qLabel(10, '10. In which subjects do you find it challenging to achieve high scores?')}
                    <Tooltip>
                      <TooltipTrigger asChild>
                        <button type="button" className="text-purple-700 hover:text-purple-800">💬</button>
                      </TooltipTrigger>
                      <TooltipContent>
                        {getHelpText(10, 'Write subjects where you get low marks. Example: "I find it hard to score well in History and Hindi."')}
                      </TooltipContent>
                    </Tooltip>
                  </label>
                  <Textarea
                    placeholder={getHelpText(10, 'Example: I find it difficult to get high marks in History and Hindi...')}
                    value={responses.section3.question10}
                    onChange={(e) => handleResponseChange('section3', 'question10', e.target.value)}
                    rows={3}
                    readOnly={isReadOnly}
                    className="border-purple-200 focus:border-purple-400"
                  />
                </div>

                <div>
                  <label className="block text-sm font-medium text-gray-700 mb-2 flex items-center gap-2">
                    {qLabel(11, '11. Which learning methodologies from the following options resonate with you the most? (Mark with ✔ that applies to you)')}
                    <Tooltip>
                      <TooltipTrigger asChild>
                        <button type="button" className="text-purple-700 hover:text-purple-800">💬</button>
                      </TooltipTrigger>
                      <TooltipContent>
                        {getHelpText(11, 'Check all the ways you like to learn. You can choose more than one.')}
                      </TooltipContent>
                    </Tooltip>
                  </label>
                  <div className="space-y-3">
                    {[
                      'visual',
                      'reading',
                      'listening',
                      'experimenting',
                      'discuss',
                      'groupDiscussions',
                      'writing',
                      'readingByheart',
                      'teaching'
                    ].map((key) => (
                      <div key={key} className="flex items-center space-x-2">
                        <Checkbox
                          id={key}
                          checked={responses.section3.question11[key as keyof typeof responses.section3.question11] as boolean}
                          onCheckedChange={(checked) => handleLearningMethodChange(key, checked as boolean)}
                          disabled={isReadOnly}
                        />
                        <label htmlFor={key} className="text-sm text-gray-700">
                          {getLearningMethodLabel(key)}
                        </label>
                      </div>
                    ))}
                    <div className="flex items-center space-x-2">
                      <Checkbox
                        id="other"
                        checked={responses.section3.question11.other !== ''}
                        onCheckedChange={(checked) => {
                          if (!checked) handleLearningMethodChange('other', '');
                        }}
                        disabled={isReadOnly}
                      />
                      <label htmlFor="other" className="text-sm text-gray-700">
                        {lang === 'kn'
                          ? 'ಇನ್ನೊಂದು ವಿಧಾನ ಇದ್ದರೆ – ಅದರಿಂದ ನಾನು ಹೆಚ್ಚು ಚೆನ್ನಾಗಿ ಕಲಿಯುತ್ತೇನೆ (ವಿವರಿಸಿ)'
                          : lang === 'ta'
                            ? 'வேறு ஏதேனும் முறையில் நான் நன்றாக கற்றுக்கொள்கிறேன் – (அந்த முறையை எழுதுங்கள்)'
                            : 'I learn better when - (any other method you apply)'}
                      </label>
                    </div>
                    {responses.section3.question11.other !== '' && (
                      <Textarea
                        placeholder={getHelpText(11, 'Write your other learning method...')}
                        value={responses.section3.question11.other}
                        onChange={(e) => handleLearningMethodChange('other', e.target.value)}
                        rows={2}
                        readOnly={isReadOnly}
                        className="border-purple-200 focus:border-purple-400 ml-6"
                      />
                    )}
                  </div>
                </div>

                <div>
                  <label className="block text-sm font-medium text-gray-700 mb-2 flex items-center gap-2">
                    {qLabel(12, '12. Do you enjoy studying alone or in a group? Why? Write the reason.')}
                    <Tooltip>
                      <TooltipTrigger asChild>
                        <button type="button" className="text-purple-700 hover:text-purple-800">💬</button>
                      </TooltipTrigger>
                      <TooltipContent>
                        {getHelpText(12, 'Say if you like studying alone or with friends, and explain why. Example: "I like studying in a group because we can help each other and discuss doubts."')}
                      </TooltipContent>
                    </Tooltip>
                  </label>
                  <Textarea
                    placeholder={getHelpText(12, 'Example: I prefer studying in a group because we can discuss and help each other understand difficult topics...')}
                    value={responses.section3.question12}
                    onChange={(e) => handleResponseChange('section3', 'question12', e.target.value)}
                    rows={3}
                    readOnly={isReadOnly}
                    className="border-purple-200 focus:border-purple-400"
                  />
                </div>

                <Button
                  onClick={() => saveSection('section3')}
                  disabled={savingSection === 'section3' || isReadOnly}
                  className="w-full bg-purple-600 hover:bg-purple-700"
                >
                  {savingSection === 'section3' ? (
                    <>Saving...</>
                  ) : (
                    <>
                      <Save className="w-4 h-4 mr-2" />
                      {lang === 'kn'
                        ? 'ಭಾಗ 3 ಅನ್ನು ಉಳಿಸಿ'
                        : lang === 'ta'
                          ? 'பகுதி 3ஐ சேமிக்கவும்'
                          : 'Save Section 3'}
                    </>
                  )}
                </Button>
              </CardContent>
            </Card>
          )}

          {currentSection === 'section4' && (
            <Card className="border-0 shadow-lg mb-4">
              <CardHeader className="bg-gradient-to-r from-orange-50 to-red-50">
                <CardTitle className="text-xl text-orange-800">
                  {lang === 'kn'
                    ? 'ಭಾಗ 4: ಶಾಲೆಯ ಸಂಬಂಧಗಳು ಮತ್ತು ಅನುಭವಗಳು'
                    : lang === 'ta'
                      ? 'பகுதி 4: பள்ளியில் உள்ள உறவுகள் மற்றும் அனுபவங்கள்'
                      : 'Section 4: School Relationships & Experiences'}
                </CardTitle>
              </CardHeader>
              <CardContent className="p-6 space-y-6">
                <div>
                  <label className="block text-sm font-medium text-gray-700 mb-2 flex items-center gap-2">
                    {qLabel(13, '13. Do you learn from your friends in school? Can you list a few things that you learnt from your friends in school recently.')}
                    <Tooltip>
                      <TooltipTrigger asChild>
                        <button type="button" className="text-orange-700 hover:text-orange-800">💬</button>
                      </TooltipTrigger>
                      <TooltipContent>
                        {getHelpText(13, 'Write what you learned from friends. Example: "My friend taught me how to solve math problems and play cricket."')}
                      </TooltipContent>
                    </Tooltip>
                  </label>
                  <Textarea
                    placeholder={getHelpText(13, 'Example: Yes, my friend Ravi taught me how to solve difficult math problems. Another friend showed me how to play cricket...')}
                    value={responses.section4.question13}
                    onChange={(e) => handleResponseChange('section4', 'question13', e.target.value)}
                    rows={3}
                    readOnly={isReadOnly}
                    className="border-orange-200 focus:border-orange-400"
                  />
                </div>

                <div>
                  <label className="block text-sm font-medium text-gray-700 mb-2 flex items-center gap-2">
                    {qLabel(14, '14. Besides academics, what aspects of school do you enjoy the most?')}
                    <Tooltip>
                      <TooltipTrigger asChild>
                        <button type="button" className="text-orange-700 hover:text-orange-800">💬</button>
                      </TooltipTrigger>
                      <TooltipContent>
                        {getHelpText(14, 'Write about non-study activities you like. Example: "I enjoy sports day, annual day celebrations, and playing with friends during break time."')}
                      </TooltipContent>
                    </Tooltip>
                  </label>
                  <Textarea
                    placeholder={getHelpText(14, 'Example: I enjoy sports day, annual day celebrations, playing games during break time, and participating in cultural events...')}
                    value={responses.section4.question14}
                    onChange={(e) => handleResponseChange('section4', 'question14', e.target.value)}
                    rows={3}
                    readOnly={isReadOnly}
                    className="border-orange-200 focus:border-orange-400"
                  />
                </div>

                <div>
                  <label className="block text-sm font-medium text-gray-700 mb-2 flex items-center gap-2">
                    {qLabel(15, '15. Who is your favourite teacher and why? How has this teacher influenced you?')}
                    <Tooltip>
                      <TooltipTrigger asChild>
                        <button type="button" className="text-orange-700 hover:text-orange-800">💬</button>
                      </TooltipTrigger>
                      <TooltipContent>
                        {getHelpText(15, 'Write about a teacher you like and how they helped you. Example: "My Science teacher is my favorite because she explains clearly and encourages me to ask questions."')}
                      </TooltipContent>
                    </Tooltip>
                  </label>
                  <Textarea
                    placeholder={getHelpText(15, 'Example: My Mathematics teacher is my favorite because she explains clearly, is patient, and always encourages me to do better...')}
                    value={responses.section4.question15}
                    onChange={(e) => handleResponseChange('section4', 'question15', e.target.value)}
                    rows={3}
                    readOnly={isReadOnly}
                    className="border-orange-200 focus:border-orange-400"
                  />
                </div>

                <div>
                  <label className="block text-sm font-medium text-gray-700 mb-2 flex items-center gap-2">
                    {qLabel(16, '16. Was there a specific instance in school that made you feel very successful or proud? What was it?')}
                    <Tooltip>
                      <TooltipTrigger asChild>
                        <button type="button" className="text-orange-700 hover:text-orange-800">💬</button>
                      </TooltipTrigger>
                      <TooltipContent>
                        {getHelpText(16, 'Write about a time you felt proud or successful. Example: "I felt proud when I won first prize in the science exhibition."')}
                      </TooltipContent>
                    </Tooltip>
                  </label>
                  <Textarea
                    placeholder={getHelpText(16, 'Example: I felt very proud when I won first prize in the science exhibition. The teacher praised my project...')}
                    value={responses.section4.question16}
                    onChange={(e) => handleResponseChange('section4', 'question16', e.target.value)}
                    rows={3}
                    readOnly={isReadOnly}
                    className="border-orange-200 focus:border-orange-400"
                  />
                </div>

                <Button
                  onClick={() => saveSection('section4')}
                  disabled={savingSection === 'section4' || isReadOnly}
                  className="w-full bg-orange-600 hover:bg-orange-700"
                >
                  {savingSection === 'section4' ? (
                    <>Saving...</>
                  ) : (
                    <>
                      <Save className="w-4 h-4 mr-2" />
                      {lang === 'kn'
                        ? 'ಭಾಗ 4 ಅನ್ನು ಉಳಿಸಿ'
                        : lang === 'ta'
                          ? 'பகுதி 4ஐ சேமிக்கவும்'
                          : 'Save Section 4'}
                    </>
                  )}
                </Button>
              </CardContent>
            </Card>
          )}

          {currentSection === 'section5' && (
            <Card className="border-0 shadow-lg mb-4">
              <CardHeader className="bg-gradient-to-r from-teal-50 to-cyan-50">
                <CardTitle className="text-xl text-teal-800">
                  {lang === 'kn'
                    ? 'ಭಾಗ 5: ಭವಿಷ್ಯ ಮತ್ತು ಚಿಂತನೆ'
                    : lang === 'ta'
                      ? 'பகுதி 5: எதிர்காலம் மற்றும் சிந்தனை'
                      : 'Section 5: Future & Reflection'}
                </CardTitle>
              </CardHeader>
              <CardContent className="p-6 space-y-6">
                <div>
                  <label className="block text-sm font-medium text-gray-700 mb-2 flex items-center gap-2">
                    {qLabel(17, '17. How will the things you learned in school help you achieve your dreams and aspirations? Explain.')}
                    <Tooltip>
                      <TooltipTrigger asChild>
                        <button type="button" className="text-teal-700 hover:text-teal-800">💬</button>
                      </TooltipTrigger>
                      <TooltipContent>
                        {getHelpText(17, 'Explain how school learning connects to your future goals. Example: "Learning Science will help me become a doctor, which is my dream."')}
                      </TooltipContent>
                    </Tooltip>
                  </label>
                  <Textarea
                    placeholder={getHelpText(17, 'Example: Learning Mathematics and Science will help me become an engineer. English will help me communicate better...')}
                    value={responses.section5.question17}
                    onChange={(e) => handleResponseChange('section5', 'question17', e.target.value)}
                    rows={3}
                    readOnly={isReadOnly}
                    className="border-teal-200 focus:border-teal-400"
                  />
                </div>

                <div>
                  <label className="block text-sm font-medium text-gray-700 mb-2 flex items-center gap-2">
                    {qLabel(18, '18. What is the one thing you would like to change in your school? Give reasons.')}
                    <Tooltip>
                      <TooltipTrigger asChild>
                        <button type="button" className="text-teal-700 hover:text-teal-800">💬</button>
                      </TooltipTrigger>
                      <TooltipContent>
                        {getHelpText(18, 'Write what you wish could be better. Example: "I wish we had a bigger library with more books to read."')}
                      </TooltipContent>
                    </Tooltip>
                  </label>
                  <Textarea
                    placeholder={getHelpText(18, 'Example: I would like to have a bigger playground and more sports equipment so we can play better...')}
                    value={responses.section5.question18}
                    onChange={(e) => handleResponseChange('section5', 'question18', e.target.value)}
                    rows={3}
                    readOnly={isReadOnly}
                    className="border-teal-200 focus:border-teal-400"
                  />
                </div>

                <div>
                  <label className="block text-sm font-medium text-gray-700 mb-2 flex items-center gap-2">
                    {qLabel(19, '19. Do you have a separate place to practice? Explain why it is necessary.')}
                    <Tooltip>
                      <TooltipTrigger asChild>
                        <button type="button" className="text-teal-700 hover:text-teal-800">💬</button>
                      </TooltipTrigger>
                      <TooltipContent>
                        {getHelpText(19, 'Write about where you study at home and why it\'s important. Example: "I have a small table in my room where I study. It\'s quiet and helps me focus."')}
                      </TooltipContent>
                    </Tooltip>
                  </label>
                  <Textarea
                    placeholder={getHelpText(19, 'Example: Yes, I have a small study table in my room. It\'s necessary because it\'s quiet and I can focus better there...')}
                    value={responses.section5.question19}
                    onChange={(e) => handleResponseChange('section5', 'question19', e.target.value)}
                    rows={3}
                    readOnly={isReadOnly}
                    className="border-teal-200 focus:border-teal-400"
                  />
                </div>

                <div>
                  <label className="block text-sm font-medium text-gray-700 mb-2 flex items-center gap-2">
                    {qLabel(20, "20. Does school play an important role in your life's learning process? Write your opinion.")}
                    <Tooltip>
                      <TooltipTrigger asChild>
                        <button type="button" className="text-teal-700 hover:text-teal-800">💬</button>
                      </TooltipTrigger>
                      <TooltipContent>
                        {getHelpText(20, 'Say if school is important for you and why. Example: "Yes, school is very important because I learn new things every day and teachers guide me."')}
                      </TooltipContent>
                    </Tooltip>
                  </label>
                  <Textarea
                    placeholder={getHelpText(20, 'Example: Yes, school is very important for me because I learn new things, meet friends, and teachers help me understand difficult topics...')}
                    value={responses.section5.question20}
                    onChange={(e) => handleResponseChange('section5', 'question20', e.target.value)}
                    rows={3}
                    readOnly={isReadOnly}
                    className="border-teal-200 focus:border-teal-400"
                  />
                </div>

                <div>
                  <label className="block text-sm font-medium text-gray-700 mb-2 flex items-center gap-2">
                    {qLabel(21, '21. Do you like talking to your parents about school activities and your learnings? What topics do you discuss with them?')}
                    <Tooltip>
                      <TooltipTrigger asChild>
                        <button type="button" className="text-teal-700 hover:text-teal-800">💬</button>
                      </TooltipTrigger>
                      <TooltipContent>
                        {getHelpText(21, 'Write if you talk to parents about school and what you discuss. Example: "Yes, I tell my parents about my test results, friends, and what I learned in class."')}
                      </TooltipContent>
                    </Tooltip>
                  </label>
                  <Textarea
                    placeholder={getHelpText(21, 'Example: Yes, I like talking to my parents about school. I tell them about my test results, friends, and what I learned in class...')}
                    value={responses.section5.question21}
                    onChange={(e) => handleResponseChange('section5', 'question21', e.target.value)}
                    rows={3}
                    readOnly={isReadOnly}
                    className="border-teal-200 focus:border-teal-400"
                  />
                </div>

                <Button
                  onClick={() => saveSection('section5')}
                  disabled={savingSection === 'section5' || isReadOnly}
                  className="w-full bg-teal-600 hover:bg-teal-700"
                >
                  {savingSection === 'section5' ? (
                    <>Saving...</>
                  ) : (
                    <>
                      <Save className="w-4 h-4 mr-2" />
                      {lang === 'kn'
                        ? 'ಭಾಗ 5ವನ್ನು ಉಳಿಸಿ'
                        : lang === 'ta'
                          ? 'பகுதி 5ஐ சேமிக்கவும்'
                          : 'Save Section 5'}
                    </>
                  )}
                </Button>
              </CardContent>
            </Card>
          )}

          {currentSection === 'section5' && (
            <div className="flex flex-col items-end gap-2 mt-6">
              {!canSubmit() && (
                <p className="text-sm text-gray-600">
                  Please complete all sections before submitting.
                </p>
              )}
              <Button
                onClick={submitAssessment}
                disabled={!canSubmit() || submitting || isReadOnly}
                className={`${
                  canSubmit() && !submitting && !isReadOnly
                    ? 'bg-green-600 hover:bg-green-700'
                    : 'bg-gray-400 cursor-not-allowed'
                }`}
              >
                {submitting ? (
                  <>
                    <div className="animate-spin rounded-full h-4 w-4 border-b-2 border-white mr-2"></div>
                    {lang === 'kn'
                      ? 'ಸಲ್ಲಿಸುತ್ತಿದೆ...'
                      : lang === 'ta'
                        ? 'சமர்ப்பித்து கொண்டிருக்கிறது...'
                        : 'Submitting...'}
                  </>
                ) : (
                  <>
                    <School className="w-4 h-4 mr-2" />
                    {lang === 'kn'
                      ? 'ಮೌಲ್ಯಮಾಪನವನ್ನು ಸಲ್ಲಿಸಿ'
                      : lang === 'ta'
                        ? 'மதிப்பீட்டை சமர்ப்பிக்கவும்'
                        : 'Submit Assessment'}
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

