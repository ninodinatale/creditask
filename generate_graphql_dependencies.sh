set -e
./manage.py graphql_schema --schema creditask.api.schema --out schema.graphql
cd ./frontend/ && npm run codegen && cd ../
LIGHT_GREEN='\033[1;32m'
printf "\033[1;32m Generated /schema.graphql and /frontnend/src/graphql/types.tsx\n"
