#!/bin/bash

REPOS_LEVEL4=`metwork_repos.py --minimal-level=4 |xargs`
REPOS_LEVEL3=`metwork_repos.py --minimal-level=3 |xargs`

LATEST_RELEASE=origin/release_0.6
LATEST_TAGS=v0.6.*
BEFORE_RELEASE=origin/release_0.5

for REPO in ${REPOS_LEVEL4}; do
    _generate_changelog.sh "${REPO}" integration origin/integration origin/integration "${BEFORE_RELEASE}" "${LATEST_TAGS}" CHANGELOG.md
    _generate_changelog.sh "${REPO}" integration origin/release_0.5 origin/release_0.5 origin/release_0.4 "v0.5.*" CHANGELOG-0.5.md
    _generate_changelog.sh "${REPO}" integration origin/release_0.4 origin/release_0.4 origin/release_0.3 "v0.4.*" CHANGELOG-0.4.md
    _generate_changelog.sh "${REPO}" release_0.5 origin/release_0.5 origin/release_0.5 origin/release_0.4 "v0.5.*" CHANGELOG.md
    _generate_changelog.sh "${REPO}" release_0.6 origin/release_0.6 origin/release_0.6 origin/release_0.5 "v0.6.*" CHANGELOG.md
done

exit 0

for REPO in ${REPOS_LEVEL3}; do
    FOUND=0
    for REPO2 in ${REPOS_LEVEL4}; do
        if test "${REPO}" = "${REPO2}"; then
            FOUND=1
            break
        fi
    done
    if test ${FOUND} -eq 0; then
        _generate_changelog.sh "${REPO}" master master master "nothing here" "v*" CHANGELOG.md
    fi
done
