# CLAUDE.md — Bloom Career Journey: Project Context & Memory

## 1. Project Overview

**Bloom Career Journey** is a career guidance and self-assessment platform for rural Indian students (grades 8–12), built by the India Literacy Project (ILP). Combines structured self-reflection exercises with AI-powered summarization and teacher-guided mentoring.

### Target Users
| Role | Description |
|------|-------------|
| **Students** | Rural students (grades 8–12) completing self-assessment modules, recording voice responses, building a career portfolio |
| **Teachers** | Review AI-generated summaries, approve/reject/edit them, manage student groups, view roadmaps/interests |
| **Admins** | Manage users, schools/states, assessment content, system configuration |

### Regional/Language Context
- Supports **English (`en`)**, **Kannada (`kn`)**, **Tamil (`ta`)**, **Hindi (`hi`)**; Unicode detection (Kannada: `0C80–0CFF`, Tamil: `0B80–0BFF`, Hindi: `0900–097F`)
- **IndicKeyboard** (`IndicKeyboard.tsx`): Kannada/Tamil/Hindi virtual keyboard layouts, scroll compensation, enlarged touch targets, haptic feedback; STT optimized for Indian accents

---

## 2. Tech Stack

### Core
| Layer | Technology |
|-------|-----------|
| Frontend | React 18, TypeScript 5.8 |
| Build | Vite 5 (SWC plugin) |
| Styling | Tailwind CSS 3.4 + `tailwindcss-animate` + `@tailwindcss/typography` |
| UI Components | shadcn/ui (Radix UI primitives) |
| Backend & DB | Supabase (Auth, PostgreSQL, Storage, RPC, RLS) |
| AI Summaries | Google Gemini API (2.0 Flash / lite fallback) |
| AI Chatbot | Google Gemini API ("Vidya Saathi" persona) |
| Speech-to-Text | Google Cloud → Azure → Gemini 1.5 Flash (cascading fallback) |
| Streaming STT | Sarvam API via WebSocket proxy (`server/proxy_server.py`) |
| Routing | React Router DOM 6 |
| State/Data | TanStack React Query 5 |
| Forms | React Hook Form + Zod |

### Key Libraries
`recharts`, `sonner`, `lucide-react`, `date-fns`, `embla-carousel-react`, `IndicKeyboard` (replaced `simple-keyboard`), `react-resizable-panels`, `cmdk`, `vaul`, `class-variance-authority` + `clsx` + `tailwind-merge`

---

## 3. Project Structure
```
bloom-career-journey/
├── src/
│   ├── App.tsx                    # Root component, all routes
│   ├── main.tsx                   # Entry point
│   ├── components/
│   │   ├── assessments/           # 8 assessment components + DB variants + SummaryViewDialog
│   │   ├── teacher/               # Header, StatsCards, StudentsTab, StudentModals, teacherStrings
│   │   ├── student/               # Header, AssessmentGrid, ProgressSection (unused), CareerChatSection, studentStrings
│   │   ├── chat/                  # Chat UI components
│   │   ├── ui/                    # 53 shadcn/ui components
│   │   ├── ProtectedRoute.tsx     # Role-based route guard
│   │   ├── HollandCodeTest.tsx / ChatbotDialog.tsx / NotificationBell.tsx
│   │   ├── ProfileDialog.tsx      # User profile editor (includes language change)
│   │   ├── LanguageSelectionDialog.tsx / ImportStudentsDialog.tsx / ResourceManager.tsx
│   ├── pages/
│   │   ├── Index.tsx / AuthPage.tsx / AdminDashboard.tsx / HollandTest.tsx / CareersExplore.tsx
│   │   ├── StudentDashboard.tsx   # Student home (orchestrator, summary dialog, deep-link support)
│   │   ├── TeacherDashboard.tsx   # Teacher home (thin orchestrator)
│   │   ├── ProfileCardPage.tsx    # My Career Compass — profile card with approval workflow
│   │   ├── CareerRoadmapPage.tsx  # Career Roadmap — milestone-based career tracker
│   │   ├── ThingsInterestMePage.tsx # Things that Interest Me — editable interests table
│   │   ├── TeacherStudentRoadmapPage.tsx  # Teacher read-only view of student roadmap
│   │   ├── TeacherStudentInterestsPage.tsx # Teacher read-only view of student interests
│   │   └── StudentSummary.tsx     # Teacher view of student summaries
│   ├── services/
│   │   ├── aiSummaryService.ts    # AI summary generation + profile card keyword extraction
│   │   ├── aiChatService.ts / speechToTextService.ts / sarvamStreamingService.ts
│   │   ├── assessmentService.ts   # Assessment templates & media via Supabase RPCs
│   │   ├── summaryDatabaseService.ts / notificationService.ts
│   │   ├── audioResponseManager.ts / supabaseUploadService.ts / transcriptCleanupService.ts
│   │   └── translationService.ts
│   ├── lib/logger.ts              # Centralized logger (dev-only, `import.meta.env.DEV`)
│   ├── hooks/
│   │   ├── useAuth.tsx            # Auth context: signIn, signUp, signOut, userProfile
│   │   ├── useLang.tsx            # i18n context: language + translation
│   │   ├── useIndicKeyboard.ts / use-toast.tsx / use-mobile.tsx
│   ├── integrations/supabase/client.ts + types.ts
│   ├── types/assessmentSummary.ts # Summary types + approval workflow types
│   └── utils/
│       ├── assessmentUnlock.ts    # Sequential unlock logic (currently bypassed)
│       └── summaryParsers.ts / databaseValidator.ts / errorHandler.ts / driveLinks.ts
├── server/proxy_server.py         # FastAPI WebSocket proxy for Sarvam STT
├── supabase/migrations/           # 150+ SQL migration files (Jan 2025–Apr 2026)
├── scripts/                       # seed_test_data, generate_test_answers, cleanup_test_data,
│                                  # parse_excel_questions, sync_questions (pending),
│                                  # generate_migration, dump_sheets, test_upsert
├── docs/                          # E2E_test_report, manual_test_checklist, google-sheets-setup, test-screenshots/
├── .claude/commands/              # migrate, seed, ship, sync-sheet, test-plan, wrap-up
└── vercel.json / components.json
```

**Organization**: Hybrid layer-based + feature-based. Top-level by layer (`pages/`, `components/`, `services/`, `hooks/`, `utils/`); feature subdirs: `assessments/`, `teacher/`, `chat/`, `ui/`.

---

## 4. Core Features & Modules

### Assessment Modules

| # | Assessment | Type Key | Component |
|---|-----------|----------|-----------|
| 1 | My Inspiration | `inspiration` | `MyInspirationAssessment.tsx` |
| 2 | About Me | `about_me` | `AboutMeAssessment.tsx` |
| 3 | My Dreams | `dreams` | `MyDreamsAssessment.tsx` |
| 4 | My School, My Learning and I | `school_learning` | `MySchoolLearningAssessment.tsx` |
| 5 | My Talents and Hobbies | `hobbies` | `MyHobbiesAssessment.tsx` |
| 6 | My Role Models | `role_models` | `MyRoleModelsAssessment.tsx` |
| 7 | Holland Code (RIASEC) | `personality` | `HollandCodeAssessment.tsx` |
| 8 | Career Guidance Tools | `career_guidance_tools` | `CareerGuidanceToolsAssessment.tsx` |

Each has a companion `*DB.tsx` for DB ops. Responses saved as JSON in `assessment_responses.responses`.

**Flow**: Student answers → `assessment_responses` → AI summary → `assessment_summaries` → teacher notified → reviews/approves → student views approved summary.

**Summary tab**: Locked until all core questions answered (`areCoreSectionsComplete()`). Unlocks progressively per section.

### AI Summary System (`aiSummaryService.ts`)
- Gemini primary: `gemini-2.0-flash`, fallback: `gemini-2.0-flash-lite`
- `BASE_SYSTEM_PROMPT`: shared constant for all 12 prompt builders (standardized counsellor instructions, 2-3 sentence limits)
- Per-assessment `generate*Summary()` (6 × primary + fallback); profile card: `generateProfileCardKeywords()` + `generateCareerDirection()`
- Templates from `summary_templates` table (cached); hardcoded fallback
- `detectLanguage()` scans Unicode ranges → `en`/`kn`/`ta`/`hi`; `SummaryTemplate` supports `en`, `kn?`, `ta?`, `hi?`
- All 6 assessments have Hindi `languageInstruction` blocks; Role Models prompt reads questions from DB
- Storage priority: student edits > teacher edits > AI original

### Teacher Approval Workflow
- Approve/reject/edit/request-revision via `SummaryApprovalCard.tsx`
- Statuses: `pending_approval` → `approved` | `rejected` | `revision_requested`
- Language-aware notifications on approval (fetches `preferred_language` from `users` via `create_notification_secure` RPC)
- `AISummaryReview.tsx` passes student's `preferred_language` to AI generators (not just `detectLanguage`)

### Audio / Voice Features
- **Batch STT** (`speechToTextService.ts`): Google Cloud → Azure → Gemini; supports `en-IN`, `hi-IN`, `kn-IN`, `ta-IN`
- **Streaming STT** (`sarvamStreamingService.ts`): Browser → WebSocket → FastAPI proxy → Sarvam API
- Offline queue (`audioResponseManager.ts`) + resumable chunked uploads (`supabaseUploadService.ts`) for poor connectivity
- **Lazy init**: mic permission on first record click only; localized denial messages (en/kn/ta/hi)

### AI Chatbot
`aiChatService.ts` + `ChatbotDialog.tsx`; "Vidya Saathi" persona; same Gemini cascade fallback as summaries.

### My Compass
- **Profile Card** (`/student/profile-card`): 6 module cards (always visible, never locked). Questions from `content_translations` (`resource_type: profile_card_{type}`); 2-3 word AI answers when complete. 7th card ("My Career Direction") synthesizes all 6. Cached in `profile_card_cache`. Teacher approval: keywords hidden until approved, reset to `pending` when student updates responses. Teacher review at `/teacher/student-profile-card/:studentId`.
- **Things that Interest Me** (`/student/things-interest-me`): Editable 4-col table (Subject, Lesson/Chapter, Why Factors, Compatible Career). Autosave 1s debounce. All 4 languages + IndicKeyboard. Backed by `things_that_interest_me` (RLS-protected). Post-assessment redirect with `?from={type}`.
- **Career Roadmap** (`/student/career-roadmap`): 7 milestones × 4 cols (Milestone + Plan A/B/C). Top 3 editable, bottom 4 locked. Autosave 1s debounce to `career_roadmap`. Midterm trigger: module 5.

---

## 5. Data Models / Schema

### Core Tables

#### `users`
| Column | Type |
|--------|------|
| id | uuid PK |
| role | enum: `admin`, `teacher`, `student` |
| full_name, email | text NOT NULL |
| mobile, state_id, school | nullable |
| preferred_language | CHECK: `en`, `kn`, `ta`, `hi` (default `en`) |
| bio, interests, career_goals, strengths, areas_for_growth, profile_picture_url, date_of_birth, gender, address | nullable |

#### `students`
| Column | Type |
|--------|------|
| id | uuid PK |
| user_id | FK → `users.id` |
| class_id | FK → `classes.id` |
| teacher_id | uuid NOT NULL |
| enrollment_status | `active`, `inactive`, `pending`, `graduated`, `transferred` |
| family_income_range, academic_performance, attendance_percentage | nullable |

#### `teachers`
| Column | Type |
|--------|------|
| id | uuid PK |
| user_id | FK → `users.id` |
| state_id | FK → `states.id` |
| specialization, qualification, experience_years | nullable |
| is_active | boolean default true |

#### `orgs` / `states` / `classes`
```
orgs (id, name) → states (id, state_name, org_id, state_code)
  → classes (id, name, state_id) / teachers (via state_id)
```

#### `assessment_responses`
| Column | Type |
|--------|------|
| id | uuid PK |
| student_id | FK → `students.id` |
| assessment_type | text NOT NULL |
| responses | jsonb NOT NULL |
| completed_at | timestamptz nullable (null = in progress) |
| review_status | `unreviewed`, `in_review`, `reviewed`, `needs_revision`, `flagged` |
| | **UNIQUE (student_id, assessment_type)** — ALWAYS use `.upsert()` |

#### `assessment_summaries`
| Column | Type |
|--------|------|
| id | uuid PK |
| assessment_response_id | FK → `assessment_responses.id` |
| ai_summary, teacher_edited_summary, student_edited_summary | jsonb |
| approval_status | `pending_approval`, `approved`, `rejected`, `revision_requested` |
| approved_by, rejected_by, rejection_reason | nullable |

#### `notifications`
| Column | Type |
|--------|------|
| id | uuid PK |
| user_id | FK → `users.id` |
| type | `summary_approved`, `teacher_message`, `assessment_submitted`, `system` |
| title, message, link | text |
| read_at | timestamptz nullable (null = unread) |

#### Compass Tables
- **`profile_card_cache`**: `(student_id, assessment_type)` unique; `keywords` jsonb `{question1: "2-3 words"}` per module, `{direction: "paragraph"}` for `career_direction`
- **`career_roadmap`**: `(student_id, milestone)` unique; `plan_a/b/c` text; milestones: `beginning_9th`, `end_9th`, `beginning_10th`, `midterm_10th`, `post_exam_10th`, `before_results_10th`, `final_decision`

#### Other Tables
- `chat_channels` / `chat_messages`: teacher–student messaging
- `counselling_activities` / `student_activity_progress`: structured activities with completion tracking
- `counselling_resources`: PDFs, videos, worksheets with download counts
- `student_notes`: teacher observations (types: observation/meeting/progress/concern/achievement/follow_up)
- `student_groups`: teacher-created groups within states/classes
- `summary_templates`: per-assessment Gemini prompt templates, multi-language
- `content_translations`: UI text by `resource_type`, `resource_key`, `lang`; includes `profile_card_{type}` entries (4 langs)
- `inspiration_sources`: video URLs; `lang` column for per-language sets (en/kn/ta/hi); filtered by `get_inspiration_videos(p_lang)`
- `things_that_interest_me`: `(student_id, row_order)` with `subject`, `lesson_chapter`, `why_factors`, `compatible_career`, `source_assessment`; RLS-protected

### Relationships
```
orgs →1:N→ states →1:N→ classes / teachers
users →1:1→ students / teachers
students →1:N→ assessment_responses →1:1→ assessment_summaries
users →1:N→ notifications
students + teachers → chat_channels →1:N→ chat_messages
```

---

## 6. Database Migrations

`supabase/migrations/`: 150+ files, Jan 2025–Apr 2026.

### Key Schema Notes
- **SQL Unicode rule**: All Kannada/Tamil/Hindi text in migrations must use PostgreSQL dollar-quoting (`$$...$$`)
- **assessment_responses unique**: `UNIQUE (student_id, assessment_type)` — all writes MUST use `.upsert({ onConflict: 'student_id,assessment_type' })`. RLS: 4 policies (`ar_select_student`, `ar_insert_student`, `ar_update_student`, `ar_select_teacher`) via `is_student_owned_by_auth()`
- **preferred_language**: CHECK constraint (not enum) — easier to add languages without migration complexity
- **users email**: `UNIQUE INDEX users_email_lower_unique ON users (LOWER(email))`; all emails normalized to lowercase on insert
- **summary RPC keys**: All 6 `get_*_summary_questions_i18n` RPCs use `'summary_question' || N` prefix (not `'question' || N`)
- **inspiration_sources**: `lang` column; `get_inspiration_videos(p_lang)` RPC; 3 videos × 4 languages (en/kn/ta/hi)
- **RLS on public tables (Apr 2026)**: 18 content/question tables have authenticated read-only policies; `SECURITY DEFINER` RPCs bypass RLS

---

## 7. Supabase Configuration

### Auth
- Email + password; `localStorage` session (`persistSession: true`, `autoRefreshToken: true`)
- Role stored in both `auth.users.user_metadata.role` and `public.users.role`

### Storage Buckets
| Bucket | Purpose |
|--------|---------|
| `audio-files` | Voice recordings (RLS-protected) |
| `avatars` | Profile pictures (RLS-protected) |

### Key RPC Functions
- `get_assessment_template(p_assessment_type)`, `get_inspiration_videos(p_lang)`, `get_assessment_media_sources(p_assessment_type)`
- `get_student_assessment_responses(teacher_user_id, filter?)`, `get_review_overview(teacher_user_id)`, `get_student_review_progress(teacher_user_id)`, `update_assessment_review(...)`
- `get_or_create_chat_channel(p_student_id, p_teacher_id)`, `create_notification_secure(p_user_id, p_type, p_title, p_message, p_link)`
- `get_all_assessment_templates()`, `update_assessment_template(...)`, `upsert_media_source(...)` — admin ops

### Environment Variables
| Variable | Purpose |
|----------|---------|
| `VITE_SUPABASE_URL` | Supabase project URL |
| `VITE_SUPABASE_ANON_KEY` | Supabase anon key |
| `VITE_GEMINI_API_KEY` | Gemini (AI summaries + chatbot) |
| `VITE_GOOGLE_SPEECH_API_KEY` | Google Cloud Speech-to-Text |
| `VITE_AZURE_SPEECH_KEY` / `VITE_AZURE_SPEECH_REGION` | Azure Speech fallback |
| `VITE_SARVAM_PROXY_URL` | Sarvam WS proxy (default: `ws://127.0.0.1:8000/ws/stream`) |
| `GOOGLE_SERVICE_ACCOUNT_JSON` / `GOOGLE_SHEET_ID` | Google Sheets API (sync-questions) |

---

## 8. API & Service Layer

**Pattern**: Frontend → Supabase directly. AI/ML via client-side `VITE_*` keys. Sarvam STT only server-mediated (Python proxy).

| Service | Key Methods |
|---------|-------------|
| `aiSummaryService.ts` | `generate*Summary()`, `detectLanguage()`, `generateProfileCardKeywords()`, `generateCareerDirection()` |
| `aiChatService.ts` | `sendMessage()`, `isConfigured()` |
| `speechToTextService.ts` | `transcribe()`, `transcribeAutoDetect()`, `transcribeLongRunningByUri()` |
| `sarvamStreamingService.ts` | `connect()`, `sendAudioChunk()`, `disconnect()` |
| `assessmentService.ts` | `getAssessmentTemplate()`, `getMediaSources()`, `getHollandCodeData()` |
| `summaryDatabaseService.ts` | `createAISummary()`, `approveSummary()`, `rejectSummary()`, `updateTeacherSummary()` |
| `notificationService.ts` | `getUnreadCount()`, `list()`, `markRead()`, `create()` |
| `audioResponseManager.ts` | `processAudioResponse()`, `syncOfflineQueue()` |
| `supabaseUploadService.ts` | `uploadFile()`, `queueUpload()`, `processQueue()` |

---

## 9. Auth & Role-Based Access

- **`ProtectedRoute.tsx`**: auth + role check; redirects to `/auth` or role dashboard
- Role routes: admin → `/admin`, teacher → `/teacher`, student → `/student`
- Compass routes: `/student/profile-card`, `/student/career-roadmap`, `/student/things-interest-me`, `/teacher/student-profile-card/:studentId`, `/teacher/student-roadmap/:studentId`, `/teacher/student-interests/:studentId`
- **RLS**: students own data only; teachers access their state's students; admins broader; RPCs use `SECURITY DEFINER` where needed

---

## 10. State Management

**Global providers** (`App.tsx`): `ErrorBoundary → Router → AuthProvider → LangProvider → Routes + Toaster`
- `AuthProvider` (`useAuth.tsx`): `user`, `session`, `signIn`, `signUp`, `signOut`, `userProfile`
- `LangProvider` (`useLang.tsx`): language state + translations; priority: URL param → `userProfile.preferred_language` → `localStorage.lang` → `'en'`
- Most data fetching: `useEffect` + direct Supabase calls (TanStack React Query available but underused)

---

## 11. Key Conventions & Patterns

| Element | Convention | Example |
|---------|-----------|---------|
| Components | PascalCase | `MyInspirationAssessment.tsx` |
| Services | camelCase singleton | `aiSummaryService` |
| Hooks | `use` prefix | `useAuth`, `useLang` |
| DB tables | snake_case | `assessment_responses` |
| Env vars | `VITE_` + SCREAMING_SNAKE | `VITE_GEMINI_API_KEY` |

- **Forms**: React Hook Form + Zod + `@hookform/resolvers`
- **Logging**: `src/lib/logger.ts` — silent in production (`import.meta.env.DEV` gate)
- **Assessment pairs**: `*Assessment.tsx` (UI+logic) + `*AssessmentDB.tsx` (DB ops)
- **SQL Unicode**: Kannada/Tamil/Hindi in migrations → `$$...$$` dollar-quoting
- **assessment_responses writes**: ALWAYS `.upsert({ onConflict: 'student_id,assessment_type' })` — NEVER bare `.insert()`
- **Bug fixes**: documented in git commit messages only, not in this file

---

## 12. Current Implementation Status

**Last verified build:** 2026-04-05

### Assessment Module Status
| Assessment | UI | DB | AI Summary | Approval | Wired |
|------------|:--:|:--:|:----------:|:--------:|:-----:|
| My Inspiration | ✅ | ✅ | ✅ | ✅ | ✅ |
| About Me | ✅ | ✅ | ✅ | ✅ | ✅ |
| My Dreams | ✅ | ✅ | ✅ | ✅ | ✅ |
| My School, My Learning and I | ✅ | ✅ | ✅ | ✅ | ✅ |
| My Talents and Hobbies | ✅ | ✅ | ✅ | ✅ | ✅ |
| My Role Models | ✅ | ✅ | ✅ | ✅ | ✅ |
| Holland Code (RIASEC) | ✅ | ✅ | ❌ | ❌ | ⚠️ |
| Career Guidance Tools | ✅ | ✅ | ❌ | ❌ | ⚠️ |

### Known Issues & Deferred Items

> [!WARNING]
> **Assessment unlock bypassed**: `checkAssessmentUnlock()` hardcoded to return `true`. Re-enable before production.

> [!NOTE]
> **API keys proxied**: Gemini key moved to `gemini-proxy` Edge Function (Apr 2026). `VITE_GEMINI_API_KEY` and `VITE_GOOGLE_SPEECH_API_KEY` removed from client bundle.

> [!NOTE]
> **Holland Code & Career Guidance Tools**: No AI summary or teacher approval — intentional for now.

> [!NOTE]
> **Hindi content translations**: Summary questions have Hindi for all 6 assessments. Some `content_translations` `hi` rows pending ILP Google Sheet update for non-summary content.

> [!NOTE]
> **Career roadmap milestone labels**: Hardcoded in en/kn/ta only — no Hindi. Pending DB migration decision.

> [!NOTE]
> **Sheet restructuring**: Phases 2–3 (Google Sheets sync automation) paused until ILP finalizes new format.

> [!NOTE]
> **ResponseViewer duplicated**: Exists in `StudentSummary.tsx` and `TeacherStudentResponsesPage.tsx`. Use the latter (handles booleans as Yes/No). Extract to `src/components/ui/ResponseViewer.tsx` in a future cleanup.

> [!NOTE]
> **ProgressSection unused**: `src/components/student/ProgressSection.tsx` not rendered — delete in cleanup.

> [!NOTE]
> **Profile Card Holland Code**: 2 questions in Google Sheet not yet in `content_translations` or `ProfileCardPage.tsx`. Deferred until Holland Code gets AI summary support.

> [!NOTE]
> **Legacy NO students**: 30 students still use `student_auth_credentials` + `authenticate_student` RPC (phone-only). Backfill to real Supabase Auth required before table/RPC can be deleted.

> [!NOTE]
> **PR 2b SMS hook blocked**: `send-sms-hook` Edge Function ready. Blocked on: MSG91 credentials (Auth Key, Flow ID, Sender ID), DLT OTP template approval, Supabase Pro plan (free plan 2s timeout may be too tight). Deploy: `supabase functions deploy send-sms-hook --no-verify-jwt`, configure Auth → Hooks, set Twilio placeholder, `supabase secrets set` for 4 MSG91 vars.

> [!NOTE]
> **Phone-only auth (PR 2a)**: Custom auth (mock session, `@internal.app` emails, `customAuth` localStorage) removed. All sign-in via `signInWithPassword({ phone, password })`. Teacher self-register via `create-teacher` Edge Function. `student_auth_credentials` + `authenticate_student` kept for legacy NO students only.

> [!NOTE]
> **Profile card rejection audit trail**: Teacher feedback is consumed by Gemini during auto-regeneration but not persisted to DB after regen (`rejection_reason` set to `null` on upsert). No history of prior feedback rounds stored. Max 3 rejection rounds per module enforced client-side only (`rejectionCounts` state — resets on page reload).

### Completed Work (Mar–Apr 2026)
| Phase | Description |
|-------|-------------|
| **0A** | Fix corrupted School Learning summary question1 |
| **0B** | `get_role_models_assessment_template` RPC + 404 fix |
| **1C–1E** | Move summary section titles + School Learning method options to DB |
| **4A** | IndicKeyboard: Tamil + Hindi layouts, scroll/touch/haptic UX |
| **4B** | Hindi (`hi`) added to `preferred_language` CHECK constraint |
| **4C** | Hindi support across all services and components |
| **4D–4E** | Remove `simple-keyboard`; full build verification (tsc + vite) |
| **5A** | Add `hi` to `SummaryTemplate` type, remove `(template as any)` casts |
| **5B** | Role Models prompt reads questions from DB template (not hardcoded) |
| **5C** | Hindi `languageInstruction` blocks in all 12 prompt builders |
| **5D** | `BASE_SYSTEM_PROMPT` constant (−115 lines duplication) |
| **5E** | Profile card questions migration: 22q + 6 titles × 4 langs → `content_translations` |
| **5F** | `generateProfileCardKeywords()` fetches from DB, returns `{question1: "..."}` |
| **5G** | `ProfileCardPage.tsx` rewrite: Q→answer display, clickable cards, Hindi, deep-link |
| **5H** | Student dashboard auto-opens `SummaryViewDialog` from URL params (`?assessment=X&tab=summary`) |
| **5I** | Remove Assessment Progress Summary placeholder from student dashboard |
| **6A** | Clean slate content migration (about_me_fields, hobbies_questions updated) |
| **6B** | Content key format fixes (role_models underscore removal, about_me section keys) |
| **6C** | Hobbies summary template key remapping (question1-8 → 1-10) |
| **6D** | Assessment type/title mismatches fixed (About Me, School Learning, Hobbies) |
| **6E** | Career roadmap: `midterm_9th` added, auto-redirect on first assessment open |
| **6F** | UI consistency: Tamil strings, Hindi auth page, footer year, translation spinners |
| **6G** | Bug fixes: API URL spaces, lang mismatch, race conditions, save guards, i18n |
| **6H** | `UNIQUE (student_id, assessment_type)` constraint + deduplication |
| **6I** | All `.insert()` → `.upsert({ onConflict })` on `assessment_responses` (10 files) |
| **6J–6K** | Drop stale RLS policy (409 on upsert); re-enable with correct `ar_*` policies |
| **6L** | E2E backend test: 42/42 pass |
| **7A** | "Things that Interest Me" page: table, compass menu entry, post-assessment redirect |
| **7B** | Mobile keyboard: overlap fix, backdrop, body scroll lock |
| **7C–7E** | Notification panel mobile alignment; audio transcription message; lazy mic init |
| **7F–7G** | Roadmap midterm trigger module 4 → 5; remove About Me summary Category labels |
| **8A** | 100+ hardcoded English strings → Hindi across 6 assessment components |
| **8B** | IndicKeyboard to ThingsInterestMePage; Hindi keyboard conditions in ProfileDialog/ChatBubble |
| **8C** | Inspiration videos: `lang` column, 4-language sets, `get_inspiration_videos(p_lang)` RPC |
| **8D** | Notifications language-aware: fetches student `preferred_language`, translates kn/ta/hi |
| **8E** | AISummaryReview passes student language to AI generators |
| **8F–8H** | ThingsInterestMePage Hindi (17 strings); NotificationBell closes on click; Hobbies Hindi section names |
| **9A** | Mandatory asterisks on Question/TripleInput/DoubleInput sub-components |
| **9B** | Remove duplicate help text (blue box + placeholder) across 4 assessments |
| **9C** | CSV import: upsert students/credentials, existing user check before create |
| **9D** | Case-insensitive email: `ilike`, lowercase normalize, unique index |
| **9E** | Bruno account merge (case-sensitive email duplicate cleanup) |
| **9F** | Summary RPC keys: `'question'\|\|N` → `'summary_question'\|\|N` |
| **9G** | NotificationBell mobile full-width positioning |
| **9H–9J** | Teacher review: Hindi detection; translated question text; i18n for Inspiration/Dreams/About Me |
| **10A** | Teacher dashboard: Performance → Language column; roadmap/interests/profile card actions |
| **10B** | `TeacherStudentRoadmapPage` + `TeacherStudentInterestsPage` (read-only views) |
| **10C** | Profile card approval workflow: pending/approved/rejected; keywords reset on response update |
| **10D–10F** | Language change from ProfileDialog; mobile button safe-area; analytics tab removed |
| **10G** | RLS enabled on 18 public content/question tables (authenticated read-only) |
| **11A** | Language change bug: `forceRefresh` param, reorder `refreshUserProfile()` before `setLang()` |
| **11B** | Tamil button overflow fix in MyInspirationAssessment (removed `whitespace-nowrap`) |
| **11C–11D** | Teacher roadmap/interests FK fix: use `student.user_id` not URL `studentId` |
| **11E** | Logout fix: state clearing unconditional, `supabase.auth.signOut()` best-effort |
| **PR 2a** | Phone-only auth: `create-teacher` EF, phone `signInWithPassword`, remove custom auth |
| **PR 2a-fix** | Profile card cache FK: all queries use `users.id`; `StudentModals.tsx` uses `selectedStudent.user_id` |
| **PR 2b-temp** | Show generated password in teacher toast (all marked `// TEMP: remove in PR 2b`) |
| **PR 2b-reg** | Student self-registration: `create-student-self-register` EF; role toggle on AuthPage |
| **12A** | `TeacherStudentResponsesPage`: 8-tab read-only response view; Holland Code RIASEC bars |
| **12B** | Hindi detection fix in `SummaryApprovalCard.detectLangKeyFromSummary()` (Devanagari range) |
| **PR 2b-sms** | `send-sms-hook` EF: MSG91 Flow API + HMAC-SHA256 verification; awaiting credentials |
| **2–3** | Google Sheets sync automation — ⏸ paused (sheet restructuring in progress) |
