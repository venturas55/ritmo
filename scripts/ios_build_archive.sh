#!/usr/bin/env bash
set -euo pipefail
: "${APPLE_TEAM_ID:?Missing APPLE_TEAM_ID}"
: "${APPLE_BUNDLE_ID:?Missing APPLE_BUNDLE_ID}"
: "${PROFILE_UUID:?Missing PROFILE_UUID}"

WORKSPACE=$(find ios -maxdepth 2 -name '*.xcworkspace' -type d | head -n 1)
[ -n "$WORKSPACE" ] || { echo 'No ios/*.xcworkspace generated'; exit 1; }
# Detect app scheme from shared xcscheme, avoiding assumptions about Expo display name.
SCHEME_FILE=$(find ios -path '*/xcshareddata/xcschemes/*.xcscheme' -type f | head -n 1)
[ -n "$SCHEME_FILE" ] || { echo 'No shared Xcode scheme generated'; exit 1; }
SCHEME=$(basename "$SCHEME_FILE" .xcscheme)
echo "Building Xcode scheme: $SCHEME"

# GitHub run_number increases monotonically per workflow; Apple requires a fresh build number.
BUILD_NUMBER="${GITHUB_RUN_NUMBER:?Missing run number}"
/usr/libexec/PlistBuddy -c "Set :CFBundleVersion $BUILD_NUMBER" "ios/$SCHEME/Info.plist" 2>/dev/null || true

mkdir -p "$PWD/output"
ARCHIVE="$RUNNER_TEMP/Ritmo.xcarchive"

xcodebuild archive \
  -workspace "$WORKSPACE" \
  -scheme "$SCHEME" \
  -configuration Release \
  -destination 'generic/platform=iOS' \
  -archivePath "$ARCHIVE" \
  -derivedDataPath "$RUNNER_TEMP/RitmoDerivedData" \
  DEVELOPMENT_TEAM="$APPLE_TEAM_ID" \
  CODE_SIGN_STYLE=Manual \
  CODE_SIGN_IDENTITY='Apple Distribution' \
  "PROVISIONING_PROFILE_SPECIFIER=$PROFILE_UUID" \
  CURRENT_PROJECT_VERSION="$BUILD_NUMBER" \
  archive

# Validate the app being shipped, not merely the source app.json.
APP_PATH=$(find "$ARCHIVE/Products/Applications" -maxdepth 1 -type d -name '*.app' | head -n 1)
[ -n "$APP_PATH" ] || { echo 'Archive contains no .app'; exit 1; }
ARCHIVED_ID=$(/usr/libexec/PlistBuddy -c 'Print CFBundleIdentifier' "$APP_PATH/Info.plist")
[ "$ARCHIVED_ID" = "$APPLE_BUNDLE_ID" ] || { echo "Archived bundle ID mismatch"; exit 1; }

python3 - <<'PY'
import os, plistlib
export = {
    'method': 'app-store-connect',
    'destination': 'export',
    'signingStyle': 'manual',
    'teamID': os.environ['APPLE_TEAM_ID'],
    'signingCertificate': 'Apple Distribution',
    'provisioningProfiles': {os.environ['APPLE_BUNDLE_ID']: os.environ['PROFILE_UUID']},
    'manageAppVersionAndBuildNumber': False,
    'stripSwiftSymbols': True,
}
with open(os.environ['RUNNER_TEMP'] + '/RitmoExportOptions.plist', 'wb') as f:
    plistlib.dump(export, f)
PY

xcodebuild -exportArchive \
  -archivePath "$ARCHIVE" \
  -exportPath "$PWD/output" \
  -exportOptionsPlist "$RUNNER_TEMP/RitmoExportOptions.plist"

IPA_FILE=$(find output -maxdepth 1 -name '*.ipa' -type f | head -n 1)
[ -n "$IPA_FILE" ] || { echo 'No IPA generated'; exit 1; }
if [ "$IPA_FILE" != 'output/Ritmo.ipa' ]; then mv "$IPA_FILE" output/Ritmo.ipa; fi
ls -lh output/Ritmo.ipa
