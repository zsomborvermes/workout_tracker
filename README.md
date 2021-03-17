# workout_tracker

## Project setup option 1: DOCKER

If you have docker installed on your machine the setup of the project is simple.

Go into the project folder and run

```shell
docker-compose up --build
```
This will start 2 docker containers, one for the Flask application and one for mysql.
The startup script will copy /app folder into the app conainer, install the requirements and start the application.
The database container will start up and run init.sql from the /db folder to create the database and tables and fill it with sample data.
The app container will wait until the database is done with the startup.
The application will be accessible on localhost:5000


## Project setup option 1: MANUAL

If you don't have docker on your machine you can still start up the project manually.
You need to have installed python 3 and pip and also need to have your own mysql database (best if you have mysql 5.7).

First go into the /app folder and run

```shell
pip install -r requirements.txt
```
After you have the requirements installed go into /app folder and open app.py.
Modify db_config on line 13 to your own mysql configuration.

Run init.sql on your database, to create the database and tables and fill it with sample data.

Go back to /app and start the application by running

```shell
python3 app.py
```
The application will be accessible on localhost:5000