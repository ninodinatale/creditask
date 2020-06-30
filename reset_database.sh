set -e
dropdb creditask
createdb creditask
printf "\033[1;34mdatabase creditask dropped and recreated\e[39m\n"
rm -f ./creditask/migrations/*.py
touch ./creditask/migrations/__init__.py
./manage.py makemigrations
./manage.py migrate
printf "\033[1;34mmigrations ran\e[39m\n"
./manage.py loaddata group.json
./manage.py loaddata user.json
./manage.py loaddata task_group.json
./manage.py loaddata task.json
printf "\033[1;34mloaded data fixtures\e[39m\n"
printf "\033[1;32mdatabase creditask has been reset and migrations have been run\e[39m\n"
