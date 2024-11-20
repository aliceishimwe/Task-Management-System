<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login - Task Management System</title>
</head>
<body>
    <%
        String dbURL = "jdbc:mysql://localhost:3306/crud";
        String dbUser = "root";
        String dbPassword = "";

        String userType = request.getParameter("userType");
        String username = request.getParameter("username");
        String password = request.getParameter("password");

        // Debugging output
        out.println("<p>UserType: " + userType + "</p>");
        out.println("<p>Username: " + username + "</p>");
        out.println("<p>Password: " + password + "</p>");

        Connection connection = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        boolean validUser = false;
        String redirectPage = "";

        try {
            // Load and register the JDBC driver
            Class.forName("com.mysql.cj.jdbc.Driver");

            // Establish a connection to the database
            connection = DriverManager.getConnection(dbURL, dbUser, dbPassword);

            // Check credentials based on user type
            if ("student".equalsIgnoreCase(userType)) {
                String sql = "SELECT * FROM students WHERE reg_number = ? AND password = ?";
                pstmt = connection.prepareStatement(sql);
                pstmt.setString(1, username);
                pstmt.setString(2, password);
                rs = pstmt.executeQuery();

                if (rs.next()) {
                    validUser = true;
                    redirectPage = "StudentTaskManagement.jsp"; // Redirect to student's dashboard
                    session.setAttribute("studentRegNumber", username); // Store user info in session
                }
            } else if ("lecturer".equalsIgnoreCase(userType)) {
                String sql = "SELECT * FROM lecturers WHERE index_number = ? AND password = ?";
                pstmt = connection.prepareStatement(sql);
                pstmt.setString(1, username);
                pstmt.setString(2, password);
                rs = pstmt.executeQuery();

                if (rs.next()) {
                    validUser = true;
                    redirectPage = "CreateTask.html"; // Redirect to lecturer's dashboard
                    session.setAttribute("lecturer_index_number", username); // Store user info in session
                }
            } else {
                out.println("<h1>Error: Invalid user type</h1>");
                out.println("<a href='login.html'>Back to Login</a>");
                return;
            }

            if (validUser) {
                response.sendRedirect(redirectPage);
            } else {
                out.println("<h1>Invalid credentials. Please try again.</h1>");
                out.println("<a href='login.html'>Back to Login</a>");
            }

        } catch (Exception e) {
            e.printStackTrace();
            out.println("<h1>Error: " + e.getMessage() + "</h1>");
            out.println("<a href='login.jsp'>Back to Login</a>");
        } finally {
            // Clean up
            if (rs != null) try { rs.close(); } catch (SQLException e) { e.printStackTrace(); }
            if (pstmt != null) try { pstmt.close(); } catch (SQLException e) { e.printStackTrace(); }
            if (connection != null) try { connection.close(); } catch (SQLException e) { e.printStackTrace(); }
        }
    %>
</body>
</html>
