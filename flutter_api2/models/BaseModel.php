<?php
class BaseModel {
    protected $conn;
    protected $table;

    public function __construct($db, $table) {
        $this->conn = $db;
        $this->table = $table;
    }

    private function getFirstColumn() {
        try {
            $query = "SHOW COLUMNS FROM {$this->table}";
            $stmt = $this->conn->query($query);
            $column = $stmt->fetch(PDO::FETCH_ASSOC);
            return $column['Field'] ?? null;
        } catch (PDOException $e) {
            return null;
        } 
    }

    public function create($data) {
        try {
            // Sanitize input data
            foreach ($data as $key => $val) {
                if (is_string($val)) {
                    $data[$key] = htmlspecialchars($val); // Sanitize string inputs
                }
            }
    
            // Prepare SQL statement
            $fields = implode(", ", array_keys($data));
            $placeholders = ":" . implode(", :", array_keys($data));
            $query = "INSERT INTO {$this->table} ($fields) VALUES ($placeholders)";
            $stmt = $this->conn->prepare($query);
    
            // Bind parameters
            foreach ($data as $key => $val) {
                if (is_null($val)) {
                    $stmt->bindValue(":$key", null, PDO::PARAM_NULL);
                } elseif (is_int($val)) {
                    $stmt->bindValue(":$key", $val, PDO::PARAM_INT);
                } elseif (is_bool($val)) {
                    $stmt->bindValue(":$key", $val, PDO::PARAM_BOOL);
                } else {
                    $stmt->bindValue(":$key", $val, PDO::PARAM_STR);
                }
            }
    
            // Execute query
            return $stmt->execute();
        } catch (PDOException $e) {
            // Log the error message
            error_log($e->getMessage()); // Log error message
            return false;
        }
    }

    public function read() {
        try {
            $query = "SELECT * FROM {$this->table}";
            $stmt = $this->conn->prepare($query);
            $stmt->execute();
            return $stmt; // Return PDOStatement object
        } catch (PDOException $e) {
            // Handle database error
            error_log('Error: ' . $e->getMessage());
            return false;
        }
    }

    public function read_single($id) {
        try {
            $firstColumn = $this->getFirstColumn();
            if (!$firstColumn) return null;
            
            // Sanitize ID (assuming it's numeric)
            $id = intval($id);

            $query = "SELECT * FROM {$this->table} WHERE {$firstColumn} = ?";
            $stmt = $this->conn->prepare($query);
            $stmt->execute([$id]);
            return $stmt->fetch(PDO::FETCH_ASSOC);
        } catch (PDOException $e) {
            return null;
        }
    }

    public function update($id, $data) {
        try {
            // Get the first column of the table
            $firstColumn = $this->getFirstColumn();
            if (!$firstColumn) return false;
            
            // Sanitize ID (assuming it's numeric)
            $id = intval($id);
    
            // Prepare the SET part of the query
            $set = "";
            foreach ($data as $key => $val) {
                $set .= "$key = :$key, ";
            }
            $set = rtrim($set, ", ");
            
            // Construct the SQL query
            $query = "UPDATE {$this->table} SET $set WHERE $firstColumn = :id";
            $stmt = $this->conn->prepare($query);
            
            // Bind the ID parameter
            $stmt->bindValue(':id', $id, PDO::PARAM_INT);
            
            // Bind the rest of the parameters
            foreach ($data as $key => $val) {
                if (is_null($val)) {
                    $stmt->bindValue(":$key", null, PDO::PARAM_NULL);
                } elseif (is_int($val)) {
                    $stmt->bindValue(":$key", $val, PDO::PARAM_INT);
                } elseif (is_bool($val)) {
                    $stmt->bindValue(":$key", $val, PDO::PARAM_BOOL);
                } else {
                    $stmt->bindValue(":$key", $val, PDO::PARAM_STR);
                }
            }
            
            // Execute the query
            return $stmt->execute();
        } catch (PDOException $e) {
            error_log("Update operation failed: " . $e->getMessage());
            return false;
        }
    }

    

    public function delete($id) {
        try {
            $firstColumn = $this->getFirstColumn();
            if (!$firstColumn) return false;
            
            // Sanitize ID (assuming it's numeric)
            $id = intval($id);

            $query = "DELETE FROM {$this->table} WHERE {$firstColumn} = ?";
            $stmt = $this->conn->prepare($query);
            return $stmt->execute([$id]);
        } catch (PDOException $e) {
            return false;
        }
    }
}
?>
