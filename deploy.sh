#!/bin/bash

APP_DIR="/home/ubuntu/ec2-deployment"
APP_NAME="todo_app"
GUNICORN_CMD="gunicorn --bind 0.0.0.0:8000 todo_app.wsgi:application"

cd $APP_DIR

git pull origin main

pip install -r requirements.txt

python manage.py migrate

python manage.py collectstatic --noinput

pm2 delete $APP_NAME || true
pm2 start --name "$APP_NAME" "$GUNICORN_CMD"

pm2 save

pm2 startup
