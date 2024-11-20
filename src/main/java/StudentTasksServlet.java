import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.RequestDispatcher;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/studentTasks")
public class StudentTasksServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Retrieve the registered number of the student from the session
        String regNumber = (String) request.getSession().getAttribute("user");

        // Check if the user is logged in
        if (regNumber == null) {
            response.sendRedirect("login.jsp?error=Please log in to view your tasks");
            return;
        }

        List<Task> tasks = new ArrayList<>();

        // Try-with-resources for Connection and PreparedStatement
        try (Connection con = Database.getConnection();
             PreparedStatement ps = con.prepareStatement("SELECT * FROM Tasks WHERE department_id = (SELECT department_id FROM Students WHERE reg_number = ?)")) {
             
            ps.setString(1, regNumber);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Task task = new Task();
                    task.setId(rs.getInt("id"));
                    task.setTitle(rs.getString("title"));
                    task.setDescription(rs.getString("description"));
                    task.setDepartmentId(rs.getInt("department_id"));
                    tasks.add(task);
                }
            }
            
        } catch (SQLException e) {
            // Log the exception and forward to an error page
            e.printStackTrace(); // In production, use a logging framework
            request.setAttribute("error", "An error occurred while retrieving tasks: " + e.getMessage());
            request.getRequestDispatcher("errorPage.jsp").forward(request, response);
            return;
        }

        // Set the tasks attribute and forward to the student Dashboard
        request.setAttribute("tasks", tasks);
        RequestDispatcher dispatcher = request.getRequestDispatcher("studentDashboard.jsp");
        dispatcher.forward(request, response);
    }
}
