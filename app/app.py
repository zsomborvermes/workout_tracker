from typing import List, Dict
from flask import Flask, render_template, request, redirect, url_for, flash, session, g
import mysql.connector
import json
from datetime import datetime
import sys
import functools
from db import Database

app = Flask(__name__)
app.config['SECRET_KEY'] = 'secret_key'

db_config = {
    'user': 'root',
    'password': 'root',
    'host': 'db',
    'port': '3306',
    'database': 'workout_tracker'
}

db = Database(**db_config)

connection = mysql.connector.connect(**db_config)
cursor = connection.cursor(dictionary=True)

def login_required(view):
    @functools.wraps(view)
    def wrapped_view(**kwargs):
        if g.user is None:
            return redirect(url_for('login'))

        return view(**kwargs)

    return 

@app.before_request
def load_logged_in_user():
    user_id = session.get('user_id')

    if user_id is None:
        g.user = None
    else:
        g.user = db.find_user_by_id(user_id)

@app.route('/')
def index():
    return render_template('base.html')

@app.route('/register', methods=('GET', 'POST'))
def register():
    if request.method == 'POST':
        username = request.form['username']
        password = request.form['password']
        error = None

        if not username:
            error = 'Username is required.'
        elif not password:
            error = 'Password is required.'
        else:
            if db.find_user_by_username(username) is not None:
                error = 'User {} is already registered.'.format(username)

        if error is None:
            db.create_user(username, password)
            return redirect(url_for('login'))

        flash(error)
    return render_template('register.html')

@app.route('/login', methods=('GET', 'POST'))
def login():
    if request.method == 'POST':
        username = request.form['username']
        password = request.form['password']
        error = None

        user = db.find_user_by_username(username)

        if user is None:
            error = 'Incorrect username.'
        elif not user['password'] == password:
            error = 'Incorrect password.'

        if error is None:
            session.clear()
            session['user_id'] = user['user_id']
            return redirect(url_for('workouts'))

        flash(error)

    return render_template('login.html')

@app.route('/logout')
def logout():
    session.clear()
    return redirect(url_for('index'))

@app.route('/workouts', methods=('GET', 'POST'))
def workouts():

    if g.user is None:
        return redirect(url_for('login'))

    user_id = session.get('user_id')
    if request.method == 'POST':
        workout_name = request.form['workout_name']
        db.create_workout(user_id, workout_name)
    
    workouts = db.find_workouts_by_user_id(user_id)
    return render_template('workouts.html', workouts = workouts)

@app.route('/workout/<workout_id>', methods=('GET', 'POST'))
def workout(workout_id):
    if g.user is None:
        return redirect(url_for('login'))

    user_id = session.get('user_id')

    workout = db.find_workout_by_workout_id(workout_id)

    if workout['user_id'] != user_id:
        return redirect(url_for('workouts'))

    if request.method == 'POST':
        exercise_name = request.form['exercise_name']
        repetitions = request.form['repetitions']
        weight = request.form['weight']

        exercise = db.find_exercise_by_name(exercise_name)

        if exercise is None:
            exercise_id = db.create_exercise(exercise_name)
        else:
            exercise_id = exercise['exercise_id']

        db.create_workout_exercise(workout_id, exercise_id, repetitions, weight)

    exercises = db.find_exercise_data_for_workout_by_workout_id(workout_id)
    return render_template('workout.html', exercises = exercises)

@app.route('/exercise_statistics')
def exercise_statistics():
    if g.user is None:
        return redirect(url_for('login'))

    user_id = session.get('user_id')
    exercise_statistics = db.find_exercise_statistics_by_user_id(user_id)

    return render_template('exercise_statistics.html', exercises = exercise_statistics)

@app.route('/record_lifts')
def record_lifts():
    records = db.find_all_record_lifts()

    return render_template('record_lifts.html', records = records)

if __name__ == '__main__':
    app.run(host='0.0.0.0')