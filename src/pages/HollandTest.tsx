import React from 'react';
import { useToast } from '@/hooks/use-toast';
import { useLang } from '@/hooks/useLang';
import HollandCodeTest from '@/components/HollandCodeTest';
import { Button } from '@/components/ui/button';
import { useNavigate } from 'react-router-dom';
import { ArrowLeft } from 'lucide-react';

export default function HollandTest() {
  const { toast } = useToast();
  const { t, lang } = useLang();
  const navigate = useNavigate();
  return (
    <div className="min-h-screen bg-gradient-to-br from-blue-50 via-white to-indigo-50 py-8" lang={lang} dir="auto">
      <div className="container mx-auto px-4">
        {/* Header with Back Button - matching assessment pages */}
        <div className="flex items-center justify-between mb-8">
          <Button
            variant="ghost"
            onClick={() => navigate(`/student?lang=${lang}`)}
            className="text-blue-600 hover:text-blue-700 hover:bg-blue-50"
          >
            <ArrowLeft className="w-4 h-4 mr-2" />
            {lang === 'kn' ? 'ಡ್ಯಾಶ್‌ಬೋರ್ಡ್‌ಗೆ ಹಿಂತಿರುಗಿ' : 'Back to Dashboard'}
          </Button>
          <div className="text-center flex-1">
            <h1 className="text-3xl font-bold text-blue-800 mb-2">
              {lang === 'kn' ? '🧭 ಮಾನಸಿಕ ಪರೀಕ್ಷೆಗಳು – ಹಾಲೆಂಡ್ ಕೋಡ್ ಅಸೆಸ್ಮೆಂಟ್' : '🧭 Psychometric Tests – Holland Code Assessment'}
            </h1>
            <p className="text-blue-600 text-lg">
              {lang === 'kn' ? 'ನಿಮ್ಮ ಹಾಲೆಂಡ್ ಕೋಡ್ ಪ್ರೊಫೈಲ್ ಅನ್ನು ಕಂಡುಹಿಡಿಯಲು ಎಲ್ಲಾ ಪ್ರಶ್ನೆಗಳಿಗೆ ಪ್ರಾಮಾಣಿಕವಾಗಿ ಉತ್ತರಿಸಿ.' : 'Answer all questions honestly to discover your Holland Code profile.'}
            </p>
            <p className="text-gray-600 mt-2">
              {lang === 'kn' ? 'ನಿಮ್ಮ RIASEC ಪ್ರಕಾರವನ್ನು ಬಹಿರಂಗಪಡಿಸಲು ಪ್ರತಿ ಗುಂಪಿನಲ್ಲಿ ನೀವು ಆನಂದಿಸುವ ಚಟುವಟಿಕೆಗಳನ್ನು ಆಯ್ಕೆಮಾಡಿ.' : 'Select activities you enjoy across each group to reveal your RIASEC type.'}
            </p>
          </div>
          <div className="w-20"></div>
        </div>
        <HollandCodeTest onCompleted={(code)=> toast({ 
          title: lang === 'kn' ? 'ಹಾಲೆಂಡ್ ಕೋಡ್ ಉಳಿಸಲಾಗಿದೆ' : 'Holland Code Saved', 
          description: lang === 'kn' ? `ನಿಮ್ಮ ಕೋಡ್: ${code}` : `Your code: ${code}` 
        })} />
      </div>
    </div>
  );
}


