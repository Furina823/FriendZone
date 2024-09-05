<?php

include_once '../config/database.php';
include_once '../models/BaseModel.php';

// Establish database connection
$database = new Database();
$db = $database->getConnection();

// Ensure the table name is provided and sanitize it
$table = isset($_GET['table']) ? htmlspecialchars($_GET['table']) : null;
if (!$table) {
    http_response_code(400);
    echo json_encode(array("message" => "Table name is required."));
    exit;
}

// Initialize the BaseModel with the database connection and table name
$model = new BaseModel($db, $table);

// Ensure the ID parameter is provided and sanitize it
$id = isset($_GET['id']) ? intval($_GET['id']) : null;
if (!$id) {
    http_response_code(400);
    echo json_encode(array("message" => "ID parameter is required."));
    exit;
}

// Read single record from the database
$row = $model->read_single($id);

// Check if a record was found
if ($row) {
    http_response_code(200); // OK
    echo json_encode($row);
} else {
    http_response_code(404); // Not Found
    echo json_encode(array("message" => "Record not found."));
}

?>
