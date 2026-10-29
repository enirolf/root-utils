#!/usr/bin/env bash

function remove_branches {
  BRANCH_LIST=$1
  for branch in $BRANCH_LIST; do
    git branch -D "$branch"
  done
}

echo "** Fetching remote branches"
git fetch --prune origin

STALE_BRANCHES=$(git branch -v | rg '\[gone\]' | sed 's/^..//' | cut -d' ' -f1)

if [[ -z "$STALE_BRANCHES" ]]; then
  echo "** Nothing to remove!"
  exit 0
fi

echo ** The following branches will be removed:
echo "$STALE_BRANCHES"

read -p "** Proceed (y/n)? " choice
case "$choice" in
y | Y) remove_branches "$STALE_BRANCHES" ;;
n | N) echo "Leaving the branches as-is" ;;
*)
  echo "invalid"
  exit 1
  ;;
esac
