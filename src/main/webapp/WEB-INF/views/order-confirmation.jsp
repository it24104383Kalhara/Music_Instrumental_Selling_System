<%--
  Created by IntelliJ IDEA.
  User: vinod
  Date: 10/17/2025
  Time: 7:15 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Order Confirmation - Musical Instruments Store</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">

    <style>
        :root {
            --primary-orange: #FF8C61;
            --primary-orange-soft: #FFB08A;
            --primary-cream: #FFF4E6;
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

        .success-container {
            max-width: 700px;
            margin: 3rem auto;
            padding: 20px;
        }

        .success-card {
            background: var(--white);
            border-radius: 15px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.1);
            padding: 3rem;
            text-align: center;
        }

        .success-icon {
            width: 100px;
            height: 100px;
            background: linear-gradient(135deg, #4CAF50 0%, #81C784 100%);
            border-radius: 50%;
            margin: 0 auto 2rem;
            display: flex;
            align-items: center;
            justify-content: center;
            animation: scaleIn 0.5s ease;
        }

        .success-icon i {
            font-size: 3rem;
            color: white;
        }

        @keyframes scaleIn {
            0% { transform: scale(0); }
            50% { transform: scale(1.1); }
            100% { transform: scale(1); }
        }

        .success-title {
            color: var(--dark-brown);
            font-weight: 700;
            margin-bottom: 1rem;
        }

        .order-number {
            color: var(--primary-orange);
            font-size: 1.3rem;
            font-weight: 700;
            margin: 1.5rem 0;
        }

        .info-box {
            background: var(--primary-cream);
            border-radius: 10px;
            padding: 1.5rem;
            margin: 2rem 0;
            text-align: left;
        }

        .info-row {
            display: flex;
            justify-content: space-between;
            padding: 0.5rem 0;
            border-bottom: 1px solid #E8E8E8;
        }

        .info-row:last-child {
            border-bottom: none;
        }

        .info-label {
            color: var(--text-light);
            font-weight: 500;
        }

        .info-value {
            color: var(--text-dark);
            font-weight: 600;
        }

        .btn-primary-custom {
            background: linear-gradient(135deg, var(--primary-orange) 0%, var(--primary-orange-soft) 100%);
            border: none;
            color: white;
            padding: 0.75rem 2rem;
            border-radius: 25px;
            font-weight: 600;
            margin: 0.5rem;
            transition: all 0.3s ease;
        }

        .btn-primary-custom:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 20px rgba(255, 140, 97, 0.3);
            color: white;
        }

        .btn-outline-custom {
            border: 2px solid var(--primary-orange);
            background: transparent;
            color: var(--primary-orange);
            padding: 0.75rem 2rem;
            border-radius: 25px;
            font-weight: 600;
            margin: 0.5rem;
            transition: all 0.3s ease;
        }

        .btn-outline-custom:hover {
            background: var(--primary-orange);
            color: white;
        }
    </style>
</head>
<body>
<div class="success-container">
    <div class="success-card">
        <div class="success-icon">
            <i class="bi bi-check-lg"></i>
        </div>

        <h1 class="success-title">Order Placed Successfully! 🎉</h1>
        <p class="text-muted">Thank you for your purchase. Your order has been received.</p>

        <div class="order-number">
            Order #${order.orderNumber}
        </div>

        <div class="info-box">
            <div class="info-row">
                <span class="info-label">Order Total:</span>
                <span class="info-value">$<fmt:formatNumber value="${order.totalAmount}" pattern="#,##0.00"/></span>
            </div>
            <div class="info-row">
                <span class="info-label">Payment Method:</span>
                <span class="info-value">${payment.paymentMethod}</span>
            </div>
            <div class="info-row">
                <span class="info-label">Payment Status:</span>
                <span class="info-value">
                        <span class="badge bg-warning text-dark">Pending Verification</span>
                    </span>
            </div>
            <div class="info-row">
                <span class="info-label">Order Status:</span>
                <span class="info-value">${order.status}</span>
            </div>
        </div>

        <div class="alert alert-info">
            <i class="bi bi-info-circle me-2"></i>
            <strong>What's Next?</strong><br>
            <small>Your payment will be verified by our admin team. Once verified, we'll start processing your order.</small>
        </div>

        <div class="mt-4">
            <a href="${pageContext.request.contextPath}/orders/view?id=${order.id}" class="btn btn-primary-custom">
                <i class="bi bi-eye me-2"></i>View Order Details
            </a>
            <a href="${pageContext.request.contextPath}/shop" class="btn btn-outline-custom">
                <i class="bi bi-shop me-2"></i>Continue Shopping
            </a>
        </div>

        <div class="mt-4">
            <small class="text-muted">
                A confirmation email has been sent to ${sessionScope.userEmail}
            </small>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>