# create-student-self-register

Edge Function for student self-registration. No OTP required — uses `auth.admin.createUser` with `phone_confirm: true`.

## Request

```
POST /functions/v1/create-student-self-register
Content-Type: application/json

{
  "fullName": "Asha Kumar",
  "phone": "+919876543210",
  "password": "MyPassword123",
  "grade": "9",
  "stateId": "<uuid>",
  "preferredLanguage": "en"
}
```

## Response

**Success (200):**
```json
{ "userId": "<uuid>" }
```

**Errors:**
- `400` — missing fields, invalid phone format, duplicate phone, class not found for grade
- `500` — auth account creation failed, DB insert failed (auth user rolled back on failure)

## Notes

- No authorization header required — public endpoint.
- `grade` must be one of `"8"`, `"9"`, `"10"`, `"11"`, `"12"`. Resolved to `class_id` via `classes WHERE name = 'Class {grade}' AND state_id = stateId`.
- Does **not** insert into `student_auth_credentials` — student has a real Supabase Auth account.
- Student is created with `teacher_id: null` and `enrollment_status: 'pending'` until a teacher claims them.
