set -e
source env/bin/activate
dropdb creditask
createdb creditask
printf "\033[1;34mdatabase creditask dropped and recreated\e[39m\n"
DEBUG=True SECRET_KEY=dev_secret_key python3 ./manage.py migrate
printf "\033[1;34mmigrations ran\e[39m\n"
DEBUG=True SECRET_KEY=dev_secret_key python3 ./manage.py populate_dev_data
printf "\033[1;34mpopulated dev data\e[39m\n"
printf "\033[1;32mdatabase creditask has been reset, migrations have been run and dev data has been created\e[39m\n"
