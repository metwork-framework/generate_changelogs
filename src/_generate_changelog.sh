#!/bin/bash

set -e

ORG=metwork-framework

if test "${7:-}" = ""; then
  echo "usage: _generate_changelog.sh REPO-NAME BRANCH REV INCLUDE EXCLUDE TAG_FILTER CHANGELOG_NAME"
  exit 1
else
  REPO=$1
fi
BRANCH=$2
REV=$3
INCLUDE=$4
EXCLUDE=$5
TAG_FILTER=$6
CHANGELOG_NAME=$7
if test "${MFSERV_CURRENT_PLUGIN_NAME:-}" = ""; then
    echo "ERROR: load the plugin environnement before"
    exit 1
fi

TMPREPO=${TMPDIR:-/tmp}/generate_changelog_$$

rm -Rf "${TMPREPO}"
mkdir -p "${TMPREPO}"
cd "${TMPREPO}"
git clone "git@github.com:${ORG}/${REPO}"

cd "${REPO}"
git checkout -b "changelog_automatic_update" --track "origin/${BRANCH}"
FIRST_CHANGELOG=0
if ! test -f ${CHANGELOG_NAME}; then
    FIRST_CHANGELOG=1
fi

if test "${REV}" = "origin/integration" -o "${REV}" = "master"; then
  TITLE="CHANGELOG"
else
  TITLE="`echo "${REV}" |sed 's~origin/~~g'` CHANGELOG"
fi

auto-changelog --template-dir="${MFSERV_CURRENT_PLUGIN_DIR}/templates" --title="${TITLE}" --rev=${REV} --exclude-branches=${EXCLUDE} --include-branches=${INCLUDE} --tag-filter=${TAG_FILTER} --output=./${CHANGELOG_NAME}

if test "${FIRST_CHANGELOG}" = "1"; then
    N=1
else
    N=$(git diff |wc -l)
fi
if test "${N}" -gt 0; then
  git add ${CHANGELOG_NAME}
  git commit -m "chore: CHANGELOG update"
  git push -u origin -f changelog_automatic_update
  SHA=$(git rev-parse HEAD)
  metwork_valid_merge_logic_status.py "${REPO}" "${SHA}"
  if test "${BRANCH}" = "master"; then
    git checkout master
  else
    git checkout -b "${BRANCH}" --track "origin/${BRANCH}"
  fi
  git merge changelog_automatic_update
  git push -u origin "${BRANCH}"
  git push origin --delete changelog_automatic_update
fi

rm -Rf "${TMPREPO}"
echo "DONE"
