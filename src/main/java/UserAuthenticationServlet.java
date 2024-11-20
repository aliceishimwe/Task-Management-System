import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

@WebServlet("/login")
public class UserAuthenticationServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String regNumber = request.getParameter("reg_number");
        String password = request.getParameter("password");
        String userType = request.getParameter("user_type");

        // Validate input
        if (regNumber == null || password == null || userType == null) {
            response.sendRedirect("login.jsp?error=Invalid input");
            return;
        }

        boolean isAuthenticated = false;

        try (Connection con = Database.getConnection()) {
            String query = "";
            if ("student".equalsIgnoreCase(userType)) {
                query = "SELECT * FROM Students WHERE reg_number = ? AND password = ?";
            } else if ("lecturer".equalsIgnoreCase(userType)) {
                query = "SELECT * FROM Lecturers WHERE index_number = ? AND password = ?";
            } else {
                response.sendRedirect("login.jsp?error=Invalid user type");
                return;
            }

            try (PreparedStatement ps = con.prepareStatement(query)) {
                ps.setString(1, regNumber);
                ps.setString(2, password);
                try (ResultSet rs = ps.executeQuery()) {
                    isAuthenticated = rs.next();
                }
            }
        } catch (SQLException e) {
            // Ideally, use a logging framework in real applications
            e.printStackTrace();
            response.sendRedirect("login.jsp?error=Database error");
            return;
        }

        if (isAuthenticated) {
            request.getSession().setAttribute("user", regNumber);
            request.getSession().setAttribute("user_type", userType);
            if ("student".equalsIgnoreCase(userType)) {
                response.sendRedirect("studentDashboard.jsp");
            } else {
                response.sendRedirect("lecturerDashboard.jsp");
            }
        } else {
            response.sendRedirect("login.jsp?error=Invalid credentials");
        }
    }
}
