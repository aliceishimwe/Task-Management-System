<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Create Task - Task Management System</title>
</head>
<body>
    <%
        String dbURL = "jdbc:mysql://localhost:3306/crud";
        String dbUser = "root";
        String dbPassword = "";

        String taskName = request.getParameter("taskName");
        String description = request.getParameter("description");
        String department = request.getParameter("department");

        Connection connection = null;
        PreparedStatement pstmt = null;

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            connection = DriverManager.getConnection(dbURL, dbUser, dbPassword);

            // Find department_id based on the department name
            String deptSql = "SELECT department_id FROM departments WHERE name = ?";
            pstmt = connection.prepareStatement(deptSql);
            pstmt.setString(1, department);
            ResultSet rs = pstmt.executeQuery();
            int departmentId = 0;
            if (rs.next()) {
                departmentId = rs.getInt("department_id");
            }
            rs.close();
            pstmt.close();

            // Check if departmentId was found
            if (departmentId == 0) {
                out.println("<h1>Department not found</h1>");
            } else {
                // Insert the task
                String sql = "INSERT INTO tasks (task_name, description, department_id) VALUES (?, ?, ?)";
                pstmt = connection.prepareStatement(sql);
                pstmt.setString(1, taskName);
                pstmt.setString(2, description);
                pstmt.setInt(3, departmentId);

                int rowsAffected = pstmt.executeUpdate();

                if (rowsAffected > 0) {
                    out.println("<h1>Task created successfully</h1>");
                } else {
                    out.println("<h1>Failed to create task</h1>");
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            out.println("<h1>Error: " + e.getMessage() + "</h1>");
        } finally {
            if (pstmt != null) try { pstmt.close(); } catch (SQLException e) { e.printStackTrace(); }
            if (connection != null) try { connection.close(); } catch (SQLException e) { e.printStackTrace(); }
        }
    %>
</body>
</html>
