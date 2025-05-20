# docker/backend/Dockerfile

FROM python:3.11.9-bookworm

WORKDIR /app

ADD ./backend/requirements.txt /app/backend/

run pip install --upgrade pip
run pip install gunicorn
run pip install -r backend/requirements.txt

add ./docker /app/docker
add ./backend /app/backend