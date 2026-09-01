#!/usr/bin/env bash

source /smoke-common/lib.sh

assert_has waterfox
assert_shared_ok /usr/bin/waterfox

# The real binary reports "Waterfox <N>.<N>". The snap shim reports
# a different banner -- fail if we see the wrong one.
out=$(timeout 10 waterfox --version 2>&1 || true)
if printf '%s' "$out" | grep -Eq '^Waterfox [0-9]+'; then
  ok "firefox --version reports Waterfox ($out)"
else
  bad "firefox --version reports Waterfox (got: $out)"
fi

smoke_report
