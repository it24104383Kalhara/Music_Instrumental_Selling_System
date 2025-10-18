<%--
  Created by IntelliJ IDEA.
  User: vinod
  Date: 10/18/2025
  Time: 6:38 AM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Reviews - Musical Instruments Store</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">

    <style>
        :root {
            --primary-orange: #FF8C61;
            --primary-orange-soft: #FFB08A;
            --primary-cream: #FFF4E6;
            --dark-brown: #6B4423;
            --text-dark: #3A3A3A;
            --text-light: #6C6C6C;
            --white: #FFFFFF;
            --bg-light: #FFFBF7;
        }

        * {
            font-family: 'Poppins', sans-serif;
        }

        body {
            background-color: var(--bg-light);
        }

        /* Navbar */
        .navbar {
            background: var(--white);
            box-shadow: 0 2px 10px rgba(0,0,0,0.05);
            padding: 0.75rem 0;
            border-bottom: 1px solid #F0F0F0;
        }

        .navbar .navbar-brand {
            font-weight: 600;
            font-size: 1.3rem;
            color: var(--primary-orange) !important;
        }

        .navbar .nav-link {
            color: var(--text-dark) !important;
            font-weight: 500;
            transition: all 0.3s ease;
            border-radius: 8px;
            padding: 0.5rem 1rem !important;
        }

        .navbar .nav-link:hover {
            color: var(--primary-orange) !important;
            background: var(--primary-cream);
        }

        .navbar .dropdown-menu {
            border: none;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1);
            border-radius: 10px;
        }

        .navbar .dropdown-item {
            padding: 0.6rem 1.2rem;
            transition: all 0.3s ease;
        }

        .navbar .dropdown-item:hover {
            background: var(--primary-cream);
            color: var(--primary-orange);
            padding-left: 1.5rem;
        }

        /* Page Header */
        .page-header {
            background: linear-gradient(135deg, var(--primary-orange) 0%, var(--primary-orange-soft) 100%);
            border-radius: 15px;
            padding: 2rem;
            margin-bottom: 2rem;
            color: white;
        }

        .page-header h2 {
            font-weight: 600;
            margin: 0;
        }

        /* Cards */
        .review-card {
            background: var(--white);
            border-radius: 12px;
            box-shadow: 0 3px 10px rgba(0,0,0,0.05);
            padding: 1.5rem;
            margin-bottom: 2rem;
        }

        .review-card h5 {
            color: var(--dark-brown);
            font-weight: 600;
            margin-bottom: 1.5rem;
        }

        /* Reviewable Items */
        .reviewable-item {
            border: 2px solid var(--primary-cream);
            border-radius: 12px;
            padding: 1.5rem;
            margin-bottom: 1rem;
            transition: all 0.3s ease;
        }

        .reviewable-item:hover {
            border-color: var(--primary-orange-soft);
            background: var(--primary-cream);
        }

        .instrument-name {
            font-weight: 600;
            color: var(--dark-brown);
            font-size: 1.1rem;
            margin-bottom: 0.5rem;
        }

        .order-info {
            color: var(--text-light);
            font-size: 0.9rem;
            margin-bottom: 1rem;
        }

        .btn-write-review {
            background: linear-gradient(135deg, var(--primary-orange) 0%, var(--primary-orange-soft) 100%);
            border: none;
            color: white;
            padding: 0.6rem 1.5rem;
            border-radius: 25px;
            font-weight: 600;
            transition: all 0.3s ease;
            text-decoration: none;
        }

        .btn-write-review:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(255, 140, 97, 0.3);
            color: white;
        }

        .already-reviewed {
            background: #E8F5E9;
            color: #4CAF50;
            padding: 0.4rem 1rem;
            border-radius: 20px;
            font-size: 0.85rem;
            font-weight: 600;
        }

        /* My Reviews */
        .my-review-item {
            border-bottom: 1px solid #F0F0F0;
            padding: 1.5rem 0;
        }

        .my-review-item:last-child {
            border-bottom: none;
        }

        .review-stars {
            color: #FFD700;
            font-size: 1.2rem;
            margin-bottom: 0.5rem;
        }

        .review-comment {
            color: var(--text-dark);
            line-height: 1.6;
            margin-bottom: 1rem;
        }

        .review-meta {
            color: var(--text-light);
            font-size: 0.9rem;
        }

        .btn-delete {
            background: #FFEBEE;
            border: none;
            color: #F44336;
            padding: 0.4rem 1rem;
            border-radius: 20px;
            font-weight: 500;
            transition: all 0.3s ease;
            font-size: 0.85rem;
        }

        .btn-delete:hover {
            background: #F44336;
            color: white;
        }

        /* Empty State */
        .empty-state {
            text-align: center;
            padding: 3rem;
            color: var(--text-light);
        }

        .empty-state i {
            font-size: 4rem;
            color: var(--primary-orange-soft);
            opacity: 0.5;
            margin-bottom: 1rem;
        }

        .alert {
            border-radius: 10px;
            border: none;
        }
    </style>
</head>
<body>
<!-- Navigation Bar -->
<nav class="navbar navbar-expand-lg">
    <div class="container-fluid">
        <a class="navbar-brand" href="${pageContext.request.contextPath}/index.jsp">
            🎵 Musical Store
        </a>
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
            <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse" id="navbarNav">
            <ul class="navbar-nav me-auto">
                <li class="nav-item">
                    <a class="nav-link" href="${pageContext.request.contextPath}/shop">
                        <i class="bi bi-shop me-1"></i>Shop
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="${pageContext.request.contextPath}/dashboard">
                        <i class="bi bi-speedometer2 me-1"></i>Dashboard
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="${pageContext.request.contextPath}/orders">
                        <i class="bi bi-list-ul me-1"></i>My Orders
                    </a>
                </li>
            </ul>
            <ul class="navbar-nav">
                <li class="nav-item dropdown">
                    <a class="nav-link dropdown-toggle" href="#" id="userDropdown" role="button" data-bs-toggle="dropdown">
                        <i class="bi bi-person-circle me-1"></i>${sessionScope.userName}
                    </a>
                    <ul class="dropdown-menu dropdown-menu-end">
                        <li>
                            <a class="dropdown-item" href="${pageContext.request.contextPath}/logout">
                                <i class="bi bi-box-arrow-right me-2"></i>Logout
                            </a>
                        </li>
                    </ul>
                </li>
            </ul>
        </div>
    </div>
</nav>

<!-- Main Content -->
<div class="container-fluid py-4">
    <!-- Page Header -->
    <div class="page-header">
        <h2><i class="bi bi-star-fill me-2"></i>My Reviews</h2>
    </div>

    <!-- Success Message -->
    <c:if test="${not empty successMessage}">
        <div class="alert alert-success">
            <i class="bi bi-check-circle me-2"></i>${successMessage}
        </div>
    </c:if>

    <c:if test="${param.deleted == 'true'}">
        <div class="alert alert-success">
            <i class="bi bi-check-circle me-2"></i>Review deleted successfully
        </div>
    </c:if>

    <!-- Items to Review -->
    <div class="review-card">
        <h5><i class="bi bi-pencil me-2" style="color: var(--primary-orange);"></i>Items You Can Review</h5>

        <c:choose>
            <c:when test="${empty reviewableOrders}">
                <div class="empty-state">
                    <i class="bi bi-inbox"></i>
                    <p>No items available to review.</p>
                    <p><small>You can review items from delivered orders.</small></p>
                </div>
            </c:when>
            <c:otherwise>
                <c:forEach var="item" items="${reviewableOrders}">
                    <div class="reviewable-item">
                        <div class="d-flex justify-content-between align-items-center">
                            <div>
                                <div class="instrument-name">
                                    <i class="bi bi-music-note-beamed me-2" style="color: var(--primary-orange);"></i>
                                        ${item.instrumentName}
                                </div>
                                <div class="order-info">
                                    Order #${item.orderNumber}
                                </div>
                            </div>
                            <div>
                                <c:choose>
                                    <c:when test="${item.alreadyReviewed}">
                                        <span class="already-reviewed">
                                            <i class="bi bi-check-circle me-1"></i>Reviewed
                                        </span>
                                    </c:when>
                                    <c:otherwise>
                                        <a href="${pageContext.request.contextPath}/reviews/submit?orderId=${item.orderId}&instrumentId=${item.instrumentId}"
                                           class="btn-write-review">
                                            <i class="bi bi-star me-1"></i>Write Review
                                        </a>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </c:otherwise>
        </c:choose>
    </div>

    <!-- My Reviews -->
    <div class="review-card">
        <h5><i class="bi bi-chat-left-text me-2" style="color: var(--primary-orange);"></i>My Reviews</h5>

        <c:choose>
            <c:when test="${empty myReviews}">
                <div class="empty-state">
                    <i class="bi bi-chat-left-text"></i>
                    <p>You haven't written any reviews yet.</p>
                </div>
            </c:when>
            <c:otherwise>
                <c:forEach var="review" items="${myReviews}">
                    <div class="my-review-item">
                        <div class="d-flex justify-content-between align-items-start mb-2">
                            <div>
                                <strong style="color: var(--dark-brown);">${review.instrumentName}</strong>
                                <div class="review-stars">
                                    <c:forEach begin="1" end="${review.rating}">⭐</c:forEach>
                                    <c:forEach begin="${review.rating + 1}" end="5">☆</c:forEach>
                                </div>
                            </div>
                            <form action="${pageContext.request.contextPath}/reviews/delete" method="post" style="display: inline;">
                                <input type="hidden" name="feedbackId" value="${review.id}">
                                <input type="hidden" name="redirectUrl" value="${pageContext.request.contextPath}/reviews/my-reviews">
                                <button type="submit" class="btn btn-delete"
                                        onclick="return confirm('Are you sure you want to delete this review?')">
                                    <i class="bi bi-trash"></i> Delete
                                </button>
                            </form>
                        </div>
                        <p class="review-comment">${review.comment}</p>
                        <div class="review-meta">
                            <i class="bi bi-receipt me-1"></i>Order #${review.orderNumber} •
                            <i class="bi bi-calendar3 ms-2 me-1"></i>
                            <fmt:parseDate value="${review.createdAt}" pattern="yyyy-MM-dd'T'HH:mm" var="parsedDate" type="both" />
                            <fmt:formatDate value="${parsedDate}" pattern="MMM dd, yyyy"/>
                        </div>
                    </div>
                </c:forEach>
            </c:otherwise>
        </c:choose>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>