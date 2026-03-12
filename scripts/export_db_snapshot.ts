import { createClient } from '@supabase/supabase-js';
import dotenv from 'dotenv';
import path from 'path';
import fs from 'fs';

// Load env vars
const envPath = path.resolve(process.cwd(), '.env');
const envLocalPath = path.resolve(process.cwd(), '.env.local');

if (fs.existsSync(envPath)) {
    dotenv.config({ path: envPath });
}
if (fs.existsSync(envLocalPath)) {
    dotenv.config({ path: envLocalPath, override: true });
}

const supabaseUrl = process.env.VITE_SUPABASE_URL;
const serviceRoleKey = process.env.SUPABASE_SERVICE_ROLE_KEY;

if (!supabaseUrl || !serviceRoleKey) {
    console.error('Missing required env vars:');
    if (!supabaseUrl) console.error('  - VITE_SUPABASE_URL');
    if (!serviceRoleKey) console.error('  - SUPABASE_SERVICE_ROLE_KEY');
    console.error('Ensure these are set in .env.local');
    process.exit(1);
}

const supabase = createClient(supabaseUrl, serviceRoleKey);

async function exportSnapshot() {
    const today = new Date().toISOString().split('T')[0];
    const outputPath = path.resolve(process.cwd(), `scripts/db_backup_${today}.json`);

    console.log('Exporting database snapshot...\n');

    // 1. assessment_summary_templates
    const { data: templates, error: templatesErr } = await supabase
        .from('assessment_summary_templates')
        .select('*');

    if (templatesErr) {
        console.error('Error fetching assessment_summary_templates:', templatesErr.message);
        process.exit(1);
    }

    // 2. content_translations
    const { data: translations, error: translationsErr } = await supabase
        .from('content_translations')
        .select('*');

    if (translationsErr) {
        console.error('Error fetching content_translations:', translationsErr.message);
        process.exit(1);
    }

    // 3. school_learning_option (may not exist)
    let schoolLearningOptions: any[] | null = null;
    let schoolLearningSkipped = false;

    const { data: slOptions, error: slErr } = await supabase
        .from('school_learning_option')
        .select('*');

    if (slErr) {
        if (slErr.code === '42P01' || slErr.message.includes('does not exist') || slErr.message.includes('relation') || slErr.message.includes('Could not find')) {
            schoolLearningSkipped = true;
            console.log('⚠ school_learning_option table does not exist — skipped\n');
        } else {
            console.error('Error fetching school_learning_option:', slErr.message);
            process.exit(1);
        }
    } else {
        schoolLearningOptions = slOptions;
    }

    // Build snapshot
    const snapshot = {
        exported_at: new Date().toISOString(),
        tables: {
            assessment_summary_templates: templates || [],
            content_translations: translations || [],
            school_learning_option: schoolLearningSkipped ? 'TABLE_NOT_FOUND' : (schoolLearningOptions || []),
        },
    };

    const json = JSON.stringify(snapshot, null, 2);
    fs.writeFileSync(outputPath, json, 'utf-8');

    // Summary
    const fileSizeBytes = fs.statSync(outputPath).size;
    const fileSizeKB = (fileSizeBytes / 1024).toFixed(1);

    console.log('=== Export Summary ===');
    console.log(`  assessment_summary_templates: ${(templates || []).length} rows`);
    console.log(`  content_translations:         ${(translations || []).length} rows`);
    if (schoolLearningSkipped) {
        console.log(`  school_learning_option:       SKIPPED (table not found)`);
    } else {
        console.log(`  school_learning_option:       ${(schoolLearningOptions || []).length} rows`);
    }
    console.log(`\n  File: ${outputPath}`);
    console.log(`  Size: ${fileSizeKB} KB (${fileSizeBytes} bytes)`);
    console.log('\nBackup complete.');
}

exportSnapshot();
