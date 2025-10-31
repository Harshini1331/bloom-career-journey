/*
  Script: seed_translations.ts
  - Reads English assessment content (questions/help) via existing RPCs/tables
  - Translates EN -> KN using Google Translate API
  - Upserts rows into public.content_translations

  Required env:
    SUPABASE_URL
    SUPABASE_SERVICE_ROLE (recommended) or VITE_SUPABASE_ANON_KEY (if RLS allows)
    GOOGLE_TRANSLATE_API_KEY
*/

import 'dotenv/config';
import { createClient } from '@supabase/supabase-js';

const SUPABASE_URL = process.env.SUPABASE_URL || process.env.VITE_SUPABASE_URL;
const SUPABASE_KEY = process.env.SUPABASE_SERVICE_ROLE || process.env.VITE_SUPABASE_ANON_KEY;
const GOOGLE_TRANSLATE_API_KEY = process.env.GOOGLE_TRANSLATE_API_KEY;

if (!SUPABASE_URL || !SUPABASE_KEY) {
  console.error('Missing SUPABASE_URL or SUPABASE key. Please set SUPABASE_URL and SUPABASE_SERVICE_ROLE.');
  process.exit(1);
}
if (!GOOGLE_TRANSLATE_API_KEY) {
  console.error('Missing GOOGLE_TRANSLATE_API_KEY');
  process.exit(1);
}

// Warn if key is not service_role (RLS will block upserts)
try {
  const parts = (SUPABASE_KEY || '').split('.');
  if (parts.length >= 2) {
    const payload = JSON.parse(Buffer.from(parts[1], 'base64').toString('utf8')) as any;
    if (payload?.role !== 'service_role') {
      console.warn('WARNING: Using a non-service role key (role=' + String(payload?.role) + '). Upserts may fail due to RLS.');
    }
  }
} catch {}

const supabase = createClient(SUPABASE_URL, SUPABASE_KEY);

type TranslationItem = {
  resource_type: string;
  resource_key: string;
  text: string; // english source
};

async function translateBatch(texts: string[], target = 'kn', source = 'en'): Promise<string[]> {
  if (texts.length === 0) return [];
  // Google Translate v2 endpoint
  const url = `https://translation.googleapis.com/language/translate/v2?key=${encodeURIComponent(GOOGLE_TRANSLATE_API_KEY!)}`;
  const body = { q: texts, target, source, format: 'text' } as any;
  const res = await fetch(url, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify(body),
  });
  if (!res.ok) {
    const msg = await res.text();
    throw new Error(`Translate API error: ${res.status} ${msg}`);
  }
  const data = await res.json();
  const trans = (data?.data?.translations || []) as Array<{ translatedText: string }>;
  return trans.map(t => t.translatedText || '');
}

async function rateLimited<T>(items: T[], batchSize: number, delayMs: number, fn: (batch: T[]) => Promise<void>) {
  for (let i = 0; i < items.length; i += batchSize) {
    const batch = items.slice(i, i + batchSize);
    await fn(batch);
    if (i + batchSize < items.length) await new Promise(r => setTimeout(r, delayMs));
  }
}

async function fetchEnglishContent(): Promise<TranslationItem[]> {
  const items: TranslationItem[] = [];

  // Inspiration: help and question texts via RPC get_inspiration_questions
  try {
    const { data } = await supabase.rpc('get_inspiration_questions');
    if (Array.isArray(data)) {
      data.forEach((row: any, idx: number) => {
        const key = `question${idx + 1}`;
        if (row?.help_text) items.push({ resource_type: 'inspiration_help', resource_key: key, text: String(row.help_text) });
        if (row?.question_text) items.push({ resource_type: 'inspiration_question', resource_key: key, text: String(row.question_text) });
      });
    }
  } catch (e) {
    console.warn('Skipping inspiration RPC fetch:', e);
  }

  // About Me: fields via RPC get_about_me_fields
  try {
    const { data } = await supabase.rpc('get_about_me_fields');
    if (Array.isArray(data)) {
      data.forEach((row: any) => {
        const fieldKey = String(row.field_key || row.key || row.id || '');
        if (!fieldKey) return;
        if (row?.question_text) items.push({ resource_type: 'about_me_question', resource_key: fieldKey, text: String(row.question_text) });
        if (row?.help_text) items.push({ resource_type: 'about_me_help', resource_key: fieldKey, text: String(row.help_text) });
      });
    }
  } catch (e) {
    console.warn('Skipping about_me RPC fetch:', e);
  }

  return items;
}

async function upsertTranslations(items: TranslationItem[], lang: 'kn' | 'en' = 'kn') {
  await rateLimited(items, 20, 500, async (batch) => {
    const translated = await translateBatch(batch.map(b => b.text), lang, 'en');
    const rows = batch.map((b, i) => ({
      resource_type: b.resource_type,
      resource_key: b.resource_key,
      lang,
      text: translated[i] || '',
      updated_at: new Date().toISOString(),
    }));
    const { error } = await supabase.from('content_translations').upsert(rows, { onConflict: 'resource_type,resource_key,lang' } as any);
    if (error) throw error;
  });
}

async function main() {
  console.log('Starting translation seed...');
  let cleared = 0;
  try {
    const { data } = await supabase.rpc('refresh_translations', { p_lang: 'kn' } as any);
    cleared = (data as any) ?? 0;
  } catch (e) {
    // If function missing or RLS denies, proceed without clearing
    cleared = 0;
  }
  console.log('Cleared KN rows:', cleared);

  const items = await fetchEnglishContent();
  console.log('Found English items:', items.length);
  if (items.length === 0) {
    console.log('No items found to translate. Exiting.');
    return;
  }

  await upsertTranslations(items, 'kn');
  console.log('Translations upserted successfully.');
}

main().catch((e) => {
  console.error('Translation seed failed:', e);
  process.exit(1);
});


