#!/bin/sh

# Wrapper for starting nginx, but also application that should be proxied
# through nginx, if given. Use template.lua to replace template variables inside nginx.conf.

# Application that will be started by nginx/openresty, should create "/tmp/app-initialized"
# so nginx can be started afterwards.

COMMAND=${@:1}
DEFAULT_CONF=nginx.conf
DEFAULT_ROOT="$(pwd)"
TOOLS=`dirname \`dirname $0\``
BUILDPACK="heroku-buildpack-openresty"

CONF="${1:-$DEFAULT_CONF}"
ROOT="${2:-$DEFAULT_ROOT}"
OUT_CONF="$CONF.compiled"

# prepare configuration first
cd "$ROOT"
cat "$CONF" | $TOOLS/template.lua > "$OUT_CONF"

if [[ ! -f "$OUT_CONF" ]]; then
    echo "Failed to generate $OUT_CONF! Bailing out..."
    exit 1
fi

if [[ -z $COMMAND ]]; then
    # no command, just run openresty
    echo "buildpack=$BUILDPACK at=start-app starting only openresty"
else
    # run appserver first, wait initialization step to completes and run openresty
    (
        echo "buildpack=$BUILDPACK at=start-app cmd=$COMMAND"
        $COMMAND
    ) &

    # appserver should produce /tmp/app-initialized when initialized so openresty can be
    # started then
    while [[ ! -f "/tmp/app-initialized" ]]; do
        echo "buildpack=$BUILDPACK at=app-initialization"
        sleep 1
    done

    echo "buildpack=$BUILDPACK at=app-initialized"
fi

# run nginx/openresty
nginx -p "$ROOT" -c "$OUT_CONF"
