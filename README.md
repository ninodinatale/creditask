## Testing
### Checking coverage

1. Run tests with `coverage run --source='.' manage.py test` for everything, or:
- For everything:
  - `coverage run --source='./creditask/' --omit="**/test_**","**/__init.py","./creditask_django/**","./creditask/views.py"  manage.py test`
- For integration tests only:
  - `coverage run --source='./creditask/' --omit="**/test_**","**/__init.py","./creditask_django/**","./creditask/views.py"  manage.py test --tag=integration`
- For unit tests only:
  - `coverage run --source='./creditask/' --omit="**/test_**","**/__init.py","./creditask_django/**","./creditask/views.py"  manage.py test --tag=unit`
2. Run coverage report with `coverage report --sort=cover --skip-empty`.

## CI/CD
### Generate `schema.graphql`

Run `./manage.py graphql_schema --schema creditask.api.schema  --out schema.graphql`
