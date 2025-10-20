<%--
  Created by IntelliJ IDEA.
  User: vinod
  Date: 8/31/2025
  Time: 10:08 AM
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
    <title>Order ${order.orderNumber} - Musical Instruments Store</title>

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

        /* Navbar Styling - Match Dashboard */
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
            text-align: center;
        }

        .page-header h2 {
            color: var(--dark-brown);
            font-weight: 600;
            margin-bottom: 0.5rem;
        }

        .page-header .order-number {
            color: var(--primary-orange);
            font-weight: 700;
        }

        .page-header p {
            color: var(--text-light);
            margin-bottom: 0;
        }

        /* Card Styling */
        .info-card {
            border: none;
            border-radius: 12px;
            box-shadow: 0 3px 10px rgba(0,0,0,0.05);
            background: var(--white);
            margin-bottom: 1.5rem;
        }

        .info-card .card-header {
            background: var(--white);
            border-bottom: 1px solid #F0F0F0;
            padding: 1.25rem;
            border-radius: 12px 12px 0 0;
        }

        .info-card h5 {
            color: var(--dark-brown);
            font-weight: 600;
            font-size: 1.1rem;
            margin-bottom: 0;
        }

        .info-card h5 i {
            color: var(--primary-orange);
        }

        /* Progress Tracker Styles */
        .progress-tracker {
            margin: 40px 0;
            list-style: none;
            display: flex;
            justify-content: space-between;
            position: relative;
            padding: 0;
        }

        .progress-tracker::before {
            content: '';
            position: absolute;
            top: 25px;
            left: 60px;
            right: 60px;
            height: 6px;
            background: var(--primary-cream);
            border-radius: 10px;
            z-index: 1;
        }

        .progress-line {
            position: absolute;
            top: 25px;
            left: 60px;
            height: 6px;
            border-radius: 10px;
            z-index: 2;
            transition: width 0.8s cubic-bezier(0.4, 0, 0.2, 1);
            width: 0;
            background: linear-gradient(90deg, var(--primary-orange) 0%, var(--primary-orange-soft) 100%);
        }

        .progress-step {
            text-align: center;
            position: relative;
            z-index: 3;
            flex: 1;
        }

        .step-icon {
            width: 50px;
            height: 50px;
            background: var(--white);
            border: 3px solid var(--primary-cream);
            border-radius: 50%;
            margin: 0 auto 12px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 20px;
            font-weight: 600;
            color: var(--text-light);
            transition: all 0.4s ease;
            box-shadow: 0 2px 8px rgba(0,0,0,0.08);
        }

        .progress-step.completed .step-icon {
            background: linear-gradient(135deg, var(--primary-orange) 0%, var(--primary-orange-soft) 100%);
            border-color: var(--primary-orange);
            color: var(--white);
            transform: scale(1.05);
        }

        .progress-step.active .step-icon {
            border-color: var(--primary-orange);
            color: var(--primary-orange);
            background: var(--primary-cream);
            animation: pulse 2s infinite;
        }

        @keyframes pulse {
            0%, 100% {
                box-shadow: 0 0 0 0 rgba(255, 140, 97, 0.4);
            }
            50% {
                box-shadow: 0 0 0 10px rgba(255, 140, 97, 0);
            }
        }

        .progress-step .step-title {
            font-weight: 600;
            font-size: 0.9rem;
            color: var(--text-light);
        }

        .progress-step .step-date {
            font-size: 0.75rem;
            color: var(--text-light);
            margin-top: 4px;
        }

        .progress-step.completed .step-title,
        .progress-step.active .step-title {
            color: var(--dark-brown);
        }

        .progress-step.completed .step-icon i {
            font-size: 24px;
        }

        /* Order Status Badge */
        .order-status-badge {
            display: inline-block;
            padding: 0.5rem 1.2rem;
            border-radius: 25px;
            font-weight: 600;
            font-size: 0.95rem;
        }

        .status-pending {
            background: #FFF5E6;
            color: #F4A261;
        }

        .status-processing {
            background: #E6F3FF;
            color: #4A90E2;
        }

        .status-shipped {
            background: var(--primary-cream);
            color: var(--primary-orange);
        }

        .status-delivered {
            background: #E8F5E9;
            color: #4CAF50;
        }

        /* Order Details Grid */
        .detail-item {
            padding: 1rem;
            border-bottom: 1px solid #F0F0F0;
        }

        .detail-item:last-child {
            border-bottom: none;
        }

        .detail-label {
            font-weight: 600;
            color: var(--dark-brown);
            font-size: 0.9rem;
            margin-bottom: 0.3rem;
        }

        .detail-value {
            color: var(--text-dark);
            font-size: 0.95rem;
        }

        .detail-value i {
            color: var(--primary-orange);
            margin-right: 0.5rem;
        }

        /* Back Button */
        .btn-back {
            background: var(--white);
            border: 2px solid var(--primary-orange);
            color: var(--primary-orange);
            border-radius: 25px;
            padding: 0.6rem 1.5rem;
            font-weight: 500;
            transition: all 0.3s ease;
        }

        .btn-back:hover {
            background: var(--primary-orange);
            color: var(--white);
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(255, 140, 97, 0.3);
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

            .progress-tracker::before {
                left: 30px;
                right: 30px;
            }

            .progress-line {
                left: 30px;
            }

            .step-icon {
                width: 40px;
                height: 40px;
                font-size: 16px;
            }

            .progress-step .step-title {
                font-size: 0.75rem;
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
        <h2>
            <i class="bi bi-music-note-beamed me-2"></i>
            Order <span class="order-number">${order.orderNumber}</span>
        </h2>
        <p class="mt-2">
            Current Status:
            <c:set var="upperStatus" value="${fn:toUpperCase(order.status)}" />
            <c:choose>
                <c:when test="${upperStatus == 'PENDING' or upperStatus == 'CONFIRMED'}">
                    <span class="order-status-badge status-pending">
                        <i class="bi bi-clock me-1"></i>Pending
                    </span>
                </c:when>
                <c:when test="${upperStatus == 'PROCESSING'}">
                    <span class="order-status-badge status-processing">
                        <i class="bi bi-gear me-1"></i>Processing
                    </span>
                </c:when>
                <c:when test="${upperStatus == 'SHIPPED'}">
                    <span class="order-status-badge status-shipped">
                        <i class="bi bi-truck me-1"></i>Shipped
                    </span>
                </c:when>
                <c:when test="${upperStatus == 'DELIVERED'}">
                    <span class="order-status-badge status-delivered">
                        <i class="bi bi-check-circle me-1"></i>Delivered
                    </span>
                </c:when>
                <c:otherwise>
                    <span class="order-status-badge status-pending">${order.status}</span>
                </c:otherwise>
            </c:choose>
        </p>
    </div>

    <div class="row">
        <!-- Order Progress Card -->
        <div class="col-lg-8 mx-auto">
            <div class="card info-card">
                <div class="card-header">
                    <h5>
                        <i class="bi bi-truck me-2"></i>Order Tracking
                    </h5>
                </div>
                <div class="card-body">
                    <div class="position-relative">
                        <ul class="progress-tracker">
                            <div class="progress-line" id="progressLine"></div>

                            <li class="progress-step" data-status="CONFIRMED">
                                <div class="step-icon">
                                    <span class="step-number">1</span>
                                    <i class="bi bi-check-lg" style="display: none;"></i>
                                </div>
                                <div class="step-title">Confirmed</div>
                            </li>

                            <li class="progress-step" data-status="PROCESSING">
                                <div class="step-icon">
                                    <span class="step-number">2</span>
                                    <i class="bi bi-check-lg" style="display: none;"></i>
                                </div>
                                <div class="step-title">Processing</div>
                            </li>

                            <li class="progress-step" data-status="SHIPPED">
                                <div class="step-icon">
                                    <span class="step-number">3</span>
                                    <i class="bi bi-check-lg" style="display: none;"></i>
                                </div>
                                <div class="step-title">Shipped</div>
                            </li>

                            <li class="progress-step" data-status="DELIVERED">
                                <div class="step-icon">
                                    <span class="step-number">4</span>
                                    <i class="bi bi-check-lg" style="display: none;"></i>
                                </div>
                                <div class="step-title">Delivered</div>
                            </li>
                        </ul>
                    </div>
                </div>
            </div>

            <!-- Order Details Card -->
            <div class="card info-card">
                <div class="card-header">
                    <h5>
                        <i class="bi bi-info-circle me-2"></i>Order Information
                    </h5>
                </div>
                <div class="card-body p-0">
                    <div class="detail-item">
                        <div class="detail-label">Order Number</div>
                        <div class="detail-value">
                            <i class="bi bi-hash"></i>${order.orderNumber}
                        </div>
                    </div>
                    <div class="detail-item">
                        <div class="detail-label">Order Date</div>
                        <div class="detail-value">
                            <i class="bi bi-calendar3"></i>${order.createdAt}
                        </div>
                    </div>
                    <div class="detail-item">
                        <div class="detail-label">Status</div>
                        <div class="detail-value">
                            <i class="bi bi-flag"></i>${order.status}
                        </div>
                    </div>
                </div>
            </div>

            <!-- Back Button -->
            <div class="text-center mt-4">
                <a href="${pageContext.request.contextPath}/orders" class="btn btn-back">
                    <i class="bi bi-arrow-left me-2"></i>Back to Orders
                </a>
            </div>
        </div>
    </div>
</div>

<!-- Bootstrap JS Bundle -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
    const statusConfig = {
        'PENDING': { step: 0, width: 0 },
        'CONFIRMED': { step: 0, width: 0 },
        'PROCESSING': { step: 1, width: 33 },
        'SHIPPED': { step: 2, width: 66 },
        'DELIVERED': { step: 3, width: 100 }
    };

    function updateProgressBar(status) {
        const steps = document.querySelectorAll('.progress-step');
        const progressLine = document.getElementById('progressLine');
        const config = statusConfig[status] || statusConfig['CONFIRMED'];

        // Animate progress line
        setTimeout(() => {
            progressLine.style.width = config.width + '%';
        }, 300);

        steps.forEach((step, index) => {
            step.classList.remove('completed', 'active');
            const stepNumber = step.querySelector('.step-number');
            const stepCheck = step.querySelector('.bi-check-lg');

            if (index < config.step) {
                // Completed steps
                step.classList.add('completed');
                stepNumber.style.display = 'none';
                stepCheck.style.display = 'block';
            } else if (index === config.step) {
                // Active step
                step.classList.add('active');
                stepNumber.style.display = 'block';
                stepCheck.style.display = 'none';
            } else {
                // Future steps
                stepNumber.style.display = 'block';
                stepCheck.style.display = 'none';
            }
        });
    }

    document.addEventListener('DOMContentLoaded', () => {
        const currentStatus = '${fn:toUpperCase(order.status)}';
        updateProgressBar(currentStatus);
    });
</script>
</body>
</html>