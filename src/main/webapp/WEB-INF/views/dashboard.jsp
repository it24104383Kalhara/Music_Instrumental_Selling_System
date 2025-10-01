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
    <title>Dashboard - Order Tracking System</title>


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
        .stat-card {
            border: none;
            border-radius: 10px;
            transition: transform 0.2s, box-shadow 0.2s;
        }
        .stat-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
        }
        .stat-icon {
            width: 48px;
            height: 48px;
            display: flex;
            align-items: center;
            justify-content: center;
            border-radius: 10px;
            font-size: 24px;
        }
        .order-badge {
            font-size: 0.875rem;
            padding: 0.35rem 0.65rem;
        }
        .table-hover tbody tr:hover {
            background-color: rgba(102, 126, 234, 0.05);
            cursor: pointer;
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
</head> <body>
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
    <!-- Welcome Section -->
    <div class="row mb-4">
        <div class="col-12">
            <h2 class="mb-0">Welcome back, ${sessionScope.user.name != null ? sessionScope.user.name : 'User'}!</h2>
            <p class="text-muted">Here's what's happening with your orders today.</p>
        </div>
    </div>

    <!-- Statistics Cards -->
    <div class="row g-3 mb-4">
        <!-- Total Orders Card -->
        <div class="col-xl-3 col-md-6">
            <div class="card stat-card">
                <div class="card-body">
                    <div class="d-flex justify-content-between align-items-center">
                        <div>
                            <p class="text-muted mb-1">Total Orders</p>
                            <h3 class="mb-0">
                                ${fn:length(orders)}
                            </h3>
                        </div>
                        <div class="stat-icon bg-primary bg-opacity-10 text-primary">
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
                            <p class="text-muted mb-1">Pending</p>
                            <h3 class="mb-0">
                                <c:set var="pendingCount" value="0" />
                                <c:forEach var="order" items="${orders}">
                                    <c:if test="${fn:containsIgnoreCase(order.status, 'pending')}">
                                        <c:set var="pendingCount" value="${pendingCount + 1}" />
                                    </c:if>
                                </c:forEach>
                                ${pendingCount}
                            </h3>
                        </div>
                        <div class="stat-icon bg-warning bg-opacity-10 text-warning">
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
                            <p class="text-muted mb-1">In Progress</p>
                            <h3 class="mb-0">
                                <c:set var="processingCount" value="0" />
                                <c:forEach var="order" items="${orders}">
                                    <c:if test="${fn:containsIgnoreCase(order.status, 'processing') or fn:containsIgnoreCase(order.status, 'shipped')}">
                                        <c:set var="processingCount" value="${processingCount + 1}" />
                                    </c:if>
                                </c:forEach>
                                ${processingCount}
                            </h3>
                        </div>
                        <div class="stat-icon bg-info bg-opacity-10 text-info">
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
                            <p class="text-muted mb-1">Delivered</p>
                            <h3 class="mb-0">
                                <c:set var="deliveredCount" value="0" />
                                <c:forEach var="order" items="${orders}">
                                    <c:if test="${fn:containsIgnoreCase(order.status, 'delivered')}">
                                        <c:set var="deliveredCount" value="${deliveredCount + 1}" />
                                    </c:if>
                                </c:forEach>
                                ${deliveredCount}
                            </h3>
                        </div>
                        <div class="stat-icon bg-success bg-opacity-10 text-success">
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
            <div class="card border-0 shadow-sm">
                <div class="card-header bg-white py-3">
                    <div class="d-flex justify-content-between align-items-center">
                        <h5 class="mb-0">
                            <i class="bi bi-clock-history me-2"></i>Recent Orders
                        </h5>
                        <a href="${pageContext.request.contextPath}/orders" class="btn btn-sm btn-primary">
                            View All Orders <i class="bi bi-arrow-right"></i>
                        </a>
                    </div>
                </div>
                <div class="card-body p-0">

                    <c:choose>
                        <c:when test="${empty orders}">
                            <!-- Empty State -->
                            <div class="text-center py-5">
                                <i class="bi bi-inbox text-muted" style="font-size: 3rem;"></i>
                                <p class="mt-3 text-muted">No orders yet.</p>
                                <p class="text-muted">Your orders will appear here once you make a purchase.</p>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <!-- Orders Table -->
                            <div class="table-responsive">
                                <table class="table table-hover mb-0">
                                    <thead class="bg-light">
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
                                                    <i class="bi bi-box-seam me-2 text-primary"></i>
                                                    <strong>${o.orderNumber}</strong>
                                                </td>
                                                <td>
                                                    <!-- Simplified status display for debugging -->
                                                    <span class="badge order-badge bg-secondary">${o.status}</span>
                                                </td>
                                                <td>
                                                    <i class="bi bi-calendar3 me-1 text-muted"></i>
                                                        ${o.createdAt}
                                                </td>
                                                <td>
                                                    <a href="${pageContext.request.contextPath}/orders/view?id=${o.id}"
                                                       class="btn btn-sm btn-outline-primary"
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
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js">
</script>
</body>
</html>