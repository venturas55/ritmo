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
DERIVED_DATA="$RUNNER_TEMP/RitmoDerivedData"
RESULT_BUNDLE="$RUNNER_TEMP/RitmoArchive.xcresult"
# Delete only the fixed build paths belonging to this CI job.
: "${RUNNER_TEMP:?Missing RUNNER_TEMP}"
[[ "$RUNNER_TEMP" = /* && "$RUNNER_TEMP" != / ]] || { echo 'RUNNER_TEMP must be an absolute temporary directory'; exit 1; }
rm -rf "$DERIVED_DATA" "$ARCHIVE" "$RESULT_BUNDLE"

# Apply manual signing only to app targets. Command-line signing settings also
# override CocoaPods targets, which must retain their generated build settings.
ruby - ios <<'RUBY'
require 'xcodeproj'
project_path = Dir.glob(File.join(ARGV.fetch(0), '*.xcodeproj')).fetch(0)
project = Xcodeproj::Project.open(project_path)
apps = project.targets.select { |target| target.product_type == 'com.apple.product-type.application' }
abort 'No application target found' if apps.empty?
apps.each do |target|
  target.build_configurations.each do |config|
    next unless config.name == 'Release'
    config.build_settings['DEVELOPMENT_TEAM'] = ENV.fetch('APPLE_TEAM_ID')
    config.build_settings['CODE_SIGN_STYLE'] = 'Manual'
    config.build_settings['CODE_SIGN_IDENTITY'] = 'Apple Distribution'
    config.build_settings['PROVISIONING_PROFILE_SPECIFIER'] = ENV.fetch('PROFILE_UUID')
  end
end
project.save
RUBY

xcodebuild \
  -workspace "$WORKSPACE" \
  -scheme "$SCHEME" \
  -configuration Release \
  -destination 'generic/platform=iOS' \
  -archivePath "$ARCHIVE" \
  -derivedDataPath "$DERIVED_DATA" \
  -resultBundlePath "$RESULT_BUNDLE" \
  -sdk iphoneos \
  ONLY_ACTIVE_ARCH=NO \
  CURRENT_PROJECT_VERSION="$BUILD_NUMBER" \
  clean archive 2>&1 | tee "$RUNNER_TEMP/ritmo-archive.log"

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
