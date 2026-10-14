#!/usr/bin/env bash
set -euo pipefail
: "${IOS_P12_BASE64:?Missing secret IOS_P12_BASE64}"
: "${IOS_P12_PASSWORD:?Missing secret IOS_P12_PASSWORD}"
: "${IOS_PROFILE_BASE64:?Missing secret IOS_PROFILE_BASE64}"
: "${APPLE_TEAM_ID:?Missing variable APPLE_TEAM_ID}"
: "${APPLE_BUNDLE_ID:?Missing variable APPLE_BUNDLE_ID}"

umask 077
CERT_FILE="$RUNNER_TEMP/ritmo-distribution.p12"
PROFILE_FILE="$RUNNER_TEMP/ritmo-distribution.mobileprovision"
KEYCHAIN="$RUNNER_TEMP/ritmo-signing.keychain-db"
# macOS base64's -D decodes from stdin.
printf '%s' "$IOS_P12_BASE64" | base64 -D > "$CERT_FILE"
printf '%s' "$IOS_PROFILE_BASE64" | base64 -D > "$PROFILE_FILE"

# CI keychain is ephemeral and isolated from the macOS user default keychain.
KEYCHAIN_PASSWORD="${KEYCHAIN_PASSWORD:-$(openssl rand -hex 24)}"
security create-keychain -p "$KEYCHAIN_PASSWORD" "$KEYCHAIN"
security set-keychain-settings -lut 21600 "$KEYCHAIN"
security unlock-keychain -p "$KEYCHAIN_PASSWORD" "$KEYCHAIN"
security list-keychains -d user -s "$KEYCHAIN" login.keychain-db
security default-keychain -d user -s "$KEYCHAIN"
security import "$CERT_FILE" -k "$KEYCHAIN" -P "$IOS_P12_PASSWORD" -T /usr/bin/codesign -T /usr/bin/security
security set-key-partition-list -S apple-tool:,apple:,codesign: -s -k "$KEYCHAIN_PASSWORD" "$KEYCHAIN" >/dev/null
security find-identity -v -p codesigning "$KEYCHAIN"

PROFILE_PLIST="$RUNNER_TEMP/ritmo-profile.plist"
security cms -D -i "$PROFILE_FILE" > "$PROFILE_PLIST"
python3 - "$PROFILE_PLIST" <<'PY'
import os, plistlib, sys
p = plistlib.load(open(sys.argv[1], 'rb'))
team = os.environ['APPLE_TEAM_ID']
bundle_id = os.environ['APPLE_BUNDLE_ID']
app_id = p.get('Entitlements', {}).get('application-identifier', '')
if p.get('TeamIdentifier', [''])[0] != team:
    sys.exit('Provisioning profile belongs to another Apple Team ID')
if app_id != f'{team}.{bundle_id}':
    sys.exit('Provisioning profile App ID does not match: expected exact bundle ID')
if p.get('ProvisionedDevices') or p.get('ProvisionsAllDevices'):
    sys.exit('Provisioning profile must be App Store distribution, not Ad Hoc or Enterprise')
if p.get('Entitlements', {}).get('get-task-allow'):
    sys.exit('Development provisioning profile is not allowed')
profile_uuid = p['UUID']
profile_name = p['Name']
with open(os.environ['GITHUB_ENV'], 'a', encoding='utf-8') as f:
    f.write(f'PROFILE_UUID={profile_uuid}\n')
    f.write(f'PROFILE_NAME={profile_name}\n')
    f.write(f'SIGNING_PROFILE_PATH={os.path.expanduser("~/Library/MobileDevice/Provisioning Profiles/")}{profile_uuid}.mobileprovision\n')
print('Validated App Store distribution profile (UUID not displayed).')
PY
mkdir -p "$HOME/Library/MobileDevice/Provisioning Profiles"
cp "$PROFILE_FILE" "$HOME/Library/MobileDevice/Provisioning Profiles/$(/usr/libexec/PlistBuddy -c 'Print UUID' "$PROFILE_PLIST").mobileprovision"
rm -f "$CERT_FILE" "$PROFILE_FILE" "$PROFILE_PLIST"
