#!/usr/bin/env bash
#
# Builds the project with DreamMaker under Wine, starts the native BYOND
# DreamDaemon server (no Wine) with the resulting .dmb on the given port, then
# launches the DreamSeeker client (under Wine) pointed at that server.
#
# Usage:
#   bin/dreamseeker.sh [--no-build] [--port 1337] [byond://host:port]
#
# Env:
#   DREAMDAEMON  path to the native server binary (default /usr/local/bin/DreamDaemon)
#
set -euo pipefail

cd "$(dirname "$0")/.."
ROOT="$PWD"

BUILD=1
PORT=1337
HOST=127.0.0.1

# Parse options: --no-build, --port N
args=()
while [ $# -gt 0 ]; do
	case "$1" in
	--no-build) BUILD=0 ;;
	--port) PORT="${2:?missing port}"; shift ;;
	--port=*) PORT="${1#*=}" ;;
	*) args+=("$1") ;;
	esac
	shift
done

# Optional explicit URL wins; otherwise default to localhost on the chosen port.
URL="${args[0]:-byond://$HOST:$PORT}"

# Native (non-Wine) server binary for BYOND.
DREAMDAEMON="${DREAMDAEMON:-/usr/local/bin/DreamDaemon}"
DMB="$ROOT/tgstation.dmb"

# tgstation's native server needs the Linux rust-g helper library, which the
# DM runtime loads from ~/.byond/bin/librust_g.so. Without it the world fails
# to initialize (undefined symbol: file_write / sql_connect_pool / ...).
ensure_rust_g() {
	# shellcheck source=dependencies.sh
	. "$ROOT/dependencies.sh"
	local target="$HOME/.byond/bin/librust_g.so"
	if [ -f "$target" ]; then
		echo ">> rust-g present: $target"
		return
	fi
	echo ">> Installing rust-g ${RUST_G_VERSION} for the native server..."
	mkdir -p "$HOME/.byond/bin"
	if ! wget -nv -O "$target" \
		"https://github.com/tgstation/rust-g/releases/download/${RUST_G_VERSION}/librust_g.so"; then
		echo "ERROR: failed to download rust-g. Install manually and re-run." >&2
		exit 1
	fi
	chmod +x "$target"
	echo ">> Installed rust-g to $target"
}
ensure_rust_g

if [ "$BUILD" -eq 1 ]; then
	echo ">> Building with DreamMaker via Wine..."
	DM_EXE="$ROOT/bin/wine-byond.sh" bash tools/build/build.sh build
fi

if [ ! -f "$DMB" ]; then
	echo "ERROR: $DMB not found. Run without --no-build (or build first)." >&2
	exit 1
fi

# Start the server if nothing is already listening on the port.
if ! (exec 3<>"/dev/tcp/$HOST/$PORT") 2>/dev/null; then
	echo ">> Starting server: $DREAMDAEMON $DMB -port $PORT -trusted"
	mkdir -p "$ROOT/data/logs"
	# Disowned background process so the server survives the client exiting.
	nohup "$DREAMDAEMON" "$DMB" -port "$PORT" -trusted >"$ROOT/data/logs/dreamseeker-server.log" 2>&1 &
	disown

	# Wait for the server to accept connections (BYOND can take a moment).
	echo ">> Waiting for server on $HOST:$PORT ..."
	for _ in $(seq 1 30); do
		if (exec 3<>"/dev/tcp/$HOST/$PORT") 2>/dev/null; then
			exec 3>&- 3<&- 2>/dev/null || true
			break
		fi
		sleep 1
	done
	if ! (exec 3<>"/dev/tcp/$HOST/$PORT") 2>/dev/null; then
		echo "ERROR: server did not come up on $HOST:$PORT (see data/logs/dreamseeker-server.log)." >&2
		exit 1
	fi
else
	echo ">> Server already listening on $HOST:$PORT; reusing it."
fi

echo ">> Launching DreamSeeker via Wine -> $URL"
exec "$ROOT/bin/wine-byond.sh" dreamseeker "$URL"
