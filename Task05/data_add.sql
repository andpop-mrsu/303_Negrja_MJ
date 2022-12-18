INSERT INTO users (first_name,last_name,email,gender,occupation_id) VALUES ("Maksim","Negrya","maksim.negrya@bk.ru","male",19);
INSERT INTO users (first_name,last_name,email,gender,occupation_id) VALUES ("Dmitry","Katin","katin.dmitry@icloud.com","male",19);
INSERT INTO users (first_name,last_name,email,gender,occupation_id) VALUES ("Maxim","Negrya","maxi_n@gmai.com","male",19);
INSERT INTO users (first_name,last_name,email,gender,occupation_id) VALUES ("Egor","Melyakin","egor_m@outlook.com","male",19);
INSERT INTO users (first_name,last_name,email,gender,occupation_id) VALUES ("Margar","Melkonyan","margar.melkonyan@bk.ru","male",19);


INSERT INTO movies(title,year) VALUES
('Iron Man',2012),
('Mob Psycho 100 III',2022),
('Stranger things 4',2022);

INSERT INTO ratings(user_id,movie_id,rating) VALUES
((SELECT id FROM users WHERE email="maksim.negrya@bk.ru" ),
(SELECT id FROM movies WHERE title="Iron Man"),      4.5),
((SELECT id FROM users WHERE email="maksim.negrya@bk.ru" ),
(SELECT id FROM movies WHERE title="Mob Psycho 100 III"),3.5),
((SELECT id FROM users WHERE email="maksim.negrya@bk.ru" ),
(SELECT id FROM movies WHERE title="Stranger things 4"), 5.0);