<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
    <title>Edit Task</title>
    <!-- Bootstrap CSS -->
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <!-- Font Awesome CSS -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.3/css/all.min.css">
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f8f9fa;
            padding: 20px;
        }
        .container {
            max-width: 600px;
            margin: 20px auto;
            background-color: #fff;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
        }
        h2 {
            text-align: center;
            margin-bottom: 20px;
        }
        .error-message {
            color: #dc3545;
            font-size: 18px;
            text-align: center;
        }
        .success-message {
            color: #28a745;
            font-size: 18px;
            text-align: center;
        }
        .back-link {
            display: block;
            margin-top: 20px;
            text-align: center;
        }
        .back-link a {
            color: #007bff;
            text-decoration: none;
        }
        .back-link a:hover {
            text-decoration: underline;
        }
    </style>
</head>
<body>
    <div class="container">
        <h2><i class="fas fa-tasks"></i> Edit Task</h2>

        <%
            String jdbcURL = "jdbc:mysql://localhost:3306/crud";
            String dbUser = "root";
            String dbPassword = "";
            Connection conn = null;
            PreparedStatement statement = null;
            ResultSet resultSet = null;

            String taskId = request.getParameter("task_id");
            String taskName = "";
            String description = "";
            String departmentId = "";
            String lecturerIndexNumber = "";

            // Fetch task details if taskId is provided
            if (taskId != null && !taskId.isEmpty()) {
                try {
                    Class.forName("com.mysql.cj.jdbc.Driver");
                    conn = DriverManager.getConnection(jdbcURL, dbUser, dbPassword);

                    String sql = "SELECT * FROM Tasks WHERE task_id=?";
                    statement = conn.prepareStatement(sql);
                    statement.setInt(1, Integer.parseInt(taskId));
                    resultSet = statement.executeQuery();

                    if (resultSet.next()) {
                        taskName = resultSet.getString("task_name");
                        description = resultSet.getString("description");
                        departmentId = resultSet.getString("department_id");
                        lecturerIndexNumber = resultSet.getString("index_number");
                    } else {
                        out.println("<div class='error-message'>Task not found.</div>");
                        out.println("<div class='back-link'><a href='TaskManagement.jsp'><i class='fas fa-arrow-left'></i> Back to Task Management</a></div>");
                        return;
                    }
                } catch (SQLException | ClassNotFoundException e) {
                    out.println("<div class='error-message'>Error fetching task details: " + e.getMessage() + "</div>");
                    e.printStackTrace();
                } finally {
                    if (resultSet != null) try { resultSet.close(); } catch (SQLException e) { e.printStackTrace(); }
                    if (statement != null) try { statement.close(); } catch (SQLException e) { e.printStackTrace(); }
                    if (conn != null) try { conn.close(); } catch (SQLException e) { e.printStackTrace(); }
                }
            } else {
                out.println("<div class='error-message'>No task ID provided.</div>");
                out.println("<div class='back-link'><a href='TaskManagement.jsp'><i class='fas fa-arrow-left'></i> Back to Task Management</a></div>");
                return;
            }
        %>

        <!-- Display task details and allow editing -->
        <form action="UpdateTaskServlet" method="post">
            <input type="hidden" name="task_id" value="<%= taskId %>">
            <div class="form-group">
                <label for="task_name">Task Name</label>
                <input type="text" id="task_name" name="task_name" class="form-control" value="<%= taskName %>" required>
            </div>
            <div class="form-group">
                <label for="description">Description</label>
                <textarea id="description" name="description" class="form-control" rows="4" required><%= description %></textarea>
            </div>
            <div class="form-group">
                <label for="department_id">Department ID</label>
                <input type="number" id="department_id" name="department_id" class="form-control" value="<%= departmentId %>" required>
            </div>
            <div class="form-group">
                <label for="index_number">Lecturer's Name</label>
                <input type="text" id="index_number" name="index_number" class="form-control" value="<%= lecturerIndexNumber %>" required>
            </div>
            <button type="submit" class="btn btn-primary">Update Task</button>
        </form>

        <div class='back-link'><a href='TaskManagement.jsp'><i class='fas fa-arrow-left'></i> Back to Task Management</a></div>
    </div>

    <!-- Bootstrap JS and dependencies -->
    <script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.9.3/dist/umd/popper.min.js"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
</body>
</html>
