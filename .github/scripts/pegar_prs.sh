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

SEARCH="merged:$(git log -1 --format=%cI $TAG_INICIAL)..$(git log -1 --format=%cI $TAG_FINAL)"
echo "SEARCH: $SEARCH"

gh pr list --base $PR_PARA_A_BRANCH \
--search "$SEARCH" --state merged \
--json title,author,url --jq '.[] | "* [\(.title)](\(.url)) - autor: @\(.author.login)"' | grep -E "$REGEX" > $RESULTADO
echo "finalizado"