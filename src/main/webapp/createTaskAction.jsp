<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Task Created</title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
</head>
<body>
    <div class="container mt-5">
        <%
            String dbURL = "jdbc:mysql://localhost:3306/crud";
            String dbUser = "root";
            String dbPassword = "";

            Connection connection = null;
            PreparedStatement pstmt = null;
            ResultSet rs = null;

            String taskName = request.getParameter("taskName");
            String description = request.getParameter("description");
            String taskId = request.getParameter("taskId");
            String departmentId = request.getParameter("department");
            String lecturerIndexNumber = request.getParameter("lecturerIndexNumber");

            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                connection = DriverManager.getConnection(dbURL, dbUser, dbPassword);

                // Check if lecturer exists
                String lecturerCheckSQL = "SELECT COUNT(*) FROM lecturers WHERE index_number = ?";
                pstmt = connection.prepareStatement(lecturerCheckSQL);
                pstmt.setString(1, lecturerIndexNumber);
                rs = pstmt.executeQuery();
                rs.next();
                int lecturerCount = rs.getInt(1);

                if (lecturerCount == 0) {
                    out.println("<div class='alert alert-danger'>Error: Lecturer with index number " + lecturerIndexNumber + " does not exist.</div>");
                } else {
                    // Insert task into the database
                    String sql = "INSERT INTO tasks (task_name, description, task_id, department_id, index_number) " +
                                 "VALUES (?, ?, ?, ?, ?)";
                    pstmt = connection.prepareStatement(sql);
                    pstmt.setString(1, taskName);
                    pstmt.setString(2, description);
                    pstmt.setString(3, taskId);
                    pstmt.setString(4, departmentId);
                    pstmt.setString(5, lecturerIndexNumber);
                    int rowsAffected = pstmt.executeUpdate();

                    if (rowsAffected > 0) {
                        out.println("<div class='alert alert-success'>Task created successfully!</div>");
                    } else {
                        out.println("<div class='alert alert-danger'>Failed to create task. Please try again.</div>");
                    }
                }

            } catch (Exception e) {
                e.printStackTrace();
                out.println("<div class='alert alert-danger'>Error: " + e.getMessage() + "</div>");
            } finally {
                if (rs != null) try { rs.close(); } catch (SQLException e) { e.printStackTrace(); }
                if (pstmt != null) try { pstmt.close(); } catch (SQLException e) { e.printStackTrace(); }
                if (connection != null) try { connection.close(); } catch (SQLException e) { e.printStackTrace(); }
            }
        %>
        <a href="TaskManagement.jsp" class="btn btn-primary">View</a>
        
    </div>
    <script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.5.4/dist/umd/popper.min.js"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
    
</body>
</html>

