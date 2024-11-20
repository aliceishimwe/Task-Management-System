@WebServlet("/getNotifications")
public class NotificationServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        String studentRegNumber = (String) request.getSession().getAttribute("studentRegNumber");
        if (studentRegNumber == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            return;
        }

        // Fetch notifications from database (replace this with your actual database code)
        List<String> notifications = fetchNotificationsForStudent(studentRegNumber);

        // Convert notifications to JSON
        String json = new Gson().toJson(notifications);
        response.getWriter().write(json);
    }

    private List<String> fetchNotificationsForStudent(String studentRegNumber) {
        // Dummy implementation - replace with actual database code
        return Arrays.asList("New task assigned: Task 1", "New task assigned: Task 2");
    }
}
