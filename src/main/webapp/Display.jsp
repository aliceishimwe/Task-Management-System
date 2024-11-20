<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="java.sql.*"%>
<!DOCTYPE html>
<html>
<head>
<link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.3/css/all.min.css">
<title>User List</title>
<style>
    body {
        font-family: Arial, sans-serif;
        background-color: #f0f0f0;
        margin: 0;
        padding: 20px;
    }

    .container {
        max-width: 800px;
        margin: 20px auto;
        background-color: #99b3ff;
        padding: 20px;
        border-radius: 8px;
        box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
    }

    h2 {
        text-align: center;
        margin-bottom: 20px;
    }

    table {
        width: 100%;
        border-collapse: collapse;
        margin-top: 20px;
    }

    th, td {
        border: 1px solid #ddd;
        padding: 8px;
        text-align: left;
    }

    th {
        background-color: #f2f2f2;
    }

    .action-buttons {
        display: flex;
        justify-content: space-around;
    }

    .edit-btn, .delete-btn {
        padding: 5px 10px;
        border: none;
        cursor: pointer;
        font-size: 14px;
        border-radius: 4px;
    }

    .edit-btn {
        background-color:#c2c2a3;
        color: white;
    }

    .edit-btn:hover {
        background-color: #218838;
    }

    .delete-btn {
        background-color:  #ff9999;
        color: white;
    }

    .delete-btn:hover {
        background-color: #da190b;
    }

    #searchInput {
        width: 100%;
        padding: 10px;
        margin-bottom: 20px;
        border: 1px solid #ddd;
        border-radius: 4px;
    }
</style>
</head>
<body>
<div class="container">
    <h2>Students List</h2>

    <a href="index.html" class="btn btn-secondary">Add New Student</a>
    <table id="userTable">
        <thead>
            <tr>
                <th>ID</th>
                <th>First Name</th>
                <th>Last Name</th>
                <th>Reg_Number</th>
                <th>Password</th>
                <th>Actions</th>
            </tr>
        </thead>
        <tbody>
            <% 
            try {
                String jdbcURL = "jdbc:mysql://localhost:3306/crud";
                String dbUser = "root";
                String dbPassword = "";
                
                Class.forName("com.mysql.jdbc.Driver");
                Connection conn = DriverManager.getConnection(jdbcURL, dbUser, dbPassword);
                
                String sql = "SELECT * FROM users";
                Statement statement = conn.createStatement();
                ResultSet result = statement.executeQuery(sql);
                
                while (result.next()) {
                    int id = result.getInt("id");
                    String firstName = result.getString("first_name");
                    String lastName = result.getString("last_name");
                    String cityName = result.getString("reg_number");
                    String email = result.getString("password");
                    
                    out.println("<tr>");
                    out.println("<td>" + id + "</td>");
                    out.println("<td>" + firstName + "</td>");
                    out.println("<td>" + lastName + "</td>");
                    out.println("<td>" + cityName + "</td>");
                    out.println("<td>" + email + "</td>");
                    out.println("<td class='action-buttons'>");
                    out.println("<button class='edit-btn' onclick='editUser(" + id + ")'>Edit</button>");
                    out.println("<button class='delete-btn' onclick='deleteUser(" + id + ")'>Delete</button>");
                    out.println("</td>");
                    out.println("</tr>");
                }
                
                conn.close();
            } catch (SQLException | ClassNotFoundException e) {
                out.println("An error occurred: " + e.getMessage());
                e.printStackTrace();
            }
            %>
        </tbody>
    </table>
</div>

<script>
    function editUser(userId) {
        window.location.href = "editUser.jsp?id=" + userId;
    }

    function deleteUser(userId) {
        if (confirm("Are you sure you want to delete this user?")) {
            var xhr = new XMLHttpRequest();
            xhr.open("POST", "UserServlet?action=delete&id=" + userId, true);
            xhr.onreadystatechange = function() {
                if (xhr.readyState === XMLHttpRequest.DONE) {
                    if (xhr.status === 200) {
                        alert("Student deleted successfully!");
                        window.location.reload();
                    } else {
                        console.log("Error:", xhr.status);
                        alert("Failed to delete student.");
                    }
                }
            };
            xhr.send();
        }
    }

    function searchTable() {
        var input, filter, table, tr, td, i, j, txtValue;
        input = document.getElementById("searchInput");
        filter = input.value.toLowerCase();
        table = document.getElementById("userTable");
        tr = table.getElementsByTagName("tr");
        
        for (i = 1; i < tr.length; i++) {
            tr[i].style.display = "none";
            td = tr[i].getElementsByTagName("td");
            for (j = 0; j < td.length; j++) {
                if (td[j]) {
                    txtValue = td[j].textContent || td[j].innerText;
                    if (txtValue.toLowerCase().indexOf(filter) > -1) {
                        tr[i].style.display = "";
                        break;
                    }
                }
            }
        }
    }
</script>
</body>
</html>
