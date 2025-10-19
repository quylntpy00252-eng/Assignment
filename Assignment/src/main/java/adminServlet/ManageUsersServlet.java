package adminServlet;

import java.io.IOException;
import java.util.List;

import DAO.UserDAO;
import DAO.UserDAOImpl;
import Entity.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/admin/manage_users")
public class ManageUsersServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        UserDAO dao = new UserDAOImpl();
        List<User> users = dao.getAllUsers();

        req.setAttribute("users", users);

        req.getRequestDispatcher("/admin/manage_users.jsp").forward(req, resp);
    }
}
