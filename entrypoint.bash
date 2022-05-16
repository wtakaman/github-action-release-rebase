#!/usr/bin/env bash

# Exit immediately if a pipeline, list, simple or compound command returns a
# non-zero status
set -e

BASE_REF=$1
HEAD_BRANCHES=$2

if [[ -z "${BASE_REF}" ]]; then
  echo "Missing \$BASE_REF"
  exit 1
fi

if [[ -z "${HEAD_BRANCHES}" ]]; then
  echo "Missing \$HEAD_BRANCHES"
  exit 1
fi

if ! git check-ref-format --allow-onelevel --normalize "${BASE_REF}"; then
  echo "BASE_REF is invalid: ${BASE_REF}"
else
  BASE_REF=$(git check-ref-format --allow-onelevel --normalize "${BASE_REF}")
fi

echo "BASE_REF=${BASE_REF}"
echo "HEAD_BRANCHES=${HEAD_BRANCHES}"

mkdir _tmp && cd _tmp


git remote -v
git remote update

for branch in ${HEAD_BRANCHES}; do
git rebase --autosquash --autostash -s recursive -X patience \
	"origin/${BASE_REF}" "origin/${branch}"
git push --force origin "HEAD:${branch}"
done

exit 0
