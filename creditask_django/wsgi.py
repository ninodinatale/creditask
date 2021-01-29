"""
WSGI config for creditask_django project.

It exposes the WSGI callable as a module-level variable named ``application``.

For more information on this file, see
https://docs.djangoproject.com/en/3.0/howto/deployment/wsgi/
"""

import os

import firebase_admin
from django.core.wsgi import get_wsgi_application

os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'creditask_django.settings')

FILE_PATH = './service-account-file.json'
try:
    os.remove(FILE_PATH)
except OSError:
    pass
with open(FILE_PATH, 'x') as f:
    f.write(
        os.environ.get('GOOGLE_APPLICATION_CREDENTIALS_JSON_STR'))
    f.close()

print(os.path.abspath(FILE_PATH))
os.environ['GOOGLE_APPLICATION_CREDENTIALS'] = os.path.abspath(FILE_PATH)
default_app = firebase_admin.initialize_app()

application = get_wsgi_application()
