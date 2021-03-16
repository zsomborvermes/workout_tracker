CREATE DATABASE workout_tracker;
USE workout_tracker;

CREATE TABLE user (
  user_id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  username VARCHAR(20),
  password VARCHAR(20)
);

CREATE TABLE exercise (
  exercise_id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(20),
  description VARCHAR(120)
);

CREATE TABLE workout (
  workout_id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  user_id INT UNSIGNED NOT NULL,
  name VARCHAR(20),
  date DATETIME,
  CONSTRAINT user_fk
    FOREIGN KEY (user_id) REFERENCES user(user_id)
    ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE workout_exercise (
  id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  workout_id INT UNSIGNED NOT NULL,
  exercise_id INT UNSIGNED NOT NULL,
  repetitions TINYINT UNSIGNED,
  weight TINYINT UNSIGNED,
  CONSTRAINT workout_fk
    FOREIGN KEY (workout_id) REFERENCES workout(workout_id)
    ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT exercise_fk
    FOREIGN KEY (exercise_id) REFERENCES exercise(exercise_id)
    ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE VIEW record_lifts
  AS SELECT
      MAX(exercise.name) AS exercise_name,
      MAX(user.user_id) AS user_id,
      MAX(username) AS username,
      MAX(workout_exercise.weight) AS personal_record
    FROM workout_exercise
    INNER JOIN workout
      ON workout_exercise.workout_id = workout.workout_id
    INNER JOIN exercise
      ON workout_exercise.exercise_id = exercise.exercise_id
    INNER JOIN user
      ON workout.user_id = user.user_id
    GROUP BY exercise.name;
    