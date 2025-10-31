package adminServlet;

import DAO.CategoryDAOImpl;
import Entity.Category;
import Utils.Jdbc;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

@WebServlet("/admin/add_category")
public class AddCategoryServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");

        String name = req.getParameter("categoryName");
        
        CategoryDAOImpl categoryDAO = new CategoryDAOImpl();
        
        // --- PHẦN SỬA CHỮA BẮT ĐẦU TẠI ĐÂY ---
        String newId = "C01"; // ID mặc định nếu bảng trống
        String maxId = categoryDAO.findMaxId();
        
        if (maxId != null && maxId.length() > 1 && maxId.startsWith("C")) {
            // Lấy phần số (ví dụ: 01 từ C01) và tăng lên 1
            try {
                int number = Integer.parseInt(maxId.substring(1));
                number++; // Tăng lên 1
                newId = "C" + String.format("%02d", number); // Format lại thành C02, C10, ...
            } catch (NumberFormatException e) {
                // Xử lý nếu ID lớn nhất không đúng định dạng số (nên kiểm tra database)
                System.err.println("Lỗi định dạng ID: " + maxId);
            }
        }
        
        // DEBUG: Kiểm tra ID mới được tạo
        System.out.println("DEBUG: New Category ID generated: " + newId);
        
        String id = newId;
        // --- PHẦN SỬA CHỮA KẾT THÚC TẠI ĐÂY ---

        Category c = new Category(id, name);

        boolean success = categoryDAO.insert(c); // Dùng đối tượng DAO đã tạo
        if (success) {
            resp.sendRedirect(req.getContextPath() + "/admin/manage_categories");
        } else {
            // Ghi log để biết lỗi
            System.err.println("LỖI: Thêm loại tin thất bại cho ID: " + id + ", Tên: " + name);
            resp.getWriter().println("❌ Thêm loại tin thất bại (Kiểm tra Log Console)");
        }
    }
}