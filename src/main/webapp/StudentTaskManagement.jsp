
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Task Management</title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
    <style>
        .dashboard-container {
            margin-top: 50px;
        }
        .table th, .table td {
            vertical-align: middle;
        }
    </style>
</head>
<body>
    <div class="container dashboard-container">
        <h2 class="text-center">Manage Tasks</h2>

        <table class="table table-striped">
            <thead>
                <tr>
                    <th>Task ID</th>
                    <th>Task Name</th>
                    <th>Description</th>
                    <th>Department</th>
                    <th>Lecturer</th>
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

                        // Get student's department_id from session
                        String studentRegNumber = (String) session.getAttribute("studentRegNumber");
                        if (studentRegNumber == null) {
                            out.println("<tr><td colspan='5'>No student information found.</td></tr>");
                        } else {
                            String deptQuery = "SELECT department_id FROM students WHERE reg_number = ?";
                            pstmt = connection.prepareStatement(deptQuery);
                            pstmt.setString(1, studentRegNumber);
                            rs = pstmt.executeQuery();

                            int studentDepartmentId = -1;
                            if (rs.next()) {
                                studentDepartmentId = rs.getInt("department_id");
                            }
                            rs.close();
                            pstmt.close();

                            if (studentDepartmentId != -1) {
                                // Query to retrieve tasks filtered by student's department
                                String sql = "SELECT t.task_id, t.task_name, t.description, d.name AS department, l.index_number AS lecturer " +
                                             "FROM tasks t " +
                                             "JOIN departments d ON t.department_id = d.department_id " +
                                             "JOIN lecturers l ON t.index_number = l.index_number " +
                                             "WHERE t.department_id = ?";
                                pstmt = connection.prepareStatement(sql);
                                pstmt.setInt(1, studentDepartmentId);
                                rs = pstmt.executeQuery();

                                while (rs.next()) {
                                    int taskId = rs.getInt("task_id");
                                    String taskName = rs.getString("task_name");
                                    String description = rs.getString("description");
                                    String department = rs.getString("department");
                                    String lecturer = rs.getString("lecturer");

                                    out.println("<tr>");
                                    out.println("<td>" + taskId + "</td>");
                                    out.println("<td>" + taskName + "</td>");
                                    out.println("<td>" + description + "</td>");
                                    out.println("<td>" + department + "</td>");
                                    out.println("<td>" + lecturer + "</td>");
                                    out.println("</tr>");
                                }

                                if (!rs.isBeforeFirst()) { // Check if result set is empty
                                    out.println("<tr><td colspan='5'>No tasks found.</td></tr>");
                                }
                            } else {
                                out.println("<tr><td colspan='5'>Student's department not found.</td></tr>");
                            }
                        }
                    } catch (Exception e) {
                        e.printStackTrace();
                        out.println("<tr><td colspan='5'>Error: " + e.getMessage() + "</td></tr>");
                    } finally {
                        if (rs != null) try { rs.close(); } catch (SQLException e) { e.printStackTrace(); }
                        if (pstmt != null) try { pstmt.close(); } catch (SQLException e) { e.printStackTrace(); }
                        if (connection != null) try { connection.close(); } catch (SQLException e) { e.printStackTrace(); }
                    }
                %>
            </tbody>
        </table>

        <!-- Download PDF Button -->
        <a href="downloadPdf" class="btn btn-secondary">Download  <i class="fas fa-file-pdf"></i></a>

        <!-- Back to Create Task Button -->
        <a href="index.html" class="btn btn-primary">Back to Home</a>
    </div>

    <script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.5.4/dist/umd/popper.min.js"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
</body>
</html>
