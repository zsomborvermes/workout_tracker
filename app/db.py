import mysql.connector

class Database:
    def __init__(self, **kwargs):
        self.connection = mysql.connector.connect(**kwargs)
        self.cursor = self.connection.cursor(dictionary=True)

    def find_user_by_id(self, user_id):
        self.cursor.execute(f"SELECT * FROM user WHERE user_id = '{user_id}'")

        return self.cursor.fetchone()

    def find_user_by_username(self, username):
        self.cursor.execute(f"SELECT * FROM user WHERE username = '{username}'")
        
        return self.cursor.fetchone()

    def create_user(self, username, password):
        self.cursor.execute(f"INSERT INTO user (username, password) VALUES ('{username}', '{password}')")
        self.connection.commit()

        return self.cursor.lastrowid

    def create_workout(self, user_id, workout_name):
        self.cursor.execute(f"INSERT INTO workout VALUES (0, {user_id},'{workout_name}', NOW())")
        self.connection.commit()

        return self.cursor.lastrowid

    def find_workouts_by_user_id(self, user_id):
        self.cursor.execute(f"SELECT * FROM workout WHERE user_id = {user_id}")

        return self.cursor.fetchall()
    
    def find_workout_by_workout_id(self, workout_id):
        self.cursor.execute(f"SELECT * FROM workout WHERE workout_id = {workout_id}")

        return self.cursor.fetchone()

    def find_exercise_by_name(self, exercise_name):
        self.cursor.execute(f"SELECT * FROM exercise WHERE name = '{exercise_name}'")
        return self.cursor.fetchone()
    
    def create_exercise(self, exercise_name):
        self.cursor.execute(f"INSERT INTO exercise VALUES (0, '{exercise_name}', NULL)")
        self.connection.commit()

        return self.cursor.lastrowid
    
    def create_workout_exercise(self, workout_id, exercise_id, repetitions, weight):
        self.cursor.execute(f"INSERT INTO workout_exercise VALUES (0, {workout_id}, {exercise_id}, {repetitions}, {weight})")
        self.connection.commit()

        return self.cursor.lastrowid

    def find_exercise_data_for_workout_by_workout_id(self, workout_id):
        self.cursor.execute(("SELECT name, repetitions, weight "
                            "FROM workout_exercise "
                            "INNER JOIN exercise "
                            "ON workout_exercise.exercise_id = exercise.exercise_id "
                            f"WHERE workout_id = {workout_id}"))

        return self.cursor.fetchall()

    def find_exercise_statistics_by_user_id(self, user_id):
        self.cursor.execute(("SELECT "
                                "exercise.name AS name, "
                                "ROUND(AVG(weight), 1) AS avg_weight, "
                                "MAX(weight) AS max_weight, "
                                "ROUND(AVG(repetitions), 1) AS avg_reps, "
                                "SUM(repetitions) AS total_reps "
                            "FROM workout_exercise "
                            "INNER JOIN workout "
                                "ON workout_exercise.workout_id = workout.workout_id "
                            "INNER JOIN exercise "
                                "ON workout_exercise.exercise_id = exercise.exercise_id "
                            f"WHERE user_id = {user_id} "
                            "GROUP BY exercise.name"))

        return self.cursor.fetchall()
 
    def find_all_record_lifts(self):
        self.cursor.execute("SELECT * FROM record_lifts")

        return self.cursor.fetchall()