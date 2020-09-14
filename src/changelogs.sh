#!/bin/bash

REPOS_LEVEL4=`metwork_repos.py --minimal-level=4 |xargs`
REPOS_LEVEL3=`metwork_repos.py --minimal-level=3 |xargs`

for REPO in ${REPOS_LEVEL4}; do
    _generate_changelog.sh "${REPO}" integration origin/integration origin/integration origin/release_0.9 xxxxxxxx CHANGELOG.md
    _generate_changelog.sh "${REPO}" integration origin/release_0.9 origin/release_0.9 origin/release_0.8 "v0.9.*" CHANGELOG-0.9.md
    _generate_changelog.sh "${REPO}" integration origin/release_0.8 origin/release_0.8 origin/release_0.7 "v0.8.*" CHANGELOG-0.8.md
    _generate_changelog.sh "${REPO}" integration origin/release_0.7 origin/release_0.7 origin/release_0.6 "v0.7.*" CHANGELOG-0.7.md

    _generate_changelog.sh "${REPO}" release_0.9 origin/release_0.9 origin/release_0.9 origin/release_0.8 "v0.9.*" CHANGELOG.md
    _generate_changelog.sh "${REPO}" release_0.9 origin/release_0.8 origin/release_0.8 origin/release_0.7 "v0.8.*" CHANGELOG-0.8.md
    _generate_changelog.sh "${REPO}" release_0.9 origin/release_0.7 origin/release_0.7 origin/release_0.6 "v0.7.*" CHANGELOG-0.7.md

    _generate_changelog.sh "${REPO}" release_0.8 origin/release_0.8 origin/release_0.8 origin/release_0.7 "v0.8.*" CHANGELOG.md
    _generate_changelog.sh "${REPO}" release_0.8 origin/release_0.7 origin/release_0.7 origin/release_0.6 "v0.7.*" CHANGELOG-0.7.md

    _generate_changelog.sh "${REPO}" release_0.7 origin/release_0.7 origin/release_0.7 origin/release_0.6 "v0.7.*" CHANGELOG.md
done

for REPO in ${REPOS_LEVEL3}; do
    FOUND=0
    for REPO2 in ${REPOS_LEVEL4}; do
        if test "${REPO}" = "${REPO2}"; then
            FOUND=1
            break
        fi
    done
    if test ${FOUND} -eq 0; then
        _generate_changelog.sh "${REPO}" master master master "nothinghere" "v*" CHANGELOG.md
    fi
done
