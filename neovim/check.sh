#!/usr/bin/env bash
#===============================================================================
#
#          FILE: check.sh
#
#         USAGE: ./check.sh [-h] [-s]
#
#   DESCRIPTION: Headless verification of the Neovim setup. Runs plugins.sh (lazy
#                sync plus Mason server install), then opens one fixture file per
#                language and checks that the expected language servers attach,
#                conform has a formatter, nvim-lint has a linter, and the PATH tools
#                exist. Exit status is non-zero on any failure. Needs network on the
#                first run. The checks themselves are in check.lua.
#
#       OPTIONS:
#                  -h: Print the usage and exit
#                  -s: Skip plugins.sh (plugins and servers already installed)
#
#===============================================================================

set -Eeuo pipefail

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
skip_sync=false

usage() {
    echo "Usage: check.sh [-h] [-s]"
    echo "    -h: print the usage and exit"
    echo "    -s: skip plugins.sh (plugins and servers already installed)"
    exit "$1"
}

while getopts "hs" option; do
    case "${option}" in
        h)
            usage 0
            ;;
        s)
            skip_sync=true
            ;;
        *)
            usage 1
            ;;
    esac
done

if [[ "${skip_sync}" == false ]]; then
    "${script_dir}/plugins.sh"
fi

fixtures="$(mktemp -d)"
trap 'rm -rf "${fixtures}"' EXIT

# A git repo so every server resolves the same root, as in real use
git init -q "${fixtures}"
mkdir -p "${fixtures}/crate/src" "${fixtures}/mod"
printf '#!/usr/bin/env bash\necho hi\n' > "${fixtures}/a.sh"
printf '[package]\nname = "check"\nversion = "0.1.0"\nedition = "2021"\n' > "${fixtures}/crate/Cargo.toml"
printf 'fn main() {}\n' > "${fixtures}/crate/src/main.rs"
printf 'int main(void) {\n    return 0;\n}\n' > "${fixtures}/a.c"
printf 'import os\n\n\ndef f() -> int:\n    return 1\n' > "${fixtures}/a.py"
printf 'local x = 1\nreturn x\n' > "${fixtures}/a.lua"
printf 'pub fn main() void {}\n' > "${fixtures}/a.zig"
printf 'module check\n\ngo 1.21\n' > "${fixtures}/mod/go.mod"
printf 'package main\n\nfunc main() {}\n' > "${fixtures}/mod/main.go"
printf 'FROM alpine:3.20\n' > "${fixtures}/Dockerfile"
printf 'all:\n\ttrue\n' > "${fixtures}/Makefile"

# -c runs after init.lua and the plugins have loaded (-l would skip both)
nvim --headless -n -i NONE \
    -c "lua _G.CHECK_DIR = '${fixtures}'" \
    -c "luafile ${script_dir}/check.lua"
