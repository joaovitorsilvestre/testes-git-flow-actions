# /bin/bash
set -e

PR_PARA_A_BRANCH="$1"
TAG_INICIAL="$2"
TAG_FINAL="$3"
REGEX="$4"
RESULTADO="$5"

# gratante que tem a evn NOME_DO_REPOSITORIO_COM_OWNER
if [ -z "$NOME_DO_REPOSITORIO_COM_OWNER" ]; then
  echo "env NOME_DO_REPOSITORIO_COM_OWNER não foi definido"
  exit 1
fi

echo "PR_PARA_A_BRANCH: $PR_PARA_A_BRANCH"
echo "TAG_INICIAL: $TAG_INICIAL"
echo "TAG_FINAL: $TAG_FINAL"
echo "REGEX: $REGEX"
echo "RESULTADO: $RESULTADO"

MERGED="$(git log -1 --format=%cI $TAG_INICIAL)..$(git log -1 --format=%cI $TAG_FINAL)"

gh search prs --base $PR_PARA_A_BRANCH \
--merged-at "$MERGED" --repo $NOME_DO_REPOSITORIO_COM_OWNER \
--json title,author,url --jq '.[] | "* [\(.title)](\(.url)) - autor: @\(.author.login)"' | grep -E "$REGEX" > $RESULTADO