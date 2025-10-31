<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ page import="Entity.User" %>
<%
    User user = (User) session.getAttribute("user");
    String fullname = (user != null && user.getFullname() != null)
            ? user.getFullname() : "Quản trị viên";
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="description" content="ABC News - Quản lý loại tin">
    <title>ABC News - Quản lý loại tin</title>
    <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Roboto:wght@400;700&display=swap">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    
    <style>
/* ================================================= */
/* CƠ SỞ CHUNG (Đồng bộ với các trang Admin khác) */
/* ================================================= */
body {
    background-color: #eef1f5; /* Nền xám nhạt hiện đại */
    color: #495057; /* Màu chữ chính */
    font-family: 'Roboto', sans-serif;
}

/* HEADER & MENU (Giả định đã có CSS chung) */
.site-header { background-color: #1a2a47; box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1); }
.logo { color: #ffffff; font-weight: 700; }
.logo span { color: #fcc419; }
.logout-btn { background: #e53935; color: white; }

/* CỘT NỘI DUNG CHÍNH */
.center-col {
    background: #ffffff;
    border-radius: 12px;
    padding: 25px;
    box-shadow: 0 4px 12px rgba(0, 0, 0, 0.05);
    margin-top: 15px;
}
.center-col h2 {
    font-size: 26px;
    font-weight: 700;
    color: #1a2a47; /* Xanh Navy Sâu */
    margin-bottom: 25px;
    border-bottom: 3px solid #fcc419; /* Vàng ấm nổi bật */
    padding-bottom: 10px;
}

/* ================================================= */
/* THANH HÀNH ĐỘNG & NÚT THÊM (Đồng bộ với Quản lý tin tức) */
/* ================================================= */
.action-bar { margin-bottom: 20px; }
.action-bar .add-news-btn { /* Đổi tên class để phù hợp hơn, nhưng vẫn dùng style này */
    display: inline-block;
    padding: 10px 20px;
    background: #1a2a47; /* Xanh Navy Sâu */
    color: #FFFFFF;
    border-radius: 8px;
    text-decoration: none;
    font-size: 16px;
    font-weight: 700;
    transition: background 0.3s, transform 0.3s;
    box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
}
.action-bar .add-news-btn:hover {
    background: #273e63;
    transform: translateY(-1px);
    box-shadow: 0 6px 12px rgba(0, 0, 0, 0.15);
}

/* ================================================= */
/* BẢNG (TABLE) */
/* ================================================= */
.news-table {
    width: 100%;
    border-collapse: separate;
    border-spacing: 0;
    font-size: 14px;
    box-shadow: 0 2px 8px rgba(0, 0, 0, 0.05);
    border-radius: 8px;
    overflow: hidden;
}

.news-table thead th {
    background: #1a2a47; /* Xanh Navy Sâu */
    color: #FFFFFF;
    padding: 15px 10px;
    text-align: left;
    font-weight: 600;
}

.news-table tbody tr { border-bottom: 1px solid #e9ecef; }
.news-table tbody tr:hover { background: #f1f4f8; }
.news-table td { padding: 12px 10px; vertical-align: middle; color: #495057; }

/* NÚT HÀNH ĐỘNG TRONG BẢNG */
.edit-btn, .delete-btn {
    display: inline-block;
    padding: 6px 12px;
    font-size: 13px;
    font-weight: 600;
    border-radius: 4px;
    text-decoration: none;
    color: #fff;
    line-height: 1;
    margin-right: 5px;
    transition: all 0.2s ease-in-out;
}

/* Sửa: Xanh dương tiêu chuẩn */
.edit-btn {
    background-color: #007bff;
}
.edit-btn:hover {
    background-color: #0056b3;
}

/* Xóa: Đỏ dịu */
.delete-btn {
    background-color: #e53935;
}
.delete-btn:hover {
    background-color: #c62828;
}

/* ================================================= */
/* MODAL (Popup) */
/* ================================================= */
.modal {
    display: none; /* Ẩn mặc định */
    position: fixed; inset: 0;
    background: rgba(26, 42, 71, 0.8); /* Xanh Navy mờ */
    justify-content: center;
    align-items: center;
    z-index: 10000;
}

.modal-content {
    background: #fff;
    width: 400px;
    padding: 30px;
    border-radius: 12px;
    box-shadow: 0 10px 40px rgba(0,0,0,0.3);
    position: relative;
    animation: fadeIn 0.3s ease-in-out;
}

.modal-content h2 {
    color: #1a2a47;
    font-size: 22px;
    font-weight: 600;
    margin-bottom: 20px;
    border-bottom: 1px solid #e9ecef;
    padding-bottom: 10px;
}

.close-btn {
    position: absolute; top: 10px; right: 15px;
    font-size: 30px;
    font-weight: 300;
    cursor: pointer;
    color: #adb5bd;
    line-height: 1;
    transition: color 0.2s;
}
.close-btn:hover { color: #dc3545; }

/* Form */
.form-group { margin-bottom: 15px; }
.form-group label {
    display: block;
    font-weight: 500;
    color: #495057;
    margin-bottom: 5px;
    font-size: 15px;
}
.form-group input[type="text"] {
    width: 100%;
    padding: 10px 12px;
    border: 1px solid #ced4da;
    border-radius: 6px;
    font-size: 15px;
    transition: border-color 0.2s;
}
.form-group input[type="text"]:focus {
    border-color: #fcc419; /* Vàng ấm khi focus */
    outline: none;
    box-shadow: 0 0 0 0.2rem rgba(252, 196, 25, 0.25);
}

/* Nút Submit */
.submit-btn {
    width: 100%;
    padding: 12px 20px;
    background: #fcc419; /* Vàng ấm */
    color: #1a2a47; /* Chữ Xanh Navy */
    border: none;
    border-radius: 8px;
    font-weight: 700;
    font-size: 16px;
    cursor: pointer;
    transition: background 0.3s;
    box-shadow: 0 4px 8px rgba(252, 196, 25, 0.3);
}
.submit-btn:hover {
    background: #ffbe00;
}

@keyframes fadeIn {
    from { opacity: 0; transform: scale(0.95); }
    to { opacity: 1; transform: scale(1); }
}
</style>
</head>
<body>

<header class="site-header">
    <div class="container">
        <div class="logo">ABC <span>News</span></div>
<nav class="menu">
    <a href="${pageContext.request.contextPath}/index"
       class="${fn:contains(pageContext.request.requestURI, '/index') ? 'active' : ''}">Trang chủ</a>

    <%-- KHỐI CODE ĐÃ SỬA: TỰ ĐỘNG TẠO MENU DỰA TRÊN CATEGORIES --%>
    <c:forEach var="c" items="${categories}">
        <a href="${pageContext.request.contextPath}/category?name=${c.name}"
           class="${fn:contains(pageContext.request.requestURI, c.name) ? 'active' : ''}">
            ${c.name}
        </a>
    </c:forEach>
    <%-- KẾT THÚC KHỐI TỰ ĐỘNG TẠO MENU --%>


    <a href="${pageContext.request.contextPath}/admin"
       class="${fn:contains(pageContext.request.requestURI, '/admin') ? 'active' : ''}">Quản trị</a>
</nav>

        <div class="header-actions">
            Xin chào <strong><%= fullname %></strong>
            <a href="${pageContext.request.contextPath}/logout" class="logout-btn">Đăng xuất</a>
        </div>
    </div>
</header>

<div class="container">
    <section class="center-col">
        <h2>Quản lý loại tin</h2>
        <div class="action-bar">
            <a href="#" class="add-news-btn" onclick="showModal('add-category-modal')">+ Thêm loại tin</a>
        </div>

        <table class="news-table">
            <thead>
            <tr>
                <th>Mã loại tin</th>
                <th>Tên loại tin</th>
                <th>Hành động</th>
            </tr>
            </thead>
            <tbody>
            <c:forEach var="c" items="${categories}">
                <tr>
                    <td>${c.id}</td>
                    <td>${c.name}</td>
                    <td>
                        <a href="#" class="edit-btn"
                           onclick="openEditModal('${c.id}', '${c.name}')">Sửa</a>
                        <a href="${pageContext.request.contextPath}/admin/delete_category?id=${c.id}"
                           class="delete-btn"
                           onclick="return confirm('Bạn có chắc muốn xóa loại tin này?')">Xóa</a>
                    </td>
                </tr>
            </c:forEach>
            </tbody>
        </table>
    </section>
</div>

<!-- Modal thêm loại tin -->
<div id="add-category-modal" class="modal">
    <div class="modal-content">
        <span class="close-btn" onclick="closeModal('add-category-modal')">&times;</span>
        <h2>Thêm loại tin</h2>
        <form action="${pageContext.request.contextPath}/admin/add_category" method="post">
            <div class="form-group">
                <label for="categoryName">Tên loại tin</label>
                <input type="text" id="categoryName" name="categoryName" placeholder="Nhập tên loại tin" required>
            </div>
            <button type="submit" class="submit-btn">Thêm</button>
        </form>
    </div>
</div>

<!-- Modal sửa loại tin -->
<div id="edit-category-modal" class="modal">
    <div class="modal-content">
        <span class="close-btn" onclick="closeModal('edit-category-modal')">&times;</span>
        <h2>Sửa loại tin</h2>
        <form action="${pageContext.request.contextPath}/admin/edit_category" method="post">
            <input type="hidden" id="edit-id" name="categoryId">
            <div class="form-group">
                <label for="edit-name">Tên loại tin</label>
                <input type="text" id="edit-name" name="categoryName" required>
            </div>
            <button type="submit" class="submit-btn">Lưu thay đổi</button>
        </form>
    </div>
</div>

<%@ include file="../includes/news_index_footer.jsp" %>

<script>
    function showModal(id) {
        document.getElementById(id).style.display = 'flex';
    }

    function closeModal(id) {
        document.getElementById(id).style.display = 'none';
    }

    function openEditModal(id, name) {
        document.getElementById('edit-id').value = id;
        document.getElementById('edit-name').value = name;
        showModal('edit-category-modal');
    }
</script>

</body>
</html>