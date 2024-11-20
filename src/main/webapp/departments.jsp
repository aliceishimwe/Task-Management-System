<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>Departments</title>
</head>
<body>
    <%
        String dbURL = "jdbc:mysql://localhost:3306/crud";
        String dbUser = "yourUsername";
        String dbPassword = "yourPassword";

        Connection connection = null;
        Statement stmt = null;
        ResultSet rs = null;

        try {
            // Load and register the JDBC driver
            Class.forName("com.mysql.cj.jdbc.Driver");

            // Establish a connection to the database
            connection = DriverManager.getConnection(dbURL, dbUser, dbPassword);

            // Create a statement and execute a query to retrieve department data
            stmt = connection.createStatement();
            String sql = "SELECT id, name FROM departments";
            rs = stmt.executeQuery(sql);

            // Generate department options
            while (rs.next()) {
                int id = rs.getInt("id");
                String name = rs.getString("name");
                out.println("<option value='" + id + "'>" + name + "</option>");
            }

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            // Clean up
            if (rs != null) try { rs.close(); } catch (SQLException e) { e.printStackTrace(); }
            if (stmt != null) try { stmt.close(); } catch (SQLException e) { e.printStackTrace(); }
            if (connection != null) try { connection.close(); } catch (SQLException e) { e.printStackTrace(); }
        }
    %>
</body>
</html>
