<%--
  Created by IntelliJ IDEA.
  User: vinod
  Date: 10/18/2025
  Time: 6:40 AM
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
    <title>Review Monitoring - Admin Dashboard</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">

    <style>
        :root {
            --primary-orange: #FF8C61;
            --primary-orange-soft: #FFB08A;
            --primary-cream: #FFF4E6;
            --accent-gold: #F4C430;
            --accent-gold-soft: #F9D968;
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
            margin: 0 0.2rem;
        }

        .navbar .nav-link:hover {
            color: var(--primary-orange) !important;
            background: var(--primary-cream);
        }

        .navbar .nav-link.active {
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

        .admin-badge {
            background: linear-gradient(135deg, var(--accent-gold) 0%, var(--accent-gold-soft) 100%);
            color: var(--dark-brown);
            padding: 0.3rem 0.8rem;
            border-radius: 20px;
            font-size: 0.75rem;
            font-weight: 600;
            margin-left: 0.5rem;
            text-transform: uppercase;
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
            margin-bottom: 0.5rem;
        }

        .page-header p {
            opacity: 0.9;
            margin: 0;
        }

        /* Statistics Cards */
        .stat-card {
            border: none;
            border-radius: 12px;
            transition: transform 0.2s, box-shadow 0.2s;
            background: var(--white);
            box-shadow: 0 3px 10px rgba(0,0,0,0.05);
            height: 100%;
        }

        .stat-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 8px 20px rgba(0,0,0,0.1);
        }

        .stat-label {
            color: var(--text-light);
            font-size: 0.9rem;
            font-weight: 500;
            margin-bottom: 0.5rem;
        }

        .stat-value {
            color: var(--dark-brown);
            font-size: 2rem;
            font-weight: 700;
        }

        .stat-icon {
            width: 50px;
            height: 50px;
            display: flex;
            align-items: center;
            justify-content: center;
            border-radius: 12px;
            font-size: 24px;
        }

        .icon-total {
            background: var(--primary-cream);
            color: var(--primary-orange);
        }

        .icon-rating {
            background: #FFF5E6;
            color: #FFD700;
        }

        /* Reviews Card */
        .reviews-card {
            border: none;
            border-radius: 12px;
            box-shadow: 0 3px 10px rgba(0,0,0,0.05);
            background: var(--white);
        }

        .reviews-card .card-header {
            background: var(--white);
            border-bottom: 1px solid #F0F0F0;
            padding: 1.25rem;
        }

        .reviews-card h5 {
            color: var(--dark-brown);
            font-weight: 600;
            font-size: 1.1rem;
        }

        /* Review Items */
        .review-item {
            border-bottom: 1px solid #F0F0F0;
            padding: 1.5rem;
            transition: all 0.3s ease;
        }

        .review-item:hover {
            background: var(--primary-cream);
        }

        .review-item:last-child {
            border-bottom: none;
        }

        .review-header {
            display: flex;
            justify-content: space-between;
            align-items: start;
            margin-bottom: 1rem;
        }

        .reviewer-info {
            flex-grow: 1;
        }

        .reviewer-name {
            font-weight: 600;
            color: var(--dark-brown);
            margin-bottom: 0.25rem;
        }

        .review-meta {
            color: var(--text-light);
            font-size: 0.85rem;
        }

        .review-stars {
            color: #FFD700;
            font-size: 1.1rem;
            margin-bottom: 0.5rem;
        }

        .review-comment {
            color: var(--text-dark);
            line-height: 1.6;
            margin-bottom: 1rem;
        }

        .instrument-tag {
            background: var(--primary-cream);
            color: var(--primary-orange);
            padding: 0.3rem 0.8rem;
            border-radius: 15px;
            font-size: 0.85rem;
            font-weight: 500;
            display: inline-block;
            margin-bottom: 0.5rem;
        }

        /* Buttons */
        .btn-delete-review {
            background: #FFEBEE;
            border: none;
            color: #F44336;
            padding: 0.4rem 1rem;
            border-radius: 20px;
            font-weight: 500;
            transition: all 0.3s ease;
            font-size: 0.85rem;
        }

        .btn-delete-review:hover {
            background: #F44336;
            color: white;
            transform: translateY(-2px);
        }

        /* Search Box */
        .search-box {
            max-width: 400px;
            margin-bottom: 1.5rem;
        }

        .search-box .input-group-text {
            background: var(--white);
            border: 2px solid #E8E8E8;
            border-right: none;
            color: var(--primary-orange);
        }

        .search-box .form-control {
            border: 2px solid #E8E8E8;
            border-left: none;
            font-size: 0.95rem;
        }

        .search-box .form-control:focus {
            border-color: var(--primary-orange-soft);
            box-shadow: none;
        }

        /* Empty State */
        .empty-state {
            text-align: center;
            padding: 4rem 2rem;
        }

        .empty-state i {
            font-size: 5rem;
            color: var(--primary-orange-soft);
            opacity: 0.5;
        }

        .empty-state h3 {
            color: var(--dark-brown);
            margin-top: 1.5rem;
        }

        .empty-state p {
            color: var(--text-light);
            margin-top: 0.5rem;
        }

        /* Alert */
        .alert {
            border-radius: 10px;
            border: none;
        }

        /* Filter Pills */
        .filter-pills {
            display: flex;
            gap: 0.5rem;
            margin-bottom: 1.5rem;
        }

        .filter-pill {
            padding: 0.5rem 1rem;
            border-radius: 20px;
            border: 2px solid var(--primary-cream);
            background: var(--white);
            color: var(--text-dark);
            font-weight: 500;
            cursor: pointer;
            transition: all 0.3s ease;
        }

        .filter-pill.active {
            background: var(--primary-orange);
            color: white;
            border-color: var(--primary-orange);
        }
    </style>
</head>
<body>
<!-- Navigation Bar -->
<nav class="navbar navbar-expand-lg">
    <div class="container-fluid">
        <a class="navbar-brand" href="${pageContext.request.contextPath}/admin/dashboard">
            🎵 Musical Store <span class="admin-badge">Admin</span>
        </a>
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
            <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse" id="navbarNav">
            <ul class="navbar-nav me-auto">
                <li class="nav-item">
                    <a class="nav-link" href="${pageContext.request.contextPath}/admin/dashboard">
                        <i class="bi bi-speedometer2 me-1"></i>Dashboard
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="${pageContext.request.contextPath}/admin/payments">
                        <i class="bi bi-credit-card me-1"></i>Payments
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link active" href="${pageContext.request.contextPath}/admin/reviews">
                        <i class="bi bi-star me-1"></i>Reviews
                    </a>
                </li>
            </ul>
            <ul class="navbar-nav">
                <li class="nav-item dropdown">
                    <a class="nav-link dropdown-toggle" href="#" id="userDropdown" role="button" data-bs-toggle="dropdown">
                        <i class="bi bi-person-circle me-1"></i>
                        ${sessionScope.userName}
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
        <h2><i class="bi bi-star-fill me-2"></i>Review Monitoring</h2>
        <p>Monitor customer reviews and feedback</p>
    </div>

    <!-- Success Message -->
    <c:if test="${not empty successMessage}">
        <div class="alert alert-success">
            <i class="bi bi-check-circle me-2"></i>${successMessage}
        </div>
    </c:if>

    <!-- Statistics -->
    <div class="row g-3 mb-4">
        <div class="col-xl-4 col-md-6">
            <div class="card stat-card">
                <div class="card-body">
                    <div class="d-flex justify-content-between align-items-center">
                        <div>
                            <p class="stat-label">Total Reviews</p>
                            <h3 class="stat-value">${fn:length(reviews)}</h3>
                        </div>
                        <div class="stat-icon icon-total">
                            <i class="bi bi-chat-left-text"></i>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <div class="col-xl-4 col-md-6">
            <div class="card stat-card">
                <div class="card-body">
                    <div class="d-flex justify-content-between align-items-center">
                        <div>
                            <p class="stat-label">Average Rating</p>
                            <h3 class="stat-value">
                                <c:set var="totalRating" value="0"/>
                                <c:forEach var="review" items="${reviews}">
                                    <c:set var="totalRating" value="${totalRating + review.rating}"/>
                                </c:forEach>
                                <c:choose>
                                    <c:when test="${fn:length(reviews) > 0}">
                                        <fmt:formatNumber value="${totalRating / fn:length(reviews)}" pattern="#.#"/>
                                    </c:when>
                                    <c:otherwise>0.0</c:otherwise>
                                </c:choose>
                            </h3>
                        </div>
                        <div class="stat-icon icon-rating">
                            <i class="bi bi-star-fill"></i>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <div class="col-xl-4 col-md-12">
            <div class="card stat-card">
                <div class="card-body">
                    <div class="d-flex justify-content-between align-items-center">
                        <div>
                            <p class="stat-label">Recent Activity</p>
                            <h3 class="stat-value" style="font-size: 1.2rem;">
                                <c:set var="recentCount" value="0"/>
                                <c:forEach var="review" items="${reviews}">
                                    <c:if test="${review.createdAt != null}">
                                        <c:set var="recentCount" value="${recentCount + 1}"/>
                                    </c:if>
                                </c:forEach>
                                ${recentCount} reviews this month
                            </h3>
                        </div>
                        <div class="stat-icon" style="background: #E6F3FF; color: #4A90E2;">
                            <i class="bi bi-graph-up"></i>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Reviews List -->
    <div class="reviews-card">
        <div class="card-header">
            <h5 class="mb-0">
                <i class="bi bi-list-check me-2" style="color: var(--primary-orange);"></i>
                All Customer Reviews
            </h5>
        </div>
        <div class="card-body p-0">
            <c:choose>
                <c:when test="${empty reviews}">
                    <div class="empty-state">
                        <i class="bi bi-chat-left-text"></i>
                        <h3>No reviews yet</h3>
                        <p>Customer reviews will appear here once they start reviewing products.</p>
                    </div>
                </c:when>
                <c:otherwise>
                    <!-- Search Box -->
                    <div class="p-3">
                        <div class="search-box">
                            <div class="input-group">
                                <span class="input-group-text">
                                    <i class="bi bi-search"></i>
                                </span>
                                <input type="text" class="form-control" id="searchReviews"
                                       placeholder="Search reviews..." onkeyup="filterReviews()">
                            </div>
                        </div>

                        <!-- Filter Pills -->
                        <div class="filter-pills">
                            <button class="filter-pill active" onclick="filterByRating('all', this)">
                                All Reviews
                            </button>
                            <button class="filter-pill" onclick="filterByRating('5', this)">
                                ⭐⭐⭐⭐⭐
                            </button>
                            <button class="filter-pill" onclick="filterByRating('4', this)">
                                ⭐⭐⭐⭐
                            </button>
                            <button class="filter-pill" onclick="filterByRating('3', this)">
                                ⭐⭐⭐
                            </button>
                            <button class="filter-pill" onclick="filterByRating('2', this)">
                                ⭐⭐
                            </button>
                            <button class="filter-pill" onclick="filterByRating('1', this)">
                                ⭐
                            </button>
                        </div>
                    </div>

                    <!-- Reviews List -->
                    <div id="reviewsList">
                        <c:forEach var="review" items="${reviews}">
                            <div class="review-item" data-rating="${review.rating}"
                                 data-search="${fn:toLowerCase(review.userName)} ${fn:toLowerCase(review.instrumentName)} ${fn:toLowerCase(review.comment)}">
                                <div class="review-header">
                                    <div class="reviewer-info">
                                        <div class="reviewer-name">
                                            <i class="bi bi-person-circle me-2" style="color: var(--primary-orange);"></i>
                                                ${review.userName}
                                        </div>
                                        <div class="review-meta">
                                            <i class="bi bi-calendar3 me-1"></i>
                                            <fmt:parseDate value="${review.createdAt}" pattern="yyyy-MM-dd'T'HH:mm" var="parsedDate" type="both" />
                                            <fmt:formatDate value="${parsedDate}" pattern="MMM dd, yyyy"/> •
                                            <i class="bi bi-receipt ms-2 me-1"></i>Order #${review.orderNumber}
                                        </div>
                                    </div>
                                    <form action="${pageContext.request.contextPath}/reviews/delete" method="post"
                                          style="display: inline;" onsubmit="return confirm('Delete this review?')">
                                        <input type="hidden" name="feedbackId" value="${review.id}">
                                        <input type="hidden" name="redirectUrl" value="${pageContext.request.contextPath}/admin/reviews">
                                        <button type="submit" class="btn btn-delete-review">
                                            <i class="bi bi-trash"></i> Delete
                                        </button>
                                    </form>
                                </div>

                                <div class="instrument-tag">
                                    <i class="bi bi-music-note-beamed me-1"></i>${review.instrumentName}
                                </div>

                                <div class="review-stars">
                                    <c:forEach begin="1" end="${review.rating}">⭐</c:forEach>
                                    <c:forEach begin="${review.rating + 1}" end="5">☆</c:forEach>
                                </div>

                                <p class="review-comment">${review.comment}</p>
                            </div>
                        </c:forEach>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
    // Search functionality
    function filterReviews() {
        const searchValue = document.getElementById('searchReviews').value.toLowerCase();
        const reviews = document.querySelectorAll('.review-item');

        reviews.forEach(review => {
            const searchText = review.getAttribute('data-search');
            if (searchText.includes(searchValue)) {
                review.style.display = '';
            } else {
                review.style.display = 'none';
            }
        });
    }

    // Filter by rating
    function filterByRating(rating, button) {
        // Update button states
        document.querySelectorAll('.filter-pill').forEach(pill => {
            pill.classList.remove('active');
        });
        button.classList.add('active');

        // Filter reviews
        const reviews = document.querySelectorAll('.review-item');

        reviews.forEach(review => {
            const reviewRating = review.getAttribute('data-rating');

            if (rating === 'all' || reviewRating === rating) {
                review.style.display = '';
            } else {
                review.style.display = 'none';
            }
        });
    }
</script>
</body>
</html>