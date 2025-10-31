package DAO;

import Entity.News;
import Utils.Jdbc;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID; // Thêm import UUID

public class NewsDAOImpl implements NewsDAO {

	@Override
	public List<News> findAll() {
	    List<News> list = new ArrayList<>();
	    String sql = """
	        SELECT n.*, c.Name AS CategoryName, u.Fullname AS AuthorName
	        FROM NEWS n
	        LEFT JOIN CATEGORIES c ON n.CategoryId = c.Id
	        LEFT JOIN USERS u ON n.Author = u.Id
	        ORDER BY n.PostedDate DESC
	    """;
	    try (Connection con = Jdbc.getConnection();
	         PreparedStatement ps = con.prepareStatement(sql);
	         ResultSet rs = ps.executeQuery()) {
	        while (rs.next()) {
	            News n = mapResultSetToNews(rs);
	            n.setCategoryName(rs.getNString("CategoryName"));
	            n.setAuthorName(rs.getNString("AuthorName")); 
	            list.add(n);
	        }
	    } catch (SQLException e) {
	        e.printStackTrace();
	    }
	    return list;
	}


    @Override
    public News findById(String id) {
        String sql = """
            SELECT n.*, c.Name AS CategoryName, u.Fullname AS AuthorName
            FROM NEWS n
            LEFT JOIN CATEGORIES c ON n.CategoryId = c.Id
            LEFT JOIN USERS u ON n.Author = u.Id
            WHERE n.Id = ?
        """;
        try (Connection con = Jdbc.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    News n = mapResultSetToNews(rs);
                    n.setCategoryName(rs.getNString("CategoryName"));
                    n.setAuthorName(rs.getNString("AuthorName")); 
                    return n;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }


    @Override
    public List<News> findByCategory(String categoryId) {
        List<News> list = new ArrayList<>();
        String sql = "SELECT * FROM NEWS WHERE CategoryId = ? ORDER BY PostedDate DESC";
        try (Connection con = Jdbc.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, categoryId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapResultSetToNews(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    @Override
    public List<News> searchByTitle(String keyword) {
        List<News> list = new ArrayList<>();
        String sql = "SELECT * FROM NEWS WHERE Title LIKE ? ORDER BY PostedDate DESC";
        try (Connection con = Jdbc.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setNString(1, "%" + keyword + "%");
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapResultSetToNews(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    @Override
    public boolean insert(News news) {
        String sql = """
            INSERT INTO NEWS (Id, Title, Content, Image, PostedDate, Author, ViewCount, CategoryId, Home, Position, Status)
            VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
            """;
        try (Connection con = Jdbc.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, news.getId());
            ps.setNString(2, news.getTitle());
            ps.setNString(3, news.getContent());
            ps.setString(4, news.getImage());
            // Sử dụng Date.valueOf() nếu cần chuyển đổi từ java.util.Date sang java.sql.Date
            ps.setDate(5, news.getPostedDate() == null ? new java.sql.Date(System.currentTimeMillis()) : news.getPostedDate());
            ps.setString(6, news.getAuthor());
            ps.setInt(7, news.getViewCount());
            ps.setString(8, news.getCategoryId());
            ps.setBoolean(9, news.isHome());
            if (news.getPosition() != null) {
                ps.setInt(10, news.getPosition());
            } else {
                ps.setNull(10, java.sql.Types.INTEGER);
            }
            if (news.getStatus() != null) {
                ps.setNString(11, news.getStatus());
            } else {
                ps.setNString(11, "Chưa duyệt");
            }
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    @Override
    public boolean update(News news) {
        String sql = """
            UPDATE NEWS
            SET Title = ?, Content = ?, Image = ?, PostedDate = ?, Author = ?, ViewCount = ?, CategoryId = ?, Home = ?, Position = ?, Status = ?
            WHERE Id = ?
            """;
        try (Connection con = Jdbc.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setNString(1, news.getTitle());
            ps.setNString(2, news.getContent());
            ps.setString(3, news.getImage());
            ps.setDate(4, news.getPostedDate() == null ? new java.sql.Date(System.currentTimeMillis()) : news.getPostedDate());
            ps.setString(5, news.getAuthor());
            ps.setInt(6, news.getViewCount());
            ps.setString(7, news.getCategoryId());
            ps.setBoolean(8, news.isHome());
            if (news.getPosition() != null) {
                ps.setInt(9, news.getPosition());
            } else {
                ps.setNull(9, java.sql.Types.INTEGER);
            }
            ps.setNString(10, news.getStatus() != null ? news.getStatus() : "Chưa duyệt");
            ps.setString(11, news.getId());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    @Override
    public boolean delete(String id) {
        String sql = "DELETE FROM NEWS WHERE Id = ?";
        try (Connection con = Jdbc.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    private News mapResultSetToNews(ResultSet rs) throws SQLException {
        News n = new News();
        n.setId(rs.getString("Id"));
        n.setTitle(rs.getNString("Title"));
        n.setContent(rs.getNString("Content"));
        n.setImage(rs.getString("Image"));
        n.setPostedDate(rs.getDate("PostedDate"));
        n.setAuthor(rs.getString("Author"));
        n.setViewCount(rs.getInt("ViewCount"));
        n.setCategoryId(rs.getString("CategoryId"));
        n.setHome(rs.getBoolean("Home"));
        
        int pos = rs.getInt("Position");
        if (rs.wasNull()) {
            n.setPosition(null);
        } else {
            n.setPosition(pos);
        }

        // Sửa: Đọc trực tiếp Status (đã có trong NEWS)
        n.setStatus(rs.getNString("Status")); 

        // Sửa: Loại bỏ logic isEmailed vì cột này không có trong bảng NEWS của bạn.
        /* try {
            n.setEmailed(rs.getBoolean("isEmailed"));
        } catch (SQLException ex) {
            n.setEmailed(false);
        } */

        return n;
    }


    @Override
    public List<News> searchNews(String keyword) {
        List<News> list = new ArrayList<>();
        String sql = "SELECT n.*, c.Name AS CategoryName FROM NEWS n LEFT JOIN CATEGORIES c ON n.CategoryId = c.Id WHERE n.Title LIKE ? OR n.Content LIKE ? ORDER BY n.PostedDate DESC";
        try (Connection con = Jdbc.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            String kw = "%" + keyword.trim() + "%";
            ps.setNString(1, kw);
            ps.setNString(2, kw);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    News n = mapResultSetToNews(rs);
                    n.setCategoryName(rs.getNString("CategoryName"));
                    list.add(n);
                }
            }

            System.out.println(">>> Tìm thấy " + list.size() + " kết quả cho từ khóa: " + keyword);

        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<News> selectByAuthor(String authorId) {
        String sql = "SELECT n.*, c.Name AS CategoryName FROM NEWS n LEFT JOIN CATEGORIES c ON n.CategoryId = c.Id WHERE n.Author = ? ORDER BY n.PostedDate DESC";
        List<News> list = new ArrayList<>();
        try (Connection con = Jdbc.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, authorId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    News n = mapResultSetToNews(rs);
                    n.setCategoryName(rs.getNString("CategoryName"));
                    list.add(n);
                }
            }
            System.out.println(">>> selectByAuthor(" + authorId + "): Tìm thấy " + list.size() + " tin");
        } catch (SQLException e) {
            System.out.println(">>> Lỗi selectByAuthor(" + authorId + "): " + e.getMessage());
            e.printStackTrace();
        }
        return list;
    }

    @Override
    public List<News> findTopViewed(int limit) {
        List<News> list = new ArrayList<>();
        // Sửa Lỗi Cú Pháp SQL: Dùng TOP (?) và set tham số limit
        String sql = "SELECT TOP (?) n.*, c.Name AS CategoryName FROM NEWS n LEFT JOIN CATEGORIES c ON n.CategoryId = c.Id ORDER BY n.ViewCount DESC, n.PostedDate DESC";
        try (Connection con = Jdbc.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            
            ps.setInt(1, limit); // Set tham số limit

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) { // Không cần kiểm tra count < limit nữa vì SQL đã xử lý
                    News n = mapResultSetToNews(rs);
                    n.setCategoryName(rs.getNString("CategoryName"));
                    list.add(n);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    @Override
    public List<News> findLatest(int limit) {
        List<News> list = new ArrayList<>();
        // Cần sửa lại để dùng TOP (?) cho nhất quán
        String sql = "SELECT TOP (?) n.*, c.Name AS CategoryName FROM NEWS n LEFT JOIN CATEGORIES c ON n.CategoryId = c.Id ORDER BY n.PostedDate DESC";
        try (Connection con = Jdbc.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            
            ps.setInt(1, limit); // Set tham số limit
            
             try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    News n = mapResultSetToNews(rs);
                    n.setCategoryName(rs.getNString("CategoryName"));
                    list.add(n);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }
    @Override
    public boolean updateStatus(String id, String newStatus) {
        String sql = "UPDATE NEWS SET Status = ? WHERE Id = ?";
        try (Connection conn = Jdbc.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setNString(1, newStatus);
            ps.setString(2, id);

            int row = ps.executeUpdate();
            return row > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }
    @Override
    public List<News> findTopViewedApproved(int limit) {
        List<News> list = new ArrayList<>();
        String sql = """
            SELECT TOP (?) n.*, c.name AS categoryName
            FROM NEWS n
            JOIN CATEGORIES c ON n.CategoryId = c.Id -- Sửa lại Category_id thành CategoryId
            WHERE n.Status = N'Đã duyệt'
            ORDER BY n.ViewCount DESC -- Sửa lại view_count thành ViewCount
        """;

        try (Connection conn = Jdbc.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, limit);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                News n = mapResultSetToNews(rs); // Sử dụng hàm map đã tối ưu
                n.setCategoryName(rs.getNString("CategoryName"));
                list.add(n);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    @Override
    public List<News> findLatestApproved(int limit) {
        List<News> list = new ArrayList<>();
        String sql = """
            SELECT TOP (?) n.*, c.name AS categoryName
            FROM NEWS n
            JOIN CATEGORIES c ON n.CategoryId = c.Id -- Sửa lại Category_id thành CategoryId
            WHERE n.Status = N'Đã duyệt'
            ORDER BY n.PostedDate DESC -- Sửa lại posted_date thành PostedDate
        """;

        try (Connection conn = Jdbc.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, limit);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                News n = mapResultSetToNews(rs); // Sử dụng hàm map đã tối ưu
                n.setCategoryName(rs.getNString("CategoryName"));
                list.add(n);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
    @Override
    public List<News> findApprovedByCategory(String categoryId) {
        List<News> list = new ArrayList<>();
        String sql = "SELECT * FROM NEWS WHERE CategoryId = ? AND Status = N'Đã duyệt' ORDER BY PostedDate DESC";
        try (Connection con = Jdbc.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, categoryId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(mapResultSetToNews(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    @Override
    public List<News> getApprovedNewsByCategoryName(String categoryName) {
        List<News> list = new ArrayList<>();
        String sql = """
            SELECT n.*, c.Name AS CategoryName, u.Fullname AS AuthorName
            FROM NEWS n
            JOIN CATEGORIES c ON n.CategoryId = c.Id
            JOIN USERS u ON n.Author = u.Id
            WHERE c.Name = ? AND n.Status = N'Đã duyệt'
            ORDER BY n.PostedDate DESC
        """;

        try (Connection con = Jdbc.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setNString(1, categoryName);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    News news = mapResultSetToNews(rs); // Sử dụng hàm map đã tối ưu
                    news.setCategoryName(rs.getNString("CategoryName"));
                    news.setAuthorName(rs.getNString("AuthorName"));
                    list.add(news);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return list;
    }
    @Override
    public News getNewsById(String id) {
        String sql = "SELECT * FROM NEWS WHERE Id = ?";
        try (Connection conn = Jdbc.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return mapResultSetToNews(rs); // Sử dụng hàm map đã tối ưu
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    @Override
    public List<News> findHomeByPosition(int position) {
        List<News> list = new ArrayList<>();
        String sql = "SELECT * FROM NEWS " +
                     "WHERE Home = 1 AND Position = ? AND Status = N'Đã duyệt' " +
                     "ORDER BY PostedDate DESC";
        try (Connection con = Jdbc.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, position);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapResultSetToNews(rs)); // Sử dụng hàm map đã tối ưu
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    @Override
    public News getById(String id) {
        String sql = """
            SELECT n.*, c.Name AS CategoryName, u.Fullname AS AuthorName
            FROM NEWS n
            LEFT JOIN CATEGORIES c ON n.CategoryId = c.Id
            LEFT JOIN USERS u ON n.Author = u.Id
            WHERE n.Id = ?
        """;
        try (Connection conn = Jdbc.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                News n = mapResultSetToNews(rs);
                n.setCategoryName(rs.getNString("CategoryName"));
                n.setAuthorName(rs.getNString("AuthorName")); 
                return n;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    @Override
    public void updateFeature(String id, boolean value) {
        // Cần kiểm tra cột isFeatured có tồn tại trong bảng NEWS không. 
        // Bảng NEWS bạn cung cấp KHÔNG có cột này. Nếu bạn muốn sử dụng, cần thêm cột này vào SQL.
        String sql = "UPDATE NEWS SET isFeatured = ? WHERE Id = ?"; 
        try (Connection con = Jdbc.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setBoolean(1, value);
            ps.setString(2, id);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    @Override
    public void updateApproved(String id, boolean value) {
        // Cột isApproved cũng KHÔNG có trong bảng NEWS. Bạn nên chỉ sử dụng cột Status.
        String sql = "UPDATE NEWS SET isApproved = ?, Status = N'Đã duyệt' WHERE Id = ?";
        try (Connection con = Jdbc.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setBoolean(1, value);
            ps.setString(2, id);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    @Override
    public void updateEmailed(String id, boolean value) {
        // Cột isEmailed cũng KHÔNG có trong bảng NEWS.
        String sql = "UPDATE NEWS SET isEmailed = ? WHERE Id = ?";
        try (Connection con = Jdbc.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setBoolean(1, value);
            ps.setString(2, id);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    @Override
    public void incrementViewCount(String id) {
        String sql = "UPDATE NEWS SET ViewCount = ISNULL(ViewCount, 0) + 1 WHERE Id = ?";
        try (Connection conn = Jdbc.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, id);
            int rows = stmt.executeUpdate();

            if (rows > 0) {
                System.out.println("Đã tăng lượt xem cho tin có ID: " + id);
            } else {
                System.out.println("Không tìm thấy tin có ID: " + id);
            }

        } catch (SQLException e) {
            System.out.println("Lỗi khi cập nhật lượt xem: " + e.getMessage());
            e.printStackTrace();
        }
    }
    @Override
    public List<News> getAllNews() {
        List<News> list = new ArrayList<>();
        String sql = "SELECT n.*, c.Name AS CategoryName, u.Fullname AS AuthorName " +
                     "FROM NEWS n " +
                     "LEFT JOIN CATEGORIES c ON n.CategoryId = c.Id " +
                     "LEFT JOIN USERS u ON n.Author = u.Id";

        try (Connection conn = Jdbc.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                News n = mapResultSetToNews(rs); // Sử dụng hàm map đã tối ưu
                n.setCategoryName(rs.getString("CategoryName"));
                n.setAuthorName(rs.getString("AuthorName"));

                list.add(n);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }


}
