<%--
Created by IntelliJ IDEA.
User: vinod
Date: 8/31/2025
Time: 9:51 AM
To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard - Musical Instruments Store</title>

    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Bootstrap Icons -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">

    <style>
        :root {
            /* Soft Musical Color Palette */
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

        /* Navbar Styling */
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
            transition: transform 0.3s ease;
        }

        .navbar .navbar-brand:hover {
            transform: translateX(3px);
        }

        .navbar .nav-link {
            color: var(--text-dark) !important;
            font-weight: 500;
            transition: all 0.3s ease;
            border-radius: 8px;
            padding: 0.5rem 1rem !important;
            margin: 0 0.2rem;
            font-size: 0.95rem;
        }

        .navbar .nav-link:hover {
            color: var(--primary-orange) !important;
            background: var(--primary-cream);
        }

        .navbar .nav-link.active {
            color: var(--primary-orange) !important;
            background: var(--primary-cream);
        }

        /* Dropdown styling */
        .navbar .dropdown-menu {
            border: none;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1);
            border-radius: 10px;
            margin-top: 0.5rem;
        }

        .navbar .dropdown-item {
            padding: 0.6rem 1.2rem;
            transition: all 0.3s ease;
            color: var(--text-dark);
            font-size: 0.95rem;
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

        /* Welcome Section */
        .welcome-section {
            background: linear-gradient(135deg, var(--primary-cream) 0%, transparent 100%);
            border-radius: 15px;
            padding: 2rem;
            margin-bottom: 2rem;
        }

        .welcome-title {
            color: var(--dark-brown);
            font-weight: 600;
            margin-bottom: 0.5rem;
        }

        .welcome-subtitle {
            color: var(--text-light);
            font-size: 0.95rem;
        }

        /* Statistics Cards */
        .stat-card {
            border: none;
            border-radius: 12px;
            transition: transform 0.2s, box-shadow 0.2s;
            background: var(--white);
            box-shadow: 0 3px 10px rgba(0,0,0,0.05);
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

        /* Icon backgrounds with soft colors */
        .icon-total {
            background: var(--primary-cream);
            color: var(--primary-orange);
        }

        .icon-pending {
            background: #FFF5E6;
            color: #F4A261;
        }

        .icon-progress {
            background: #E6F3FF;
            color: #4A90E2;
        }

        .icon-delivered {
            background: #E8F5E9;
            color: #4CAF50;
        }

        /* Table and Orders Section */
        .orders-card {
            border: none;
            border-radius: 12px;
            box-shadow: 0 3px 10px rgba(0,0,0,0.05);
            background: var(--white);
        }

        .orders-card .card-header {
            background: var(--white);
            border-bottom: 1px solid #F0F0F0;
            padding: 1.25rem;
        }

        .orders-card h5 {
            color: var(--dark-brown);
            font-weight: 600;
            font-size: 1.1rem;
        }

        .btn-view-all {
            background: linear-gradient(135deg, var(--primary-orange) 0%, var(--primary-orange-soft) 100%);
            color: white;
            border: none;
            border-radius: 20px;
            padding: 0.4rem 1rem;
            font-size: 0.85rem;
            font-weight: 500;
            transition: all 0.3s ease;
        }

        .btn-view-all:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(255, 140, 97, 0.3);
            color: white;
        }

        .table {
            font-size: 0.95rem;
        }

        .table thead {
            background: var(--bg-light);
            color: var(--text-dark);
        }

        .table thead th {
            border: none;
            font-weight: 600;
            padding: 1rem;
        }

        .table-hover tbody tr:hover {
            background-color: var(--primary-cream);
            cursor: pointer;
        }

        .table tbody td {
            padding: 1rem;
            vertical-align: middle;
            color: var(--text-dark);
        }

        /* Order Status Badges */
        .order-badge {
            font-size: 0.85rem;
            padding: 0.4rem 0.8rem;
            border-radius: 20px;
            font-weight: 500;
        }

        .badge-pending {
            background: #FFF5E6;
            color: #F4A261;
        }

        .badge-processing {
            background: #E6F3FF;
            color: #4A90E2;
        }

        .badge-shipped {
            background: var(--primary-cream);
            color: var(--primary-orange);
        }

        .badge-delivered {
            background: #E8F5E9;
            color: #4CAF50;
        }

        .btn-outline-view {
            border: 2px solid var(--primary-orange);
            color: var(--primary-orange);
            border-radius: 20px;
            padding: 0.3rem 1rem;
            font-size: 0.85rem;
            font-weight: 500;
            transition: all 0.3s ease;
        }

        .btn-outline-view:hover {
            background: var(--primary-orange);
            color: white;
            transform: translateY(-2px);
        }

        /* Empty State */
        .empty-state {
            padding: 4rem 2rem;
            text-align: center;
        }

        .empty-state i {
            font-size: 4rem;
            color: var(--primary-orange-soft);
            opacity: 0.5;
        }

        .empty-state p {
            color: var(--text-light);
            margin-top: 1rem;
        }

        /* Mobile responsive */
        @media (max-width: 768px) {
            .navbar .navbar-collapse {
                background: var(--white);
                padding: 1rem;
                border-radius: 10px;
                margin-top: 1rem;
                box-shadow: 0 5px 15px rgba(0,0,0,0.1);
            }
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
                    <a class="nav-link active" href="${pageContext.request.contextPath}/dashboard">
                        <i class="bi bi-speedometer2 me-1"></i>Dashboard
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="${pageContext.request.contextPath}/orders">
                        <i class="bi bi-list-ul me-1"></i>All Orders
                    </a>
                </li>
            </ul>
            <ul class="navbar-nav">
                <li class="nav-item dropdown">
                    <a class="nav-link dropdown-toggle" href="#" id="userDropdown" role="button" data-bs-toggle="dropdown">
                        <i class="bi bi-person-circle me-1"></i>
                        <c:choose>
                            <c:when test="${not empty sessionScope.userEmail}">
                                ${sessionScope.userEmail}
                            </c:when>
                            <c:otherwise>
                                User
                            </c:otherwise>
                        </c:choose>
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
            </ul>
        </div>
    </div>
</nav>

<!-- Main Content -->
<div class="container-fluid py-4">
    <!-- Welcome Section -->
    <div class="welcome-section">
        <h2 class="welcome-title">
            Welcome back,
            <c:choose>
                <c:when test="${not empty sessionScope.userName}">
                    ${sessionScope.userName}
                </c:when>
                <c:otherwise>Music Lover</c:otherwise>
            </c:choose>!
        </h2>
        <p class="welcome-subtitle">Here's what's happening with your orders today.</p>
    </div>

    <!-- Statistics Cards -->
    <div class="row g-3 mb-4">
        <!-- Total Orders Card -->
        <div class="col-xl-3 col-md-6">
            <div class="card stat-card">
                <div class="card-body">
                    <div class="d-flex justify-content-between align-items-center">
                        <div>
                            <p class="stat-label">Total Orders</p>
                            <h3 class="stat-value">${fn:length(orders)}</h3>
                        </div>
                        <div class="stat-icon icon-total">
                            <i class="bi bi-cart3"></i>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Pending Orders Card -->
        <div class="col-xl-3 col-md-6">
            <div class="card stat-card">
                <div class="card-body">
                    <div class="d-flex justify-content-between align-items-center">
                        <div>
                            <p class="stat-label">Pending</p>
                            <h3 class="stat-value">
                                <c:set var="pendingCount" value="0" />
                                <c:forEach var="order" items="${orders}">
                                    <c:if test="${fn:containsIgnoreCase(order.status, 'pending')}">
                                        <c:set var="pendingCount" value="${pendingCount + 1}" />
                                    </c:if>
                                </c:forEach>
                                ${pendingCount}
                            </h3>
                        </div>
                        <div class="stat-icon icon-pending">
                            <i class="bi bi-clock-history"></i>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Processing/Shipped Orders Card -->
        <div class="col-xl-3 col-md-6">
            <div class="card stat-card">
                <div class="card-body">
                    <div class="d-flex justify-content-between align-items-center">
                        <div>
                            <p class="stat-label">In Progress</p>
                            <h3 class="stat-value">
                                <c:set var="processingCount" value="0" />
                                <c:forEach var="order" items="${orders}">
                                    <c:if test="${fn:containsIgnoreCase(order.status, 'processing') or fn:containsIgnoreCase(order.status, 'shipped')}">
                                        <c:set var="processingCount" value="${processingCount + 1}" />
                                    </c:if>
                                </c:forEach>
                                ${processingCount}
                            </h3>
                        </div>
                        <div class="stat-icon icon-progress">
                            <i class="bi bi-arrow-repeat"></i>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Delivered Orders Card -->
        <div class="col-xl-3 col-md-6">
            <div class="card stat-card">
                <div class="card-body">
                    <div class="d-flex justify-content-between align-items-center">
                        <div>
                            <p class="stat-label">Delivered</p>
                            <h3 class="stat-value">
                                <c:set var="deliveredCount" value="0" />
                                <c:forEach var="order" items="${orders}">
                                    <c:if test="${fn:containsIgnoreCase(order.status, 'delivered')}">
                                        <c:set var="deliveredCount" value="${deliveredCount + 1}" />
                                    </c:if>
                                </c:forEach>
                                ${deliveredCount}
                            </h3>
                        </div>
                        <div class="stat-icon icon-delivered">
                            <i class="bi bi-check-circle"></i>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Recent Orders Section -->
    <div class="row">
        <div class="col-12">
            <div class="card orders-card">
                <div class="card-header">
                    <div class="d-flex justify-content-between align-items-center">
                        <h5 class="mb-0">
                            <i class="bi bi-clock-history me-2" style="color: var(--primary-orange);"></i>
                            Recent Orders
                        </h5>
                        <a href="${pageContext.request.contextPath}/orders" class="btn btn-sm btn-view-all">
                            View All Orders <i class="bi bi-arrow-right"></i>
                        </a>
                    </div>
                </div>
                <div class="card-body p-0">
                    <c:choose>
                        <c:when test="${empty orders}">
                            <!-- Empty State -->
                            <div class="empty-state">
                                <i class="bi bi-music-note-list"></i>
                                <p class="mt-3">No orders yet.</p>
                                <p>Your musical instrument orders will appear here.</p>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <!-- Orders Table -->
                            <div class="table-responsive">
                                <table class="table table-hover mb-0">
                                    <thead>
                                    <tr>
                                        <th class="px-4">Order Number</th>
                                        <th>Status</th>
                                        <th>Created Date</th>
                                        <th>Actions</th>
                                    </tr>
                                    </thead>
                                    <tbody>
                                    <c:forEach var="o" items="${orders}" varStatus="loop">
                                        <c:if test="${loop.index < 3}">
                                            <tr onclick="window.location='${pageContext.request.contextPath}/orders/view?id=${o.id}'" style="cursor: pointer;">
                                                <td class="px-4">
                                                    <i class="bi bi-music-note-beamed me-2" style="color: var(--primary-orange);"></i>
                                                    <strong>${o.orderNumber}</strong>
                                                </td>
                                                <td>
                                                    <c:set var="upperStatus" value="${fn:toUpperCase(o.status)}" />
                                                    <c:choose>
                                                        <c:when test="${upperStatus == 'PENDING' or o.status == 'Pending'}">
                                                                <span class="badge order-badge badge-pending">
                                                                    <i class="bi bi-clock me-1"></i>Pending
                                                                </span>
                                                        </c:when>
                                                        <c:when test="${upperStatus == 'PROCESSING' or o.status == 'Processing'}">
                                                                <span class="badge order-badge badge-processing">
                                                                    <i class="bi bi-gear me-1"></i>Processing
                                                                </span>
                                                        </c:when>
                                                        <c:when test="${upperStatus == 'SHIPPED' or o.status == 'Shipped'}">
                                                                <span class="badge order-badge badge-shipped">
                                                                    <i class="bi bi-truck me-1"></i>Shipped
                                                                </span>
                                                        </c:when>
                                                        <c:when test="${upperStatus == 'DELIVERED' or o.status == 'Delivered'}">
                                                                <span class="badge order-badge badge-delivered">
                                                                    <i class="bi bi-check-circle me-1"></i>Delivered
                                                                </span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="badge order-badge bg-secondary">${o.status}</span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td>
                                                    <i class="bi bi-calendar3 me-1" style="color: var(--text-light);"></i>
                                                        ${o.createdAt}
                                                </td>
                                                <td>
                                                    <a href="${pageContext.request.contextPath}/orders/view?id=${o.id}"
                                                       class="btn btn-sm btn-outline-view"
                                                       onclick="event.stopPropagation();">
                                                        <i class="bi bi-eye me-1"></i>View Details
                                                    </a>
                                                </td>
                                            </tr>
                                        </c:if>
                                    </c:forEach>
                                    </tbody>
                                </table>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Bootstrap JS Bundle -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>