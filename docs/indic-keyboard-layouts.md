# Indic Keyboard Layouts — Character Reference

Used by `src/components/ui/IndicKeyboard.tsx`. Each layout follows the same
row structure: vowels, vowel-marks/signs, consonant rows, numbers.

---

## Kannada (kn) — Unicode U+0C80–U+0CFF

| Row | Characters | Count |
|-----|-----------|-------|
| vowels | ಅ ಆ ಇ ಈ ಉ ಊ ಋ ಎ ಏ ಐ ಒ ಓ ಔ | 13 |
| row1 (vowel signs + virama) | ಾ ಿ ೀ ು ೂ ೃ ೆ ೇ ೈ ೊ ೋ ೌ ್ | 13 |
| row2 (consonants) | ಕ ಖ ಗ ಘ ಙ ಚ ಛ ಜ ಝ ಞ | 10 |
| row3 (consonants) | ಟ ಠ ಡ ಢ ಣ ತ ಥ ದ ಧ ನ | 10 |
| row4 (consonants) | ಪ ಫ ಬ ಭ ಮ ಯ ರ ಲ ವ | 9 |
| row5 (consonants) | ಶ ಷ ಸ ಹ ಳ ೞ ಱ | 7 |
| numbers | ೦ ೧ ೨ ೩ ೪ ೫ ೬ ೭ ೮ ೯ | 10 |

**Total: 72 characters**

---

## Tamil (ta) — Unicode U+0B80–U+0BFF

| Row | Characters | Count |
|-----|-----------|-------|
| vowels | அ ஆ இ ஈ உ ஊ எ ஏ ஐ ஒ ஓ ஔ | 12 |
| row1 (vowel signs + pulli) | ா ி ீ ு ூ ெ ே ை ொ ோ ௌ ் ஃ | 13 |
| row2 (core consonants) | க ங ச ஞ ட ண த ந ப ம | 10 |
| row3 (consonants) | ய ர ல வ ழ ள ற ன | 8 |
| row4 (loanword consonants) | ஜ ஷ ஸ ஹ | 4 |
| row5 (special) | ௐ | 1 |
| numbers | (hidden — uses standard digits) | 0 |

**Total: 48 characters**

---

## Hindi / Devanagari (hi) — Unicode U+0900–U+097F

| Row | Characters | Count |
|-----|-----------|-------|
| vowels | अ आ इ ई उ ऊ ऋ ए ऐ ओ औ अं अः | 13 |
| row1 (vowel signs + virama) | ा ि ी ु ू ृ े ै ो ौ ं ः ँ ् | 14 |
| row2 (consonants) | क ख ग घ ङ च छ ज झ ञ | 10 |
| row3 (consonants) | ट ठ ड ढ ण त थ द ध न | 10 |
| row4 (consonants) | प फ ब भ म य र ल व | 9 |
| row5 (consonants) | श ष स ह | 4 |
| row6 (special) | ॐ | 1 |
| numbers | ० १ २ ३ ४ ५ ६ ७ ८ ९ | 10 |

**Total: 71 characters**

---

## Notes

- All three keyboards share the same UI grid in `IndicKeyboard.tsx`.
- Hindi vowels "अं" and "अः" are multi-codepoint sequences (base + combining mark).
- Empty rows (`[]`) are valid — the UI renders nothing for them.
- The `numbers` row is hidden for Tamil to save vertical space.
- Maximum height is `40vh` with `overflowY: auto` for small screens.
