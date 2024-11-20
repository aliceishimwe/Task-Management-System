<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Registration Confirmation</title>
</head>
<body>
    <%
        // Database connection parameters
        String dbURL = "jdbc:mysql://localhost:3306/crud";
        String dbUser = "root";
        String dbPassword = "";

        String userType = request.getParameter("userType");
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String departmentName = request.getParameter("department");

        Connection connection = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        String sql = "";
        int departmentId = 0;

        try {
            // Load and register the JDBC driver
            Class.forName("com.mysql.cj.jdbc.Driver");

            // Establish a connection to the database
            connection = DriverManager.getConnection(dbURL, dbUser, dbPassword);

            // Find department_id based on the department name
            String deptSql = "SELECT department_id FROM departments WHERE name = ?";
            pstmt = connection.prepareStatement(deptSql);
            pstmt.setString(1, departmentName);
            rs = pstmt.executeQuery();
            if (rs.next()) {
                departmentId = rs.getInt("department_id");
            } else {
                out.println("<h1>Error: Department not found</h1>");
                return;
            }
            rs.close();
            pstmt.close();

            // Prepare SQL based on user type
            if ("student".equalsIgnoreCase(userType)) {
                sql = "INSERT INTO students (reg_number, password, name, department_id) VALUES (?, ?, ?, ?)";
            } else if ("lecturer".equalsIgnoreCase(userType)) {
                sql = "INSERT INTO lecturers (index_number, password, name, department_id) VALUES (?, ?, ?, ?)";
            } else {
                out.println("<h1>Error: Invalid user type</h1>");
                return;
            }

            pstmt = connection.prepareStatement(sql);
            pstmt.setString(1, username);
            pstmt.setString(2, password);
            pstmt.setString(3, username); // assuming the username is used as name
            pstmt.setInt(4, departmentId);

            int rowsAffected = pstmt.executeUpdate();

            if (rowsAffected > 0) {
                if ("student".equalsIgnoreCase(userType)) {
                    out.println("<h1>Registration Successful</h1>");
                    out.println("<a href='login.html'>Login,Student</a>");
                } else if ("lecturer".equalsIgnoreCase(userType)) {
                    out.println("<h1>Registration Successful</h1>");
                    out.println("<a href='login.html'>Login,Lecture</a>");
                }
            } else {
                out.println("<h1>Registration Failed</h1>");
            }

        } catch (Exception e) {
            e.printStackTrace();
            out.println("<h1>Error: " + e.getMessage() + "</h1>");
        } finally {
            // Clean up
            if (rs != null) try { rs.close(); } catch (SQLException e) { e.printStackTrace(); }
            if (pstmt != null) try { pstmt.close(); } catch (SQLException e) { e.printStackTrace(); }
            if (connection != null) try { connection.close(); } catch (SQLException e) { e.printStackTrace(); }
        }
    %>
</body>
</html>
