<?php
require "conn.php";

if ($_SERVER["REQUEST_METHOD"] == "POST") {
    $email = $_POST["email"];
    $new_password = $_POST["password"];
    

    // Prepare the SQL statement
    $stmt = $conn->prepare("UPDATE user SET password = ? WHERE email = ?");
    $stmt->bind_param("ss", $new_password, $email);


    if ($stmt->execute()) {
        // Prepare and execute the token removal statement
        $remove_token_stmt = $conn->prepare("DELETE FROM password_reset_tokens WHERE email = ?");
        $remove_token_stmt->bind_param("s", $email);
        $remove_token_stmt->execute();
        
        echo "<script>alert('Password reset successful. You can now go back to FriendZone application & log in with your new password.');</script>";
    } else {
        echo "Error updating password: " . $conn->error;
    }

    // Close the statements
    $stmt->close();
    $remove_token_stmt->close();
}

$conn->close();
?>
