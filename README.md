## Testing
### Checking coverage

1. Run tests with `coverage run --source='.' manage.py test`.
2. Run coverage report with `coverage report`.

## CI/CD
### Generate `schema.graphql`

Run `./manage.py graphql_schema --schema creditask.schema.schema  --out schema.graphql`
