#!/bin/sh

cd farnsworth
./manage.py runserver 0.0.0.0:8000 &

cd ../farnsworth-web
./node_modules/.bin/ember serve --live-reload false &

cd ../terry
./node_modules/.bin/ember serve --live-reload false
