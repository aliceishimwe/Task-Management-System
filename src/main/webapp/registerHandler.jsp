<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Registration Result</title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.3/css/all.min.css">
    <style>
        body {
            padding-top: 56px;
        }
        .container {
            max-width: 500px;
            margin-top: 50px;
        }
    </style>
</head>
<body>
    <nav class="navbar navbar-expand-lg navbar-light bg-light fixed-top">
        <a class="navbar-brand" href="#">Task Management System</a>
        <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarNav" aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
            <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse" id="navbarNav">
            <ul class="navbar-nav">
                <li class="nav-item">
                    <a class="nav-link" href="index.html">Home</a>
                </li>
            </ul>
        </div>
    </nav>

    <div class="container">
        <h2 class="text-center">Registration Result</h2>
        <%
            String regNumber = request.getParameter("reg_number");
            String password = request.getParameter("password");
            String userType = request.getParameter("user_type");
            boolean registrationSuccessful = false;

            // Database connection parameters
            String dbUrl = "jdbc:mysql://localhost:3306/crud";
            String dbUser = "root";
            String dbPassword = "password";

            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                Connection conn = DriverManager.getConnection(dbUrl, dbUser, dbPassword);

                // Check if the user already exists
                String checkQuery = "SELECT COUNT(*) FROM users WHERE reg_number = ?";
                PreparedStatement checkStmt = conn.prepareStatement(checkQuery);
                checkStmt.setString(1, regNumber);
                ResultSet rs = checkStmt.executeQuery();
                rs.next();
                if (rs.getInt(1) > 0) {
                    // User exists
                    out.println("<div class='alert alert-danger' role='alert'>User with this registration number already exists.</div>");
                } else {
                    // Register new user
                    String insertQuery = "INSERT INTO users (reg_number, password, user_type) VALUES (?, ?, ?)";
                    PreparedStatement insertStmt = conn.prepareStatement(insertQuery);
                    insertStmt.setString(1, regNumber);
                    insertStmt.setString(2, password); // Consider hashing the password in a real application
                    insertStmt.setString(3, userType);
                    int rowsAffected = insertStmt.executeUpdate();
                    
                    if (rowsAffected > 0) {
                        registrationSuccessful = true;
                        out.println("<div class='alert alert-success' role='alert'>Registration successful! You can <a href='login.jsp'>login</a> now.</div>");
                    } else {
                        out.println("<div class='alert alert-danger' role='alert'>Registration failed. Please try again.</div>");
                    }
                }
                conn.close();
            } catch (Exception e) {
                e.printStackTrace();
                out.println("<div class='alert alert-danger' role='alert'>An error occurred: " + e.getMessage() + "</div>");
            }
        %>
    </div>

    <script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.5.4/dist/umd/popper.min.js"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
</body>
</html>
