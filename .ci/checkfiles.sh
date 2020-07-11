#!/bin/bash

rm out.log

find Core -type f -name "*.qs" -exec ./.ci/checkfile.sh {} \;
find Patches -type f -name "*.qs" -exec ./.ci/checkfile.sh {} \;
find Patches -type f -name "*.txt" -exec ./.ci/checkfile.sh {} \;
find Addons -type f -name "*.qs" -exec ./.ci/checkfile.sh {} \;
find Input -type f -name "*.txt" -exec ./.ci/checkfile.sh {} \;

export DATA=$(cat out.log|grep -v "Input/msgStringEng.txt")
if [[ -n "${DATA}" ]]; then
    echo "Found wrong chars in files"
    cat out.log|grep -v "Input/msgStringEng.txt"
    exit 1
fi

export DATA=$(git diff)
if [[ -n "${DATA}" ]]; then
    echo "Found wrong end lines or tabs or BOM chars in files"
    git diff
    exit 1
fi
