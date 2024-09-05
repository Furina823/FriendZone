<?php
  require 'conn.php';
  if(isset($_GET['token'])){
    $token = $_GET['token'];
    $sql ="SELECT email FROM password_reset_tokens WHERE token = '$token' AND expiration_time > NOW()";    
    $result = $conn->query($sql);
    if ($result->num_rows > 0){
      $row = $result->fetch_assoc();
      $email = $row['email'];


?>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>FriendZone Login</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    <style>
        body {
            margin: 0;
            padding: 0;
            font-family: Roboto Flex, sans-serif;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            background-color: #f5f5f5;
        }

        .container {
            display: flex;
            background-color: white;
            border-radius: 15px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
            overflow: hidden;
            width: 80%;
            max-width: 1200px;
            height: 80%;
            max-height: 700px;
        }

        .image-section {
            position: relative;
            flex: 1;
            height: 100%;
        }

        .image-section img {
            width: 100%;
            height: 100%;
            object-fit: cover;
            border-radius: 30px;
        }

        .overlay {
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(238, 197, 253, 0.5);
            border-radius: 30px;
        }

        .login-section {
            flex: 1;
            padding: 40px 30px;
            display: flex;
            flex-direction: column;
            justify-content: center;
            background-color: #fff;
        }

        .logo {
            text-align: center;
            margin-bottom: 20px;
        }

        .logo img {
            width: 205px;
            height: 155px;
        }

        .login-header {
            text-align: center;
            padding-right: 20px;
            margin-bottom: 10px;
            font-size: 20px;
            color: #333;
        }

        form {
            display: flex;
            flex-direction: column;
            gap: 10px;
            width: 100%;
            max-width: 325px;
            margin-left: 100px;
        }

        form label {
            font-size: 18px;
            margin-bottom: 5px;
            color: #9D9D9D;
        }

        form input {
            padding: 17px;
            border: 1px solid #ddd;
            border-radius: 10px;
            max-width:400px;
        }

        form input:focus {
            border: 1px solid #4C315C;
            outline: 1px solid #4C315C;
        }

        .password-wrapper {
            position: relative;
        }

        .password-wrapper input {
            width: calc(100% - 40px);
        }

        form a {
            color: #5c4dff;
            text-decoration: none;
            font-size: 14px;
            text-align: center;
            display: block;
        }

        form button {
            padding: 15px;
            margin: 0 auto;
            margin-top: 8px;
            width: 80%;
            font-size: 16px;
            color: #fff;
            background-color: #4C315C;
            border: none;
            border-radius: 25px;
            cursor: pointer;
        }

        p {
            font-size: 12px;
            text-align: center;
        }

        form p a {
            color: #5c4dff;
            text-decoration: none;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="image-section">
            <div class="overlay"></div>
            <img src="Background.jpg" alt="Group of friends">
        </div>
        <div class="login-section">
            <div class="logo">
                <img src="FriendZoneLogo.jpg" alt="FriendZone Logo"><br><br>
            </div>
            <form action="reset_password.php" method="post">
                <div class="login-header"><b>New Password</b></div><br>
                <input type="hidden" name="email" value="<?php echo $email; ?>">
                    <input type="password" id="password" name="password" required>
                <button type="submit"><b>Reset Password</b></button>
            </form>
        </div>
    </div>
</body>
</html>


<?php
} else {
	echo "Invalid token.";
}
} else {
	echo "Token is missing.";
}

$conn->close();