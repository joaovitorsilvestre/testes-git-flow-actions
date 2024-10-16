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

# Temos que adicionar 10 segundos a mais, senão iremos pegar as mudanças da última tag também
HORARIO_TAG_INICIAL=$(TZ=UTC0 date -d @$(git log -1 --format="%at" $TAG_INICIAL) +%Y-%m-%dT%H:%M:%S%:z)
HORARIO_TAG_INICIAL=$(TZ=UTC0 date -d "$(date -d "$HORARIO_TAG_INICIAL" +%Y-%m-%dT%H:%M:%S%z) + 10 seconds" +%Y-%m-%dT%H:%M:%S%:z)

SEARCH="merged:$HORARIO_TAG_INICIAL..$(TZ=UTC0 date -d @$(git log -1 --format="%at" $TAG_FINAL) +%Y-%m-%dT%H:%M:%S%:z)"
echo "SEARCH: $SEARCH"

gh pr list --base $PR_PARA_A_BRANCH \
--search "$SEARCH" --state merged \
--json title,author,url --jq '.[] | "* [\(.title)](\(.url)) - autor: @\(.author.login)"' | grep -E "$REGEX" > $RESULTADO
echo "finalizado"
echo "resultado:"
cat $RESULTADO
echo "*************"