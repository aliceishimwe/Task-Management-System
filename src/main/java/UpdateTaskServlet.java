import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.SQLException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/UpdateTaskServlet")
public class UpdateTaskServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String jdbcURL = "jdbc:mysql://localhost:3306/crud";
        String dbUser = "root";
        String dbPassword = "";

        String taskId = request.getParameter("task_id");
        String taskName = request.getParameter("task_name");
        String description = request.getParameter("description");
        String departmentId = request.getParameter("department_id");
        String lecturerIndexNumber = request.getParameter("index_number");

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection(jdbcURL, dbUser, dbPassword);

            String sql = "UPDATE Tasks SET task_name=?, description=?, department_id=?, index_number=? WHERE task_id=?";
            PreparedStatement statement = conn.prepareStatement(sql);
            statement.setString(1, taskName);
            statement.setString(2, description);
            statement.setString(3, departmentId);
            statement.setString(4, lecturerIndexNumber);
            statement.setInt(5, Integer.parseInt(taskId));

            int rowsUpdated = statement.executeUpdate();

            if (rowsUpdated > 0) {
                response.sendRedirect("TaskManagement.jsp?message=Task updated successfully");
            } else {
                response.sendRedirect("TaskManagement.jsp?error=Error updating task");
            }

            statement.close();
            conn.close();
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
            response.sendRedirect("TaskManagement.jsp?error=" + e.getMessage());
        }
    }
}
