import React, { useMemo } from 'react';
import { Card, CardContent, CardHeader, CardTitle } from '@/components/ui/card';
import { Button } from '@/components/ui/button';
import { useNavigate } from 'react-router-dom';
import { useLang } from '@/hooks/useLang';

// Attempt to discover career card images at build time.
// Preferred: public/career_cards (accessible at /career_cards/<file>)
// Fallback: src/assets/career_cards
const publicImages = import.meta.glob('/career_cards/*.{png,jpg,jpeg,webp,svg}', {
  eager: true,
  query: '?url',
  import: 'default'
}) as Record<string, string>;

const srcImages = import.meta.glob('/src/assets/career_cards/*.{png,jpg,jpeg,webp,svg}', {
  eager: true,
  query: '?url',
  import: 'default'
}) as Record<string, string>;

// Additional fallback: src/career_cards (as provided by your project structure)
const srcRootImages = import.meta.glob('/src/career_cards/*.{png,jpg,jpeg,webp,svg}', {
  eager: true,
  query: '?url',
  import: 'default'
}) as Record<string, string>;

type SpotlightProps = {
  title?: string;
};

export default function CareerSpotlight({ title = 'Career Spotlight' }: SpotlightProps) {
  const navigate = useNavigate();
  const { t, lang } = useLang();

  const allImages = useMemo(() => {
    const pub = Object.values(publicImages);
    if (pub.length > 0) return pub;
    const srcA = Object.values(srcImages);
    if (srcA.length > 0) return srcA;
    return Object.values(srcRootImages);
  }, []);

  const pickDaily = useMemo(() => {
    if (allImages.length === 0) return null;
    const daySeed = new Date().toISOString().slice(0, 10); // YYYY-MM-DD
    let hash = 0;
    for (let i = 0; i < daySeed.length; i++) hash = (hash * 31 + daySeed.charCodeAt(i)) >>> 0;
    const index = hash % allImages.length;
    return allImages[index];
  }, [allImages]);

  const displayTitle = title === 'Career Spotlight' 
    ? (lang === 'kn' ? 'ವೃತ್ತಿ ಸ್ಪಾಟ್ಲೈಟ್' : 'Career Spotlight')
    : title;

  return (
    <Card className="border-0 shadow-lg" lang={lang} dir="auto">
      <CardHeader>
        <CardTitle className="text-xl text-gray-800">{displayTitle}</CardTitle>
      </CardHeader>
      <CardContent>
        {pickDaily ? (
          <div>
            <div className="rounded-lg overflow-hidden border bg-white">
              <img
                src={pickDaily}
                alt={lang === 'kn' ? 'ವೃತ್ತಿ ಕಾರ್ಡ್' : 'Career card'}
                className="w-full h-auto object-cover"
                loading="lazy"
              />
            </div>
            <div className="mt-3 flex justify-between items-center">
              <span className="text-sm text-gray-600">
                {lang === 'kn' ? 'ಪ್ರತಿದಿನ ಹೊಸ ಸ್ಪಾಟ್ಲೈಟ್' : 'New spotlight each day'}
              </span>
              <Button size="sm" className="bg-blue-600 hover:bg-blue-700" onClick={() => navigate('/careers')}>
                {lang === 'kn' ? 'ಎಲ್ಲಾ ವೃತ್ತಿಗಳನ್ನು ಅನ್ವೇಷಿಸಿ' : 'Explore all careers'}
              </Button>
            </div>
          </div>
        ) : (
          <div className="text-center py-6">
            <div className="text-sm text-gray-600 mb-3">
              {lang === 'kn' 
                ? 'ವೃತ್ತಿ ಕಾರ್ಡ್‌ಗಳು ಕಂಡುಬಂದಿಲ್ಲ.'
                : 'Career cards not found in public/career_cards, src/assets/career_cards, or src/career_cards.'
              }
            </div>
            <Button size="sm" variant="outline" onClick={() => navigate('/careers')}>
              {lang === 'kn' ? 'ಎಲ್ಲಾ ವೃತ್ತಿಗಳನ್ನು ಅನ್ವೇಷಿಸಿ' : 'Explore all careers'}
            </Button>
          </div>
        )}
      </CardContent>
    </Card>
  );
}


