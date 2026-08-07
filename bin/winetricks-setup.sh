#!/usr/bin/env bash
#
# Installs and verifies the libraries DreamSeeker needs inside the Wine
# prefix: the WebView2 runtime (for the tgui browser) and the DirectX
# redistributables (d3dx9/d3dcompiler_47) pulled in via winetricks.
#
# Usage:
#   bin/winetricks-setup.sh install   # install missing deps
#   bin/winetricks-setup.sh verify    # check deps are present
#
set -euo pipefail

WINEPREFIX="${WINEPREFIX:-$HOME/Games/byond}"
export WINEPREFIX

# Wine verbs to keep DreamSeeker happy. d3dx9 and d3dcompiler_47 cover the
# DirectX bits; webview2 provides the embedded Chromium runtime for tgui.
WINETRICKS_VERBS=(webview2 d3dx9 d3dcompiler_47 vcrun2022 corefonts)

WINE_DRIVE="$WINEPREFIX/drive_c"
WEBVIEW2_HOME="$WINE_DRIVE/Program Files (x86)/Microsoft/EdgeWebView"

require_cmd() {
	local cmd="$1"
	if ! command -v "$cmd" >/dev/null 2>&1; then
		echo "ERROR: '$cmd' not found on PATH." >&2
		exit 1
	fi
}

verb_failed() {
	echo "ERROR: a winetricks verb failed. Re-run with WINEDEBUG and inspect output." >&2
	exit 1
}

install() {
	require_cmd wine
	require_cmd winetricks
	if [ ! -d "$BYOND_DIR" ] 2>/dev/null && [ ! -d "$WINE_DRIVE" ]; then
		echo "Wine prefix '$WINEPREFIX' does not exist; initializing." >&2
		wineboot -u 2>/dev/null || true
	fi
	echo "Installing/updating Wine libraries: ${WINETRICKS_VERBS[*]}"
	# -q quiet, -f force (idempotent), --no-isolate keeps a normal prefix.
	winetricks -q -f --no-isolate "${WINETRICKS_VERBS[@]}" || verb_failed
	verify
}

verify() {
	local ok=1
	echo "Verifying Wine prefix: $WINEPREFIX"

	# WebView2 runtime (EdgeWebView install dir + BYOND's loader DLL).
	if [ -d "$WEBVIEW2_HOME" ] && [ -n "$(find "$WEBVIEW2_HOME" -iname 'msedgewebview2.exe' 2>/dev/null | head -1)" ]; then
		echo "  [OK] WebView2 runtime present"
	else
		echo "  [MISSING] WebView2 runtime (run: bin/winetricks-setup.sh install)" >&2
		ok=0
	fi
	if [ -f "$BYOND_BIN/WebView2Loader.dll" ]; then
		echo "  [OK] WebView2Loader.dll in BYOND bin"
	else
		echo "  [MISSING] BYOND bin/WebView2Loader.dll" >&2
		ok=0
	fi

	# DirectX redistributables: d3dx9_43 + d3dcompiler_47 cover what DreamSeeker
	# and the tgui browser rely on.
	local sys32="$WINE_DRIVE/windows/system32"
	for dll in d3dx9_43.dll d3dcompiler_47.dll; do
		if [ -f "$sys32/$dll" ]; then
			echo "  [OK] $dll"
		else
			echo "  [MISSING] windows/system32/$dll" >&2
			ok=0
		fi
	done

	if [ "$ok" -eq 1 ]; then
		echo "All DreamSeeker libraries are present."
	else
		echo "Some libraries are missing. Run: bin/winetricks-setup.sh install" >&2
		exit 1
	fi
}

# Resolve BYOND bin dir (needs the prefix present).
BYOND_BIN="$WINE_DRIVE/Program Files (x86)/BYOND/bin"
BYOND_DIR="$WINE_DRIVE/Program Files (x86)/BYOND"

case "${1:-verify}" in
install) install ;;
verify) verify ;;
*) echo "Usage: $0 {install|verify}" >&2; exit 2 ;;
esac
