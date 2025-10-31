
<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="description" content="ABC News - Trang tin tức hàng đầu Việt Nam, cập nhật tin tức nhanh chóng, chính xác và đa chiều.">
    <meta name="keywords" content="tin tức, Việt Nam, văn hóa, pháp luật, thể thao, ABC News">
    <meta name="author" content="New newspaper">
    <title>ABC News - Trang chủ</title>
    <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Roboto:wght@400;700&family=Open+Sans:wght@400;600&display=swap">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    
    <style>
        /* ================================================= */
        /* TOAST MESSAGE (ĐỒNG BỘ VỚI MÀU QUẢN TRỊ - ĐỎ NHẸ) */
        /* ================================================= */
        .toast {
            position: fixed;
            top: 20px;
            left: 50%;
            transform: translateX(-50%);
            /* Sử dụng màu đỏ của nút Logout trong Admin */
            background-color: #e53935; 
            color: white;
            padding: 12px 25px;
            border-radius: 10px;
            font-weight: bold;
            z-index: 9999;
            box-shadow: 0 2px 8px rgba(0,0,0,0.3);
            animation: fadeInOut 3s ease-in-out;
        }

        @keyframes fadeInOut {
            0% { opacity: 0; transform: translate(-50%, -10px); }
            10%, 90% { opacity: 1; transform: translate(-50%, 0); }
            100% { opacity: 0; transform: translate(-50%, -10px); }
        }

        /* ================================================= */
        /* HEADER (ĐỒNG BỘ VỚI MÀU QUẢN TRỊ - XANH NAVY) */
        /* ================================================= */
        .site-header {
            /* Dùng màu nền Admin */
            background-color: #1a2a47; 
            color: #FFFFFF;
            padding: 15px 0;
            position: sticky;
            top: 0;
            z-index: 1000;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1); /* Bóng mờ nhẹ */
        }
        
        .site-header .container {
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .logo { 
            font-size: 28px; 
            font-weight: 700; 
            color: #FFFFFF; 
        }
        
        /* Dùng màu Vàng ấm Admin cho span */
        .logo span { 
            color: #fcc419; 
            font-weight: 400;
        }
        
        /* ================================================= */
        /* MENU & NAV (Giả định nằm trong news_index_nav.jsp) */
        /* ================================================= */
        .menu {
            display: flex;
            gap: 20px;
        }
        
        .menu a {
            color: #c7d1e0; /* Màu chữ nhẹ nhàng Admin */
            text-decoration: none;
            padding: 5px 0;
            transition: color 0.2s, border-bottom 0.2s;
            font-weight: 500;
        }

        .menu a:hover {
            color: #ffffff;
        }
        
        .menu a.active {
            color: #ffffff;
            border-bottom: 3px solid #fcc419; /* Vàng nổi bật Admin */
            padding-bottom: 2px;
        }


        /* ================================================= */
        /* MODAL (Đăng nhập) */
        /* ================================================= */
        .modal {
            position: fixed;
            z-index: 10000;
            left: 0;
            top: 0;
            width: 100%;
            height: 100%;
            overflow: auto;
            background-color: rgba(26, 42, 71, 0.8); /* Dùng màu overlay Admin */
            display: none; 
            justify-content: center;
            align-items: center;
        }

        .modal-content {
            background-color: #fff;
            padding: 30px;
            border-radius: 12px;
            width: 90%;
            max-width: 400px;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.5);
            position: relative;
        }

        .modal-content h2 {
            color: #1a2a47; /* Tiêu đề Xanh Navy Admin */
            margin-top: 0;
            border-bottom: 2px solid #e9ecef;
            padding-bottom: 10px;
            margin-bottom: 20px;
        }
        
        .modal-content p {
            color: #6c757d;
            font-size: 14px;
            margin-bottom: 25px;
        }

        .close-btn {
            color: #adb5bd; /* Màu xám Admin */
            float: right;
            font-size: 28px;
            font-weight: bold;
            position: absolute;
            top: 10px;
            right: 20px;
            transition: color 0.2s;
        }

        .close-btn:hover,
        .close-btn:focus {
            color: #e53935; /* Hover Đỏ Admin */
            text-decoration: none;
            cursor: pointer;
        }

        /* FORM STYLING TRONG MODAL */
        .form-group {
            margin-bottom: 15px;
        }

        .form-group label {
            display: block;
            margin-bottom: 5px;
            font-weight: 500;
            color: #495057;
        }

        .modal-content input[type="email"],
        .modal-content input[type="password"] {
            width: 100%;
            padding: 10px;
            border: 1px solid #ced4da;
            border-radius: 6px;
            box-sizing: border-box;
            transition: border-color 0.2s;
        }
        
        .modal-content input:focus {
            border-color: #007bff; /* Giữ màu Xanh dương cho focus/action */
            outline: none;
            box-shadow: 0 0 0 3px rgba(0, 123, 255, 0.2);
        }
        
        /* Nút Đăng nhập */
        .submit-btn {
            width: 100%;
            /* Dùng màu Xanh dương chuyên nghiệp (như nút Submit trong popup Admin) */
            background-color: #007bff; 
            color: white;
            padding: 12px;
            border: none;
            border-radius: 8px;
            font-size: 16px;
            font-weight: 700;
            cursor: pointer;
            transition: background-color 0.3s, box-shadow 0.3s;
            margin-top: 15px;
        }

        .submit-btn:hover {
            background-color: #0056b3; 
            box-shadow: 0 4px 10px rgba(0, 123, 255, 0.4);
        }
    </style>
</head>
<body>
    <header class="site-header">
        <div class="container">
            <div class="logo">ABC<span> News</span></div>  
        	<%@ include file="../includes/news_index_nav.jsp" %>
    </header>

    <div id="login-modal" class="modal">
    <div class="modal-content">
        <span class="close-btn" onclick="closeModal('login-modal')">&times;</span>
        <h2>Đăng nhập</h2>
        <p>Đăng nhập để truy cập tin tức cá nhân hóa và nhiều tính năng hơn.</p>
        <form action="${pageContext.request.contextPath}/login" method="post">
            <div class="form-group">
                <label>Email</label>
                <input type="email" name="email" placeholder="Nhập email của bạn" required>
            </div>
            <div class="form-group">
                <label>Mật khẩu</label>
                <input type="password" name="password" placeholder="Nhập mật khẩu" required>
            </div>
            <button type="submit" class="submit-btn">Đăng nhập</button>
        </form>
    </div>
</div>
    <div class="container">
        <div class="container-3col">
            <%@ include file="../includes/news_index_left.jsp" %>
            <%@ include file="../includes/news_index_center.jsp" %>
            <%@ include file="../includes/news_index_right.jsp" %>
        </div>
    </div>

    <%@ include file="../includes/news_index_footer.jsp" %>

    <script>
        function showModal(modalId) {
            document.getElementById(modalId).style.display = 'flex';
        }

        function closeModal(modalId) {
            document.getElementById(modalId).style.display = 'none';
        }

        function switchModal(currentModalId, targetModalId) {
            closeModal(currentModalId);
            showModal(targetModalId);
        }

        //  Nếu có error=1 trên URL => mở modal đăng nhập + hiển thị thông báo
        document.addEventListener("DOMContentLoaded", function() {
            const params = new URLSearchParams(window.location.search);
            if (params.get("error") === "1") {
                showModal('login-modal');
                const toast = document.createElement("div");
                toast.className = "toast";
                toast.textContent = "Email hoặc mật khẩu không đúng!";
                document.body.appendChild(toast);
                setTimeout(() => toast.remove(), 3000);
            }
        });
    </script>
</body>
</html>