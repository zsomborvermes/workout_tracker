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

LOCK TABLES `exercise` WRITE;
/*!40000 ALTER TABLE `exercise` DISABLE KEYS */;
INSERT INTO `exercise` VALUES (1,'Benchpress',NULL),(2,'Incline Dumbell',NULL),(3,'Cable extension',NULL),(4,'Deadlift',NULL),(5,'Barbell row',NULL),(6,'Dumbell curl',NULL),(7,'Squat',NULL),(8,'Leg extension',NULL),(9,'Leg press',NULL),(10,'Dumbell row',NULL),(11,'Cable pulldown',NULL),(12,'Cable fly',NULL),(13,'Dips',NULL),(14,'Hammer curl',NULL);
/*!40000 ALTER TABLE `exercise` ENABLE KEYS */;
UNLOCK TABLES;

LOCK TABLES `user` WRITE;
/*!40000 ALTER TABLE `user` DISABLE KEYS */;
INSERT INTO `user` VALUES (1,'user_1','user_1'),(2,'user_2','user_2'),(3,'user_3','user_3');
/*!40000 ALTER TABLE `user` ENABLE KEYS */;
UNLOCK TABLES;


LOCK TABLES `workout` WRITE;
/*!40000 ALTER TABLE `workout` DISABLE KEYS */;
INSERT INTO `workout` VALUES (1,1,'Push','2021-03-17 18:05:15'),(2,1,'Pull','2021-03-17 18:07:47'),(3,2,'Leg','2021-03-17 18:10:06'),(4,2,'Upper body','2021-03-17 18:13:29'),(5,3,'Full body','2021-03-17 18:17:49'),(6,3,'Arms','2021-03-17 18:19:41');
/*!40000 ALTER TABLE `workout` ENABLE KEYS */;
UNLOCK TABLES;


LOCK TABLES `workout_exercise` WRITE;
/*!40000 ALTER TABLE `workout_exercise` DISABLE KEYS */;
INSERT INTO `workout_exercise` VALUES (1,1,1,10,60),(2,1,1,10,60),(3,1,1,6,80),(4,1,1,4,85),(5,1,2,10,20),(6,1,2,10,25),(7,1,2,8,30),(8,1,3,12,20),(9,1,3,10,22),(10,1,3,8,25),(11,2,4,10,100),(12,2,4,8,110),(13,2,4,8,110),(14,2,4,6,130),(15,2,5,12,30),(16,2,5,10,32),(17,2,5,8,35),(18,2,6,10,15),(19,2,6,10,15),(20,2,6,8,20),(21,3,7,10,80),(22,3,7,10,80),(23,3,7,8,100),(24,3,7,6,110),(25,3,8,10,60),(26,3,8,10,60),(27,3,8,8,65),(28,3,9,10,150),(29,3,9,10,150),(30,3,9,8,160),(31,4,1,10,60),(32,4,1,10,60),(33,4,1,8,80),(34,4,1,6,85),(35,4,10,10,30),(36,4,10,10,30),(37,4,10,10,30),(38,4,11,10,50),(39,4,11,10,60),(40,4,11,8,70),(41,4,12,15,5),(42,4,12,10,8),(43,4,12,10,8),(44,5,1,5,100),(45,5,1,4,110),(46,5,1,3,120),(47,5,1,3,125),(48,5,4,10,100),(49,5,4,6,140),(50,5,4,4,150),(51,5,4,3,155),(52,5,7,6,100),(53,5,7,4,130),(54,5,7,4,130),(55,5,7,3,132),(56,6,3,10,20),(57,6,3,10,20),(58,6,3,10,20),(59,6,6,10,10),(60,6,6,8,15),(61,6,6,8,15),(62,6,13,10,10),(63,6,13,10,15),(64,6,13,10,15),(65,6,14,10,15),(66,6,14,10,15),(67,6,14,8,20);
/*!40000 ALTER TABLE `workout_exercise` ENABLE KEYS */;
UNLOCK TABLES;