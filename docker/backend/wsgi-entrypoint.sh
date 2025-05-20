#!/bin/sh

until cd /app/backend/wordblox
do
    echo "Waiting for server volume"
done

./manage.py makemigrations

until ./manage.py migrate
do
    echo "Waiting for db to be ready..."
    sleep 2
done

./manage.py collectstatic --noinput

gunicorn wordblox.wsgi --bind 0.0.0.0:8000 --workers 4 --threads 4