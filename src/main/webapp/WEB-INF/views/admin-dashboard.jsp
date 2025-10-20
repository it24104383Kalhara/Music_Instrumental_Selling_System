<%--
  Created by IntelliJ IDEA.
  User: vinod
  Date: 10/15/2025
  Time: 4:43 PM
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
    <title>Admin Dashboard - Musical Instruments Store</title>

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
            margin-top: 0.5rem;
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

        /* Admin Badge */
        .admin-badge {
            background: linear-gradient(135deg, var(--accent-gold) 0%, var(--accent-gold-soft) 100%);
            color: var(--dark-brown);
            padding: 0.3rem 0.8rem;
            border-radius: 20px;
            font-size: 0.75rem;
            font-weight: 600;
            margin-left: 0.5rem;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        /* Welcome Section */
        .welcome-section {
            background: linear-gradient(135deg, var(--primary-orange) 0%, var(--primary-orange-soft) 100%);
            border-radius: 15px;
            padding: 2rem;
            margin-bottom: 2rem;
            color: white;
        }

        .welcome-title {
            font-weight: 600;
            margin-bottom: 0.5rem;
        }

        .welcome-subtitle {
            opacity: 0.9;
            font-size: 0.95rem;
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

        .icon-processing {
            background: #E6F3FF;
            color: #4A90E2;
        }

        .icon-shipped {
            background: #FFF5E6;
            color: #F4A261;
        }

        .icon-delivered {
            background: #E8F5E9;
            color: #4CAF50;
        }

        .icon-cancelled {
            background: #FFEBEE;
            color: #F44336;
        }

        /* Orders Card */
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

        /* Table */
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
        }

        .table tbody td {
            padding: 1rem;
            vertical-align: middle;
            color: var(--text-dark);
        }

        /* Status Dropdown */
        .status-select {
            border: 2px solid #F0F0F0;
            border-radius: 8px;
            padding: 0.4rem 0.8rem;
            font-size: 0.85rem;
            font-weight: 500;
            cursor: pointer;
            transition: all 0.3s ease;
        }

        .status-select:focus {
            border-color: var(--primary-orange-soft);
            outline: none;
            box-shadow: 0 0 0 0.2rem rgba(255, 140, 97, 0.15);
        }

        .status-select.processing {
            background: #E6F3FF;
            color: #4A90E2;
        }

        .status-select.shipped {
            background: #FFF5E6;
            color: #F4A261;
        }

        .status-select.delivered {
            background: #E8F5E9;
            color: #4CAF50;
        }

        .status-select.cancelled {
            background: #FFEBEE;
            color: #F44336;
        }

        /* Reports Section */
        .reports-section {
            background: var(--white);
            border-radius: 12px;
            padding: 2rem;
            box-shadow: 0 3px 10px rgba(0,0,0,0.05);
            margin-top: 2rem;
        }

        .reports-section h5 {
            color: var(--dark-brown);
            font-weight: 600;
            margin-bottom: 1rem;
        }

        .report-btn {
            background: linear-gradient(135deg, var(--primary-orange) 0%, var(--primary-orange-soft) 100%);
            color: white;
            border: none;
            border-radius: 10px;
            padding: 0.7rem 1.5rem;
            font-weight: 600;
            transition: all 0.3s ease;
            margin-right: 1rem;
            margin-bottom: 0.5rem;
        }

        .report-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(255, 140, 97, 0.3);
            color: white;
        }

        .report-btn i {
            margin-right: 0.5rem;
        }

        /* Toast Notification */
        .toast-container {
            position: fixed;
            top: 20px;
            right: 20px;
            z-index: 9999;
        }

        .toast {
            border-radius: 10px;
            box-shadow: 0 5px 15px rgba(0,0,0,0.2);
        }

        .toast-success {
            border-left: 4px solid #4CAF50;
        }

        .toast-error {
            border-left: 4px solid #F44336;
        }
    </style>
</head>
<body>
<!-- Navigation Bar -->
<nav class="navbar navbar-expand-lg">
    <div class="container-fluid">
        <a class="navbar-brand" href="${pageContext.request.contextPath}/index.jsp">
            🎵 Musical Store <span class="admin-badge">Admin</span>
        </a>
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
            <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse" id="navbarNav">
            <ul class="navbar-nav me-auto">
                <li class="nav-item">
                    <a class="nav-link active" href="${pageContext.request.contextPath}/admin/dashboard">
                        <i class="bi bi-speedometer2 me-1"></i>Dashboard
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="#ordersSection">
                        <i class="bi bi-list-ul me-1"></i>Manage Orders
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="#reportsSection">
                        <i class="bi bi-file-earmark-bar-graph me-1"></i>Reports
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="${pageContext.request.contextPath}/admin/payments">
                        <i class="bi bi-credit-card me-1"></i>Payments
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="${pageContext.request.contextPath}/admin/reviews">
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
    <!-- Welcome Section -->
    <div class="welcome-section">
        <h2 class="welcome-title">
            <i class="bi bi-shield-check me-2"></i>Admin Dashboard
        </h2>
        <p class="welcome-subtitle">
            Manage customer orders and track business performance
        </p>
    </div>

    <!-- Statistics Cards -->
    <div class="row g-3 mb-4">
        <div class="col-xl-3 col-md-6">
            <div class="card stat-card">
                <div class="card-body">
                    <div class="d-flex justify-content-between align-items-center">
                        <div>
                            <p class="stat-label">Total Orders</p>
                            <h3 class="stat-value">${totalOrders}</h3>
                        </div>
                        <div class="stat-icon icon-total">
                            <i class="bi bi-cart3"></i>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <div class="col-xl-3 col-md-6">
            <div class="card stat-card">
                <div class="card-body">
                    <div class="d-flex justify-content-between align-items-center">
                        <div>
                            <p class="stat-label">Processing</p>
                            <h3 class="stat-value">${processingCount}</h3>
                        </div>
                        <div class="stat-icon icon-processing">
                            <i class="bi bi-gear"></i>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <div class="col-xl-3 col-md-6">
            <div class="card stat-card">
                <div class="card-body">
                    <div class="d-flex justify-content-between align-items-center">
                        <div>
                            <p class="stat-label">Shipped</p>
                            <h3 class="stat-value">${shippedCount}</h3>
                        </div>
                        <div class="stat-icon icon-shipped">
                            <i class="bi bi-truck"></i>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <div class="col-xl-3 col-md-6">
            <div class="card stat-card">
                <div class="card-body">
                    <div class="d-flex justify-content-between align-items-center">
                        <div>
                            <p class="stat-label">Delivered</p>
                            <h3 class="stat-value">${deliveredCount}</h3>
                        </div>
                        <div class="stat-icon icon-delivered">
                            <i class="bi bi-check-circle"></i>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Add this after the Delivered Orders stat card -->
    <div class="col-xl-3 col-md-6">
        <div class="card stat-card">
            <div class="card-body">
                <div class="d-flex justify-content-between align-items-center">
                    <div>
                        <p class="stat-label">Pending Payments</p>
                        <h3 class="stat-value">
                            ${not empty pendingPaymentsCount ? pendingPaymentsCount : 0}
                        </h3>
                    </div>
                    <div class="stat-icon" style="background: #FFF5E6; color: #F4A261;">
                        <i class="bi bi-credit-card"></i>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Orders Management Section -->
    <div class="row" id="ordersSection">
        <div class="col-12">
            <div class="card orders-card">
                <div class="card-header">
                    <h5 class="mb-0">
                        <i class="bi bi-list-check me-2" style="color: var(--primary-orange);"></i>
                        All Customer Orders
                    </h5>
                </div>
                <div class="card-body p-0">
                    <c:choose>
                        <c:when test="${empty orders}">
                            <div class="text-center py-5">
                                <i class="bi bi-inbox" style="font-size: 4rem; color: var(--primary-orange-soft); opacity: 0.5;"></i>
                                <p class="mt-3 text-muted">No orders found.</p>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="table-responsive">
                                <table class="table table-hover mb-0">
                                    <thead>
                                    <tr>
                                        <th class="px-4">Order Number</th>
                                        <th>Customer</th>
                                        <th>Total Amount</th>
                                        <th>Status</th>
                                        <th>Created Date</th>
                                    </tr>
                                    </thead>
                                    <tbody>
                                    <c:forEach var="order" items="${orders}">
                                        <tr>
                                            <td class="px-4">
                                                <i class="bi bi-music-note-beamed me-2" style="color: var(--primary-orange);"></i>
                                                <strong>${order.orderNumber}</strong>
                                            </td>
                                            <td>
                                                <div>
                                                    <strong>${order.customerName}</strong><br>
                                                    <small class="text-muted">${order.customerEmail}</small>
                                                </div>
                                            </td>
                                            <td>
                                                <strong>$<fmt:formatNumber value="${order.totalAmount}" pattern="#,##0.00"/></strong>
                                            </td>
                                            <td>
                                                <select class="status-select ${fn:toLowerCase(order.status)}"
                                                        data-order-id="${order.id}"
                                                        data-original-value="${order.status}"
                                                        onchange="updateOrderStatus(this)">
                                                    <option value="Processing" ${order.status == 'Processing' ? 'selected' : ''}>Processing</option>
                                                    <option value="Shipped" ${order.status == 'Shipped' ? 'selected' : ''}>Shipped</option>
                                                    <option value="Delivered" ${order.status == 'Delivered' ? 'selected' : ''}>Delivered</option>
                                                    <option value="Cancelled" ${order.status == 'Cancelled' ? 'selected' : ''}>Cancelled</option>
                                                </select>
                                            </td>
                                            <td>
                                                <i class="bi bi-calendar3 me-1" style="color: var(--text-light);"></i>
                                                <fmt:parseDate value="${order.createdAt}" pattern="yyyy-MM-dd'T'HH:mm" var="parsedDate" type="both" />
                                                <fmt:formatDate value="${parsedDate}" pattern="MMM dd, yyyy"/>
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
    </div>

    <!-- Reports Section -->
    <div class="reports-section" id="reportsSection">
        <h5>
            <i class="bi bi-file-earmark-bar-graph me-2" style="color: var(--primary-orange);"></i>
            Generate Reports
        </h5>
        <p class="text-muted mb-3">Export and analyze business data </p>

        <a href="${pageContext.request.contextPath}/admin/reports/sales" class="btn report-btn">
            <i class="bi bi-graph-up"></i>Sales Report
        </a>
        <a href="${pageContext.request.contextPath}/admin/reports/orders" class="btn report-btn">
            <i class="bi bi-file-text"></i>Order Report
        </a>
        <a href="${pageContext.request.contextPath}/admin/reports/customers" class="btn report-btn">
            <i class="bi bi-people"></i>Customer Report
        </a>
        <a href="${pageContext.request.contextPath}/admin/reports/inventory" class="btn report-btn">
            <i class="bi bi-box-seam"></i>Inventory Report
        </a>
    </div>
</div>

<!-- Toast Container -->
<div class="toast-container">
    <div id="statusToast" class="toast" role="alert">
        <div class="toast-header">
            <i class="bi bi-check-circle-fill me-2 text-success" id="toastIcon"></i>
            <strong class="me-auto" id="toastTitle">Success</strong>
            <button type="button" class="btn-close" data-bs-dismiss="toast"></button>
        </div>
        <div class="toast-body" id="toastMessage">
            Order status updated successfully!
        </div>
    </div>
</div>

<!-- Bootstrap JS Bundle -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

<script>
    // Update Order Status Function
    function updateOrderStatus(selectElement) {
        const orderId = selectElement.getAttribute('data-order-id');
        const newStatus = selectElement.value;
        const originalValue = selectElement.getAttribute('data-original-value');

        // Update select background color based on status
        selectElement.className = 'status-select ' + newStatus.toLowerCase();

        // Confirm the change
        if (!confirm(`Are you sure you want to change the status to "${newStatus}"?`)) {
            selectElement.value = originalValue;
            selectElement.className = 'status-select ' + originalValue.toLowerCase();
            return;
        }

        // Make AJAX request to update status
        fetch('${pageContext.request.contextPath}/admin/updateOrderStatus', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded',
            },
            body: 'orderId=' + orderId + '&status=' + encodeURIComponent(newStatus)
        })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    // Update the original value
                    selectElement.setAttribute('data-original-value', newStatus);

                    // Show success toast
                    showToast('Success', data.message, 'success');

                    // Reload page after 1.5 seconds to update statistics
                    setTimeout(() => {
                        location.reload();
                    }, 1500);
                } else {
                    // Revert to original value
                    selectElement.value = originalValue;
                    selectElement.className = 'status-select ' + originalValue.toLowerCase();

                    // Show error toast
                    showToast('Error', data.message, 'error');
                }
            })
            .catch(error => {
                // Revert to original value
                selectElement.value = originalValue;
                selectElement.className = 'status-select ' + originalValue.toLowerCase();

                // Show error toast
                showToast('Error', 'Failed to update order status. Please try again.', 'error');
                console.error('Error:', error);
            });
    }

    // Show Toast Notification
    function showToast(title, message, type) {
        const toastEl = document.getElementById('statusToast');
        const toastIcon = document.getElementById('toastIcon');
        const toastTitle = document.getElementById('toastTitle');
        const toastMessage = document.getElementById('toastMessage');

        // Update toast content
        toastTitle.textContent = title;
        toastMessage.textContent = message;

        // Update icon and class
        if (type === 'success') {
            toastIcon.className = 'bi bi-check-circle-fill me-2 text-success';
            toastEl.classList.remove('toast-error');
            toastEl.classList.add('toast-success');
        } else {
            toastIcon.className = 'bi bi-x-circle-fill me-2 text-danger';
            toastEl.classList.remove('toast-success');
            toastEl.classList.add('toast-error');
        }

        // Show toast
        const toast = new bootstrap.Toast(toastEl);
        toast.show();
    }

    // View Order Details
    function viewOrderDetails(orderId) {
        alert('Order details view will be implemented. Order ID: ' + orderId);
        // Future: window.location.href = '${pageContext.request.contextPath}/admin/orders/view?id=' + orderId;
    }

    // Smooth scroll
    document.querySelectorAll('a[href^="#"]').forEach(anchor => {
        anchor.addEventListener('click', function (e) {
            e.preventDefault();
            const target = document.querySelector(this.getAttribute('href'));
            if (target) {
                target.scrollIntoView({ behavior: 'smooth', block: 'start' });
            }
        });
    });
</script>
</body>
</html>