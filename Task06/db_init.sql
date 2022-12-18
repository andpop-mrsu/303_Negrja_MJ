PRAGMA FOREIGN_KEYS = ON;

DROP TABLE IF EXISTS categories;
DROP TABLE IF EXISTS registrations;
DROP TABLE IF EXISTS workers;
DROP TABLE IF EXISTS specializations;
DROP TABLE IF EXISTS services;


CREATE TABLE specializations(
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    specialization TEXT NOT NULL UNIQUE
);

CREATE TABLE workers(
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    first_n TEXT NOT NULL,
    second_n TEXT NOT NULL,
    middle_n TEXT NOT NULL,
    status TEXT NOT NULL CHECK (status = "working" OR status = "fired" ),
    percent REAL NOT NULL CHECK ( percent BETWEEN 0 AND 100),
    specialization_id INTEGER NOT NULL,
    FOREIGN KEY (specialization_id) REFERENCES specializations(id)
);

CREATE TABLE categories(
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    category TEXT NOT NULL
);

CREATE TABLE services(
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    car_category INTEGER NOT NULL,
    name_service TEXT NOT NULL,
    duration TEXT NOT NULL,
    price REAL NOT NULL,
    FOREIGN KEY (car_category) REFERENCES categories(id),
    UNIQUE(car_category,name_service)
);

CREATE TABLE registrations(
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    worker_id INTEGER NOT NULL,
    service_id INTEGER NOT NULL,
    day TIMESTAMP NOT NULL,
    work_status TEXT NOT NULL CHECK(work_status = "done"  OR work_status = "cancelled" OR work_status = "assigned"),
    FOREIGN KEY (worker_id) REFERENCES workers(id),
    FOREIGN KEY (service_id) REFERENCES services(id)
);

INSERT INTO categories(category) VALUES('B'),('C');

INSERT INTO services(car_category, name_service, duration, price) VALUES
(1,'Мойка','00:25:00',700),
(2,'Мойка','00:55:00',1500),
(1,'Полная диагностика двигателя','01:30:00',1800),
(1,'Диагностика подвески','00:15:00',500);

INSERT INTO specializations(specialization) VALUES
      ("Диагност двигателя"),
      ("Диагност подвески"),
      ("Механик"),
      ("Мойщик");

INSERT INTO workers(second_n, first_n, middle_n, status, percent, specialization_id) VALUES
    ("Зайцев","Григорий","Платонович","working",12.5,1),
    ("Крылов", "Даниил", "Михайлович","fired",20.5,1),
    ("Дегтярев","Михаил","Фёдорович","working",13.5,2),
    ("Лазарев", "Степан", "Петрович","working",9,3),
    ("Горелов", "Максим", "Григорьевич","working",11,4);

INSERT INTO registrations(worker_id, service_id, day, work_status) VALUES
      (1,2,1669901400,"assigned"),
      (3,2,1671535800,"assigned"),
      (3,1,1669188600,"done"),
      (4,2,1568238200,"done"),
      (2,3,1668298200,"cancelled"),
      (2,1,1468298200,"done");