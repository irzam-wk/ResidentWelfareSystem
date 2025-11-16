<?php
session_start();
require "db.php";  // Your DB connection file

if ($_SERVER["REQUEST_METHOD"] == "POST") {

    $email = trim($_POST["email"]);
    $password = trim($_POST["password"]);

    // Prepare SQL
    $sql = "SELECT * FROM users WHERE email = ?";
    $stmt = $conn->prepare($sql);
    $stmt->bind_param("s", $email);
    $stmt->execute();
    $result = $stmt->get_result();

    // Check if user exists
    if ($result->num_rows === 1) {
        $user = $result->fetch_assoc();

        // Verify hash
        if (password_verify($password, $user['password'])) {

            // Store login info in session
            $_SESSION["logged_in"] = true;
            $_SESSION["user_id"] = $user["user_id"];
            $_SESSION["email"] = $user["email"];
            $_SESSION["role"] = $user["role"];

            // Redirect based on role
            if ($user["role"] === "Admin") {
                header("Location: admin_dashboard.php");
                exit();
            } elseif ($user["role"] === "Staff") {
                header("Location: staff.html");
                exit();
            } else {
                header("Location: resident_dashboard.php");
                exit();
            }

        } else {
            $error = "Incorrect password!";
        }

    } else {
        $error = "No account found with that email!";
    }
}
?>
