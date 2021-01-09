set -e
DEBUG=True SECRET_KEY=dev_secret_key python3 ./manage.py graphql_schema --schema creditask.api.schema --out frontend/schema.graphql
cd ./frontend
sh devops/generate_artemis.sh
