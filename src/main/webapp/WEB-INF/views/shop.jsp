<%--
  Created by IntelliJ IDEA.
  User: vinod
  Date: 10/16/2025
  Time: 6:14 PM
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
    <title>Shop Instruments - Musical Instruments Store</title>

    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Bootstrap Icons -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">

    <style>
        :root {
            --primary-orange: #FF8C61;
            --primary-orange-soft: #FFB08A;
            --primary-terracotta: #C2785C;
            --primary-cream: #FFF4E6;
            --accent-gold: #F4C430;
            --accent-gold-soft: #F9D968;
            --dark-brown: #6B4423;
            --light-peach: #FFDAB9;
            --text-dark: #3A3A3A;
            --text-light: #6C6C6C;
            --white: #FFFFFF;
            --bg-light: #FFFBF7;
            --bg-section: #FAFAFA;
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

        .navbar .dropdown-item i {
            width: 20px;
            color: var(--primary-orange);
        }

        /* Cart Badge */
        .cart-badge {
            position: absolute;
            top: -8px;
            right: -8px;
            background: linear-gradient(135deg, var(--primary-orange) 0%, var(--primary-orange-soft) 100%);
            color: white;
            border-radius: 50%;
            width: 20px;
            height: 20px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 0.7rem;
            font-weight: 600;
        }

        /* Page Header */
        .page-header {
            background: linear-gradient(135deg, var(--primary-orange) 0%, var(--primary-orange-soft) 100%);
            padding: 3rem 0;
            margin-bottom: 2rem;
            color: white;
            text-align: center;
        }

        .page-header h1 {
            font-weight: 700;
            margin-bottom: 0.5rem;
        }

        .page-header p {
            font-size: 1.1rem;
            opacity: 0.9;
        }

        /* Search & Filter Section */
        .filter-section {
            background: var(--white);
            border-radius: 12px;
            padding: 1.5rem;
            margin-bottom: 2rem;
            box-shadow: 0 3px 10px rgba(0,0,0,0.05);
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
            padding: 0.65rem 1rem;
        }

        .search-box .form-control:focus {
            border-color: var(--primary-orange-soft);
            box-shadow: 0 0 0 3px rgba(255, 140, 97, 0.1);
        }

        .btn-search {
            background: linear-gradient(135deg, var(--primary-orange) 0%, var(--primary-orange-soft) 100%);
            border: none;
            color: white;
            padding: 0.65rem 1.5rem;
            font-weight: 600;
            border-radius: 8px;
            transition: all 0.3s ease;
        }

        .btn-search:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(255, 140, 97, 0.3);
            color: white;
        }

        .filter-btn {
            border: 2px solid var(--primary-cream);
            background: var(--white);
            color: var(--text-dark);
            padding: 0.5rem 1.2rem;
            border-radius: 25px;
            font-weight: 500;
            transition: all 0.3s ease;
            margin: 0.25rem;
            cursor: pointer;
        }

        .filter-btn:hover {
            background: var(--primary-cream);
            border-color: var(--primary-orange-soft);
            color: var(--primary-orange);
        }

        .filter-btn.active {
            background: linear-gradient(135deg, var(--primary-orange) 0%, var(--primary-orange-soft) 100%);
            color: white;
            border-color: var(--primary-orange);
        }

        /* Instrument Cards */
        .instrument-card {
            background: var(--white);
            border-radius: 15px;
            overflow: hidden;
            transition: all 0.3s ease;
            box-shadow: 0 3px 10px rgba(0,0,0,0.08);
            height: 100%;
            display: flex;
            flex-direction: column;
            border: 1px solid #F0F0F0;
        }

        .instrument-card:hover {
            transform: translateY(-8px);
            box-shadow: 0 12px 30px rgba(0,0,0,0.15);
        }

        .instrument-icon {
            background: linear-gradient(135deg, var(--primary-cream) 0%, var(--light-peach) 100%);
            height: 250px;  /* ← Increased from 180px */
            position: relative;
            overflow: hidden;
        }

        /* NEW: Image styling */
        .instrument-image {
            width: 100%;
            height: 100%;
            object-fit: cover;
            transition: transform 0.3s ease;
        }

        /* Zoom effect on hover */
        .instrument-card:hover .instrument-image {
            transform: scale(1.1);
        }

        .stock-badge {
            position: absolute;
            top: 10px;
            right: 10px;
            padding: 0.4rem 0.8rem;
            border-radius: 20px;
            font-size: 0.75rem;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .badge-in-stock {
            background: #E8F5E9;
            color: #4CAF50;
        }

        .badge-low-stock {
            background: #FFF5E6;
            color: #F4A261;
        }

        .badge-out-stock {
            background: #FFEBEE;
            color: #F44336;
        }

        .card-body {
            padding: 1.5rem;
            flex-grow: 1;
            display: flex;
            flex-direction: column;
        }

        .instrument-name {
            font-size: 1.2rem;
            font-weight: 600;
            color: var(--dark-brown);
            margin-bottom: 0.5rem;
        }

        .instrument-description {
            color: var(--text-light);
            font-size: 0.9rem;
            margin-bottom: 1rem;
            flex-grow: 1;
            line-height: 1.6;
        }

        .price-section {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-top: auto;
            padding-top: 1rem;
            border-top: 1px solid #F0F0F0;
        }

        .price {
            font-size: 1.8rem;
            font-weight: 700;
            color: var(--primary-orange);
        }

        .btn-add-cart {
            background: linear-gradient(135deg, var(--primary-orange) 0%, var(--primary-orange-soft) 100%);
            border: none;
            color: white;
            padding: 0.6rem 1.5rem;
            border-radius: 25px;
            font-weight: 600;
            transition: all 0.3s ease;
            font-size: 0.9rem;
        }

        .btn-add-cart:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(255, 140, 97, 0.4);
            color: white;
        }

        .btn-add-cart:disabled {
            background: #CCCCCC;
            cursor: not-allowed;
            transform: none;
        }

        .btn-view-details {
            border: 2px solid var(--primary-orange);
            color: var(--primary-orange);
            background: transparent;
            padding: 0.5rem 1rem;
            border-radius: 25px;
            font-weight: 500;
            transition: all 0.3s ease;
            font-size: 0.85rem;
            text-decoration: none;
            display: inline-block;
        }

        .btn-view-details:hover {
            background: var(--primary-orange);
            color: white;
            transform: translateY(-2px);
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

        /* Results Count */
        .results-count {
            color: var(--text-light);
            font-size: 0.95rem;
            margin-bottom: 1rem;
        }

        .results-count strong {
            color: var(--primary-orange);
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
                    <a class="nav-link active" href="${pageContext.request.contextPath}/shop">
                        <i class="bi bi-shop me-1"></i>Shop
                    </a>
                </li>
                <c:if test="${not empty sessionScope.userId}">
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
                </c:if>
            </ul>
            <ul class="navbar-nav">
                <li class="nav-item">
                    <a class="nav-link position-relative" href="${pageContext.request.contextPath}/cart">
                        <i class="bi bi-cart3 me-1"></i>Cart
                        <span class="cart-badge" id="cartBadge">0</span>
                    </a>
                </li>
                <c:choose>
                    <c:when test="${not empty sessionScope.userId}">
                        <li class="nav-item dropdown">
                            <a class="nav-link dropdown-toggle" href="#" id="userDropdown" role="button" data-bs-toggle="dropdown">
                                <i class="bi bi-person-circle me-1"></i>
                                    ${sessionScope.userName}
                            </a>
                            <ul class="dropdown-menu dropdown-menu-end">
                                <li>
                                    <a class="dropdown-item" href="${pageContext.request.contextPath}/profile">
                                        <i class="bi bi-person me-2"></i>Profile
                                    </a>
                                </li>
                                <li><hr class="dropdown-divider"></li>
                                <li>
                                    <a class="dropdown-item" href="${pageContext.request.contextPath}/logout">
                                        <i class="bi bi-box-arrow-right me-2"></i>Logout
                                    </a>
                                </li>
                            </ul>
                        </li>
                    </c:when>
                    <c:otherwise>
                        <li class="nav-item">
                            <a class="nav-link" href="${pageContext.request.contextPath}/login">
                                <i class="bi bi-box-arrow-in-right me-1"></i>Login
                            </a>
                        </li>
                    </c:otherwise>
                </c:choose>
            </ul>
        </div>
    </div>
</nav>

<!-- Page Header -->
<div class="page-header">
    <div class="container">
        <h1><i class="bi bi-music-note-list me-3"></i>Browse Our Collection</h1>
        <p>Discover premium musical instruments for every musician</p>
    </div>
</div>

<!-- Main Content -->
<div class="container-fluid py-4">
    <!-- Search & Filter Section -->
    <div class="filter-section">
        <div class="row g-3 align-items-center">
            <!-- Search Box -->
            <div class="col-md-6">
                <form action="${pageContext.request.contextPath}/shop" method="get" class="search-box">
                    <div class="input-group">
                        <span class="input-group-text">
                            <i class="bi bi-search"></i>
                        </span>
                        <input type="text"
                               class="form-control"
                               name="search"
                               placeholder="Search instruments..."
                               value="${currentSearch}">
                        <button type="submit" class="btn btn-search">
                            Search
                        </button>
                    </div>
                </form>
            </div>

            <!-- Filter Buttons -->
            <div class="col-md-6">
                <div class="d-flex flex-wrap align-items-center">
                    <small class="text-muted me-2">Filter:</small>
                    <a href="${pageContext.request.contextPath}/shop"
                       class="filter-btn ${empty currentFilter ? 'active' : ''}">
                        All
                    </a>
                    <a href="${pageContext.request.contextPath}/shop?filter=instock"
                       class="filter-btn ${currentFilter == 'instock' ? 'active' : ''}">
                        <i class="bi bi-check-circle me-1"></i>In Stock
                    </a>
                </div>
            </div>
        </div>
    </div>

    <!-- Results Count -->
    <div class="results-count">
        <i class="bi bi-filter-circle me-1"></i>
        Showing <strong>${fn:length(instruments)}</strong> instrument(s)
    </div>

    <!-- Instruments Grid -->
    <c:choose>
        <c:when test="${empty instruments}">
            <!-- Empty State -->
            <div class="empty-state">
                <i class="bi bi-music-note-list"></i>
                <h3>No instruments found</h3>
                <p>Try adjusting your search or filter criteria</p>
                <a href="${pageContext.request.contextPath}/shop" class="btn btn-add-cart mt-3">
                    <i class="bi bi-arrow-left me-2"></i>View All Instruments
                </a>
            </div>
        </c:when>
        <c:otherwise>
            <!-- Instruments Grid -->
            <div class="row g-4">
                <c:forEach var="instrument" items="${instruments}">
                    <div class="col-lg-3 col-md-4 col-sm-6">
                        <div class="instrument-card">
                            <!-- Instrument Icon/Image -->
                            <div class="instrument-icon">
                                <!-- Product Image -->
                                <img src="${pageContext.request.contextPath}/images/instruments/${instrument.id}.jpg"
                                     alt="${instrument.name}"
                                     class="instrument-image"
                                     onerror="this.onerror=null; this.src='${pageContext.request.contextPath}/images/instruments/default.jpg';">

                                <!-- Stock Badge (stays on top of image) -->
                                <c:choose>
                                    <c:when test="${instrument.stockQuantity > 10}">
                                        <span class="stock-badge badge-in-stock">In Stock</span>
                                    </c:when>
                                    <c:when test="${instrument.stockQuantity > 0}">
                                        <span class="stock-badge badge-low-stock">Only ${instrument.stockQuantity} left</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="stock-badge badge-out-stock">Out of Stock</span>
                                    </c:otherwise>
                                </c:choose>
                            </div>

                            <!-- Card Body -->
                            <div class="card-body">
                                <h5 class="instrument-name">${instrument.name}</h5>
                                <p class="instrument-description">
                                    <c:choose>
                                        <c:when test="${not empty instrument.description}">
                                            ${instrument.shortDescription}
                                        </c:when>
                                        <c:otherwise>
                                            High-quality instrument for musicians of all levels
                                        </c:otherwise>
                                    </c:choose>
                                </p>

                                <!-- Price Section -->
                                <div class="price-section">
                                    <div class="price">
                                        $<fmt:formatNumber value="${instrument.price}" pattern="#,##0.00"/>
                                    </div>
                                </div>

                                <!-- Action Buttons -->
                                <div class="mt-3 d-flex gap-2">
                                    <c:choose>
                                        <c:when test="${instrument.stockQuantity > 0}">
                                            <button class="btn btn-add-cart flex-grow-1"
                                                    onclick="addToCart(${instrument.id}, '${fn:escapeXml(instrument.name)}')">
                                                <i class="bi bi-cart-plus me-1"></i>Add to Cart
                                            </button>
                                        </c:when>
                                        <c:otherwise>
                                            <button class="btn btn-add-cart flex-grow-1" disabled>
                                                <i class="bi bi-x-circle me-1"></i>Out of Stock
                                            </button>
                                        </c:otherwise>
                                    </c:choose>
                                    <a href="${pageContext.request.contextPath}/shop/instrument?id=${instrument.id}"
                                       class="btn-view-details">
                                        <i class="bi bi-eye"></i>
                                    </a>
                                </div>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </c:otherwise>
    </c:choose>
</div>

<!-- Bootstrap JS Bundle -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

<!-- Cart Functions -->
<script>
    function addToCart(instrumentId, instrumentName) {
        fetch('${pageContext.request.contextPath}/cart/add', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded',
            },
            body: 'instrumentId=' + instrumentId + '&quantity=1'
        })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    // Update cart badge
                    document.getElementById('cartBadge').textContent = data.cartCount;

                    // Show success message
                    showToastMessage('✅ Added to cart!', instrumentName + ' has been added to your cart', 'success');
                } else {
                    // Show error message
                    showToastMessage('❌ Error', data.message, 'error');
                }
            })
            .catch(error => {
                console.error('Error:', error);
                showToastMessage('❌ Error', 'Failed to add item to cart', 'error');
            });
    }

    // Toast notification function
    function showToastMessage(title, message, type) {
        // Simple alert for now (you can implement Bootstrap toast later)
        alert(title + '\n' + message);
    }

    // Load cart count on page load
    document.addEventListener('DOMContentLoaded', function() {
        // Update cart badge with actual count
        fetch('${pageContext.request.contextPath}/cart')
            .then(response => response.text())
            .then(html => {
                // Extract cart count from response (or use separate API)
                // For now, we'll keep it simple
            })
            .catch(error => console.error('Error loading cart count:', error));
    });

    // Load cart count on page load
    document.addEventListener('DOMContentLoaded', function() {
        // TODO: Fetch actual cart count from session/server
        // For now, set to 0
        document.getElementById('cartBadge').textContent = '0';
    });
</script>
</body>
</html>