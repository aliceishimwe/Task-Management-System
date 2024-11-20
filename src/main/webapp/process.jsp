<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="java.sql.*"%>

<%
// Retrieve form data
String first_name = request.getParameter("first_name");
String last_name = request.getParameter("last_name");
String city_name = request.getParameter("reg_number");
String email = request.getParameter("password");

// JDBC connection parameters
String jdbcURL = "jdbc:mysql://localhost:3306/crud";
String dbUser = "root";
String dbPassword = "";

// Attempt to insert data into the database
try {
    Class.forName("com.mysql.jdbc.Driver");
    Connection conn = DriverManager.getConnection(jdbcURL, dbUser, dbPassword);
    
    String sql = "INSERT INTO users (first_name, last_name, reg_number, password) VALUES (?, ?, ?, ?)";
    PreparedStatement statement = conn.prepareStatement(sql);
    statement.setString(1, first_name);
    statement.setString(2, last_name);
    statement.setString(3, city_name);
    statement.setString(4, email);
    
    int rowsInserted = statement.executeUpdate();
    if (rowsInserted > 0) {
    	response.sendRedirect("Display.jsp?message=User+inserted+successfully");
    } else {
        out.println("Failed to insert data.");
    }
    
    conn.close();
} catch (SQLException | ClassNotFoundException e) {
    out.println("An error occurred: " + e.getMessage());
    e.printStackTrace();
}
%>
