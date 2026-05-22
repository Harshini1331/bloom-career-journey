import os
import requests
from dotenv import load_dotenv

load_dotenv()

supabase_url = os.environ.get("VITE_SUPABASE_URL")
service_role_key = os.environ.get("SUPABASE_SERVICE_ROLE_KEY")

if not supabase_url or not service_role_key:
    print("[ERROR] Missing SUPABASE_URL or SUPABASE_SERVICE_ROLE_KEY in .env")
    exit(1)

headers = {
    "apikey": service_role_key,
    "Authorization": f"Bearer {service_role_key}",
    "Content-Type": "application/json"
}

phone_variants = ["+919840857339", "919840857339", "9840857339"]

def check_table(table_name, column_name):
    print(f"\nChecking table '{table_name}' on column '{column_name}'...")
    for variant in phone_variants:
        url = f"{supabase_url}/rest/v1/{table_name}?{column_name}=eq.{variant}"
        try:
            res = requests.get(url, headers=headers)
            if res.status_code == 200:
                data = res.json()
                if data:
                    print(f"[FOUND] Found match in '{table_name}' for '{variant}':")
                    for row in data:
                        print(f"   {row}")
                    return True
            else:
                print(f"   Error checking variant '{variant}' in '{table_name}': {res.status_code} - {res.text}")
        except Exception as e:
            print(f"   Exception for '{variant}' in '{table_name}': {e}")
    print(f"[NOT FOUND] No match in '{table_name}' on column '{column_name}'.")
    return False

# Check public.users
check_table("users", "mobile")

# Check public.student_auth_credentials
check_table("student_auth_credentials", "mobile")

# Let's also search student_auth_credentials using 'email' just in case
print("\nChecking table 'student_auth_credentials' for emails/mobile matching format...")
url_all_creds = f"{supabase_url}/rest/v1/student_auth_credentials"
try:
    res = requests.get(url_all_creds, headers=headers)
    if res.status_code == 200:
        data = res.json()
        print(f"Total credentials in student_auth_credentials: {len(data)}")
        for row in data:
            email = row.get("email") or ""
            mobile = row.get("mobile") or ""
            if any(p in email or p in mobile for p in ["9840857339"]):
                print(f"[FOUND] Found partial match in student_auth_credentials: {row}")
    else:
        print(f"Error listing credentials: {res.text}")
except Exception as e:
    print(f"Exception listing credentials: {e}")

# Let's search public.users by full_name or email too if they have it
print("\nChecking public.users by partial name/email...")
url_all_users = f"{supabase_url}/rest/v1/users"
try:
    res = requests.get(url_all_users, headers=headers)
    if res.status_code == 200:
        data = res.json()
        print(f"Total users in public.users: {len(data)}")
        for row in data:
            email = row.get("email") or ""
            mobile = row.get("mobile") or ""
            name = row.get("full_name") or ""
            if any(p in email or p in mobile or p in name for p in ["9840857339"]):
                print(f"[FOUND] Found partial match in users: {row}")
    else:
        print(f"Error listing users: {res.text}")
except Exception as e:
    print(f"Exception listing users: {e}")
