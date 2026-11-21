#!/usr/bin/env bash
# Install the course extensions (Classroom 50 Helper, Exam Proctor) from their VSIX files,
# both through the 'code' CLI and by extracting into the extensions folder, so that they
# load in browser-based GitHub Codespaces as well as in desktop VS Code.
set -e
shopt -s nullglob

for VSIX_FILE in classroom50-helper-extension/*.vsix proctor-extension/*.vsix; do
  echo "Installing extension from: $VSIX_FILE"
  if command -v code &> /dev/null; then code --install-extension "$VSIX_FILE" --force || true; fi
  if command -v code-insiders &> /dev/null; then code-insiders --install-extension "$VSIX_FILE" --force || true; fi

  TMP_EXTRACT="/tmp/vsix-extract-$$"
  rm -rf "$TMP_EXTRACT"; mkdir -p "$TMP_EXTRACT"
  unzip -q "$VSIX_FILE" -d "$TMP_EXTRACT"
  EXT_DIR_NAME=$(python3 -c "import json,sys; p=json.load(open(sys.argv[1])); print(f\"{p['publisher']}.{p['name']}-{p['version']}\")" "$TMP_EXTRACT/extension/package.json")
  EXT_ID="${EXT_DIR_NAME%-*}"          # publisher.name, without the version

  for EXT_DIR in "/home/vscode/.vscode-remote/extensions" "/home/vscode/.vscode-server/extensions"; do
    mkdir -p "$EXT_DIR"
    TARGET_PATH="$EXT_DIR/$EXT_DIR_NAME"
    # remove older versions of the same extension, so only this version can load
    if [ -n "$EXT_ID" ]; then
      for OLD in "$EXT_DIR/$EXT_ID"-* "$EXT_DIR/${EXT_ID,,}"-*; do
        [ -d "$OLD" ] && [ "$OLD" != "$TARGET_PATH" ] && rm -rf "$OLD" && echo "  removed old $(basename "$OLD")"
      done
    fi
    rm -rf "$TARGET_PATH"; mkdir -p "$TARGET_PATH"
    cp -r "$TMP_EXTRACT/extension/"* "$TARGET_PATH/"
    echo "✔ Extracted to $TARGET_PATH"
  done
  rm -rf "$TMP_EXTRACT"
done
echo "🎉 Extension installation completed."
