<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Данные о мастерах</title>
</head>
    <?php
        $pdo = new PDO("sqlite:data.db");

        $query =   "SELECT workers.id,second_n,first_n,middle_n,DATE(registrations.day,'unixepoch') AS 'date',name_service,price FROM workers
        INNER JOIN registrations on registrations.worker_id == workers.id
        INNER JOIN services s on registrations.service_id = s.id
        ORDER BY second_n,'date';";

        $statement = $pdo->query($query);
        $data = $statement->fetchAll();
        $statement->closeCursor();

        $array_id = [];

        foreach($data as $d){
            $array_id[] = $d['id'];
        }

        $array_id = array_unique($array_id);
        sort($array_id);
    ?>
<body>

    <style>
        .table {
            border-collapse: collapse;
            margin: 25px 0;
            font-size: 0.9em;
            font-family: sans-serif;
            min-width: 400px;
            box-shadow: 0 0 20px rgba(0, 0, 0, 0.15);
        }

        .table thead tr {
            background-color: #009879;
            color: #ffffff;
            text-align: left;
        }

        .table th,
        .table td {
            padding: 12px 15px;
        }

        .table tbody tr {
            border-bottom: 1px solid #dddddd;
        }

        .table tbody tr:nth-of-type(even) {
            background-color: #f3f3f3;
        }

        .table tbody tr:last-of-type {
            border-bottom: 2px solid #009879;
        }

        .table tbody tr.active-row {
            font-weight: bold;
            color: #009879;
        }
    </style>

    <h1> Выбрать мастреа по номеру.</h1>

    <form method="POST">
        <label>
            <select style="width: 150px;" name="id">
                <option value= <?= null ?>>
                    All
                </option>
                <?php foreach($array_id as $id) {?>
                    <option value= <?= $id ?>>
                        <?= $id ?>
                    </option>
                <?php }?>
            </select>
        </label>
        <button type="submit"> Поиск</button>
    </form>

    <br>

    <?php
        $worker_id = 0;
        if(isset($_POST["id"])){
            $worker_id = (int)$_POST["id"];
        }

        if($worker_id === 0){
            $query =   "SELECT workers.id,second_n,first_n,middle_n,DATE(registrations.day,'unixepoch') AS 'date',name_service,price FROM workers
            INNER JOIN registrations on registrations.worker_id == workers.id
            INNER JOIN services s on registrations.service_id = s.id
            ORDER BY second_n,'date';";
        }else{
            $query =   "SELECT workers.id,second_n,first_n,middle_n,DATE(registrations.day,'unixepoch') AS 'date',name_service,price FROM workers
            INNER JOIN registrations on registrations.worker_id == workers.id
            INNER JOIN services s on registrations.service_id = s.id WHERE worker_id == {$worker_id}
            ORDER BY second_n,'date';";
        }
        $statement = $pdo->query($query);
        $data = $statement->fetchAll();
    ?>

    <table border="1" width="100%" cellpadding="10" class="table">
        <thead>
            <th>ID</th>
            <th>ФИО</th>
            <th>День</th>
            <th>Услуга</th>
            <th>Цена</th>
        </thead>
        <?php foreach($data as $d) { ?>
            <tr>
                <th><?= $d["id"] ?></th>
                <th><?= $d["second_n"]," ",$d["first_n"]," ",$d["middle_n"]?></th>
                <th><?= $d["date"] ?></th>
                <th><?= $d["name_service"] ?></th>
                <th><?= $d["price"] ?></th>
            </tr>
        <?php }?>
    </table>
</body>
</html>