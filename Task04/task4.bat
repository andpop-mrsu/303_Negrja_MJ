#!/bin/bash

chcp 65001

sqlite3 movies_rating.db < db_init.sql

echo "1. Найти все пары пользователей, оценивших один и тот же фильм. Устранить дубликаты, проверить отсутствие пар с самим собой. Для каждой пары должны быть указаны имена пользователей и название фильма, который они ценили."
echo --------------------------------------------------
sqlite3 movies_rating.db -box -echo "SELECT DISTINCT u.name,u2.name,mov.title FROM ratings t1,ratings t2 CROSS JOIN movies ON t1.movie_id = t2.movie_id INNER JOIN movies mov ON mov.id = t1.movie_id INNER JOIN  users u on t1.user_id = u.id INNER JOIN users u2 on t2.user_id =u2.id WHERE t1.user_id != t2.user_id LIMIT 50;"
echo ""

echo "2. Найти 10 самых старых оценок от разных пользователей, вывести названия фильмов, имена пользователей, оценку, дату отзыва в формате ГГГГ-ММ-ДД."
echo --------------------------------------------------
sqlite3 movies_rating.db -box -echo 'SELECT m.title,u.name,rating, DATE(timestamp,"unixepoch") AS year FROM ratings INNER JOIN users u ON u.id = user_id INNER JOIN movies m on m.id = ratings.movie_id GROUP BY user_id ORDER BY year LIMIT 10;'
echo ""

echo "3. Вывести в одном списке все фильмы с максимальным средним рейтингом и все фильмы с минимальным средним рейтингом. Общий список отсортировать по году выпуска и названию фильма. В зависимости от рейтинга в колонке “Рекомендуем” для фильмов должно быть написано “Да” или “Нет”."
echo --------------------------------------------------
sqlite3 movies_rating.db -box -echo "SELECT title,year,score,recommendation FROM movies INNER JOIN (SELECT movie_id,AVG_SCORE as score, CASE AVG_SCORE WHEN max_rating THEN 'Yes' WHEN min_rating THEN 'No' END 'recommendation' FROM (SELECT min(min_max_rating) AS min_rating ,max(min_max_rating) AS max_rating  FROM (SELECT movie_id,AVG(rating) AS min_max_rating FROM ratings GROUP BY movie_id)), (SELECT AVG(rating) AS AVG_SCORE,movie_id FROM ratings GROUP BY movie_id) WHERE AVG_SCORE = min_rating or AVG_SCORE = max_rating) ON movies.id = movie_id WHERE year NOT NULL ORDER BY year,title;"
echo ""

echo "4. Вычислить количество оценок и среднюю оценку, которую дали фильмам пользователи-мужчины в период с 2011 по 2014 год."
echo --------------------------------------------------
sqlite3 movies_rating.db -box -echo 'SELECT COUNT(rating) AS number_rating , ROUND(AVG(rating),1) AS average_score FROM (SELECT substr(DATE(timestamp,"unixepoch"),1,4) date,rating,user_id,movie_id FROM ratings WHERE date >= "2011"  and date <= "2014") INNER JOIN users u ON user_id=u.id WHERE u.gender == "male";'
echo ""

echo "5. Составить список фильмов с указанием средней оценки и количества пользователей, которые их оценили. Полученный список отсортировать по году выпуска и названиям фильмов. В списке оставить первые 20 записей."
echo --------------------------------------------------
sqlite3 movies_rating.db -box -echo "SELECT title,avg_score,amount_usr FROM movies INNER JOIN (SELECT count(user_id) AS amount_usr,movie_id,AVG(rating) AS avg_score FROM ratings GROUP BY movie_id) m ON m.movie_id = movies.id ORDER BY year,title LIMIT 20"
echo ""

echo "6. Определить самый распространенный жанр фильма и количество фильмов в этом жанре. Отдельную таблицу для жанров не использовать, жанры нужно извлекать из таблицы movies."
echo --------------------------------------------------
sqlite3 movies_rating.db -box -echo "WITH sub_gener as (SELECT geners as str, geners as s_str from movies UNION ALL SELECT CASE WHEN instr(gener.s_str, '|') != 0 then substr(gener.s_str, 0, instr(gener.s_str, '|')) ELSE gener.s_str END str, CASE   WHEN instr(gener.s_str, '|') != 0 then substr(gener.s_str, instr(gener.s_str, '|') + 1) ELSE 'd' END s_str FROM sub_gener gener WHERE s_str != 'd') SELECT str as movie_gener,count(str) AS amount_movie FROM sub_gener WHERE s_str != str GROUP BY str ORDER BY amount_movie DESC LIMIT 1;"
echo ""

echo "7. Вывести список из 10 последних зарегистрированных пользователей в формате “Фамилия Имя|Дата регистрации” (сначала фамилия, потом имя)."
echo --------------------------------------------------
sqlite3 movies_rating.db -box -echo 'SELECT name, register_date FROM (SELECT substr(name,instr(name," ")+1,length(name)) || " " || substr(name,1,instr(name," ")) AS name, register_date  FROM users ORDER BY register_date DESC LIMIT 10);'
echo ""

echo "8. С помощью рекурсивного CTE определить, на какие дни недели приходился ваш день рождения в каждом году."
echo --------------------------------------------------
sqlite3 movies_rating.db -box -echo "WITH date_ AS (SELECT DATE('2002-04-11') as birthday UNION SELECT DATE(birthday,'1 year') FROM date_ WHERE birthday < DATE('now')) SELECT substr(birthday,0,5) AS year, CASE STRFTIME('%w',birthday) WHEN '0' THEN 'Sunday' WHEN '1'THEN 'Monday' WHEN '2' THEN 'Tuesday' WHEN '3' THEN 'Wednesday' WHEN '4' THEN 'Thursday' WHEN '5' THEN 'Friday'WHEN '6' THEN 'Saturday' END birth_day FROM date_;"
echo ""