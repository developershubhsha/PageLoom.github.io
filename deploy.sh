#!/bin/zsh
set -euo pipefail

cd "$(dirname "$0")"

if ! command -v gh >/dev/null && [[ ! -x ../.tools/gh ]]; then
  echo "Install GitHub CLI, then run: gh auth login"
  exit 1
fi

GH="${GH:-$(command -v gh || true)}"
if [[ -z "${GH}" && -x ../.tools/gh ]]; then
  GH="../.tools/gh"
fi

if ! "$GH" auth status >/dev/null 2>&1; then
  echo "Log in to GitHub first:"
  echo "  $GH auth login"
  exit 1
fi

if [[ ! -d .git ]]; then
  git init
  git add index.html privacy.html styles.css README.md
  git commit -m "Add PageLoom support and privacy pages."
fi

USER="$("$GH" api user --jq .login)"
if ! git remote get-url origin >/dev/null 2>&1; then
  "$GH" repo create pageloom-support --public --source=. --remote=origin --push
else
  git push -u origin HEAD
fi

"$GH" api -X POST "repos/${USER}/pageloom-support/pages" \
  -f build_type=legacy \
  -f "source[branch]=main" \
  -f "source[path]=/" >/dev/null 2>&1 || true

echo
echo "Support:  https://${USER}.github.io/pageloom-support/"
echo "Privacy:  https://${USER}.github.io/pageloom-support/privacy.html"
