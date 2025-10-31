package adminServlet;


import java.io.IOException;
import java.util.List;

import DAO.NewsDAO;
import DAO.NewsDAOImpl;
import DAO.UserDAO;
import DAO.UserDAOImpl;
import Entity.News;
import Entity.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/admin")
public class AdminServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
    	NewsDAO newsDAO = new NewsDAOImpl();
    	UserDAO userDAO = new UserDAOImpl();
        List<User> users = userDAO.findAll();
        request.setAttribute("users", users);
        
        List<News> homeLeft = newsDAO.findHomeByPosition(1);   // vị trí cột trái
        List<News> homeCenter = newsDAO.findHomeByPosition(2); 
        
        request.setAttribute("homeLeft", homeLeft);
        request.setAttribute("homeCenter", homeCenter);
        
        request.getRequestDispatcher("/admin/admin.jsp").forward(request, response);
    }
}