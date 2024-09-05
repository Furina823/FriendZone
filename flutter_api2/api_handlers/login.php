<?php
session_start();
require_once '../config/database.php';

header('Content-Type: application/json');
header('Access-Control-Allow-Origin: *');

$email = isset($_GET['email']) ? $_GET['email'] : '';
$password = isset($_GET['password']) ? $_GET['password'] : '';

if (empty($email) || empty($password)) {
    echo json_encode(['status' => 'error', 'message' => 'Email and password are required']);
    exit;
}

$conn = (new Database())->getConnection();

if (!$conn) {
    echo json_encode(['status' => 'error', 'message' => 'Database connection not established']);
    exit;
}

$sql = 'SELECT * FROM user WHERE email = :email AND password = :password';
$stmt = $conn->prepare($sql);
$stmt->bindParam(":email", $email);
$stmt->bindParam(":password", $password);
$stmt->execute();
$returnValue = $stmt->fetchAll(PDO::FETCH_ASSOC);

if (!empty($returnValue)) {
    $_SESSION['user'] = $returnValue[0]; // Store user info in session
    echo json_encode(['status' => 'success', 'data' => $returnValue]);
} else {
    echo json_encode(['status' => 'error', 'message' => 'Invalid email or password']);
}
?>
