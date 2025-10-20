<%--
  Created by IntelliJ IDEA.
  User: vinod
  Date: 10/17/2025
  Time: 6:56 PM
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
    <title>Shopping Cart - Musical Instruments Store</title>

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

        .cart-badge {
            position: absolute;
            top: -8px;
            right: -8px;
            background: linear-gradient(135deg, var(--primary-orange) 0%, var(--primary-orange-soft) 100%);
            color: white;
            border-radius: 50%;
            width: 20px;
            height: 20px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 0.7rem;
            font-weight: 600;
        }

        /* Page Header */
        .page-header {
            background: linear-gradient(135deg, var(--primary-orange) 0%, var(--primary-orange-soft) 100%);
            padding: 2rem 0;
            margin-bottom: 2rem;
            color: white;
        }

        .page-header h1 {
            font-weight: 700;
            margin-bottom: 0.5rem;
        }

        /* Cart Card */
        .cart-card {
            background: var(--white);
            border-radius: 12px;
            box-shadow: 0 3px 10px rgba(0,0,0,0.05);
            padding: 1.5rem;
            margin-bottom: 1.5rem;
        }

        .cart-card h5 {
            color: var(--dark-brown);
            font-weight: 600;
            margin-bottom: 1.5rem;
        }

        /* Cart Item */
        .cart-item {
            display: flex;
            align-items: center;
            padding: 1.5rem;
            border: 1px solid #F0F0F0;
            border-radius: 12px;
            margin-bottom: 1rem;
            transition: all 0.3s ease;
        }

        .cart-item:hover {
            box-shadow: 0 5px 15px rgba(0,0,0,0.08);
        }

        /* Cart Item Image */
        .item-image {
            width: 80px;
            height: 80px;
            border-radius: 12px;
            overflow: hidden;
            margin-right: 1.5rem;
            flex-shrink: 0;
        }

        .cart-item-image {
            width: 100%;
            height: 100%;
            object-fit: cover;
            background: linear-gradient(135deg, var(--primary-cream) 0%, var(--light-peach) 100%);
        }

        .item-details {
            flex-grow: 1;
        }

        .item-name {
            font-weight: 600;
            color: var(--dark-brown);
            font-size: 1.1rem;
            margin-bottom: 0.3rem;
        }

        .item-price {
            color: var(--primary-orange);
            font-weight: 600;
            font-size: 1rem;
        }

        /* Quantity Controls */
        .quantity-controls {
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .qty-btn {
            width: 35px;
            height: 35px;
            border: 2px solid var(--primary-orange);
            background: var(--white);
            color: var(--primary-orange);
            border-radius: 8px;
            display: flex;
            align-items: center;
            justify-content: center;
            cursor: pointer;
            transition: all 0.3s ease;
            font-weight: 600;
        }

        .qty-btn:hover {
            background: var(--primary-orange);
            color: white;
        }

        .qty-input {
            width: 60px;
            text-align: center;
            border: 2px solid #F0F0F0;
            border-radius: 8px;
            padding: 0.4rem;
            font-weight: 600;
            color: var(--text-dark);
        }

        .qty-input:focus {
            outline: none;
            border-color: var(--primary-orange-soft);
        }

        .item-subtotal {
            font-weight: 700;
            color: var(--dark-brown);
            font-size: 1.2rem;
            margin: 0 1.5rem;
            min-width: 100px;
            text-align: right;
        }

        .btn-remove {
            background: #FFEBEE;
            border: none;
            color: #F44336;
            width: 35px;
            height: 35px;
            border-radius: 8px;
            display: flex;
            align-items: center;
            justify-content: center;
            cursor: pointer;
            transition: all 0.3s ease;
        }

        .btn-remove:hover {
            background: #F44336;
            color: white;
            transform: scale(1.1);
        }

        /* Summary Card */
        .summary-card {
            background: var(--white);
            border-radius: 12px;
            box-shadow: 0 3px 10px rgba(0,0,0,0.05);
            padding: 1.5rem;
            position: sticky;
            top: 20px;
        }

        .summary-card h5 {
            color: var(--dark-brown);
            font-weight: 600;
            margin-bottom: 1.5rem;
        }

        .summary-row {
            display: flex;
            justify-content: space-between;
            padding: 0.75rem 0;
            border-bottom: 1px solid #F0F0F0;
        }

        .summary-row:last-child {
            border-bottom: none;
        }

        .summary-label {
            color: var(--text-dark);
            font-weight: 500;
        }

        .summary-value {
            color: var(--text-dark);
            font-weight: 600;
        }

        .total-row {
            margin-top: 1rem;
            padding-top: 1rem;
            border-top: 2px solid var(--primary-cream);
        }

        .total-row .summary-label {
            font-size: 1.1rem;
            color: var(--dark-brown);
            font-weight: 600;
        }

        .total-row .summary-value {
            font-size: 1.5rem;
            color: var(--primary-orange);
            font-weight: 700;
        }

        .delivery-note {
            background: var(--primary-cream);
            padding: 0.75rem;
            border-radius: 8px;
            margin-top: 1rem;
            font-size: 0.85rem;
            color: var(--text-dark);
        }

        .delivery-note i {
            color: var(--primary-orange);
        }

        /* Buttons */
        .btn-checkout {
            background: linear-gradient(135deg, var(--primary-orange) 0%, var(--primary-orange-soft) 100%);
            border: none;
            color: white;
            padding: 0.9rem;
            border-radius: 10px;
            font-weight: 600;
            width: 100%;
            margin-top: 1.5rem;
            transition: all 0.3s ease;
            font-size: 1rem;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .btn-checkout:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 20px rgba(255, 140, 97, 0.3);
            color: white;
        }

        .btn-continue {
            border: 2px solid var(--primary-orange);
            background: transparent;
            color: var(--primary-orange);
            padding: 0.75rem 1.5rem;
            border-radius: 10px;
            font-weight: 600;
            transition: all 0.3s ease;
            text-decoration: none;
            display: inline-block;
        }

        .btn-continue:hover {
            background: var(--primary-orange);
            color: white;
            transform: translateY(-2px);
        }

        /* Empty Cart */
        .empty-cart {
            text-align: center;
            padding: 4rem 2rem;
        }

        .empty-cart i {
            font-size: 5rem;
            color: var(--primary-orange-soft);
            opacity: 0.5;
        }

        .empty-cart h3 {
            color: var(--dark-brown);
            margin-top: 1.5rem;
        }

        .empty-cart p {
            color: var(--text-light);
            margin-top: 0.5rem;
        }

        /* Toast */
        .toast-container {
            position: fixed;
            top: 80px;
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
            🎵 Musical Store
        </a>
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
            <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse" id="navbarNav">
            <ul class="navbar-nav me-auto">
                <li class="nav-item">
                    <a class="nav-link" href="${pageContext.request.contextPath}/shop">
                        <i class="bi bi-shop me-1"></i>Shop
                    </a>
                </li>
                <c:if test="${not empty sessionScope.userId}">
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/dashboard">
                            <i class="bi bi-speedometer2 me-1"></i>Dashboard
                        </a>
                    </li>
                </c:if>
            </ul>
            <ul class="navbar-nav">
                <li class="nav-item">
                    <a class="nav-link active position-relative" href="${pageContext.request.contextPath}/cart">
                        <i class="bi bi-cart3 me-1"></i>Cart
                        <span class="cart-badge" id="cartBadge">${totalItems}</span>
                    </a>
                </li>
                <c:choose>
                    <c:when test="${not empty sessionScope.userId}">
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
                    </c:when>
                    <c:otherwise>
                        <li class="nav-item">
                            <a class="nav-link" href="${pageContext.request.contextPath}/login">
                                <i class="bi bi-box-arrow-in-right me-1"></i>Login
                            </a>
                        </li>
                    </c:otherwise>
                </c:choose>
            </ul>
        </div>
    </div>
</nav>

<!-- Page Header -->
<div class="page-header">
    <div class="container">
        <h1><i class="bi bi-cart3 me-3"></i>Shopping Cart</h1>
        <p>${totalItems} item(s) in your cart</p>
    </div>
</div>

<!-- Main Content -->
<div class="container py-4">
    <c:choose>
        <c:when test="${empty cart || fn:length(cart) == 0}">
            <!-- Empty Cart -->
            <div class="cart-card">
                <div class="empty-cart">
                    <i class="bi bi-cart-x"></i>
                    <h3>Your cart is empty</h3>
                    <p>Add some musical instruments to get started!</p>
                    <a href="${pageContext.request.contextPath}/shop" class="btn btn-checkout mt-3">
                        <i class="bi bi-shop me-2"></i>Continue Shopping
                    </a>
                </div>
            </div>
        </c:when>
        <c:otherwise>
            <div class="row">
                <!-- Cart Items -->
                <div class="col-lg-8">
                    <div class="cart-card">
                        <h5><i class="bi bi-bag-check me-2"></i>Cart Items</h5>

                        <c:forEach var="entry" items="${cart}">
                            <c:set var="item" value="${entry.value}"/>
                            <div class="cart-item" data-instrument-id="${item.instrumentId}">
                                <div class="item-image">
                                    <img src="${pageContext.request.contextPath}/images/instruments/${item.instrumentId}.jpg"
                                         alt="${item.instrumentName}"
                                         class="cart-item-image"
                                         onerror="this.onerror=null; this.src='${pageContext.request.contextPath}/images/instruments/default.jpg';">
                                </div>
                                <div class="item-details">
                                    <div class="item-name">${item.instrumentName}</div>
                                    <div class="item-price">$<fmt:formatNumber value="${item.price}" pattern="#,##0.00"/> each</div>
                                </div>
                                <div class="quantity-controls">
                                    <button class="qty-btn" onclick="decreaseQuantity(${item.instrumentId})">
                                        <i class="bi bi-dash"></i>
                                    </button>
                                    <input type="number" class="qty-input" value="${item.quantity}"
                                           min="1" id="qty-${item.instrumentId}" readonly>
                                    <button class="qty-btn" onclick="increaseQuantity(${item.instrumentId})">
                                        <i class="bi bi-plus"></i>
                                    </button>
                                </div>
                                <div class="item-subtotal" id="subtotal-${item.instrumentId}">
                                    $<fmt:formatNumber value="${item.subtotal}" pattern="#,##0.00"/>
                                </div>
                                <button class="btn-remove" onclick="removeItem(${item.instrumentId}, '${item.instrumentName}')">
                                    <i class="bi bi-trash"></i>
                                </button>
                            </div>
                        </c:forEach>

                        <div class="mt-3">
                            <a href="${pageContext.request.contextPath}/shop" class="btn-continue">
                                <i class="bi bi-arrow-left me-2"></i>Continue Shopping
                            </a>
                        </div>
                    </div>
                </div>

                <!-- Order Summary -->
                <div class="col-lg-4">
                    <div class="summary-card">
                        <h5><i class="bi bi-receipt me-2"></i>Order Summary</h5>

                        <div class="summary-row">
                            <span class="summary-label">Subtotal:</span>
                            <span class="summary-value" id="display-subtotal">
                                $<fmt:formatNumber value="${subtotal}" pattern="#,##0.00"/>
                            </span>
                        </div>

                        <div class="summary-row">
                            <span class="summary-label">Delivery Fee:</span>
                            <span class="summary-value" id="display-delivery">
                                $<fmt:formatNumber value="${deliveryFee}" pattern="#,##0.00"/>
                            </span>
                        </div>

                        <div class="summary-row total-row">
                            <span class="summary-label">Total:</span>
                            <span class="summary-value" id="display-total">
                                $<fmt:formatNumber value="${total}" pattern="#,##0.00"/>
                            </span>
                        </div>

                        <c:if test="${deliveryFee > 0}">
                            <div class="delivery-note">
                                <i class="bi bi-info-circle me-2"></i>
                                <strong>Free delivery</strong> on orders above $500!
                            </div>
                        </c:if>

                        <c:choose>
                            <c:when test="${not empty sessionScope.userId}">
                                <a href="${pageContext.request.contextPath}/checkout" class="btn btn-checkout">
                                    <i class="bi bi-credit-card me-2"></i>Proceed to Checkout
                                </a>
                            </c:when>
                            <c:otherwise>
                                <a href="${pageContext.request.contextPath}/login" class="btn btn-checkout">
                                    <i class="bi bi-box-arrow-in-right me-2"></i>Login to Checkout
                                </a>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </div>
        </c:otherwise>
    </c:choose>
</div>

<!-- Toast Container -->
<div class="toast-container">
    <div id="cartToast" class="toast" role="alert">
        <div class="toast-header">
            <i class="bi bi-check-circle-fill me-2 text-success" id="toastIcon"></i>
            <strong class="me-auto" id="toastTitle">Success</strong>
            <button type="button" class="btn-close" data-bs-dismiss="toast"></button>
        </div>
        <div class="toast-body" id="toastMessage">
            Cart updated successfully!
        </div>
    </div>
</div>

<!-- Bootstrap JS Bundle -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

<script>
    // Update quantity (increase)
    function increaseQuantity(instrumentId) {
        const input = document.getElementById('qty-' + instrumentId);
        const newQuantity = parseInt(input.value) + 1;
        updateCartQuantity(instrumentId, newQuantity);
    }

    // Update quantity (decrease)
    function decreaseQuantity(instrumentId) {
        const input = document.getElementById('qty-' + instrumentId);
        const currentQuantity = parseInt(input.value);
        if (currentQuantity > 1) {
            updateCartQuantity(instrumentId, currentQuantity - 1);
        }
    }

    // Update cart quantity via AJAX
    function updateCartQuantity(instrumentId, quantity) {
        fetch('${pageContext.request.contextPath}/cart/update', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded',
            },
            body: 'instrumentId=' + instrumentId + '&quantity=' + quantity
        })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    // Update UI
                    document.getElementById('qty-' + instrumentId).value = quantity;
                    document.getElementById('subtotal-' + instrumentId).textContent = '$' + parseFloat(data.itemSubtotal).toFixed(2);
                    document.getElementById('display-subtotal').textContent = '$' + parseFloat(data.subtotal).toFixed(2);
                    document.getElementById('display-delivery').textContent = '$' + parseFloat(data.deliveryFee).toFixed(2);
                    document.getElementById('display-total').textContent = '$' + parseFloat(data.total).toFixed(2);
                    document.getElementById('cartBadge').textContent = data.cartCount;

                    showToast('Success', 'Quantity updated', 'success');
                } else {
                    showToast('Error', data.message, 'error');
                }
            })
            .catch(error => {
                showToast('Error', 'Failed to update cart', 'error');
                console.error('Error:', error);
            });
    }

    // Remove item from cart
    function removeItem(instrumentId, instrumentName) {
        if (!confirm('Remove "' + instrumentName + '" from cart?')) {
            return;
        }

        fetch('${pageContext.request.contextPath}/cart/remove', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded',
            },
            body: 'instrumentId=' + instrumentId
        })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    // Remove item from UI
                    const itemElement = document.querySelector('[data-instrument-id="' + instrumentId + '"]');
                    itemElement.style.opacity = '0';
                    itemElement.style.transform = 'translateX(100px)';

                    setTimeout(() => {
                        itemElement.remove();

                        // Update totals
                        document.getElementById('display-subtotal').textContent = '$' + parseFloat(data.subtotal).toFixed(2);
                        document.getElementById('display-delivery').textContent = '$' + parseFloat(data.deliveryFee).toFixed(2);
                        document.getElementById('display-total').textContent = '$' + parseFloat(data.total).toFixed(2);
                        document.getElementById('cartBadge').textContent = data.cartCount;

                        // Reload page if cart is empty
                        if (data.cartCount === 0) {
                            location.reload();
                        }
                    }, 300);

                    showToast('Success', data.message, 'success');
                } else {
                    showToast('Error', data.message, 'error');
                }
            })
            .catch(error => {
                showToast('Error', 'Failed to remove item', 'error');
                console.error('Error:', error);
            });
    }

    // Show toast notification
    function showToast(title, message, type) {
        const toastEl = document.getElementById('cartToast');
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