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
    <title>All Orders - Order Tracking System</title>

    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Bootstrap Icons -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">

    <style>
        body {
            background-color: #f8f9fa;
        }
        .navbar {
            box-shadow: 0 2px 4px rgba(0,0,0,.08);
        }
        .filter-card {
            border: none;
            border-radius: 10px;
            box-shadow: 0 2px 4px rgba(0,0,0,.05);
        }
        .order-badge {
            font-size: 0.875rem;
            padding: 0.35rem 0.65rem;
        }
        .table-hover tbody tr:hover {
            background-color: rgba(102, 126, 234, 0.05);
        }
        .search-box {
            max-width: 400px;
        }
        .status-filter-btn {
            border-radius: 20px;
            padding: 0.375rem 1rem;
            margin: 0.25rem;
            border: 1px solid #dee2e6;
            background: white;
            transition: all 0.2s;
            cursor: pointer;
        }
        .status-filter-btn:hover {
            background: #f8f9fa;
        }
        .status-filter-btn.active {
            background: #0d6efd;
            color: white;
            border-color: #0d6efd;
        }
        /* Gradient Navbar Theme */
        .navbar-gradient {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            box-shadow: 0 2px 4px rgba(0,0,0,.1);
            padding: 0.75rem 0;
        }

        .navbar-gradient .navbar-brand {
            font-weight: 600;
            font-size: 1.3rem;
            color: white !important;
            transition: transform 0.3s ease;
        }

        .navbar-gradient .navbar-brand:hover {
            transform: translateX(5px);
        }

        .navbar-gradient .nav-link {
            color: rgba(255, 255, 255, 0.9) !important;
            font-weight: 500;
            transition: all 0.3s ease;
            border-radius: 5px;
            padding: 0.5rem 1rem !important;
            margin: 0 0.2rem;
        }

        .navbar-gradient .nav-link:hover {
            color: white !important;
            background: rgba(255, 255, 255, 0.1);
            transform: translateY(-2px);
        }

        .navbar-gradient .nav-link.active {
            color: white !important;
            background: rgba(255, 255, 255, 0.15);
        }

        /* Dropdown styling */
        .navbar-gradient .dropdown-menu {
            border: none;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.15);
            border-radius: 10px;
            margin-top: 0.5rem;
        }

        .navbar-gradient .dropdown-item {
            padding: 0.7rem 1.2rem;
            transition: all 0.3s ease;
        }

        .navbar-gradient .dropdown-item:hover {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding-left: 1.5rem;
        }

        .navbar-gradient .dropdown-item i {
            width: 20px;
        }

        /* Mobile responsive */
        @media (max-width: 768px) {
            .navbar-gradient .navbar-collapse {
                background: rgba(0, 0, 0, 0.1);
                padding: 1rem;
                border-radius: 10px;
                margin-top: 1rem;
            }
        }
    </style>
</head>
<body>
<!-- Navigation Bar -->
<nav class="navbar navbar-expand-lg navbar-dark navbar-gradient">
    <div class="container-fluid">
        <a class="navbar-brand" href="${pageContext.request.contextPath}/index.jsp">
            <i class="bi bi-box-seam me-2"></i>Order Tracking
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
                        <i class="bi bi-person-circle me-1"></i> ${sessionScope.user.email}
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
    <div class="row mb-4">
        <div class="col-12">
            <div class="d-flex justify-content-between align-items-center">
                <div>
                    <h2 class="mb-0">All Orders</h2>
                    <p class="text-muted mb-0">
                        Total: <strong><c:out value="${fn:length(orders)}" default="0"/></strong> orders
                    </p>
                </div>
                <div>
                    <button class="btn btn-primary" onclick="window.print()">
                        <i class="bi bi-printer me-2"></i>Print
                    </button>
                </div>
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
                            <span class="input-group-text bg-white">
                                <i class="bi bi-search"></i>
                            </span>
                        <input type="text"
                               class="form-control border-start-0"
                               id="searchInput"
                               placeholder="Search by order number..."
                               onkeyup="filterOrders()">
                    </div>
                </div>

                <!-- Status Filter Buttons -->
                <div class="col-md-6">
                    <div class="d-flex flex-wrap align-items-center">
                        <small class="text-muted me-2">Filter by status:</small>
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
    <div class="card border-0 shadow-sm">
        <div class="card-body p-0">
            <c:choose>
                <c:when test="${empty orders}">
                    <!-- Empty State -->
                    <div class="text-center py-5">
                        <i class="bi bi-inbox text-muted" style="font-size: 4rem;"></i>
                        <h4 class="mt-3 text-muted">No orders found</h4>
                        <p class="text-muted">You haven't placed any orders yet.</p>
                        <a href="${pageContext.request.contextPath}/dashboard" class="btn btn-primary mt-3">
                            <i class="bi bi-arrow-left me-2"></i>Back to Dashboard
                        </a>
                    </div>
                </c:when>
                <c:otherwise>
                    <!-- Orders Table -->
                    <div class="table-responsive">
                        <table class="table table-hover mb-0" id="ordersTable">
                            <thead class="bg-light">
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
                                        <i class="bi bi-box-seam me-2 text-primary"></i>
                                        <strong><c:out value="${order.orderNumber}"/></strong>
                                    </td>
                                    <td>
                                        <c:set var="upperStatus" value="${fn:toUpperCase(order.status)}" />
                                        <c:choose>
                                            <c:when test="${upperStatus == 'PENDING'}">
            <span class="badge order-badge bg-warning text-dark">
                <i class="bi bi-clock me-1"></i>Pending
            </span>
                                            </c:when>
                                            <c:when test="${upperStatus == 'PROCESSING'}">
            <span class="badge order-badge bg-info">
                <i class="bi bi-gear me-1"></i>Processing
            </span>
                                            </c:when>
                                            <c:when test="${upperStatus == 'SHIPPED'}">
            <span class="badge order-badge bg-primary">
                <i class="bi bi-truck me-1"></i>Shipped
            </span>
                                            </c:when>
                                            <c:when test="${upperStatus == 'DELIVERED'}">
            <span class="badge order-badge bg-success">
                <i class="bi bi-check-circle me-1"></i>Delivered
            </span>
                                            </c:when>
                                            <c:when test="${upperStatus == 'CANCELLED'}">
            <span class="badge order-badge bg-danger">
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
                                        <i class="bi bi-calendar3 me-1 text-muted"></i>
                                        <c:out value="${order.createdAt}"/>
                                    </td>
                                    <td>
                                        <a href="${pageContext.request.contextPath}/orders/view?id=${order.id}"
                                           class="btn btn-sm btn-outline-primary">
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

    // Status filter - FIXED FOR CASE SENSITIVITY
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

    // Debug: Log all status values on page load
    window.addEventListener('load', function() {
        const rows = document.getElementsByClassName('order-row');
        const statuses = new Set();
        for (let row of rows) {
            statuses.add(row.getAttribute('data-status'));
        }
        console.log('Unique status values in your data:', Array.from(statuses));
    });
</script>
</body>
</html>