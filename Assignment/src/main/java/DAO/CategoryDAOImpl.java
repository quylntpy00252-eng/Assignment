package DAO;

import Entity.Category;
import Utils.Jdbc;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class CategoryDAOImpl implements CategoryDAO {

    @Override
    public List<Category> findAll() {
        List<Category> list = new ArrayList<>();
        String sql = "SELECT * FROM CATEGORIES ORDER BY Name ASC";
        try (Connection con = Jdbc.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(mapResultSetToCategory(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    @Override
    public Category findById(String id) {
        String sql = "SELECT * FROM CATEGORIES WHERE Id = ?";
        try (Connection con = Jdbc.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return mapResultSetToCategory(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    @Override
    public boolean insert(Category category) {
        String sql = "INSERT INTO CATEGORIES (Id, Name) VALUES (?, ?)";
        try (Connection con = Jdbc.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, category.getId());
            ps.setNString(2, category.getName());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    @Override
    public boolean update(Category category) {
        String sql = "UPDATE CATEGORIES SET Name = ? WHERE Id = ?";
        try (Connection con = Jdbc.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setNString(1, category.getName());
            ps.setString(2, category.getId());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    @Override
    public boolean delete(String id) {
        String sql = "DELETE FROM CATEGORIES WHERE Id = ?";
        try (Connection con = Jdbc.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    private Category mapResultSetToCategory(ResultSet rs) throws SQLException {
        Category c = new Category();
        c.setId(rs.getString("Id"));
        c.setName(rs.getNString("Name"));
        return c;
    }
    public String findMaxId() {
        // Truy vấn để lấy ID lớn nhất theo thứ tự giảm dần (ORDER BY Id DESC) và chỉ lấy 1 dòng
        String sql = "SELECT TOP 1 Id FROM CATEGORIES ORDER BY Id DESC";
        try (Connection con = Jdbc.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getString("Id");
            }
        } catch (SQLException e) {
            // e.printStackTrace(); // Tùy chọn: có thể bỏ qua lỗi này nếu bảng trống
        }
        return null; // Trả về null nếu bảng hoàn toàn trống
    }
}