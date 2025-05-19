# docker/backend/Dockerfile

FROM python:3.11.9-bookworm

WORKDIR /app/backend

COPY requirements.txt .
RUN pip install --upgrade pip && pip install -r requirements.txt

COPY . .

RUN python manage.py collectstatic --noinput