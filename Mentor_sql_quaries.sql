create database mini_project;
drop database mini_project;
use mini_project;
drop table user_submissions;
CREATE TABLE user_sub_sql_mentor06nov(
  id INT AUTO_INCREMENT PRIMARY KEY,
  user_id BIGINT,
  question_id INT,
  points INT,
  submitted_at TIMESTAMP,
  username VARCHAR(50)
);

select * from user_sub_sql_mentor06nov;

-- alter-- -------------------
-- My Solutions
-- -------------------

-- Q.1 List all distinct users and their stats (return user_name, total_submissions, points earned)

SELECT 
    username,
    COUNT(*) AS total_submissions,
    SUM(points) AS points_earned
FROM
    user_sub_sql_mentor06nov
GROUP BY username
ORDER BY total_submissions DESC;


-- -- Q.2 Calculate the daily average points for each user.
-- each day
-- each user and their daily avg points
-- group by day and user

SELECT
  DATE_FORMAT(submitted_at, '%d-%m') AS month,
  username,
  AVG(points) AS daily_earned_points
FROM user_sub_sql_mentor06nov
GROUP BY username, DATE_FORMAT(submitted_at, '%d-%m')
order by username asc;


 -- Q.3 Find the top 3 users with the most correct submissions for each day.

-- each day
-- most correct submissions

select * from user_sub_sql_mentor06nov;

WITH daily_submissions AS (
  SELECT
    DATE_FORMAT(submitted_at, '%d-%m') AS daily,
    username,
    SUM(CASE WHEN points > 0 THEN 1 ELSE 0 END) AS correct_submissions
  FROM user_sub_sql_mentor06nov
  GROUP BY username, daily
),
user_rank AS (
  SELECT
    daily,
    username,
    correct_submissions,
    DENSE_RANK() OVER (PARTITION BY daily ORDER BY correct_submissions DESC) AS Rank1
  FROM daily_submissions
  ORDER BY daily, Rank1
)
SELECT 
  daily,
  username,
  correct_submissions
FROM user_rank
WHERE Rank1 <= 3
ORDER BY daily, Rank1;


-- Q.4 Find the top 5 users with the highest number of incorrect submissions.

SELECT 
	username,
	SUM(CASE 
		WHEN points < 0 THEN 1 ELSE 0
	END) as incorrect_submissions,
	SUM(CASE 
			WHEN points > 0 THEN 1 ELSE 0
		END) as correct_submissions,
	SUM(CASE 
		WHEN points < 0 THEN points ELSE 0
	END) as incorrect_submissions_points,
	SUM(CASE 
			WHEN points > 0 THEN points ELSE 0
		END) as correct_submissions_points_earned,
	SUM(points) as points_earned
FROM user_sub_sql_mentor06nov
GROUP BY username
ORDER BY incorrect_submissions DESC;


-- Q.5 Find the top 10 performers for each week.


SELECT *  
FROM (
    SELECT 
        WEEK(submitted_at) AS week_no,
        username,
        SUM(points) AS total_points_earned,
        DENSE_RANK() OVER (PARTITION BY WEEK(submitted_at) ORDER BY SUM(points) DESC) AS Rank1
    FROM user_sub_sql_mentor06nov
    GROUP BY week_no, username
    ORDER BY week_no, total_points_earned DESC
) AS ranked_submissions
WHERE Rank1 <= 10;

