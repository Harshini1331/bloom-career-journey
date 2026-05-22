import os
import requests
from dotenv import load_dotenv

# Load env
if os.path.exists(".env"):
    print("[OK] .env file exists in the directory.")
else:
    print("[ERROR] .env file does NOT exist in the directory!")
    
load_dotenv()

widget_id = os.environ.get("VITE_MSG91_WIDGET_ID")
token_auth = os.environ.get("VITE_MSG91_TOKEN_AUTH")
auth_key = os.environ.get("MSG91_AUTH_KEY")

def inspect_var(name, val):
    if not val:
        print(f"[ERROR] {name}: MISSING or EMPTY")
        return
    print(f"   {name}: FOUND")
    print(f"   Length: {len(val)}")
    print(f"   First 3 chars: {val[:3]}")
    print(f"   Last 3 chars: {val[-3:]}")
    if "<" in val or ">" in val or "placeholder" in val.lower() or "widget id" in val.lower() or "token auth" in val.lower():
        print(f"   [WARNING] Value seems to contain placeholder brackets/text!")
    if val.startswith('"') or val.endswith('"') or val.startswith("'") or val.endswith("'"):
        print(f"   [WARNING] Value has literal quotes included inside the variable value!")

print("\n--- Inspecting environment variables loaded by python-dotenv ---")
inspect_var("VITE_MSG91_WIDGET_ID", widget_id)
inspect_var("VITE_MSG91_TOKEN_AUTH", token_auth)
inspect_var("MSG91_AUTH_KEY", auth_key)

print("\n--- Scanning .env file for potential syntax errors ---")
if os.path.exists(".env"):
    with open(".env", "r", encoding="utf-8", errors="ignore") as f:
        lines = f.readlines()
    for idx, line in enumerate(lines, 1):
        line_strip = line.strip()
        if not line_strip or line_strip.startswith("#"):
            continue
        
        # Check for spaces around =
        if "=" in line_strip:
            parts = line_strip.split("=", 1)
            key = parts[0]
            val = parts[1]
            if key.endswith(" ") or val.startswith(" "):
                print(f"   [WARNING] Line {idx}: Spaces found around '=': `{line_strip}`")
            
            # Check for JSON objects
            if val.strip().startswith("{") and not (val.strip().startswith("'") or val.strip().startswith('"')):
                print(f"   [WARNING] Line {idx}: JSON object is not quoted: `{line_strip[:50]}...`")
