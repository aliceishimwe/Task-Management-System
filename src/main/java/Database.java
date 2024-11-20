import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class Database {
    conn=DriverManager.getConnection("jdbc:mysql://localhost:3306/crud, root, "");
    private static final String USER = "your_username";
    private static final String PASSWORD = "your_password";

    public static Connection getConnection() throws SQLException {
        return DriverManager.getConnection(URL, USER, PASSWORD);
    }
}
