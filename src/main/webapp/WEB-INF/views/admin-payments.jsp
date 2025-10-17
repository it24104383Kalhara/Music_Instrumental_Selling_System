<%--
  Created by IntelliJ IDEA.
  User: vinod
  Date: 10/17/2025
  Time: 7:18 PM
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
    <title>Payment Verification - Admin Dashboard</title>

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

        .icon-pending {
            background: #FFF5E6;
            color: #F4A261;
        }

        .icon-completed {
            background: #E8F5E9;
            color: #4CAF50;
        }

        .icon-failed {
            background: #FFEBEE;
            color: #F44336;
        }

        .icon-revenue {
            background: var(--primary-cream);
            color: var(--primary-orange);
        }

        /* Payments Card */
        .payments-card {
            border: none;
            border-radius: 12px;
            box-shadow: 0 3px 10px rgba(0,0,0,0.05);
            background: var(--white);
        }

        .payments-card .card-header {
            background: var(--white);
            border-bottom: 1px solid #F0F0F0;
            padding: 1.25rem;
        }

        .payments-card h5 {
            color: var(--dark-brown);
            font-weight: 600;
            font-size: 1.1rem;
        }

        /* Filter Buttons */
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
            text-decoration: none;
            display: inline-block;
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

        /* Status Badges */
        .payment-badge {
            font-size: 0.85rem;
            padding: 0.4rem 0.8rem;
            border-radius: 20px;
            font-weight: 500;
        }

        .badge-pending {
            background: #FFF5E6;
            color: #F4A261;
        }

        .badge-completed {
            background: #E8F5E9;
            color: #4CAF50;
        }

        .badge-failed {
            background: #FFEBEE;
            color: #F44336;
        }

        /* Action Buttons */
        .btn-verify {
            background: #E8F5E9;
            border: none;
            color: #4CAF50;
            padding: 0.4rem 1rem;
            border-radius: 20px;
            font-weight: 500;
            transition: all 0.3s ease;
            font-size: 0.85rem;
        }

        .btn-verify:hover {
            background: #4CAF50;
            color: white;
            transform: translateY(-2px);
        }

        .btn-reject {
            background: #FFEBEE;
            border: none;
            color: #F44336;
            padding: 0.4rem 1rem;
            border-radius: 20px;
            font-weight: 500;
            transition: all 0.3s ease;
            font-size: 0.85rem;
            margin-left: 0.5rem;
        }

        .btn-reject:hover {
            background: #F44336;
            color: white;
            transform: translateY(-2px);
        }

        /* Toast */
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
                    <a class="nav-link active" href="${pageContext.request.contextPath}/admin/payments">
                        <i class="bi bi-credit-card me-1"></i>Payments
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
        <h2><i class="bi bi-credit-card-2-front me-2"></i>Payment Verification</h2>
        <p>Review and verify customer payments</p>
    </div>

    <!-- Statistics Cards -->
    <div class="row g-3 mb-4">
        <div class="col-xl-3 col-md-6">
            <div class="card stat-card">
                <div class="card-body">
                    <div class="d-flex justify-content-between align-items-center">
                        <div>
                            <p class="stat-label">Pending Verification</p>
                            <h3 class="stat-value">${pendingCount}</h3>
                        </div>
                        <div class="stat-icon icon-pending">
                            <i class="bi bi-clock-history"></i>
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
                            <p class="stat-label">Verified</p>
                            <h3 class="stat-value">${completedCount}</h3>
                        </div>
                        <div class="stat-icon icon-completed">
                            <i class="bi bi-check-circle"></i>
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
                            <p class="stat-label">Failed/Rejected</p>
                            <h3 class="stat-value">${failedCount}</h3>
                        </div>
                        <div class="stat-icon icon-failed">
                            <i class="bi bi-x-circle"></i>
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
                            <p class="stat-label">Total Revenue</p>
                            <h3 class="stat-value">$<fmt:formatNumber value="${totalRevenue}" pattern="#,##0"/></h3>
                        </div>
                        <div class="stat-icon icon-revenue">
                            <i class="bi bi-currency-dollar"></i>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Payments Table -->
    <div class="row">
        <div class="col-12">
            <div class="card payments-card">
                <div class="card-header">
                    <div class="d-flex justify-content-between align-items-center">
                        <h5 class="mb-0">
                            <i class="bi bi-list-check me-2" style="color: var(--primary-orange);"></i>
                            All Payments
                        </h5>
                        <div>
                            <a href="${pageContext.request.contextPath}/admin/payments"
                               class="filter-btn ${empty currentFilter ? 'active' : ''}">
                                All
                            </a>
                            <a href="${pageContext.request.contextPath}/admin/payments?filter=pending"
                               class="filter-btn ${currentFilter == 'pending' ? 'active' : ''}">
                                <i class="bi bi-clock me-1"></i>Pending Only
                            </a>
                        </div>
                    </div>
                </div>
                <div class="card-body p-0">
                    <c:choose>
                        <c:when test="${empty payments}">
                            <div class="text-center py-5">
                                <i class="bi bi-inbox" style="font-size: 4rem; color: var(--primary-orange-soft); opacity: 0.5;"></i>
                                <p class="mt-3 text-muted">No payments found.</p>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="table-responsive">
                                <table class="table table-hover mb-0">
                                    <thead>
                                    <tr>
                                        <th class="px-4">Order Number</th>
                                        <th>Customer</th>
                                        <th>Amount</th>
                                        <th>Payment Method</th>
                                        <th>Transaction ID</th>
                                        <th>Status</th>
                                        <th>Payment Date</th>
                                        <th>Actions</th>
                                    </tr>
                                    </thead>
                                    <tbody>
                                    <c:forEach var="payment" items="${payments}">
                                        <tr data-payment-id="${payment.id}">
                                            <td class="px-4">
                                                <i class="bi bi-receipt me-2" style="color: var(--primary-orange);"></i>
                                                <strong>${payment.orderNumber}</strong>
                                            </td>
                                            <td>
                                                <div>
                                                    <strong>${payment.customerName}</strong>
                                                </div>
                                            </td>
                                            <td>
                                                <strong style="color: var(--primary-orange);">
                                                    $<fmt:formatNumber value="${payment.amount}" pattern="#,##0.00"/>
                                                </strong>
                                            </td>
                                            <td>${payment.paymentMethod}</td>
                                            <td>
                                                <small class="text-muted">${payment.transactionId}</small>
                                            </td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${payment.paymentStatus == 'Pending'}">
                                                            <span class="badge payment-badge badge-pending">
                                                                <i class="bi bi-clock me-1"></i>Pending
                                                            </span>
                                                    </c:when>
                                                    <c:when test="${payment.paymentStatus == 'Completed'}">
                                                            <span class="badge payment-badge badge-completed">
                                                                <i class="bi bi-check-circle me-1"></i>Verified
                                                            </span>
                                                    </c:when>
                                                    <c:otherwise>
                                                            <span class="badge payment-badge badge-failed">
                                                                <i class="bi bi-x-circle me-1"></i>Failed
                                                            </span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td>
                                                <i class="bi bi-calendar3 me-1" style="color: var(--text-light);"></i>
                                                <fmt:parseDate value="${payment.paymentDate}" pattern="yyyy-MM-dd'T'HH:mm" var="parsedDate" type="both" />
                                                <fmt:formatDate value="${parsedDate}" pattern="MMM dd, yyyy HH:mm"/>
                                            </td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${payment.paymentStatus == 'Pending'}">
                                                        <button class="btn btn-verify btn-sm"
                                                                onclick="verifyPayment(${payment.id}, 'verify', '${payment.orderNumber}')">
                                                            <i class="bi bi-check me-1"></i>Verify
                                                        </button>
                                                        <button class="btn btn-reject btn-sm"
                                                                onclick="verifyPayment(${payment.id}, 'reject', '${payment.orderNumber}')">
                                                            <i class="bi bi-x"></i>Reject
                                                        </button>
                                                    </c:when>
                                                    <c:otherwise>
                                                            <span class="text-muted">
                                                                <i class="bi bi-check-all"></i> Processed
                                                            </span>
                                                    </c:otherwise>
                                                </c:choose>
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
</div>

<!-- Toast Container -->
<div class="toast-container">
    <div id="paymentToast" class="toast" role="alert">
        <div class="toast-header">
            <i class="bi bi-check-circle-fill me-2 text-success" id="toastIcon"></i>
            <strong class="me-auto" id="toastTitle">Success</strong>
            <button type="button" class="btn-close" data-bs-dismiss="toast"></button>
        </div>
        <div class="toast-body" id="toastMessage">
            Payment verified successfully!
        </div>
    </div>
</div>

<!-- Bootstrap JS Bundle -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

<script>
    // Verify or reject payment
    function verifyPayment(paymentId, action, orderNumber) {
        const actionText = action === 'verify' ? 'verify' : 'reject';
        const confirmMsg = `Are you sure you want to ${actionText} payment for order ${orderNumber}?`;

        if (!confirm(confirmMsg)) {
            return;
        }

        fetch('${pageContext.request.contextPath}/admin/verifyPayment', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded',
            },
            body: 'paymentId=' + paymentId + '&action=' + action
        })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    showToast('Success', data.message, 'success');

                    // Reload page after 1.5 seconds
                    setTimeout(() => {
                        location.reload();
                    }, 1500);
                } else {
                    showToast('Error', data.message, 'error');
                }
            })
            .catch(error => {
                showToast('Error', 'Failed to process payment. Please try again.', 'error');
                console.error('Error:', error);
            });
    }

    // Show toast notification
    function showToast(title, message, type) {
        const toastEl = document.getElementById('paymentToast');
        const toastIcon = document.getElementById('toastIcon');
        const toastTitle = document.getElementById('toastTitle');
        const toastMessage = document.getElementById('toastMessage');

        toastTitle.textContent = title;
        toastMessage.textContent = message;

        if (type === 'success') {
            toastIcon.className = 'bi bi-check-circle-fill me-2 text-success';
            toastEl.classList.remove('toast-error');
            toastEl.classList.add('toast-success');
        } else {
            toastIcon.className = 'bi bi-x-circle-fill me-2 text-danger';
            toastEl.classList.remove('toast-success');
            toastEl.classList.add('toast-error');
        }

        const toast = new bootstrap.Toast(toastEl);
        toast.show();
    }
</script>
</body>
</html>