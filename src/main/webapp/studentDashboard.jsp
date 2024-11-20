


<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>StudentDashboard</title>
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
        <h2 class="text-center">Welcome, Student</h2>

        <h3>Your Tasks</h3>
        <table class="table table-striped">
            <thead>
                <tr>
                    <th>Task ID</th>
                    <th>Task Name</th>
                    <th>Description</th>
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
                        // Load and register the JDBC driver
                        Class.forName("com.mysql.cj.jdbc.Driver");

                        // Establish a connection to the database
                        connection = DriverManager.getConnection(dbURL, dbUser, dbPassword);

                        // Get the user registration number from session
                        String userRegNumber = (String) session.getAttribute("reg_number");

                        if (userRegNumber == null || userRegNumber.trim().isEmpty()) {
                            out.println("<tr><td colspan='3'>Error: Student not logged in</td></tr>");
                        } else {
                            // Debug: Print user registration number
                            out.println("<tr><td colspan='3'>Debug: User Reg Number = " + userRegNumber + "</td></tr>");

                            // Query to get tasks for the student based on department
                            String sql = "SELECT t.task_id, t.task_name, t.description " +
                                         "FROM tasks t " +
                                         "JOIN departments d ON t.department_id = d.department_id " +
                                         "JOIN students s ON s.department_id = d.department_id " +
                                         "WHERE s.reg_number = ?";
                            pstmt = connection.prepareStatement(sql);
                            pstmt.setString(1, userRegNumber);
                            rs = pstmt.executeQuery();

                            boolean tasksFound = false;
                            while (rs.next()) {
                                out.println("<tr>");
                                out.println("<td>" + rs.getInt("task_id") + "</td>");
                                out.println("<td>" + rs.getString("task_name") + "</td>");
                                out.println("<td>" + rs.getString("description") + "</td>");
                                out.println("</tr>");
                                tasksFound = true;
                            }

                            if (!tasksFound) {
                                out.println("<tr><td colspan='3'>No tasks found for this student.</td></tr>");
                            }
                        }

                    } catch (SQLException e) {
                        out.println("<tr><td colspan='3'>Error fetching tasks: " + e.getMessage() + "</td></tr>");
                    } catch (ClassNotFoundException e) {
                        out.println("<tr><td colspan='3'>Error: JDBC Driver class not found.</td></tr>");
                    } finally {
                        // Clean up
                        if (rs != null) try { rs.close(); } catch (SQLException e) { e.printStackTrace(); }
                        if (pstmt != null) try { pstmt.close(); } catch (SQLException e) { e.printStackTrace(); }
                        if (connection != null) try { connection.close(); } catch (SQLException e) { e.printStackTrace(); }
                    }
                %>
            </tbody>
        </table>

        <a href="index.html" class="btn btn-primary">Back to HomePage</a>
    </div>

    <script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.5.4/dist/umd/popper.min.js"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
</body>
</html>
