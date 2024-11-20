import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

@WebServlet("/manageTasks")

public class ManageTasksServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        String title = request.getParameter("title");
        String description = request.getParameter("description");
        String taskId = request.getParameter("task_id");
        int departmentId = Integer.parseInt(request.getParameter("department_id"));
        String lecturerIndexNumber = (String) request.getSession().getAttribute("user");

        try (Connection con = Database.getConnection(); // Ensure Database.getConnection() is defined
             PreparedStatement ps = createPreparedStatement(con, action, title, description, departmentId, taskId, lecturerIndexNumber)) {

            if (ps != null) {
                ps.executeUpdate();
            } else {
                throw new IllegalArgumentException("Invalid action: " + action);
            }

        } catch (SQLException e) {
            handleException(request, response, "Database error occurred: " + e.getMessage(), e);
        } catch (IllegalArgumentException e) {
            handleException(request, response, e.getMessage(), e);
        }

        response.sendRedirect("lecturerDashboard.jsp");
    }

    private PreparedStatement createPreparedStatement(Connection con, String action, String title, String description,
                                                      int departmentId, String taskId, String lecturerIndexNumber) throws SQLException {
        String sql = null;
        if ("create".equalsIgnoreCase(action)) {
            sql = "INSERT INTO Tasks (title, description, department_id, lecturer_index_number) VALUES (?, ?, ?, ?)";
        } else if ("update".equalsIgnoreCase(action)) {
            sql = "UPDATE Tasks SET title = ?, description = ?, department_id = ? WHERE id = ?";
        } else if ("delete".equalsIgnoreCase(action)) {
            sql = "DELETE FROM Tasks WHERE id = ?";
        }

        if (sql != null) {
            PreparedStatement ps = con.prepareStatement(sql);
            if ("create".equalsIgnoreCase(action)) {
                ps.setString(1, title);
                ps.setString(2, description);
                ps.setInt(3, departmentId);
                ps.setString(4, lecturerIndexNumber);
            } else if ("update".equalsIgnoreCase(action)) {
                ps.setString(1, title);
                ps.setString(2, description);
                ps.setInt(3, departmentId);
                ps.setString(4, taskId);
            } else if ("delete".equalsIgnoreCase(action)) {
                ps.setString(1, taskId);
            }
            return ps;
        }
        return null;
    }

    private void handleException(HttpServletRequest request, HttpServletResponse response, String message, Exception e)
            throws ServletException, IOException {
        e.printStackTrace(); // Use a logging framework in real applications
        request.setAttribute("error", message);
        request.getRequestDispatcher("errorPage.jsp").forward(request, response);
    }
}
