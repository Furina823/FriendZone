<?php

class Database {

    private $host = "localhost";
    private $db_name = "friendzone";
    private $username = "root";
    private $password = "";
    public $conn;

    public function getConnection(){

        $this->conn = null;

        try {
            $host = 'mysql:host=' . $this->host . ';dbname=' . $this->db_name;
            $username = $this->username;
            $password = $this->password;
            $options = [
                PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION,
                PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
                PDO::ATTR_EMULATE_PREPARES => false,
            ];
        
            $db = new PDO($host, $username, $password, $options);

            // Assign the PDO object to $this->conn
            $this->conn = $db;

            // Return the PDO object
            return $this->conn;
        } catch (PDOException $e) {
            echo 'Connection failed: ' . $e->getMessage();
            return null; // Return null on connection failure
        }

    }
}

?>
