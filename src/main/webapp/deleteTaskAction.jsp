<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Delete Task</title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
</head>
<body>
    <nav class="navbar navbar-expand-lg navbar-light bg-light fixed-top">
        <a class="navbar-brand" href="#">Task Management System</a>
    </nav>

    <div class="container mt-5">
        <%
            // Database connection parameters
            String dbURL = "jdbc:mysql://localhost:3306/crud";
            String dbUser = "root";
            String dbPassword = "";

            // Retrieve task ID from request
            String taskId = request.getParameter("task_id");

            Connection connection = null;
            PreparedStatement pstmt = null;

            try {
                // Load and register the JDBC driver
                Class.forName("com.mysql.cj.jdbc.Driver");

                // Establish a connection to the database
                connection = DriverManager.getConnection(dbURL, dbUser, dbPassword);

                // Prepare SQL to delete the task
                String sql = "DELETE FROM tasks WHERE task_id = ?";
                pstmt = connection.prepareStatement(sql);
                pstmt.setString(1, taskId);

                int rowsAffected = pstmt.executeUpdate();

                if (rowsAffected > 0) {
                    out.println("<h1>Task Deleted Successfully</h1>");
                } else {
                    out.println("<h1>Error: Task Deletion Failed</h1>");
                }
                out.println("<a href='TaskManagement.jsp'>Go back to Dashboard</a>");
            } catch (Exception e) {
                e.printStackTrace();
                out.println("<h1>Error: " + e.getMessage() + "</h1>");
                out.println("<a href='TaskManagement.jsp'>Go back to Dashboard</a>");
            } finally {
                // Clean up
                if (pstmt != null) try { pstmt.close(); } catch (SQLException e) { e.printStackTrace(); }
                if (connection != null) try { connection.close(); } catch (SQLException e) { e.printStackTrace(); }
            }
        %>
    </div>

    <script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.5.4/dist/umd/popper.min.js"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
</body>
</html>
