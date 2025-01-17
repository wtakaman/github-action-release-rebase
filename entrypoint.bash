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
git init

git config user.name "Taka"
git config user.email "takaman@gmail.com"

git remote add origin "https://x-access-token:${GITHUB_TOKEN}@github.com/${GITHUB_REPOSITORY}.git"
git remote set-url origin "https://x-access-token:${GH_TOKEN}@github.com/${GITHUB_REPOSITORY}.git"

git remote -v
git remote update

# See https://git-scm.com/docs/git-rebase for options documentation
for branch in ${HEAD_BRANCHES}; do
echo "rebasing ${branch}" 
git checkout "origin/${branch}"
git rebase \
	origin/${BASE_REF}
echo "pushing ${branch}" 

git push --force origin "HEAD:${branch}"

echo "pushed ${branch}" 
done

exit 0
