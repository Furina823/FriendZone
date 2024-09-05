<?php
include_once '../config/database.php';
include_once '../models/BaseModel.php';

$database = new Database();
$db = $database->getConnection();

// Ensure the table name is provided and validate it
$table = isset($_GET['table']) ? htmlspecialchars($_GET['table']) : null;
if (!$table) {
    http_response_code(400);
    echo json_encode(array("message" => "Table name is required."));
    exit;
}

$model = new BaseModel($db, $table);

// Ensure this script is accessed via POST method
if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    http_response_code(405); // Method Not Allowed
    echo json_encode(array("message" => "Method not allowed."));
    exit;
}

// Validate and sanitize input data
$input_data = json_decode(file_get_contents("php://input"), true);
if (!$input_data || !is_array($input_data)) {
    http_response_code(400);
    echo json_encode(array("message" => "Invalid JSON data provided."));
    exit;
}

// Create record
if ($model->create($input_data)) {
    http_response_code(201); // Created
    echo json_encode(array("message" => "Record was created."));
} else {
    http_response_code(500); // Internal Server Error
    echo json_encode(array("message" => "Unable to create record."));
}

?>
