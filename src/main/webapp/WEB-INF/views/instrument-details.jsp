<%--
  Created by IntelliJ IDEA.
  User: vinod
  Date: 10/18/2025
  Time: 6:37 AM
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
    <title>${instrument.name} - Musical Instruments Store</title>

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

        /* Product Section */
        .product-card {
            background: var(--white);
            border-radius: 15px;
            box-shadow: 0 3px 10px rgba(0,0,0,0.08);
            padding: 2rem;
            margin-bottom: 2rem;
        }

        .product-icon {
            background: linear-gradient(135deg, var(--primary-cream) 0%, #FFDAB9 100%);
            height: 300px;
            border-radius: 15px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 10rem;
            margin-bottom: 2rem;
        }

        /* Product Image Styles */
        .product-image-container {
            position: relative;
            background: linear-gradient(135deg, var(--primary-cream) 0%, #FFDAB9 100%);
            height: 400px;
            border-radius: 15px;
            overflow: hidden;
            margin-bottom: 2rem;
        }

        .product-image {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }

        /* Move stock badge styles to be inside image container */
        .product-image-container .stock-badge {
            position: absolute;
            top: 15px;
            right: 15px;
            margin-bottom: 0;
        }

        .product-title {
            font-size: 2rem;
            font-weight: 700;
            color: var(--dark-brown);
            margin-bottom: 1rem;
        }

        .product-price {
            font-size: 2.5rem;
            font-weight: 700;
            color: var(--primary-orange);
            margin-bottom: 1.5rem;
        }

        .product-description {
            color: var(--text-dark);
            line-height: 1.8;
            margin-bottom: 2rem;
        }

        .stock-badge {
            display: inline-block;
            padding: 0.5rem 1rem;
            border-radius: 20px;
            font-weight: 600;
            margin-bottom: 1.5rem;
        }

        .stock-in {
            background: #E8F5E9;
            color: #4CAF50;
        }

        .stock-low {
            background: #FFF5E6;
            color: #F4A261;
        }

        .stock-out {
            background: #FFEBEE;
            color: #F44336;
        }

        .btn-add-to-cart {
            background: linear-gradient(135deg, var(--primary-orange) 0%, var(--primary-orange-soft) 100%);
            border: none;
            color: white;
            padding: 1rem 3rem;
            border-radius: 50px;
            font-weight: 600;
            font-size: 1.1rem;
            transition: all 0.3s ease;
        }

        .btn-add-to-cart:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 20px rgba(255, 140, 97, 0.3);
            color: white;
        }

        .btn-back {
            border: 2px solid var(--primary-orange);
            background: transparent;
            color: var(--primary-orange);
            padding: 0.75rem 2rem;
            border-radius: 50px;
            font-weight: 600;
            transition: all 0.3s ease;
            text-decoration: none;
        }

        .btn-back:hover {
            background: var(--primary-orange);
            color: white;
        }

        /* Reviews Section */
        .reviews-section {
            background: var(--white);
            border-radius: 15px;
            box-shadow: 0 3px 10px rgba(0,0,0,0.08);
            padding: 2rem;
        }

        .reviews-header {
            border-bottom: 2px solid var(--primary-cream);
            padding-bottom: 1.5rem;
            margin-bottom: 2rem;
        }

        .reviews-header h3 {
            color: var(--dark-brown);
            font-weight: 600;
            margin-bottom: 1rem;
        }

        .rating-summary {
            display: flex;
            align-items: center;
            gap: 1rem;
            margin-bottom: 1rem;
        }

        .avg-rating {
            font-size: 3rem;
            font-weight: 700;
            color: var(--primary-orange);
        }

        .rating-stars {
            font-size: 1.5rem;
            color: #FFD700;
        }

        .review-count {
            color: var(--text-light);
        }

        .review-item {
            border-bottom: 1px solid #F0F0F0;
            padding: 1.5rem 0;
        }

        .review-item:last-child {
            border-bottom: none;
        }

        .review-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 1rem;
        }

        .reviewer-name {
            font-weight: 600;
            color: var(--dark-brown);
        }

        .review-date {
            color: var(--text-light);
            font-size: 0.9rem;
        }

        .review-stars {
            color: #FFD700;
            font-size: 1.1rem;
            margin-bottom: 0.5rem;
        }

        .review-comment {
            color: var(--text-dark);
            line-height: 1.6;
        }

        .no-reviews {
            text-align: center;
            padding: 3rem;
            color: var(--text-light);
        }

        .no-reviews i {
            font-size: 4rem;
            color: var(--primary-orange-soft);
            opacity: 0.5;
            margin-bottom: 1rem;
        }

        .btn-write-review {
            background: var(--primary-cream);
            border: 2px solid var(--primary-orange);
            color: var(--primary-orange);
            padding: 0.75rem 2rem;
            border-radius: 50px;
            font-weight: 600;
            transition: all 0.3s ease;
            text-decoration: none;
            display: inline-block;
        }

        .btn-write-review:hover {
            background: var(--primary-orange);
            color: white;
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
                        <span class="cart-badge">0</span>
                    </a>
                </li>
                <c:choose>
                    <c:when test="${not empty sessionScope.userId}">
                        <li class="nav-item">
                            <a class="nav-link" href="${pageContext.request.contextPath}/dashboard">
                                <i class="bi bi-person-circle me-1"></i>${sessionScope.userName}
                            </a>
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

<!-- Main Content -->
<div class="container py-5">
    <div class="row">
        <!-- Product Details -->
        <div class="col-lg-6">
            <div class="product-card">
                <!-- Product Image -->
                <div class="product-image-container">
                    <img src="${pageContext.request.contextPath}/images/instruments/${instrument.id}.jpg"
                         alt="${instrument.name}"
                         class="product-image"
                         onerror="this.onerror=null; this.src='${pageContext.request.contextPath}/images/instruments/default.jpg';">

                    <!-- Stock Badge -->
                    <c:choose>
                        <c:when test="${instrument.stockQuantity > 10}">
            <span class="stock-badge stock-in">
                <i class="bi bi-check-circle me-1"></i>In Stock
            </span>
                        </c:when>
                        <c:when test="${instrument.stockQuantity > 0}">
            <span class="stock-badge stock-low">
                <i class="bi bi-exclamation-triangle me-1"></i>Only ${instrument.stockQuantity} left
            </span>
                        </c:when>
                        <c:otherwise>
            <span class="stock-badge stock-out">
                <i class="bi bi-x-circle me-1"></i>Out of Stock
            </span>
                        </c:otherwise>
                    </c:choose>
                </div>

                <h1 class="product-title">${instrument.name}</h1>

                <div class="product-price">
                    $<fmt:formatNumber value="${instrument.price}" pattern="#,##0.00"/>
                </div>

                <p class="product-description">
                    ${not empty instrument.description ? instrument.description : 'High-quality musical instrument perfect for musicians of all skill levels.'}
                </p>

                <div class="mb-4">
                    <c:choose>
                        <c:when test="${instrument.stockQuantity > 0}">
                            <button class="btn btn-add-to-cart" onclick="addToCart(${instrument.id}, '${fn:escapeXml(instrument.name)}')">
                                <i class="bi bi-cart-plus me-2"></i>Add to Cart
                            </button>
                        </c:when>
                        <c:otherwise>
                            <button class="btn btn-add-to-cart" disabled>
                                <i class="bi bi-x-circle me-2"></i>Out of Stock
                            </button>
                        </c:otherwise>
                    </c:choose>
                </div>

                <a href="${pageContext.request.contextPath}/shop" class="btn-back">
                    <i class="bi bi-arrow-left me-2"></i>Back to Shop
                </a>
            </div>
        </div>

        <!-- Reviews Section -->
        <div class="col-lg-6">
            <div class="reviews-section">
                <div class="reviews-header">
                    <h3><i class="bi bi-star-fill me-2" style="color: #FFD700;"></i>Customer Reviews</h3>

                    <c:if test="${reviewCount > 0}">
                        <div class="rating-summary">
                            <div class="avg-rating">
                                <fmt:formatNumber value="${avgRating}" pattern="#.#"/>
                            </div>
                            <div>
                                <div class="rating-stars">
                                    <c:forEach begin="1" end="5" var="i">
                                        <c:choose>
                                            <c:when test="${i <= avgRating}">⭐</c:when>
                                            <c:otherwise>☆</c:otherwise>
                                        </c:choose>
                                    </c:forEach>
                                </div>
                                <div class="review-count">Based on ${reviewCount} review(s)</div>
                            </div>
                        </div>
                    </c:if>

                    <c:if test="${canReview}">
                        <div class="mt-3">
                            <a href="${pageContext.request.contextPath}/reviews/my-reviews" class="btn-write-review">
                                <i class="bi bi-pencil me-2"></i>Write a Review
                            </a>
                        </div>
                    </c:if>
                </div>

                <!-- Reviews List -->
                <c:choose>
                    <c:when test="${empty reviews}">
                        <div class="no-reviews">
                            <i class="bi bi-chat-left-text"></i>
                            <p>No reviews yet. Be the first to review this instrument!</p>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <c:forEach var="review" items="${reviews}">
                            <div class="review-item">
                                <div class="review-header">
                                    <span class="reviewer-name">
                                        <i class="bi bi-person-circle me-2" style="color: var(--primary-orange);"></i>
                                        ${review.userName}
                                    </span>
                                    <span class="review-date">
                                        <fmt:parseDate value="${review.createdAt}" pattern="yyyy-MM-dd'T'HH:mm" var="parsedDate" type="both" />
                                        <fmt:formatDate value="${parsedDate}" pattern="MMM dd, yyyy"/>
                                    </span>
                                </div>
                                <div class="review-stars">
                                    <c:forEach begin="1" end="${review.rating}">⭐</c:forEach>
                                    <c:forEach begin="${review.rating + 1}" end="5">☆</c:forEach>
                                </div>
                                <p class="review-comment">${review.comment}</p>
                            </div>
                        </c:forEach>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
    function addToCart(instrumentId, instrumentName) {
        fetch('${pageContext.request.contextPath}/cart/add', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded',
            },
            body: 'instrumentId=' + instrumentId + '&quantity=1'
        })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    alert('✅ Added to cart!\n\n' + instrumentName + ' has been added to your cart.');
                    // Update cart badge if exists
                    const badge = document.querySelector('.cart-badge');
                    if (badge) {
                        badge.textContent = data.cartCount;
                    }
                } else {
                    alert('❌ Error\n\n' + data.message);
                }
            })
            .catch(error => {
                console.error('Error:', error);
                alert('Failed to add item to cart');
            });
    }
</script>
</body>
</html>