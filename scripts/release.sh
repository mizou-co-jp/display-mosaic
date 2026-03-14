#!/bin/bash
set -euo pipefail

# =============================================================================
# DisplayMosaic Release Script
# Usage: ./scripts/release.sh <version>
# Example: ./scripts/release.sh 1.0.2
# =============================================================================

VERSION="${1:?Usage: $0 <version> (e.g. 1.0.2)}"
APP_NAME="DisplayMosaic"
BUNDLE_ID="jp.co.mizou.DisplayMosaic"
TEAM_ID="JBSFX35S2Z"
DEVELOPER_ID="Developer ID Application: MIZOU, CO., LTD. (${TEAM_ID})"

BUILD_DIR="/tmp/${APP_NAME}Build"
APP_PATH="${BUILD_DIR}/Release/${APP_NAME}.app"
ZIP_PATH="/tmp/${APP_NAME}-${VERSION}.zip"

echo "=== Building ${APP_NAME} v${VERSION} ==="

# 1. Build
xcodebuild -scheme "${APP_NAME}" -configuration Release \
  clean build \
  SYMROOT="${BUILD_DIR}" \
  CODE_SIGN_IDENTITY="${DEVELOPER_ID}" \
  DEVELOPMENT_TEAM="${TEAM_ID}" \
  CODE_SIGN_STYLE=Manual \
  2>&1 | tail -3

if [ ! -d "${APP_PATH}" ]; then
  echo "ERROR: Build failed - ${APP_PATH} not found"
  exit 1
fi

echo "=== Signing with Developer ID ==="

# 2. Deep sign with hardened runtime
codesign --force --deep --options runtime \
  --sign "${DEVELOPER_ID}" \
  --timestamp \
  "${APP_PATH}"

# Verify
codesign --verify --deep --strict --verbose=2 "${APP_PATH}" 2>&1 | tail -3
echo "Signing verified."

# 3. Create zip for notarization
echo "=== Creating zip ==="
rm -f "${ZIP_PATH}"
ditto -c -k --keepParent "${APP_PATH}" "${ZIP_PATH}"

# 4. Notarize
echo "=== Submitting for notarization ==="

API_KEY="${HOME}/.appstoreconnect/private_keys/AuthKey_M73GGJSLUF.p8"
API_KEY_ID="M73GGJSLUF"
API_ISSUER_ID="4b692bcd-cb30-41fb-9c0b-b9cf31fcab17"

xcrun notarytool submit "${ZIP_PATH}" \
  --key "${API_KEY}" \
  --key-id "${API_KEY_ID}" \
  --issuer "${API_ISSUER_ID}" \
  --wait

# 5. Staple
echo "=== Stapling notarization ticket ==="
xcrun stapler staple "${APP_PATH}"

# 6. Re-create zip with stapled ticket
rm -f "${ZIP_PATH}"
ditto -c -k --keepParent "${APP_PATH}" "${ZIP_PATH}"

# 7. Compute SHA256
SHA=$(shasum -a 256 "${ZIP_PATH}" | awk '{print $1}')
echo ""
echo "=== Release Ready ==="
echo "Version: ${VERSION}"
echo "Zip: ${ZIP_PATH}"
echo "SHA256: ${SHA}"
echo ""
echo "Next steps:"
echo "  gh release create v${VERSION} ${ZIP_PATH} --repo mizou-co-jp/display-mosaic --title \"v${VERSION}\""
echo "  Update Homebrew tap with SHA256: ${SHA}"
