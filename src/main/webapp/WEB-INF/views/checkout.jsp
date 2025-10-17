<%--
  Created by IntelliJ IDEA.
  User: vinod
  Date: 10/17/2025
  Time: 7:13 PM
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
    <title>Checkout - Musical Instruments Store</title>

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
        }

        .navbar .nav-link:hover {
            color: var(--primary-orange) !important;
            background: var(--primary-cream);
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

        /* Progress Steps */
        .checkout-progress {
            background: var(--white);
            border-radius: 12px;
            padding: 2rem;
            margin-bottom: 2rem;
            box-shadow: 0 3px 10px rgba(0,0,0,0.05);
        }

        .progress-steps {
            display: flex;
            justify-content: space-between;
            position: relative;
            margin-bottom: 0;
        }

        .progress-steps::before {
            content: '';
            position: absolute;
            top: 20px;
            left: 25%;
            right: 25%;
            height: 3px;
            background: var(--primary-orange);
            z-index: 1;
        }

        .progress-step {
            text-align: center;
            position: relative;
            z-index: 2;
            flex: 1;
        }

        .step-circle {
            width: 40px;
            height: 40px;
            background: var(--primary-orange);
            border-radius: 50%;
            margin: 0 auto 10px;
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-weight: 600;
        }

        .step-circle.inactive {
            background: #E0E0E0;
            color: #999;
        }

        .step-label {
            font-size: 0.85rem;
            color: var(--text-dark);
            font-weight: 500;
        }

        /* Cards */
        .checkout-card {
            background: var(--white);
            border-radius: 12px;
            box-shadow: 0 3px 10px rgba(0,0,0,0.05);
            padding: 1.5rem;
            margin-bottom: 1.5rem;
        }

        .checkout-card h5 {
            color: var(--dark-brown);
            font-weight: 600;
            margin-bottom: 1.5rem;
        }

        /* Form */
        .form-label {
            font-weight: 600;
            color: var(--text-dark);
            margin-bottom: 0.5rem;
        }

        .form-control, .form-select {
            border: 2px solid #F0F0F0;
            border-radius: 8px;
            padding: 0.75rem;
            transition: all 0.3s ease;
        }

        .form-control:focus, .form-select:focus {
            border-color: var(--primary-orange-soft);
            box-shadow: 0 0 0 3px rgba(255, 140, 97, 0.1);
        }

        /* Order Summary */
        .summary-card {
            background: var(--white);
            border-radius: 12px;
            box-shadow: 0 3px 10px rgba(0,0,0,0.05);
            padding: 1.5rem;
            position: sticky;
            top: 20px;
        }

        .order-item {
            display: flex;
            justify-content: space-between;
            padding: 0.75rem 0;
            border-bottom: 1px solid #F0F0F0;
        }

        .order-item:last-child {
            border-bottom: none;
        }

        .item-name {
            font-weight: 500;
            color: var(--text-dark);
        }

        .item-qty {
            color: var(--text-light);
            font-size: 0.9rem;
        }

        .item-price {
            font-weight: 600;
            color: var(--primary-orange);
        }

        .summary-row {
            display: flex;
            justify-content: space-between;
            padding: 0.75rem 0;
            border-bottom: 1px solid #F0F0F0;
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

        /* Buttons */
        .btn-place-order {
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

        .btn-place-order:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 20px rgba(255, 140, 97, 0.3);
            color: white;
        }

        .btn-back-cart {
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

        .btn-back-cart:hover {
            background: var(--primary-orange);
            color: white;
        }

        /* Payment Method Cards */
        .payment-method {
            border: 2px solid #F0F0F0;
            border-radius: 10px;
            padding: 1rem;
            margin-bottom: 1rem;
            cursor: pointer;
            transition: all 0.3s ease;
        }

        .payment-method:hover {
            border-color: var(--primary-orange-soft);
            background: var(--primary-cream);
        }

        .payment-method input[type="radio"] {
            margin-right: 1rem;
        }

        .payment-method.selected {
            border-color: var(--primary-orange);
            background: var(--primary-cream);
        }

        .payment-icon {
            font-size: 1.5rem;
            margin-right: 0.5rem;
        }

        /* Alert */
        .alert {
            border-radius: 10px;
            border: none;
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
            </ul>
            <ul class="navbar-nav">
                <li class="nav-item">
                    <a class="nav-link position-relative" href="${pageContext.request.contextPath}/cart">
                        <i class="bi bi-cart3 me-1"></i>Cart
                        <span class="cart-badge">${fn:length(cart)}</span>
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="#">
                        <i class="bi bi-person-circle me-1"></i>${sessionScope.userName}
                    </a>
                </li>
            </ul>
        </div>
    </div>
</nav>

<!-- Main Content -->
<div class="container py-4">
    <!-- Progress Steps -->
    <div class="checkout-progress">
        <div class="progress-steps">
            <div class="progress-step">
                <div class="step-circle inactive">1</div>
                <div class="step-label">Cart</div>
            </div>
            <div class="progress-step">
                <div class="step-circle">2</div>
                <div class="step-label">Checkout</div>
            </div>
            <div class="progress-step">
                <div class="step-circle inactive">3</div>
                <div class="step-label">Confirmation</div>
            </div>
        </div>
    </div>

    <!-- Error Message -->
    <c:if test="${not empty error}">
        <div class="alert alert-danger">
            <i class="bi bi-exclamation-triangle me-2"></i>${error}
        </div>
    </c:if>

    <form action="${pageContext.request.contextPath}/checkout" method="post" id="checkoutForm">
        <div class="row">
            <!-- Left Column - Forms -->
            <div class="col-lg-8">
                <!-- Shipping Information -->
                <div class="checkout-card">
                    <h5><i class="bi bi-truck me-2"></i>Shipping Information</h5>

                    <div class="mb-3">
                        <label for="fullName" class="form-label">Full Name</label>
                        <input type="text" class="form-control" id="fullName"
                               value="${sessionScope.userName}" readonly>
                    </div>

                    <div class="mb-3">
                        <label for="email" class="form-label">Email Address</label>
                        <input type="email" class="form-control" id="email"
                               value="${sessionScope.userEmail}" readonly>
                    </div>

                    <div class="mb-3">
                        <label for="shippingAddress" class="form-label">Shipping Address *</label>
                        <textarea class="form-control" id="shippingAddress" name="shippingAddress"
                                  rows="3" required
                                  placeholder="Enter your complete delivery address"></textarea>
                        <small class="text-muted">Street address, City, Postal Code, Country</small>
                    </div>

                    <div class="row">
                        <div class="col-md-6 mb-3">
                            <label for="phone" class="form-label">Phone Number</label>
                            <input type="tel" class="form-control" id="phone" name="phone"
                                   placeholder="+1 234 567 890">
                        </div>
                        <div class="col-md-6 mb-3">
                            <label for="deliveryNotes" class="form-label">Delivery Notes (Optional)</label>
                            <input type="text" class="form-control" id="deliveryNotes" name="deliveryNotes"
                                   placeholder="Any special instructions">
                        </div>
                    </div>
                </div>

                <!-- Payment Information -->
                <div class="checkout-card">
                    <h5><i class="bi bi-credit-card me-2"></i>Payment Method</h5>

                    <div class="payment-method" onclick="selectPayment('credit-card', this)">
                        <input type="radio" name="paymentMethod" value="Credit Card" id="creditCard" required>
                        <label for="creditCard" class="mb-0">
                            <span class="payment-icon">💳</span>
                            <strong>Credit/Debit Card</strong>
                        </label>
                    </div>

                    <div class="payment-method" onclick="selectPayment('paypal', this)">
                        <input type="radio" name="paymentMethod" value="PayPal" id="paypal">
                        <label for="paypal" class="mb-0">
                            <span class="payment-icon">🅿️</span>
                            <strong>PayPal</strong>
                        </label>
                    </div>

                    <div class="payment-method" onclick="selectPayment('bank', this)">
                        <input type="radio" name="paymentMethod" value="Bank Transfer" id="bankTransfer">
                        <label for="bankTransfer" class="mb-0">
                            <span class="payment-icon">🏦</span>
                            <strong>Bank Transfer</strong>
                        </label>
                    </div>

                    <!-- Card Details (show only for Credit Card) -->
                    <div id="cardDetails" style="display: none; margin-top: 1.5rem;">
                        <div class="mb-3">
                            <label for="cardName" class="form-label">Cardholder Name</label>
                            <input type="text" class="form-control" id="cardName" name="cardName"
                                   placeholder="Name on card">
                        </div>
                        <div class="mb-3">
                            <label for="cardNumber" class="form-label">Card Number</label>
                            <input type="text" class="form-control" id="cardNumber" name="cardNumber"
                                   placeholder="1234 5678 9012 3456" maxlength="19">
                        </div>
                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label for="expiryDate" class="form-label">Expiry Date</label>
                                <input type="text" class="form-control" id="expiryDate" name="expiryDate"
                                       placeholder="MM/YY" maxlength="5">
                            </div>
                            <div class="col-md-6 mb-3">
                                <label for="cvv" class="form-label">CVV</label>
                                <input type="text" class="form-control" id="cvv" name="cvv"
                                       placeholder="123" maxlength="3">
                            </div>
                        </div>
                    </div>

                    <div class="alert alert-info mt-3">
                        <i class="bi bi-info-circle me-2"></i>
                        <small><strong>Note:</strong> Your payment will be marked as "Pending" until verified by our admin team.</small>
                    </div>
                </div>

                <a href="${pageContext.request.contextPath}/cart" class="btn-back-cart">
                    <i class="bi bi-arrow-left me-2"></i>Back to Cart
                </a>
            </div>

            <!-- Right Column - Order Summary -->
            <div class="col-lg-4">
                <div class="summary-card">
                    <h5><i class="bi bi-receipt me-2"></i>Order Summary</h5>

                    <!-- Order Items -->
                    <div class="mb-3">
                        <c:forEach var="entry" items="${cart}">
                            <c:set var="item" value="${entry.value}"/>
                            <div class="order-item">
                                <div>
                                    <div class="item-name">${item.instrumentName}</div>
                                    <div class="item-qty">Qty: ${item.quantity}</div>
                                </div>
                                <div class="item-price">
                                    $<fmt:formatNumber value="${item.subtotal}" pattern="#,##0.00"/>
                                </div>
                            </div>
                        </c:forEach>
                    </div>

                    <!-- Totals -->
                    <div class="summary-row">
                        <span class="summary-label">Subtotal:</span>
                        <span class="summary-value">
                            $<fmt:formatNumber value="${subtotal}" pattern="#,##0.00"/>
                        </span>
                    </div>

                    <div class="summary-row">
                        <span class="summary-label">Delivery Fee:</span>
                        <span class="summary-value">
                            $<fmt:formatNumber value="${deliveryFee}" pattern="#,##0.00"/>
                        </span>
                    </div>

                    <div class="summary-row total-row">
                        <span class="summary-label">Total:</span>
                        <span class="summary-value">
                            $<fmt:formatNumber value="${total}" pattern="#,##0.00"/>
                        </span>
                    </div>

                    <c:if test="${deliveryFee > 0}">
                        <div class="alert alert-warning mt-3">
                            <small><i class="bi bi-info-circle me-1"></i> Add $<fmt:formatNumber value="${500 - subtotal}" pattern="#,##0.00"/> more for free delivery!</small>
                        </div>
                    </c:if>

                    <button type="submit" class="btn btn-place-order">
                        <i class="bi bi-lock me-2"></i>Place Order
                    </button>

                    <div class="text-center mt-3">
                        <small class="text-muted">
                            <i class="bi bi-shield-check me-1"></i>Secure checkout
                        </small>
                    </div>
                </div>
            </div>
        </div>
    </form>
</div>

<!-- Bootstrap JS Bundle -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

<script>
    // Select payment method
    function selectPayment(method, element) {
        // Remove selected class from all
        document.querySelectorAll('.payment-method').forEach(el => {
            el.classList.remove('selected');
        });

        // Add selected class to clicked
        element.classList.add('selected');

        // Show/hide card details
        const cardDetails = document.getElementById('cardDetails');
        if (method === 'credit-card') {
            cardDetails.style.display = 'block';
            document.getElementById('cardName').required = true;
            document.getElementById('cardNumber').required = true;
        } else {
            cardDetails.style.display = 'none';
            document.getElementById('cardName').required = false;
            document.getElementById('cardNumber').required = false;
        }
    }

    // Format card number
    document.getElementById('cardNumber')?.addEventListener('input', function(e) {
        let value = e.target.value.replace(/\s/g, '');
        let formattedValue = value.match(/.{1,4}/g)?.join(' ') || value;
        e.target.value = formattedValue;
    });

    // Format expiry date
    document.getElementById('expiryDate')?.addEventListener('input', function(e) {
        let value = e.target.value.replace(/\D/g, '');
        if (value.length >= 2) {
            value = value.slice(0, 2) + '/' + value.slice(2, 4);
        }
        e.target.value = value;
    });

    // Only numbers for CVV
    document.getElementById('cvv')?.addEventListener('input', function(e) {
        e.target.value = e.target.value.replace(/\D/g, '');
    });

    // Form validation
    document.getElementById('checkoutForm').addEventListener('submit', function(e) {
        const paymentMethod = document.querySelector('input[name="paymentMethod"]:checked');
        if (!paymentMethod) {
            e.preventDefault();
            alert('Please select a payment method');
            return false;
        }

        if (paymentMethod.value === 'Credit Card') {
            const cardNumber = document.getElementById('cardNumber').value.replace(/\s/g, '');
            if (cardNumber.length < 13) {
                e.preventDefault();
                alert('Please enter a valid card number');
                return false;
            }
        }

        return confirm('Confirm order placement?\n\nTotal: $${total}');
    });
</script>
</body>
</html>