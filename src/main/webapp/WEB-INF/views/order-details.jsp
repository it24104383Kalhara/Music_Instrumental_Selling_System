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
    <title>Order ${order.orderNumber} - Tracking</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">

    <style>
        body {
            background-color: #f8f9fa;
            font-family: 'Arial', sans-serif;
        }
        .navbar {
            box-shadow: 0 2px 4px rgba(0,0,0,.08);
        }

        /* Progress Bar Styles */
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
            top: 20px;
            left: 50px;
            right: 50px;
            height: 8px;
            background: #e9ecef;
            border-radius: 4px;
            z-index: 1;
        }

        .progress-line {
            position: absolute;
            top: 20px;
            left: 50px;
            height: 8px;
            border-radius: 4px;
            z-index: 2;
            transition: width 0.5s ease-in-out;
            width: 0;
            background: #28a745; /* always green */
        }

        .progress-step {
            text-align: center;
            position: relative;
            z-index: 3;
            flex: 1;
        }

        .step-icon {
            width: 40px;
            height: 40px;
            background: #fff;
            border: 3px solid #e9ecef;
            border-radius: 50%;
            margin: 0 auto 8px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 18px;
            color: #6c757d;
            transition: all 0.3s ease;
        }

        .progress-step.completed .step-icon {
            background: #28a745;
            border-color: #28a745;
            color: #fff;
        }

        .progress-step.active .step-icon {
            border-color: #28a745;
            color: #28a745;
        }

        .progress-step .step-title {
            font-weight: 600;
            font-size: 14px;
            color: #6c757d;
        }

        .progress-step.completed .step-title,
        .progress-step.active .step-title {
            color: #212529;
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
<div class="container-fluid pb-4 mt-4">
    <div class="row mb-4">
        <div class="col-12 text-center">
            <h2 class="mb-1">Order ${order.orderNumber}</h2>
            <p class="text-muted">Current Status: <strong id="statusText">${order.status}</strong></p>
        </div>
    </div>

    <!-- Order Progress Card -->
    <div class="card info-card mb-4">
        <div class="card-header bg-white">
            <h5 class="mb-0"><i class="bi bi-truck me-2"></i>Order Tracking</h5>
        </div>
        <div class="card-body">
            <div class="position-relative">
                <ul class="progress-tracker">
                    <div class="progress-line" id="progressLine"></div>

                    <li class="progress-step" data-status="CONFIRMED">
                        <div class="step-icon">1</div>
                        <div class="step-title">Confirmed</div>
                    </li>

                    <li class="progress-step" data-status="PROCESSING">
                        <div class="step-icon">2</div>
                        <div class="step-title">Processing</div>
                    </li>

                    <li class="progress-step" data-status="SHIPPED">
                        <div class="step-icon">3</div>
                        <div class="step-title">Shipped</div>
                    </li>

                    <li class="progress-step" data-status="DELIVERED">
                        <div class="step-icon">4</div>
                        <div class="step-title">Delivered</div>
                    </li>
                </ul>
            </div>
        </div>
    </div>
</div>

<!-- JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
    const statusConfig = {
        'CONFIRMED': { step: 0, width: 0 },
        'PROCESSING': { step: 1, width: 33 },
        'SHIPPED': { step: 2, width: 66 },
        'DELIVERED': { step: 3, width: 100 }
    };

    function updateProgressBar(status) {
        const steps = document.querySelectorAll('.progress-step');
        const progressLine = document.getElementById('progressLine');
        const config = statusConfig[status] || statusConfig['CONFIRMED'];

        progressLine.style.width = `${config.width}%`;

        steps.forEach((step, index) => {
            step.classList.remove('completed', 'active');
            if (index < config.step) {
                step.classList.add('completed');
            } else if (index === config.step) {
                step.classList.add('active');
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
