<?php
include_once '../config/database.php';
include_once '../models/BaseModel.php';

// Check if the request method is DELETE
if ($_SERVER['REQUEST_METHOD'] === 'DELETE') {
    // Check if required parameters are present
    $table = isset($_GET['table']) ? $_GET['table'] : null;
    $id = isset($_GET['id']) ? intval($_GET['id']) : null; // Ensure id is an integer

    // Validate required parameters
    if (!$table || !$id) {
        http_response_code(400);
        echo json_encode(array("message" => "Table name and id are required."));
        exit;
    }

    try {
        // Establish database connection (using PDO)
        $database = new Database();
        $db = $database->getConnection();

        // Get the primary key column dynamically
        $primaryKey = getPrimaryKeyColumnName($table, $db); // Implement this function to fetch the primary key column

        if (!$primaryKey) {
            http_response_code(500);
            echo json_encode(array("message" => "Failed to fetch primary key column for table {$table}."));
            exit;
        }

        // Construct SQL query with prepared statement
        $query = "DELETE FROM {$table} WHERE {$primaryKey} = :id";
        $stmt = $db->prepare($query);
        $stmt->bindParam(':id', $id, PDO::PARAM_INT); // Bind id as integer

        // Execute query
        if ($stmt->execute()) {
            http_response_code(200);
            echo json_encode(array("message" => "Record with ID $id from table $table deleted successfully."));
        } else {
            http_response_code(500);
            echo json_encode(array("message" => "Failed to delete record."));
        }
    } catch (PDOException $e) {
        http_response_code(500);
        echo json_encode(array("message" => "Database error: " . $e->getMessage()));
    }
    exit;
} else {
    // Method not allowed
    http_response_code(405); // Method Not Allowed
    echo json_encode(array("message" => "Method not allowed."));
    exit;
}

// Function to get primary key column name for a table
function getPrimaryKeyColumnName($table, $db) {
    $query = "SHOW COLUMNS FROM {$table} WHERE `Key` = 'PRI'";
    $stmt = $db->prepare($query);
    $stmt->execute();
    $column = $stmt->fetch(PDO::FETCH_ASSOC);

    if ($column && isset($column['Field'])) {
        return $column['Field'];
    }
    return null;
}
?>
