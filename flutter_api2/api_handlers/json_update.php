<?php
header('Content-Type: application/json');

// Enable error reporting
ini_set('display_errors', 1);
ini_set('display_startup_errors', 1);
error_reporting(E_ALL);

// Database connection
$mysqli = new mysqli("localhost", "root", "", "friendzone");

if ($mysqli->connect_error) {
    die("Connection failed: " . $mysqli->connect_error);
}

// Function to delete file and handle errors
function delete_file($file_path) {
    if (file_exists($file_path)) {
        if (!unlink($file_path)) {
            file_put_contents('error.log', "Error deleting file: " . $file_path . PHP_EOL, FILE_APPEND);
            die("Error deleting file.");
        }
    }
}

// Function to write JSON data to file and handle errors
function write_json_file($file_path, $data) {
    if (file_put_contents($file_path, $data) === false) {
        file_put_contents('error.log', "Error writing JSON file: " . $file_path . PHP_EOL, FILE_APPEND);
        die("Error writing JSON file.");
    }
}

// Update user data
$user_result = $mysqli->query("SELECT * FROM user");

if ($user_result === false) {
    file_put_contents('error.log', "Error executing user query: " . $mysqli->error . PHP_EOL, FILE_APPEND);
    die("Error executing user query: " . $mysqli->error);
}

$user_data = $user_result->fetch_all(MYSQLI_ASSOC);
$user_json_file_path = 'C:/xampp/htdocs/flutter_api2/api_handlers/user.json';

delete_file($user_json_file_path);

$user_json_data = json_encode([
    'type' => 'header', 
    'version' => '1.0', 
    'comment' => 'Updated user data', 
    'data' => $user_data
], JSON_PRETTY_PRINT);

write_json_file($user_json_file_path, $user_json_data);

// Update event data
$event_result = $mysqli->query("SELECT * FROM event");

if ($event_result === false) {
    file_put_contents('error.log', "Error executing event query: " . $mysqli->error . PHP_EOL, FILE_APPEND);
    die("Error executing event query: " . $mysqli->error);
}

$event_data = $event_result->fetch_all(MYSQLI_ASSOC);
$event_json_file_path = 'C:/xampp/htdocs/flutter_api2/api_handlers/event.json';

delete_file($event_json_file_path);

$event_json_data = json_encode([
    'type' => 'header', 
    'version' => '1.0', 
    'comment' => 'Updated event data', 
    'data' => $event_data
], JSON_PRETTY_PRINT);

write_json_file($event_json_file_path, $event_json_data);

$mysqli->close();
?>
