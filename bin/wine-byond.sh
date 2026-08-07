#!/usr/bin/env bash
#
# Runs a BYOND binary through Wine, using the dedicated Wine prefix.
#
# The Wine prefix holds BYOND (DreamMaker/DreamSeeker) plus the WebView2
# runtime and DirectX redistributables installed via winetricks. This script
# is used both as the DM compiler entry point for the build (DM_EXE) and to
# launch the DreamSeeker client.
#
# Usage:
#   bin/wine-byond.sh [dm|dreammaker] [-D<def> ...] file.dme   # compile
#   bin/wine-byond.sh dreamseeker [byond://host:port]          # launch client
#   bin/wine-byond.sh dreamdaemon file.dmb [args...]           # wine server
#   bin/wine-byond.sh setup                                     # install wine deps
#   bin/wine-byond.sh verify                                    # check deps
#
set -euo pipefail

# Wine prefix for BYOND. Standard WINEPREFIX env var wins; otherwise default
# to the conventional per-user games location under $HOME.
WINEPREFIX="${WINEPREFIX:-$HOME/Games/byond}"
export WINEPREFIX

BYOND_BIN="$WINEPREFIX/drive_c/Program Files (x86)/BYOND/bin"

# The compiler is the default target so the build tool can invoke this script
# directly as DM_EXE (e.g. `bin/wine-byond.sh -DCBT tgstation.dme`). A leading
# arg is only treated as a subcommand when it matches a known target.
mode="${1:-dm}"
case "$mode" in
dm|dreammaker|dreamseeker|seeker|dreamdaemon|daemon|setup|verify)
	shift
	;;
*)
	mode="dm"
	;;
esac

case "$mode" in
dm|dreammaker)
	exec wine "$BYOND_BIN/dm.exe" "$@"
	;;
dreamseeker|seeker)
	exec wine "$BYOND_BIN/dreamseeker.exe" "$@"
	;;
dreamdaemon|daemon)
	exec wine "$BYOND_BIN/dreamdaemon.exe" "$@"
	;;
setup)
	exec bash "$(dirname "$0")/winetricks-setup.sh" install "$@"
	;;
verify)
	exec bash "$(dirname "$0")/winetricks-setup.sh" verify "$@"
	;;
*)
	echo "Unknown BYOND target '$mode'." >&2
	echo "Usage: $0 [dm|dreammaker|dreamseeker|dreamdaemon|setup|verify]" >&2
	exit 2
	;;
esac
