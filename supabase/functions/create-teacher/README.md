# create-teacher Edge Function

Supabase Edge Function that creates teacher accounts with real Supabase Auth credentials. Called from the AuthPage sign-up form when a teacher self-registers.

## Input

```
POST /create-teacher

{
  "fullName": "Priya Sharma",
  "phone": "+919876543210",
  "password": "teacher_chosen_password",
  "stateId": "<states.id>",
  "preferredLanguage": "en"
}
```

No Authorization header required — this is a public endpoint for self-registration.

## Output

Success:
```json
{ "userId": "<uuid>" }
```

Failure (400 / 500):
```json
{ "error": "Phone number already registered" }
```

## Logic

1. Validate phone is E.164 format (`+` followed by 10-15 digits)
2. Check `users.mobile` for duplicate — returns 400 if exists
3. `auth.admin.createUser()` with phone + teacher's chosen password + `phone_confirm: true`
4. Insert `public.users` (id = auth user id, role = 'teacher')
5. Insert `public.teachers` (user_id, state_id, is_active, joining_date)
6. On DB failure, rollback auth user via `auth.admin.deleteUser()`
7. Return `{ userId }` on success

## Deploy

```bash
supabase functions deploy create-teacher
```

## Environment variables

- `SUPABASE_URL` - auto-injected by Supabase
- `SUPABASE_SERVICE_ROLE_KEY` - auto-injected by Supabase

No additional configuration needed.
