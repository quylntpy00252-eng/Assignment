<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ page import="Entity.User" %>
<%
    User user = (User) session.getAttribute("user");
    boolean isLoggedIn = (user != null);
    boolean isAdmin = false;
    if (isLoggedIn) {
        isAdmin = user.isRole(); 
    }
%>
<nav class="menu">
    <a href="${pageContext.request.contextPath}/index"
       class="${fn:endsWith(pageContext.request.requestURI, '/index') ? 'active' : ''}">Trang chủ</a>

    <%-- KHỐI CODE ĐÃ SỬA: TỰ ĐỘNG TẠO MENU DỰA TRÊN CATEGORIES --%>
    <%-- Bạn cần đảm bảo biến ${categories} đã được truyền từ Servlet vào Request Scope --%>
    <c:forEach var="c" items="${categories}">
        <a href="${pageContext.request.contextPath}/category?name=${c.name}"
           class="${fn:contains(pageContext.request.requestURI, c.name) ? 'active' : ''}">
            ${c.name}
        </a>
    </c:forEach>
    <%-- KẾT THÚC KHỐI TỰ ĐỘNG TẠO MENU --%>


    <c:if test="${not empty sessionScope.user}">
        <c:choose>
            <c:when test="${sessionScope.user.role}">
                <a href="${pageContext.request.contextPath}/admin">Quản trị</a>
            </c:when>
            <c:otherwise>
                <a href="${pageContext.request.contextPath}/reporter">Quản lý tin</a>
            </c:otherwise>
        </c:choose>
    </c:if>
</nav>


		
		<div class="header-actions">
		    	<form action="${pageContext.request.contextPath}/search" method="get" class="search-form">
				    <input type="text" name="keyword" placeholder="Tìm kiếm tin tức..." class="search-bar" required>
				    <button type="submit" class="search-btn">🔍</button>
				</form>
		    	
		
		    <% if (!isLoggedIn) { %>
		        <button class="login-btn" onclick="showModal('login-modal')">Đăng nhập</button>
		    <% } else { %>
		        <span class="user-info">Xin chào, <strong><%= user.getFullname() %></strong></span>
			<a href="${pageContext.request.contextPath}/logout" class="logout-btn">Đăng xuất</a>
		    <% } %>
		</div>
		
		