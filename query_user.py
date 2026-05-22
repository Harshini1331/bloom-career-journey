import os
import requests
from dotenv import load_dotenv

load_dotenv()

supabase_url = os.environ.get("VITE_SUPABASE_URL")
service_role_key = os.environ.get("SUPABASE_SERVICE_ROLE_KEY")

if not supabase_url or not service_role_key:
    print("❌ Error: Missing SUPABASE_URL or SUPABASE_SERVICE_ROLE_KEY in .env")
    exit(1)

# Initialize Supabase headers
headers = {
    "apikey": service_role_key,
    "Authorization": f"Bearer {service_role_key}",
    "Content-Type": "application/json"
}

phone_to_find = "+919840857339"

print(f"Searching database for phone: {phone_to_find}")

# 1. Search in public.users
print("\n1. Checking public.users table...")
url_users = f"{supabase_url}/rest/v1/users?mobile=eq.{phone_to_find}"
try:
    res = requests.get(url_users, headers=headers)
    print(f"Status Code: {res.status_code}")
    if res.status_code == 200:
        data = res.json()
        print(f"Data found: {data}")
    else:
        print(f"Error: {res.text}")
except Exception as e:
    print(f"Exception: {e}")

# 2. Search in auth.users (since we cannot query auth schema directly via REST without admin schema,
# we can use the Supabase Auth Admin API to list/find users)
# The endpoint for admin listing users is: /auth/v1/admin/users
print("\n2. Checking auth.users (via admin API)...")
url_auth_users = f"{supabase_url}/auth/v1/admin/users"
try:
    res = requests.get(url_auth_users, headers=headers)
    print(f"Status Code: {res.status_code}")
    if res.status_code == 200:
        users = res.json().get("users", [])
        found = False
        print(f"Total users in Auth: {len(users)}")
        for u in users:
            u_phone = u.get("phone")
            u_email = u.get("email")
            if u_phone == phone_to_find or u_phone == phone_to_find.replace("+", ""):
                print(f"[FOUND] Found user in Auth:")
                print(f"   ID: {u.get('id')}")
                print(f"   Email: {u_email}")
                print(f"   Phone: {u_phone}")
                print(f"   Confirmed At: {u.get('phone_confirmed_at') or u.get('email_confirmed_at')}")
                print(f"   Created At: {u.get('created_at')}")
                print(f"   Last Sign In: {u.get('last_sign_in_at')}")
                print(f"   User Metadata: {u.get('user_metadata')}")
                found = True
        if not found:
            print("[NOT FOUND] User not found in Supabase Auth by phone number.")
            # Print a list of first few users in auth for debugging format
            print("First 3 users in Auth list:")
            for u in users[:3]:
                print(f"  - Phone: {u.get('phone')}, Email: {u.get('email')}")
    else:
        print(f"Error: {res.text}")
except Exception as e:
    print(f"Exception: {e}")
