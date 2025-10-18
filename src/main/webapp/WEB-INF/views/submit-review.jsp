<%--
  Created by IntelliJ IDEA.
  User: vinod
  Date: 10/18/2025
  Time: 6:38 AM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Write a Review - Musical Instruments Store</title>

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
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .review-container {
            max-width: 600px;
            width: 100%;
            padding: 20px;
        }

        .review-card {
            background: var(--white);
            border-radius: 20px;
            box-shadow: 0 10px 40px rgba(0,0,0,0.1);
            padding: 2.5rem;
        }

        .review-header {
            text-align: center;
            margin-bottom: 2rem;
        }

        .review-header h2 {
            color: var(--dark-brown);
            font-weight: 700;
            margin-bottom: 0.5rem;
        }

        .review-header p {
            color: var(--text-light);
        }

        .form-label {
            color: var(--text-dark);
            font-weight: 600;
            margin-bottom: 0.5rem;
        }

        .form-control, .form-select {
            border: 2px solid #F0F0F0;
            border-radius: 10px;
            padding: 0.75rem;
            transition: all 0.3s ease;
        }

        .form-control:focus, .form-select:focus {
            border-color: var(--primary-orange-soft);
            box-shadow: 0 0 0 0.2rem rgba(255, 140, 97, 0.15);
        }

        /* Star Rating */
        .star-rating {
            display: flex;
            gap: 0.5rem;
            font-size: 2.5rem;
            margin-bottom: 1.5rem;
        }

        .star {
            cursor: pointer;
            color: #DDD;
            transition: all 0.2s ease;
        }

        .star:hover,
        .star.active {
            color: #FFD700;
            transform: scale(1.1);
        }

        .btn-submit {
            background: linear-gradient(135deg, var(--primary-orange) 0%, var(--primary-orange-soft) 100%);
            border: none;
            color: white;
            padding: 0.85rem;
            border-radius: 50px;
            font-weight: 600;
            width: 100%;
            transition: all 0.3s ease;
            margin-top: 1rem;
        }

        .btn-submit:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 20px rgba(255, 140, 97, 0.3);
            color: white;
        }

        .btn-cancel {
            border: 2px solid var(--primary-orange);
            background: transparent;
            color: var(--primary-orange);
            padding: 0.75rem;
            border-radius: 50px;
            font-weight: 600;
            width: 100%;
            transition: all 0.3s ease;
            text-decoration: none;
            display: block;
            text-align: center;
            margin-top: 1rem;
        }

        .btn-cancel:hover {
            background: var(--primary-orange);
            color: white;
        }

        .alert {
            border-radius: 10px;
            border: none;
        }
    </style>
</head>
<body>
<div class="review-container">
    <div class="review-card">
        <div class="review-header">
            <h2>⭐ Write a Review</h2>
            <p>Share your experience with this instrument</p>
        </div>

        <c:if test="${not empty error}">
            <div class="alert alert-danger">
                <i class="bi bi-exclamation-triangle me-2"></i>${error}
            </div>
        </c:if>

        <form action="${pageContext.request.contextPath}/reviews/submit" method="post" id="reviewForm">
            <input type="hidden" name="orderId" value="${orderId}">
            <input type="hidden" name="instrumentId" value="${instrumentId}">
            <input type="hidden" name="rating" id="ratingInput" value="5">

            <div class="mb-3">
                <label class="form-label">Order Number</label>
                <input type="text" class="form-control" value="${orderNumber}" readonly>
            </div>

            <div class="mb-4">
                <label class="form-label">Your Rating *</label>
                <div class="star-rating" id="starRating">
                    <span class="star active" data-rating="1">⭐</span>
                    <span class="star active" data-rating="2">⭐</span>
                    <span class="star active" data-rating="3">⭐</span>
                    <span class="star active" data-rating="4">⭐</span>
                    <span class="star active" data-rating="5">⭐</span>
                </div>
                <small class="text-muted">Click to rate (1-5 stars)</small>
            </div>

            <div class="mb-3">
                <label for="comment" class="form-label">Your Review *</label>
                <textarea class="form-control" id="comment" name="comment" rows="5"
                          required placeholder="Share your experience with this instrument..."></textarea>
                <small class="text-muted">Minimum 10 characters</small>
            </div>

            <button type="submit" class="btn btn-submit">
                <i class="bi bi-send me-2"></i>Submit Review
            </button>

            <a href="${pageContext.request.contextPath}/reviews/my-reviews" class="btn-cancel">
                <i class="bi bi-x-circle me-2"></i>Cancel
            </a>
        </form>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
    // Star rating functionality
    const stars = document.querySelectorAll('.star');
    const ratingInput = document.getElementById('ratingInput');
    let selectedRating = 5;

    stars.forEach(star => {
        star.addEventListener('click', function() {
            selectedRating = parseInt(this.getAttribute('data-rating'));
            ratingInput.value = selectedRating;

            // Update star display
            stars.forEach((s, index) => {
                if (index < selectedRating) {
                    s.classList.add('active');
                } else {
                    s.classList.remove('active');
                }
            });
        });

        star.addEventListener('mouseover', function() {
            const hoverRating = parseInt(this.getAttribute('data-rating'));
            stars.forEach((s, index) => {
                if (index < hoverRating) {
                    s.style.color = '#FFD700';
                } else {
                    s.style.color = '#DDD';
                }
            });
        });
    });

    document.getElementById('starRating').addEventListener('mouseleave', function() {
        stars.forEach((s, index) => {
            if (index < selectedRating) {
                s.style.color = '#FFD700';
            } else {
                s.style.color = '#DDD';
            }
        });
    });

    // Form validation
    document.getElementById('reviewForm').addEventListener('submit', function(e) {
        const comment = document.getElementById('comment').value.trim();

        if (comment.length < 10) {
            e.preventDefault();
            alert('Please write at least 10 characters in your review.');
            return false;
        }

        return confirm('Submit this review?');
    });
</script>
</body>
</html>