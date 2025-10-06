<%--
  Created by IntelliJ IDEA.
  User: vinod
  Date: 8/31/2025
  Time: 9:56 AM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>All Orders - Musical Instruments Store</title>

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

        /* Page Header */
        .page-header {
            background: linear-gradient(135deg, var(--primary-cream) 0%, transparent 100%);
            border-radius: 15px;
            padding: 2rem;
            margin-bottom: 2rem;
        }

        .page-title {
            color: var(--dark-brown);
            font-weight: 600;
            margin-bottom: 0.5rem;
        }

        .page-subtitle {
            color: var(--text-light);
            font-size: 0.95rem;
        }

        /* Filter Card */
        .filter-card {
            border: none;
            border-radius: 12px;
            box-shadow: 0 3px 10px rgba(0,0,0,0.05);
            background: var(--white);
        }

        .search-box {
            max-width: 400px;
        }

        .search-box .input-group-text {
            background: var(--white);
            border: 1.5px solid #E8E8E8;
            border-right: none;
            color: var(--primary-orange);
        }

        .search-box .form-control {
            border: 1.5px solid #E8E8E8;
            border-left: none;
            font-size: 0.95rem;
        }

        .search-box .form-control:focus {
            border-color: var(--primary-orange-soft);
            box-shadow: 0 0 0 3px rgba(255, 140, 97, 0.1);
        }

        /* Status Filter Buttons */
        .status-filter-btn {
            border-radius: 25px;
            padding: 0.4rem 1.2rem;
            margin: 0.25rem;
            border: 2px solid var(--primary-cream);
            background: var(--white);
            transition: all 0.2s;
            cursor: pointer;
            font-size: 0.9rem;
            font-weight: 500;
            color: var(--text-dark);
        }

        .status-filter-btn:hover {
            background: var(--primary-cream);
            border-color: var(--primary-orange-soft);
            color: var(--primary-orange);
        }

        .status-filter-btn.active {
            background: linear-gradient(135deg, var(--primary-orange) 0%, var(--primary-orange-soft) 100%);
            color: white;
            border-color: var(--primary-orange);
        }

        .status-filter-btn i {
            font-size: 0.85rem;
        }

        /* Orders Table Card */
        .orders-card {
            border: none;
            border-radius: 12px;
            box-shadow: 0 3px 10px rgba(0,0,0,0.05);
            background: var(--white);
        }

        .table {
            font-size: 0.95rem;
        }

        .table thead {
            background: var(--bg-light);
        }

        .table thead th {
            border: none;
            font-weight: 600;
            color: var(--dark-brown);
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
            border-color: #F5F5F5;
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

        .badge-cancelled {
            background: #FFE5E5;
            color: #E74C3C;
        }

        /* Buttons */
        .btn-print {
            background: linear-gradient(135deg, var(--primary-orange) 0%, var(--primary-orange-soft) 100%);
            color: white;
            border: none;
            border-radius: 25px;
            padding: 0.5rem 1.5rem;
            font-weight: 500;
            transition: all 0.3s ease;
        }

        .btn-print:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(255, 140, 97, 0.3);
            color: white;
        }

        .btn-view-details {
            border: 2px solid var(--primary-orange);
            color: var(--primary-orange);
            border-radius: 20px;
            padding: 0.3rem 1rem;
            font-size: 0.85rem;
            font-weight: 500;
            transition: all 0.3s ease;
            background: transparent;
        }

        .btn-view-details:hover {
            background: var(--primary-orange);
            color: white;
            transform: translateY(-2px);
        }

        .btn-back {
            background: linear-gradient(135deg, var(--primary-orange) 0%, var(--primary-orange-soft) 100%);
            color: white;
            border: none;
            border-radius: 25px;
            padding: 0.6rem 1.5rem;
            font-weight: 500;
            transition: all 0.3s ease;
        }

        .btn-back:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(255, 140, 97, 0.3);
            color: white;
        }

        /* Empty State */
        .empty-state {
            padding: 4rem 2rem;
            text-align: center;
        }

        .empty-state i {
            font-size: 5rem;
            color: var(--primary-orange-soft);
            opacity: 0.5;
        }

        .empty-state h4 {
            color: var(--dark-brown);
            margin-top: 1.5rem;
        }

        .empty-state p {
            color: var(--text-light);
            margin-top: 0.5rem;
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

            .status-filter-btn {
                padding: 0.3rem 0.8rem;
                font-size: 0.85rem;
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
                    <a class="nav-link" href="${pageContext.request.contextPath}/dashboard">
                        <i class="bi bi-speedometer2 me-1"></i>Dashboard
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link active" href="${pageContext.request.contextPath}/orders">
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
    <!-- Page Header -->
    <div class="page-header">
        <div class="d-flex justify-content-between align-items-center">
            <div>
                <h2 class="page-title">All Orders</h2>
                <p class="page-subtitle mb-0">
                    Total: <strong><c:out value="${fn:length(orders)}" default="0"/></strong> orders
                </p>
            </div>
            <div>
                <button class="btn btn-print" onclick="window.print()">
                    <i class="bi bi-printer me-2"></i>Print
                </button>
            </div>
        </div>
    </div>

    <!-- Search and Filter Section -->
    <div class="card filter-card mb-4">
        <div class="card-body">
            <div class="row g-3">
                <!-- Search Box -->
                <div class="col-md-6">
                    <div class="input-group search-box">
                        <span class="input-group-text">
                            <i class="bi bi-search"></i>
                        </span>
                        <input type="text"
                               class="form-control"
                               id="searchInput"
                               placeholder="Search by order number..."
                               onkeyup="filterOrders()">
                    </div>
                </div>

                <!-- Status Filter Buttons -->
                <div class="col-md-6">
                    <div class="d-flex flex-wrap align-items-center">
                        <small class="text-muted me-2" style="font-size: 0.9rem;">Filter by status:</small>
                        <button class="status-filter-btn active" onclick="filterByStatus('ALL', this)">
                            All
                        </button>
                        <button class="status-filter-btn" onclick="filterByStatus('PENDING', this)">
                            <i class="bi bi-clock"></i> Pending
                        </button>
                        <button class="status-filter-btn" onclick="filterByStatus('PROCESSING', this)">
                            <i class="bi bi-gear"></i> Processing
                        </button>
                        <button class="status-filter-btn" onclick="filterByStatus('SHIPPED', this)">
                            <i class="bi bi-truck"></i> Shipped
                        </button>
                        <button class="status-filter-btn" onclick="filterByStatus('DELIVERED', this)">
                            <i class="bi bi-check-circle"></i> Delivered
                        </button>
                        <button class="status-filter-btn" onclick="filterByStatus('CANCELLED', this)">
                            <i class="bi bi-x-circle"></i> Cancelled
                        </button>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Orders Section -->
    <div class="card orders-card">
        <div class="card-body p-0">
            <c:choose>
                <c:when test="${empty orders}">
                    <!-- Empty State -->
                    <div class="empty-state">
                        <i class="bi bi-music-note-list"></i>
                        <h4>No orders found</h4>
                        <p>You haven't placed any instrument orders yet.</p>
                        <a href="${pageContext.request.contextPath}/dashboard" class="btn btn-back mt-3">
                            <i class="bi bi-arrow-left me-2"></i>Back to Dashboard
                        </a>
                    </div>
                </c:when>
                <c:otherwise>
                    <!-- Orders Table -->
                    <div class="table-responsive">
                        <table class="table table-hover mb-0" id="ordersTable">
                            <thead>
                            <tr>
                                <th class="px-4">Order Number</th>
                                <th>Status</th>
                                <th>Date</th>
                                <th>Actions</th>
                            </tr>
                            </thead>
                            <tbody>
                            <c:forEach items="${orders}" var="order">
                                <tr class="order-row" data-status="${order.status}" data-order="${order.orderNumber}">
                                    <td class="px-4">
                                        <i class="bi bi-music-note-beamed me-2" style="color: var(--primary-orange);"></i>
                                        <strong><c:out value="${order.orderNumber}"/></strong>
                                    </td>
                                    <td>
                                        <c:set var="upperStatus" value="${fn:toUpperCase(order.status)}" />
                                        <c:choose>
                                            <c:when test="${upperStatus == 'PENDING' or order.status == 'Pending'}">
                                                    <span class="badge order-badge badge-pending">
                                                        <i class="bi bi-clock me-1"></i>Pending
                                                    </span>
                                            </c:when>
                                            <c:when test="${upperStatus == 'PROCESSING' or order.status == 'Processing'}">
                                                    <span class="badge order-badge badge-processing">
                                                        <i class="bi bi-gear me-1"></i>Processing
                                                    </span>
                                            </c:when>
                                            <c:when test="${upperStatus == 'SHIPPED' or order.status == 'Shipped'}">
                                                    <span class="badge order-badge badge-shipped">
                                                        <i class="bi bi-truck me-1"></i>Shipped
                                                    </span>
                                            </c:when>
                                            <c:when test="${upperStatus == 'DELIVERED' or order.status == 'Delivered'}">
                                                    <span class="badge order-badge badge-delivered">
                                                        <i class="bi bi-check-circle me-1"></i>Delivered
                                                    </span>
                                            </c:when>
                                            <c:when test="${upperStatus == 'CANCELLED' or order.status == 'Cancelled'}">
                                                    <span class="badge order-badge badge-cancelled">
                                                        <i class="bi bi-x-circle me-1"></i>Cancelled
                                                    </span>
                                            </c:when>
                                            <c:otherwise>
                                                    <span class="badge order-badge bg-secondary">
                                                        <c:out value="${order.status}"/>
                                                    </span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <i class="bi bi-calendar3 me-1" style="color: var(--text-light);"></i>
                                        <c:out value="${order.createdAt}"/>
                                    </td>
                                    <td>
                                        <a href="${pageContext.request.contextPath}/orders/view?id=${order.id}"
                                           class="btn btn-sm btn-view-details">
                                            <i class="bi bi-eye"></i> View Details
                                        </a>
                                    </td>
                                </tr>
                            </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</div>

<!-- Bootstrap JS Bundle -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

<!-- Page Scripts -->
<script>
    // Search functionality
    function filterOrders() {
        const searchValue = document.getElementById('searchInput').value.toLowerCase();
        const rows = document.getElementsByClassName('order-row');

        for (let row of rows) {
            const orderNumber = row.getAttribute('data-order').toLowerCase();
            if (orderNumber.includes(searchValue)) {
                row.style.display = '';
            } else {
                row.style.display = 'none';
            }
        }
    }

    // Status filter
    function filterByStatus(status, button) {
        // Update button states
        document.querySelectorAll('.status-filter-btn').forEach(btn => {
            btn.classList.remove('active');
        });
        button.classList.add('active');

        // Filter rows
        const rows = document.getElementsByClassName('order-row');
        let visibleCount = 0;

        for (let row of rows) {
            const rowStatus = row.getAttribute('data-status');

            // Case-insensitive comparison
            if (status === 'ALL' ||
                rowStatus.toUpperCase() === status.toUpperCase() ||
                rowStatus.toLowerCase() === status.toLowerCase() ||
                rowStatus === status) {
                row.style.display = '';
                visibleCount++;
            } else {
                row.style.display = 'none';
            }
        }

        // Show message if no results
        if (visibleCount === 0 && status !== 'ALL') {
            console.log('No orders found with status: ' + status);
        }
    }
</script>
</body>
</html>