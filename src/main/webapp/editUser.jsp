<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
    <title>Edit User</title>
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-color: #e9ecef;
            margin: 0;
            padding: 20px;
        }

        .container {
            max-width: 700px;
            margin: 30px auto;
            background-color: #ffffff;
            padding: 25px;
            border-radius: 10px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
        }

        h2 {
            text-align: center;
            color: #343a40;
            margin-bottom: 20px;
        }

        form {
            display: flex;
            flex-direction: column;
        }

        label {
            font-weight: 600;
            margin-bottom: 8px;
            color: #495057;
        }

        input[type=text], input[type=email] {
            padding: 12px;
            margin-bottom: 15px;
            border: 2px solid #ced4da;
            border-radius: 6px;
            font-size: 16px;
            background-color: #f8f9fa;
        }

        input[type=submit] {
            background-color: #007bff;
            color: white;
            border: none;
            padding: 14px 22px;
            text-align: center;
            text-decoration: none;
            display: inline-block;
            font-size: 18px;
            border-radius: 6px;
            cursor: pointer;
            transition: background-color 0.3s;
        }

        input[type=submit]:hover {
            background-color: #0056b3;
        }

        .error-message {
            color: #dc3545;
            font-size: 16px;
            margin-top: 10px;
        }
    </style>
</head>
<body>
    <div class="container">
        <h2>Update Students</h2>
        <%
            String jdbcURL = "jdbc:mysql://localhost:3306/crud";
            String dbUser = "root";
            String dbPassword = "";
            Connection conn = null;
            PreparedStatement statement = null;
            ResultSet resultSet = null;
            String id = request.getParameter("id");
            String firstName = "";
            String lastName = "";
            String regnumber = "";
            String password = "";

            try {
                Class.forName("com.mysql.cj.jdbc.Driver");  // Updated to use the latest MySQL driver class name
                conn = DriverManager.getConnection(jdbcURL, dbUser, dbPassword);
                
                String sql = "SELECT * FROM users WHERE id=?";
                statement = conn.prepareStatement(sql);
                statement.setInt(1, Integer.parseInt(id));
                resultSet = statement.executeQuery();
                
                if (resultSet.next()) {
                    firstName = resultSet.getString("first_name");
                    lastName = resultSet.getString("last_name");
                    regnumber = resultSet.getString("reg_number");
                    password = resultSet.getString("password");
                }
            } catch (SQLException | ClassNotFoundException e) {
                out.println("<div class='error-message'>An error occurred: " + e.getMessage() + "</div>");
                e.printStackTrace();
            } finally {
                if (resultSet != null) {
                    try {
                        resultSet.close();
                    } catch (SQLException e) {
                        e.printStackTrace();
                    }
                }
                if (statement != null) {
                    try {
                        statement.close();
                    } catch (SQLException e) {
                        e.printStackTrace();
                    }
                }
                if (conn != null) {
                    try {
                        conn.close();
                    } catch (SQLException e) {
                        e.printStackTrace();
                    }
                }
            }
        %>
        <form method="post" action="update.jsp">
            <input type="hidden" id="id" name="id" value="<%= id %>">
            <label for="first_name">First Name:</label>
            <input type="text" id="first_name" name="first_name" value="<%= firstName %>">
            <label for="last_name">Last Name:</label>
            <input type="text" id="last_name" name="last_name" value="<%= lastName %>">
            <label for="reg_number">Reg_Name:</label>
            <input type="text" id="reg_name" name="reg_number" value="<%= regnumber %>">
            <label for="password">PassWord:</label>
            <input type="password" id="password" name="password" value="<%= password %>">
            <input type="submit" value="Update">
        </form>
    </div>
</body>
</html>
