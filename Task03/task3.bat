#!/bin/bash
chcp 65001

sqlite3 movies_rating.db < db_init.sql

echo "1. Составить список фильмов, имеющих хотя бы одну оценку. Список фильмов отсортировать по году выпуска и по названиям. В списке оставить первые 10 фильмов."
echo --------------------------------------------------
sqlite3 movies_rating.db -box -echo 'SELECT title FROM ratings INNER JOIN movies on movies.id = ratings.movie_id and year NOT NULL GROUP BY title HAVING count(movie_id) ORDER BY year,title LIMIT 10;'
echo ""

echo "2.Вывести список всех пользователей, фамилии (не имена!) которых начинаются на букву 'A'. Полученный список отсортировать по дате регистрации. В списке оставить первых 5 пользователей."
echo --------------------------------------------------
sqlite3 movies_rating.db -box -echo "SELECT name,register_date FROM users WHERE SUBSTRING(name ,instr(name,' ')+1,length(name)-1) like'A%' ORDER BY register_date LIMIT 5;"
echo ""

echo "3.Написать запрос, возвращающий информацию о рейтингах в более читаемом формате: имя и фамилия эксперта, название фильма, год выпуска, оценка и дата оценки в формате ГГГГ-ММ-ДД. Отсортировать данные по имени эксперта, затем названию фильма и оценке. В списке оставить первые 50 записей."
echo --------------------------------------------------
sqlite3 movies_rating.db -box -echo "SELECT users.name,title,year,rating,DATE(timestamp,'unixepoch') as date FROM ratings INNER JOIN movies on movies.id == ratings.movie_id INNER JOIN users on ratings.user_id = users.id ORDER BY users.name,title,rating LIMIT 50;"
echo ""

echo "4.Вывести список фильмов с указанием тегов, которые были им присвоены пользователями. Сортировать по году выпуска, затем по названию фильма, затем по тегу. В списке оставить первые 40 записей."
echo --------------------------------------------------
sqlite3 movies_rating.db -box -echo "SELECT title,tag FROM tags INNER JOIN movies on movie_id == movies.id WHERE year NOT NULL ORDER BY year,title,tag LIMIT 40;"
echo ""

echo "5.Вывести список самых свежих фильмов. В список должны войти все фильмы последнего года выпуска, имеющиеся в базе данных. Запрос должен быть универсальным, не зависящим от исходных данных (нужный год выпуска должен определяться в запросе, а не жестко задаваться)"
echo --------------------------------------------------
sqlite3 movies_rating.db -box -echo "SELECT title FROM movies WHERE year=(SELECT max(year) FROM movies);"
echo ""

echo "6.Найти все драмы, выпущенные после 2005 года, которые понравились женщинам (оценка не ниже 4.5). Для каждого фильма в этом списке вывести название, год выпуска и количество таких оценок. Результат отсортировать по году выпуска и названию фильма."
echo --------------------------------------------------
sqlite3 movies_rating.db -box -echo "SELECT drama.title,drama.year,count(drama.title) as number_rating FROM ratings INNER JOIN (SELECT title,id,year FROM movies WHERE geners LIKE '%Drama%' AND year > 2005) drama ON movie_id == drama.id INNER JOIN users ON ratings.user_id = users.id WHERE gender == 'female' GROUP BY drama.title ORDER BY drama.year,drama.title;"
echo ""

echo "7.Провести анализ востребованности ресурса - вывести количество пользователей, регистрировавшихся на сайте в каждом году. Найти, в каких годах регистрировалось больше всего и меньше всего пользователей."
echo --------------------------------------------------
sqlite3 movies_rating.db -box -echo "SELECT CAST(substr(register_date,0,5) as INT) as year, count(substr(register_date,0,5)) as amount_user FROM users GROUP BY year;"
echo ""

echo " Год в который зарегестрировалось меньше всех пользователей."
sqlite3 movies_rating.db -box -echo "SELECT year,min(amount_user) as user FROM (SELECT CAST(substr(register_date,0,5) as INT) as year, count(substr(register_date,0,5)) as amount_user FROM users GROUP BY year);"
echo ""

echo " Год в который зарегестрировалось больше всех пользователей."
sqlite3 movies_rating.db -box -echo "SELECT year,max(amount_user) as user FROM (SELECT CAST(substr(register_date,0,5) as INT) as year, count(substr(register_date,0,5)) as amount_user FROM users GROUP BY year);"
echo ""