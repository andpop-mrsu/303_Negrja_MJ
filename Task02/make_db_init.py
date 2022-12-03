import csv


def read_csv(path: str) -> list:
    list_: list = list()
    with open(path, 'r', encoding="UTF-8") as file:
        csv_read = csv.reader(file)
        for row in csv_read:
            list_.append(row)
    return list_


table_names = ("movies", "tags", "ratings", "users")

tables = ["""\nCREATE TABLE movies(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        `title` TEXT,
        `year` INTEGER,
        `geners` TEXT
);
""",
          """\nCREATE TABLE tags(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        `user_id` INTEGER NOT NULL,
        `movie_id` INTEGER NOT NULL,
        `tag` TEXT NOT NULL,
        `timestamp` TIMESTAMP 
);
""",

          """\nCREATE TABLE ratings(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        `user_id` INTEGER,
        `movie_id` INTEGER,
        `rating` REAL,
        `timestamp` TIMESTAMP 
);
""",
          """\nCREATE TABLE users(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        `name` TEXT NOT NULL,
        `email` TEXT NOT NULL,
        `gender` TEXT NOT NULL,
        `register_date` DATE,
        `occupation` TEXT
);
"""
          ]

users = list()

movies = read_csv("./dataset/movies.csv")[1:]
tags = read_csv("./dataset/tags.csv")[1:]
ratings = read_csv("./dataset/ratings.csv")[1:]

for i in range(len(movies)):
    try:
        movie = [
            movies[i][0],
            movies[i][1],
            int(movies[i][1].strip()[-5:-1:]),
            movies[i][2]
        ]
        movies[i] = movie
    except:
        movie = [
            movies[i][0],
            movies[i][1],
            None,
            movies[i][2]
        ]
        movies[i] = movie
        continue

with open("./dataset/users.txt", "r", encoding="UTF-8") as file:
    read = file.readlines()

    for i in range(len(read)):
        user_data = read[i][:-1].split("|")
        users.append(user_data[1:])

with open("db_init.sql", 'w', encoding="UTF-8") as file:
    for table_name in table_names:
        file.write(f"DROP TABLE IF EXISTS {table_name};\n")

    for table in tables:
        file.write(table)

    insert = "\nINSERT INTO movies VALUES "
    file.write(insert)
    for i in range(len(movies)):
        if movies[i][2] == None:
            file.write(
                f"""({movies[i][0]},"{movies[i][1].replace('"', "'")}",NULL,"{movies[i][3]}"),\n""")
            continue
        if i != len(movies) - 1:
            file.write(
                f"""({movies[i][0]},"{movies[i][1].replace('"', "'")}","{movies[i][2]}","{movies[i][3]}"),\n""")
        else:
            file.write(
                f"""({movies[i][0]},"{movies[i][1]}","{movies[i][2]}","{movies[i][3]}");\n""")

    insert = "\nINSERT INTO tags VALUES "
    file.write(insert)
    for i in range(len(tags)):
        if i != len(tags) - 1:
            file.write(
                f"""(NULL,{tags[i][0]},{tags[i][1]},"{tags[i][2].replace('"','')}",{tags[i][3]}),\n""")
        else:
            file.write(
                f"""(NULL,{tags[i][0]},{tags[i][1]},"{tags[i][2].replace('"','')}",{tags[i][3]});\n""")

    insert = "\nINSERT INTO ratings VALUES "
    file.write(insert)
    for i in range(len(ratings)):
        if i != len(ratings) - 1:
            file.write(
                f"""(NULL,{ratings[i][0]},{ratings[i][1]},{ratings[i][2].replace('"','')},{ratings[i][3]}),\n""")
        else:
            file.write(
                f"""(NULL,{ratings[i][0]},{ratings[i][1]},{ratings[i][2].replace('"','')},{ratings[i][3]});\n""")

    insert = "\nINSERT INTO users VALUES "
    file.write(insert)
    for i in range(len(users)):
        if 'none' in users[i][4]:
            file.write(
                f"""(NULL,"{users[i][0]}","{users[i][1]}","{users[i][2]}","{users[i][3]}",NULL),\n""")
            continue
        if i != len(users) - 1:
            file.write(
                f"""(NULL,"{users[i][0]}","{users[i][1]}","{users[i][2]}","{users[i][3]}","{users[i][4]}"),\n""")
        else:
            file.write(
                f"""(NULL,"{users[i][0]}","{users[i][1]}","{users[i][2]}","{users[i][3]}","{users[i][4]}");\n\n""")
