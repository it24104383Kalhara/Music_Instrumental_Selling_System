<%--
  Created by IntelliJ IDEA.
  User: vinod
  Date: 10/18/2025
  Time: 10:32 AM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Staff Dashboard - Musical Instruments Store</title>

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
            --staff-purple: #9C27B0;
            --staff-purple-soft: #BA68C8;
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

        .staff-badge {
            background: linear-gradient(135deg, var(--staff-purple) 0%, var(--staff-purple-soft) 100%);
            color: white;
            padding: 0.3rem 0.8rem;
            border-radius: 20px;
            font-size: 0.75rem;
            font-weight: 600;
            margin-left: 0.5rem;
            text-transform: uppercase;
        }

        /* Page Header */
        .page-header {
            background: linear-gradient(135deg, var(--staff-purple) 0%, var(--staff-purple-soft) 100%);
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

        .icon-instock {
            background: #E8F5E9;
            color: #4CAF50;
        }

        .icon-lowstock {
            background: #FFF5E6;
            color: #F4A261;
        }

        .icon-outstock {
            background: #FFEBEE;
            color: #F44336;
        }

        .icon-orders {
            background: #E6F3FF;
            color: #4A90E2;
        }

        .icon-processing {
            background: #F3E5F5;
            color: var(--staff-purple);
        }

        /* Quick Actions */
        .quick-actions {
            background: var(--white);
            border-radius: 12px;
            box-shadow: 0 3px 10px rgba(0,0,0,0.05);
            padding: 2rem;
        }

        .quick-actions h5 {
            color: var(--dark-brown);
            font-weight: 600;
            margin-bottom: 1.5rem;
        }

        .action-btn {
            display: block;
            padding: 1rem;
            margin-bottom: 1rem;
            border-radius: 10px;
            border: 2px solid #F0F0F0;
            background: var(--white);
            color: var(--text-dark);
            text-decoration: none;
            transition: all 0.3s ease;
            font-weight: 500;
        }

        .action-btn:hover {
            border-color: var(--staff-purple);
            background: #F3E5F5;
            color: var(--staff-purple);
            transform: translateX(5px);
        }

        .action-btn i {
            width: 30px;
            color: var(--staff-purple);
        }

        /* Recent Activity */
        .activity-card {
            background: var(--white);
            border-radius: 12px;
            box-shadow: 0 3px 10px rgba(0,0,0,0.05);
            padding: 2rem;
        }

        .activity-card h5 {
            color: var(--dark-brown);
            font-weight: 600;
            margin-bottom: 1.5rem;
        }

        .activity-item {
            padding: 1rem;
            border-left: 3px solid var(--staff-purple);
            background: #F3E5F5;
            border-radius: 8px;
            margin-bottom: 1rem;
        }

        .activity-time {
            color: var(--text-light);
            font-size: 0.85rem;
        }
    </style>
</head>
<body>
<!-- Navigation Bar -->
<nav class="navbar navbar-expand-lg">
    <div class="container-fluid">
        <a class="navbar-brand" href="${pageContext.request.contextPath}/staff/dashboard">
            🎵 Musical Store <span class="staff-badge">Staff</span>
        </a>
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
            <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse" id="navbarNav">
            <ul class="navbar-nav me-auto">
                <li class="nav-item">
                    <a class="nav-link active" href="${pageContext.request.contextPath}/staff/dashboard">
                        <i class="bi bi-speedometer2 me-1"></i>Dashboard
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="${pageContext.request.contextPath}/staff/instruments">
                        <i class="bi bi-box-seam me-1"></i>Manage Inventory
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
        <h2><i class="bi bi-shop me-2"></i>Staff Dashboard</h2>
        <p>Manage inventory and track product availability</p>
    </div>

    <!-- Statistics Cards -->
    <div class="row g-3 mb-4">
        <div class="col-xl-4 col-md-6">
            <div class="card stat-card">
                <div class="card-body">
                    <div class="d-flex justify-content-between align-items-center">
                        <div>
                            <p class="stat-label">Total Products</p>
                            <h3 class="stat-value">${totalInstruments}</h3>
                        </div>
                        <div class="stat-icon icon-total">
                            <i class="bi bi-music-note-list"></i>
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
                            <p class="stat-label">In Stock</p>
                            <h3 class="stat-value">${inStockCount}</h3>
                        </div>
                        <div class="stat-icon icon-instock">
                            <i class="bi bi-check-circle"></i>
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
                            <p class="stat-label">Low Stock Alert</p>
                            <h3 class="stat-value">${lowStockCount}</h3>
                        </div>
                        <div class="stat-icon icon-lowstock">
                            <i class="bi bi-exclamation-triangle"></i>
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
                            <p class="stat-label">Out of Stock</p>
                            <h3 class="stat-value">${outOfStockCount}</h3>
                        </div>
                        <div class="stat-icon icon-outstock">
                            <i class="bi bi-x-circle"></i>
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
                            <p class="stat-label">Total Orders</p>
                            <h3 class="stat-value">${totalOrders}</h3>
                        </div>
                        <div class="stat-icon icon-orders">
                            <i class="bi bi-bag"></i>
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
                            <p class="stat-label">Processing Orders</p>
                            <h3 class="stat-value">${processingOrders}</h3>
                        </div>
                        <div class="stat-icon icon-processing">
                            <i class="bi bi-gear"></i>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Quick Actions & Alerts -->
    <div class="row">
        <!-- Quick Actions -->
        <div class="col-lg-6 mb-4">
            <div class="quick-actions">
                <h5><i class="bi bi-lightning-charge me-2"></i>Quick Actions</h5>

                <a href="${pageContext.request.contextPath}/staff/instruments/add" class="action-btn">
                    <i class="bi bi-plus-circle"></i>
                    Add New Instrument
                </a>

                <a href="${pageContext.request.contextPath}/staff/instruments" class="action-btn">
                    <i class="bi bi-box-seam"></i>
                    View All Inventory
                </a>

                <a href="${pageContext.request.contextPath}/staff/instruments?filter=low-stock" class="action-btn">
                    <i class="bi bi-exclamation-triangle"></i>
                    View Low Stock Items
                </a>

                <a href="${pageContext.request.contextPath}/staff/instruments?filter=out-of-stock" class="action-btn">
                    <i class="bi bi-x-circle"></i>
                    View Out of Stock Items
                </a>
            </div>
        </div>

        <!-- Alerts -->
        <div class="col-lg-6 mb-4">
            <div class="activity-card">
                <h5><i class="bi bi-bell me-2"></i>Inventory Alerts</h5>

                <c:choose>
                    <c:when test="${lowStockCount > 0 || outOfStockCount > 0}">
                        <c:if test="${outOfStockCount > 0}">
                            <div class="activity-item" style="border-left-color: #F44336; background: #FFEBEE;">
                                <strong style="color: #F44336;">
                                    <i class="bi bi-x-circle me-2"></i>Critical Alert
                                </strong>
                                <p class="mb-1">${outOfStockCount} product(s) are out of stock</p>
                                <a href="${pageContext.request.contextPath}/staff/instruments?filter=out-of-stock"
                                   style="color: #F44336; font-weight: 500;">
                                    View Items →
                                </a>
                            </div>
                        </c:if>

                        <c:if test="${lowStockCount > 0}">
                            <div class="activity-item" style="border-left-color: #F4A261; background: #FFF5E6;">
                                <strong style="color: #F4A261;">
                                    <i class="bi bi-exclamation-triangle me-2"></i>Low Stock Warning
                                </strong>
                                <p class="mb-1">${lowStockCount} product(s) have low stock (≤5 items)</p>
                                <a href="${pageContext.request.contextPath}/staff/instruments?filter=low-stock"
                                   style="color: #F4A261; font-weight: 500;">
                                    View Items →
                                </a>
                            </div>
                        </c:if>
                    </c:when>
                    <c:otherwise>
                        <div class="activity-item" style="border-left-color: #4CAF50; background: #E8F5E9;">
                            <strong style="color: #4CAF50;">
                                <i class="bi bi-check-circle me-2"></i>All Good!
                            </strong>
                            <p class="mb-0">No stock alerts at the moment. All products are well stocked.</p>
                        </div>
                    </c:otherwise>
                </c:choose>

                <c:if test="${processingOrders > 0}">
                    <div class="activity-item mt-3">
                        <strong style="color: var(--staff-purple);">
                            <i class="bi bi-bag me-2"></i>Orders Update
                        </strong>
                        <p class="mb-0">${processingOrders} order(s) are currently being processed</p>
                    </div>
                </c:if>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>