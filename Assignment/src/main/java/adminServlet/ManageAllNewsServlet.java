package adminServlet;

import DAO.CategoryDAO;
import DAO.CategoryDAOImpl;
import DAO.NewsDAO;
import DAO.NewsDAOImpl;
import Entity.Category; // Cần import Category
import Entity.News;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

@WebServlet("/admin/manage_all_news")
public class ManageAllNewsServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        
        req.setCharacterEncoding("UTF-8");
        resp.setCharacterEncoding("UTF-8");
        
        // 1. Lấy Categories cho Menu (BẮT BUỘC)
        CategoryDAO categoryDAO = new CategoryDAOImpl();
        List<Category> categories = categoryDAO.findAll();
        req.setAttribute("categories", categories); // <-- FIX: Cần biến này cho JSP
        
        // 2. Lấy danh sách News cho Bảng
        NewsDAO newsDAO = new NewsDAOImpl();
        List<News> newsList = newsDAO.findAll();
        req.setAttribute("newsList", newsList);
        
        // 3. Xử lý thông báo (nếu có từ redirect)
        String message = req.getParameter("message");
        if (message != null) {
            req.setAttribute("message", message);
        }

        req.getRequestDispatcher("/admin/manage_all_news.jsp").forward(req, resp);
    }
}