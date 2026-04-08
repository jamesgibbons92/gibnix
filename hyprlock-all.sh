#!/usr/bin/env bash

set -euo pipefail

while read -r id; do
    hyprctl --instance "$id" keyword misc:allow_session_lock_restore 1
    hyprctl --instance "$id" dispatch exec hyprlock
done < <(hyprctl instances -j | jq -r '.[].instance')
