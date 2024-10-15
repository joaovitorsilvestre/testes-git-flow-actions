# /bin/bash
set -e

PR_PARA_A_BRANCH="$1"
TAG_INICIAL="$2"
TAG_FINAL="$3"
REGEX="$4"
RESULTADO="$5"

echo "PR_PARA_A_BRANCH: $PR_PARA_A_BRANCH"
echo "TAG_INICIAL: $TAG_INICIAL"
echo "TAG_FINAL: $TAG_FINAL"
echo "REGEX: $REGEX"
echo "RESULTADO: $RESULTADO"

REPO_WITH_OWNER=$(git config --get remote.origin.url | sed 's/.*://;s/.git$//')

MERGED="$(git log -1 --format=%cI $TAG_INICIAL)..$(git log -1 --format=%cI $TAG_FINAL)"

gh search prs --base $PR_PARA_A_BRANCH \
--merged-at "$MERGED" --repo $REPO_WITH_OWNER \
--json title,author,url --jq '.[] | "* [\(.title)](\(.url)) - autor: @\(.author.login)"' | grep -E "$REGEX" > $RESULTADO