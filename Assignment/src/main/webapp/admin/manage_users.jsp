<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ page import="Entity.User" %>

<%
    User user = (User) session.getAttribute("user");
    String fullname = (user != null && user.getFullname() != null) ? user.getFullname() : "Quản trị viên";
%>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="description" content="ABC News - Quản lý người dùng.">
    <meta name="keywords" content="quản lý người dùng, quản trị, ABC News">
    <meta name="author" content="ABC News">
    <title>ABC News - Quản lý người dùng</title>

    <!-- Font và CSS -->
    <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Roboto:wght@400;700&family=Open+Sans:wght@400;600&display=swap">
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
body.modal-open { overflow: hidden; }

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
.action-bar .add-news-btn {
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
/* BẢNG & NÚT HÀNH ĐỘNG TRONG BẢNG */
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

/* Nút Sửa */
.edit-btn {
    background-color: #007bff; /* Xanh dương tiêu chuẩn */
    display: inline-block;
    padding: 6px 12px;
    font-size: 13px;
    font-weight: 600;
    border-radius: 4px;
    text-decoration: none;
    color: #fff;
    margin-right: 5px;
    transition: all 0.2s ease-in-out;
}
.edit-btn:hover { background-color: #0056b3; }

/* Nút Xóa */
.delete-btn {
    background-color: #e53935; /* Đỏ dịu */
    display: inline-block;
    padding: 6px 12px;
    font-size: 13px;
    font-weight: 600;
    border-radius: 4px;
    text-decoration: none;
    color: #fff;
    transition: all 0.2s ease-in-out;
}
.delete-btn:hover { background-color: #c62828; }

/* ================================================= */
/* MODAL (Popup) - Đã thay đổi custom- thành đồng bộ */
/* ================================================= */
.custom-modal {
    display: none;
    position: fixed; inset: 0;
    background: rgba(26, 42, 71, 0.8); /* Xanh Navy mờ */
    justify-content: center;
    align-items: center;
    z-index: 10000;
    overflow-y: auto;
}

.custom-modal-content {
    background: #fff;
    border-radius: 12px;
    padding: 30px;
    width: 100%;
    max-width: 450px; /* Tăng nhẹ để phù hợp form dài hơn */
    box-shadow: 0 10px 40px rgba(0,0,0,0.3);
    position: relative;
    animation: fadeIn 0.3s ease-in-out;
    margin: 40px 15px; /* Thêm margin cho mobile */
}

.custom-close-btn {
    position: absolute; top: 12px; right: 18px;
    font-size: 30px;
    font-weight: 300;
    color: #adb5bd;
    cursor: pointer;
    line-height: 1;
    transition: color 0.2s;
}
.custom-close-btn:hover { color: #dc3545; }

.custom-modal-content h2 {
    color: #1a2a47; /* Xanh Navy Sâu */
    font-size: 24px;
    font-weight: 600;
    margin-bottom: 20px;
    border-bottom: 1px solid #e9ecef;
    padding-bottom: 10px;
}

/* Form */
.custom-form-group {
    text-align: left;
    margin-bottom: 15px;
}

.custom-form-group label {
    display: block;
    margin-bottom: 6px;
    font-weight: 600;
    font-size: 15px;
    color: #1a2a47; /* Xanh Navy Sâu */
}

.custom-form-group input,
.custom-form-group select {
    width: 100%;
    padding: 10px 12px;
    border: 1px solid #ced4da;
    border-radius: 6px;
    background-color: #f8f9fa; /* Nền input xám nhẹ */
    font-size: 15px;
    transition: border-color 0.2s, box-shadow 0.2s;
    box-sizing: border-box;
}

.custom-form-group input:focus,
.custom-form-group select:focus {
    border-color: #fcc419; /* Vàng ấm khi focus */
    box-shadow: 0 0 0 0.2rem rgba(252, 196, 25, 0.25);
    outline: none;
}

/* Nút Submit */
.custom-submit-btn {
    width: 100%;
    padding: 12px 20px;
    background: #fcc419; /* Vàng ấm */
    color: #1a2a47; /* Chữ Xanh Navy */
    border: none;
    border-radius: 8px;
    font-weight: 700;
    font-size: 16px;
    cursor: pointer;
    transition: background 0.3s, transform 0.2s;
    box-shadow: 0 4px 8px rgba(252, 196, 25, 0.3);
    margin-top: 10px;
}
.custom-submit-btn:hover {
    background: #ffbe00;
    transform: translateY(-1px);
}

@keyframes fadeIn {
    from { opacity: 0; transform: scale(0.95); }
    to { opacity: 1; transform: scale(1); }
}
</style>
</head>

<body>
    <!-- Header -->
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

    <!-- Main Content -->
    <div class="container">
        <section class="center-col">
            <h2>Quản lý người dùng</h2>

            <div class="action-bar">
                <a href="#add-user" class="add-news-btn" onclick="showModal('add-user-modal')">+ Thêm người dùng</a>
            </div>

            <table class="news-table">
                <thead>
                    <tr>
                        <th>Họ tên</th>
                        <th>Email</th>
                        <th>Vai trò</th>
                        <th>Hành động</th>
                    </tr>
                </thead>
               <tbody>
    <c:forEach var="u" items="${users}">
        <tr>
            <td>${fn:escapeXml(u.fullname)}</td>
            <td>${fn:escapeXml(u.email)}</td>
            <td>
                <c:choose>
				    <c:when test="${u.role}">Quản trị</c:when>
				    <c:otherwise>Phóng viên</c:otherwise>
				</c:choose>

            </td>
            <td>
                <a href="#edit-user"
                   class="edit-btn"
                   data-id="${u.id}"
                   data-fullname="${fn:escapeXml(u.fullname)}"
                   data-email="${fn:escapeXml(u.email)}"
                   data-role="${u.role}"
                   data-birthday="${u.birthday}"
                   data-gender="${u.gender}"
                   data-mobile="${u.mobile}"
                   onclick="openEditUser(this)">Sửa</a>
                <a href="${pageContext.request.contextPath}/admin/delete_user?id=${u.id}"
                   class="delete-btn"
                   onclick="return confirm('Bạn có chắc muốn xóa người dùng này?')">Xóa</a>
            </td>
        </tr>
    </c:forEach>
</tbody>

            </table>
        </section>
    </div>

    <!-- Add User Modal -->
    <div id="add-user-modal" class="custom-modal">
        <div class="custom-modal-content">
            <span class="custom-close-btn" onclick="closeModal('add-user-modal')">&times;</span>
            <h2>Thêm người dùng</h2>
            <form action="${pageContext.request.contextPath}/admin/add_user" method="post">
                <div class="custom-form-group">
                    <label for="add-userId">Mã người dùng</label>
                    <input type="text" id="add-userId" name="id" placeholder="Nhập mã người dùng (ví dụ: pv01)" required>
                </div>
                <div class="custom-form-group">
                    <label for="add-fullName">Họ và tên</label>
                    <input type="text" id="add-fullName" name="fullname" placeholder="Nhập họ và tên" required>
                </div>
                <div class="custom-form-group">
                    <label for="add-birthday">Ngày sinh</label>
                    <input type="date" id="add-birthday" name="birthday" required>
                </div>
                <div class="custom-form-group">
                    <label for="add-gender">Giới tính</label>
                    <select id="add-gender" name="gender" required>
                        <option value="1">Nam</option>
                        <option value="0">Nữ</option>
                    </select>
                </div>
                <div class="custom-form-group">
                    <label for="add-mobile">Số điện thoại</label>
                    <input type="text" id="add-mobile" name="mobile" placeholder="Nhập số điện thoại" required>
                </div>
                <div class="custom-form-group">
                    <label for="add-email">Email</label>
                    <input type="email" id="add-email" name="email" placeholder="Nhập email" required>
                </div>
                <div class="custom-form-group">
                    <label for="add-password">Mật khẩu</label>
                    <input type="password" id="add-password" name="password" placeholder="Nhập mật khẩu" required>
                </div>
                <div class="custom-form-group">
                    <label for="add-role">Vai trò</label>
                    <select id="add-role" name="role" required>
                        <option value="0">Phóng viên</option>
                        <option value="1">Quản trị</option>
                    </select>
                </div>
                <button type="submit" class="custom-submit-btn">Thêm người dùng</button>
            </form>
        </div>
    </div>

    <!-- Edit User Modal -->
    <div id="edit-user-modal" class="custom-modal">
        <div class="custom-modal-content">
            <span class="custom-close-btn" onclick="closeModal('edit-user-modal')">&times;</span>
            <h2>Sửa người dùng</h2>
            <form action="${pageContext.request.contextPath}/admin/edit_user" method="post">
                <input type="hidden" name="id" id="edit-user-id">
                <div class="custom-form-group">
                    <label for="edit-fullName">Họ và tên</label>
                    <input type="text" id="edit-fullName" name="fullname" required>
                </div>
                <div class="custom-form-group">
                    <label for="edit-birthday">Ngày sinh</label>
                    <input type="date" id="edit-birthday" name="birthday" required>
                </div>
                <div class="custom-form-group">
                    <label for="edit-gender">Giới tính</label>
                    <select id="edit-gender" name="gender" required>
                        <option value="1">Nam</option>
                        <option value="0">Nữ</option>
                    </select>
                </div>
                <div class="custom-form-group">
                    <label for="edit-mobile">Số điện thoại</label>
                    <input type="text" id="edit-mobile" name="mobile" required>
                </div>
                <div class="custom-form-group">
                    <label for="edit-email">Email</label>
                    <input type="email" id="edit-email" name="email" required>
                </div>
                <div class="custom-form-group">
                    <label for="edit-password">Mật khẩu</label>
                    <input type="password" id="edit-password" name="password" placeholder="Để trống nếu không đổi">
                </div>
                <div class="custom-form-group">
                    <label for="edit-role">Vai trò</label>
                    <select id="edit-role" name="role" required>
                        <option value="0">Phóng viên</option>
                        <option value="1">Quản trị</option>
                    </select>
                </div>
                <button type="submit" class="custom-submit-btn">Lưu thay đổi</button>
            </form>
        </div>
    </div>

    <!-- Footer -->
<%@ include file="../includes/news_index_footer.jsp" %>

    <!-- Script -->
    <script>
        function showModal(modalId, id = '', fullname = '', email = '', role = '', birthday = '', gender = '', mobile = '', address = '') {
            const modal = document.getElementById(modalId);
            if (modal) {
                modal.style.display = 'flex';
                document.body.classList.add('modal-open');

                if (modalId === 'edit-user-modal') {
                    document.getElementById('edit-user-id').value = id;
                    document.getElementById('edit-fullName').value = fullname;
                    document.getElementById('edit-email').value = email;
                    document.getElementById('edit-role').value = role ? '1' : '0';
                    document.getElementById('edit-birthday').value = birthday || '';
                    document.getElementById('edit-gender').value = gender || '';
                    document.getElementById('edit-mobile').value = mobile || '';
                } else if (modalId === 'add-user-modal') {
                    const form = modal.querySelector('form');
                    if (form) form.reset();
                }
            }
        }

        function closeModal(modalId) {
            const modal = document.getElementById(modalId);
            if (modal) {
                modal.style.display = 'none';
                document.body.classList.remove('modal-open');
                const form = modal.querySelector('form');
                if (form) form.reset();
            }
        }

        window.onclick = function(event) {
            const modals = document.getElementsByClassName('custom-modal');
            for (let modal of modals) {
                if (event.target === modal) {
                    modal.style.display = 'none';
                    document.body.classList.remove('modal-open');
                    const form = modal.querySelector('form');
                    if (form) form.reset();
                }
            }
        };
        function openEditUser(element) {
            const modal = document.getElementById('edit-user-modal');
            if (!modal) return;

            document.getElementById('edit-user-id').value = element.dataset.id || '';
            document.getElementById('edit-fullName').value = element.dataset.fullname || '';
            document.getElementById('edit-email').value = element.dataset.email || '';
            document.getElementById('edit-role').value = element.dataset.role || '0';
            document.getElementById('edit-birthday').value = element.dataset.birthday || '';
            document.getElementById('edit-gender').value = element.dataset.gender || '1';
            document.getElementById('edit-mobile').value = element.dataset.mobile || '';

            modal.style.display = 'flex';
            document.body.classList.add('modal-open');
        }
    </script>
</body>
</html>