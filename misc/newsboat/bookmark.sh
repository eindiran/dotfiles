#!/usr/bin/env bash
#===============================================================================
#
#          FILE: bookmark.sh
#
#         USAGE: ./bookmark.sh <url> [<title> <description>]
#
#   DESCRIPTION: Bookmark a page from within newsboat.
#
#       OPTIONS:
#                *         URL: [required] URL to visit and bookmark.
#                *       TITLE: [optional] Title to list in .newsboat/bookmarks
#                * DESCRIPTION: [optional] Description to list in .newsboat/bookmarks
#
#  REQUIREMENTS: curl
#
#         NOTES: This is taken very heavily based on this script:
#                https://github.com/gpakosz/.newsboat/blob/master/bookmark.sh
#===============================================================================

set -Eeuo pipefail

URL="$1"
TITLE="$2"
DESCRIPTION="$3"

if [ "$#" -lt 1 ]; then
    printf "Usage: ./bookmark.sh <url> [<title> <description>]\n"
    exit 1
else
    URL="$(curl -sIL -o /dev/null -w '%{url_effective}' "${URL}")"
fi

URL="$(echo "${URL}" | perl -pe 's/(\?|\&)?utm_[a-z]+=[^\&]+//g;' -e 's/(#|\&)?utm_[a-z]+=[^\&]+//g;')"

grep -q "${URL}\t${TITLE}\t${DESCRIPTION}" ~/.newsboat/bookmarks || printf "%s\t%s\t%s\n" "${URL}" "${TITLE}" "${DESCRIPTION}" >> ~/.newsboat/bookmarks
