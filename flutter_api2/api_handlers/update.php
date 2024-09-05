<?php

include_once '../config/database.php';
include_once '../models/BaseModel.php';

// Establish database connection
$database = new Database();
$db = $database->getConnection();

// Check if the request method is POST
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    // Check if required parameters are present
    $table = isset($_GET['table']) ? htmlspecialchars($_GET['table']) : null;
    $id = isset($_GET['id']) ? htmlspecialchars($_GET['id']) : null;

    // Validate required parameters
    if (!$table || !$id) {
        http_response_code(400);
        echo json_encode(array("message" => "Table name and ID are required."));
        exit;
    }

    try {
        // Instantiate the BaseModel with database connection
        $model = new BaseModel($db, $table);

        // Prepare data for update
        $data = json_decode(file_get_contents("php://input"), true);
        if (!$data) {
            http_response_code(400);
            echo json_encode(array("message" => "Invalid JSON data provided."));
            exit;
        }

        // Unset the ID from data since it's already passed as a separate parameter
        unset($data['id']);

        // Perform update operation
        if ($model->update($id, $data)) {
            http_response_code(200);
            echo json_encode(array("message" => "Record was updated."));
        } else {
            http_response_code(500);
            echo json_encode(array("message" => "Unable to update record."));
        }
    } catch (PDOException $e) {
        http_response_code(500);
        echo json_encode(array("message" => "Database error: " . $e->getMessage()));
    }
} else {
    // Method not allowed
    http_response_code(405); // Method Not Allowed
    echo json_encode(array("message" => "Method not allowed."));
}
?>
