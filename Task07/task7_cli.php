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

    print_r("╔════════════════════════════╗\n");
    print_r("║ Выберите номер мастера :   ║\n");
    print_r("╠════════════════════════════╣\n");
    foreach($array_id as $id){
        print_r("║  {$id}                         ║\n");
    }
    print_r("╚════════════════════════════╝\n");

    print_r("Input : ");
    $worker_id = readline();
    
    if(($worker_id > max($array_id) && $worker_id < 0) || ((float)$worker_id*10)%10 !== 0)
    {
        print_r("Мастера с номером {$worker_id} в базе нету.\n");
        return -1;
    }

    if($worker_id !== "")
    {
        $query =   "SELECT workers.id,second_n,first_n,middle_n,DATE(registrations.day,'unixepoch') AS 'date',name_service,price FROM workers
                INNER JOIN registrations on registrations.worker_id == workers.id
                INNER JOIN services s on registrations.service_id = s.id WHERE worker_id == {$worker_id}
                ORDER BY second_n,'date';";
        $statement = $pdo->query($query);
        $data = $statement->fetchAll();
    }

    print_r("╔════╦═══════════════════════════╦════════════╦═══════════╦══════════╗\n");//  ╚╔ ╩ ╦ ╠ ═ ╬ ╣ ║ ╗ ╝
    print_r("║ ID ║          ФИО              ║    день    ║   услуга  ║   цена   ║\n");
    print_r("╠════╬═══════════════════════════╬════════════╬═══════════╬══════════╣\n");
    foreach($data as $d){
    //"║   {$d['id']}   ║  {$d['second_n']} {$d['first_n']} {$d['middle_n']} ║\n")
        $format = "║  %d ║ %s %s %s ║ %s ║   %s   ║  %5s   ║\n";
        echo sprintf($format,$d["id"],$d['second_n'],$d['first_n'],$d['middle_n'],$d['date'],$d['name_service'],$d["price"]);

    }
    print_r("╚════╩═══════════════════════════╩════════════╩═══════════╩══════════╝\n");
?>