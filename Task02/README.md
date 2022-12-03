На компьютере должен быть устоновлен Python v.3 и SQLite3 и этого будет достаточно чтобы все работало коректно на `Linux` и `macOS`,
для коректной работы на `Windows` в `db_init.bat` нужно изменить строку
`sqlite3 movies_rating.db < db_init.sql` на `sqlite3 -init db_init.sql movies_rating.db`.
