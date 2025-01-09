#!/bin/bash

# Generate .env file for the frontend
daytona env list | sed 's/: /=/g' > ./frontend/.env
if [ $? -ne 0 ]; then
    echo "Failed to generate .env file"
    exit 1
fi

# Start the frontend
npm start --prefix frontend &
if [ $? -ne 0 ]; then
    echo "Failed to start the frontend"
    exit 1
fi

# Apply database migrations
python backend/manage.py makemigrations
if [ $? -ne 0 ]; then
    echo "Failed to make migrations"
    exit 1
fi

python backend/manage.py migrate
if [ $? -ne 0 ]; then
    echo "Failed to migrate the database"
    exit 1
fi

# Start the Django server
python backend/manage.py runserver 0.0.0.0:8000
