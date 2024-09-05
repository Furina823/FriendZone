<?php

include_once '../config/database.php';
include_once '../models/BaseModel.php';

// Check if table name is provided in the URL
$table = isset($_GET['table']) ? $_GET['table'] : null;

// Validate table name
if (!$table) {
    http_response_code(400);
    echo json_encode(array("message" => "Table name is required."));
    exit;
}

try {
    // Establish database connection
    $database = new Database();
    $db = $database->getConnection();

    // Initialize BaseModel instance with the table name
    $model = new BaseModel($db, $table);

    // Fetch records from the table
    $stmt = $model->read();
    
    // Check if records were fetched successfully
    if ($stmt !== false) {
        $num = $stmt->rowCount();

        if ($num > 0) {
            $items = array();
            $items["records"] = array();

            while ($row = $stmt->fetch(PDO::FETCH_ASSOC)) {
                $item = array();
                foreach ($row as $key => $val) {
                    $item[$key] = $val;
                }
                $items["records"][] = $item; // Append item to records array
            }

            // Return JSON response
            echo json_encode($items);
        } else {
            // No records found
            http_response_code(404);
            echo json_encode(array("message" => "No records found."));
        }
    } else {
        // Error fetching records
        http_response_code(500);
        echo json_encode(array("message" => "Error fetching records."));
    }
} catch (PDOException $e) {
    // Database error
    http_response_code(500);
    echo json_encode(array("message" => "Database error: " . $e->getMessage()));
}

?>
