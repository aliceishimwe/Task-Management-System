<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Lecturer Dashboard</title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <style>
        .dashboard-container {
            margin-top: 50px;
        }
    </style>
</head>
<body>
    <nav class="navbar navbar-expand-lg navbar-light bg-light fixed-top">
        <a class="navbar-brand" href="#">Task Management System</a>
    </nav>

    <div class="container dashboard-container">
        <h2 class="text-center">Welcome, Lecturer</h2>

        <h3>Create New Task</h3>
        <form method="POST" action="#"> <!-- Adjust action URL as necessary -->
            <div class="form-group">
                <label for="taskName">Task Name</label>
                <input type="text" class="form-control" id="taskName" name="taskName" required>
            </div>
            <div class="form-group">
                <label for="description">Description</label>
                <textarea class="form-control" id="description" name="description" rows="3" required></textarea>
            </div>
            <div class="form-group">
                <label for="department">Department</label>
                <select class="form-control" id="department" name="department" required>
                    <option value="" disabled selected>Select department</option>
                    <option value="1">IT</option>
                    <option value="2">Civil</option>
                    <option value="3">Logistics</option>
                    <option value="4">Fashion & Design</option>
                    <option value="5">Creative Arts</option>
                </select>
            </div>
            <button type="submit" class="btn btn-primary">Create Task</button>
        </form>

        <h3 class="mt-5">Your Tasks</h3>
        <table class="table table-striped">
            <thead>
                <tr>
                    <th>Task ID</th>
                    <th>Task Name</th>
                    <th>Description</th>
                    <th>Department</th>
                    <th>Actions</th>
                </tr>
            </thead>
            <tbody>
                <%
                    String dbURL = "jdbc:mysql://localhost:3306/crud";
                    String dbUser = "root";
                    String dbPassword = "";

                    Connection connection = null;
                    PreparedStatement pstmt = null;
                    ResultSet rs = null;

                    try {
                        Class.forName("com.mysql.cj.jdbc.Driver");
                        connection = DriverManager.getConnection(dbURL, dbUser, dbPassword);

                        String lecturerIndexNumber = (String) session.getAttribute("lecturer_index_number");

                        if (lecturerIndexNumber == null) {
                            out.println("<tr><td colspan='5'>Error: Lecturer not logged in</td></tr>");
                            return;
                        }

                        // Correct SQL query
                        String sql = "SELECT t.task_id, t.task_name, t.description, d.name AS department " +
                                     "FROM tasks t " +
                                     "JOIN departments d ON t.department_id = d.department_id " +
                                     "WHERE t.lecturer_index_number = ?";
                        pstmt = connection.prepareStatement(sql);
                        pstmt.setString(1, lecturerIndexNumber);
                        rs = pstmt.executeQuery();

                        boolean hasResults = false; // Flag to check if there are results

                        while (rs.next()) {
                            hasResults = true; // Set flag to true if at least one row is found
                            int taskId = rs.getInt("task_id");
                            String taskName = rs.getString("task_name");
                            String description = rs.getString("description");
                            String department = rs.getString("department"); // Corrected column reference

                            out.println("<tr>");
                            out.println("<td>" + taskId + "</td>");
                            out.println("<td>" + taskName + "</td>");
                            out.println("<td>" + description + "</td>");
                            out.println("<td>" + department + "</td>");
                            out.println("<td>");
                            out.println("<a href='updateTask.jsp?task_id=" + taskId + "' class='btn btn-warning btn-sm'>Update</a> ");
                            out.println("<a href='deleteTaskAction.jsp?task_id=" + taskId + "' class='btn btn-danger btn-sm' onclick='return confirm(\"Are you sure you want to delete this task?\")'>Delete</a>");
                            out.println("</td>");
                            out.println("</tr>");
                        }

                        if (!hasResults) {
                            out.println("<tr><td colspan='5'>No tasks found.</td></tr>");
                        }
                    } catch (Exception e) {
                        e.printStackTrace();
                        out.println("<tr><td colspan='5'>Error fetching tasks: " + e.getMessage() + "</td></tr>");
                    } finally {
                        if (rs != null) try { rs.close(); } catch (SQLException e) { e.printStackTrace(); }
                        if (pstmt != null) try { pstmt.close(); } catch (SQLException e) { e.printStackTrace(); }
                        if (connection != null) try { connection.close(); } catch (SQLException e) { e.printStackTrace(); }
                    }
                %>
            </tbody>
        </table>
    </div>

    <script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.5.4/dist/umd/popper.min.js"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
</body>
</html>

<a href='index.html'>Back to HomePage</a>
