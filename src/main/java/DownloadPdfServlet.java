import com.itextpdf.text.Document;
import com.itextpdf.text.DocumentException;
import com.itextpdf.text.Paragraph;
import com.itextpdf.text.pdf.PdfWriter;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

@WebServlet("/downloadPdf")
public class DownloadPdfServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("application/pdf");
        response.setHeader("Content-Disposition", "attachment; filename=tasks.pdf");

        Document document = new Document();
        PdfWriter pdfWriter = null;
        try {
            pdfWriter = PdfWriter.getInstance(document, response.getOutputStream());
            document.open();

            String dbURL = "jdbc:mysql://localhost:3306/crud";
            String dbUser = "root";
            String dbPassword = "";

            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
            } catch (ClassNotFoundException e) {
                throw new ServletException("MySQL JDBC Driver not found", e);
            }

            try (Connection connection = DriverManager.getConnection(dbURL, dbUser, dbPassword)) {
                String studentRegNumber = (String) request.getSession().getAttribute("studentRegNumber");
                if (studentRegNumber != null) {
                    String deptQuery = "SELECT department_id FROM students WHERE reg_number = ?";
                    try (PreparedStatement pstmt = connection.prepareStatement(deptQuery)) {
                        pstmt.setString(1, studentRegNumber);
                        try (ResultSet rs = pstmt.executeQuery()) {
                            int studentDepartmentId = -1;
                            if (rs.next()) {
                                studentDepartmentId = rs.getInt("department_id");
                            }

                            if (studentDepartmentId != -1) {
                                String sql = "SELECT t.task_id, t.task_name, t.description, d.name AS department, l.index_number AS lecturer " +
                                             "FROM tasks t " +
                                             "JOIN departments d ON t.department_id = d.department_id " +
                                             "JOIN lecturers l ON t.index_number = l.index_number " +
                                             "WHERE t.department_id = ?";
                                try (PreparedStatement taskStmt = connection.prepareStatement(sql)) {
                                    taskStmt.setInt(1, studentDepartmentId);
                                    try (ResultSet taskRs = taskStmt.executeQuery()) {
                                        while (taskRs.next()) {
                                            int taskId = taskRs.getInt("task_id");
                                            String taskName = taskRs.getString("task_name");
                                            String description = taskRs.getString("description");
                                            String department = taskRs.getString("department");
                                            String lecturer = taskRs.getString("lecturer");

                                            document.add(new Paragraph("Task ID: " + taskId));
                                            document.add(new Paragraph("Task Name: " + taskName));
                                            document.add(new Paragraph("Description: " + description));
                                            document.add(new Paragraph("Department: " + department));
                                            document.add(new Paragraph("Lecturer: " + lecturer));
                                            document.add(new Paragraph(" "));
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            } catch (SQLException e) {
                e.printStackTrace();
                throw new ServletException("Error generating PDF", e);
            }
        } catch (DocumentException e) {
            throw new IOException(e.getMessage());
        } finally {
            if (document != null) {
                document.close();
            }
            if (pdfWriter != null) {
                pdfWriter.close();
            }
        }
    }
}
