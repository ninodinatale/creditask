set -e
dropdb creditask
createdb creditask
printf "\033[1;34mdatabase creditask dropped and recreated\e[39m\n"
rm -f ./creditask/migrations/*.py
touch ./creditask/migrations/__init__.py
./manage.py makemigrations
./manage.py migrate
printf "\033[1;34mmigrations ran\e[39m\n"
./manage.py populate_dev_data
printf "\033[1;34mpopulated dev data\e[39m\n"
printf "\033[1;32mdatabase creditask has been reset, migrations have been run and dev data has been created\e[39m\n"
