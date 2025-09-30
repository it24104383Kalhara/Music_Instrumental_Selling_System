<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Welcome - Order Tracking System</title>

    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Bootstrap Icons -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">

    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            overflow-x: hidden;
        }

        /* Hero Section */
        .hero-section {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            display: flex;
            align-items: center;
            position: relative;
            overflow: hidden;
        }

        .hero-section::before {
            content: '';
            position: absolute;
            width: 200%;
            height: 200%;
            top: -50%;
            left: -50%;
            background: url("data:image/svg+xml,%3Csvg width='60' height='60' viewBox='0 0 60 60' xmlns='http://www.w3.org/2000/svg'%3E%3Cg fill='none' fill-rule='evenodd'%3E%3Cg fill='%23ffffff' fill-opacity='0.05'%3E%3Cpath d='M36 34v-4h-2v4h-4v2h4v4h2v-4h4v-2h-4zm0-30V0h-2v4h-4v2h4v4h2V6h4V4h-4zM6 34v-4H4v4H0v2h4v4h2v-4h4v-2H6zM6 4V0H4v4H0v2h4v4h2V6h4V4H6z'/%3E%3C/g%3E%3C/g%3E%3C/svg%3E");
        }

        .hero-content {
            position: relative;
            z-index: 2;
        }

        .hero-title {
            font-size: 3.5rem;
            font-weight: 700;
            color: white;
            margin-bottom: 1.5rem;
            animation: fadeInUp 0.8s ease;
        }

        .hero-subtitle {
            font-size: 1.25rem;
            color: rgba(255, 255, 255, 0.9);
            margin-bottom: 2rem;
            animation: fadeInUp 0.8s ease 0.2s;
            animation-fill-mode: both;
        }

        .hero-buttons {
            animation: fadeInUp 0.8s ease 0.4s;
            animation-fill-mode: both;
        }

        .btn-hero {
            padding: 14px 40px;
            font-size: 1.1rem;
            font-weight: 600;
            border-radius: 50px;
            transition: all 0.3s ease;
            text-transform: uppercase;
            letter-spacing: 1px;
        }

        .btn-hero-primary {
            background: white;
            color: #667eea;
            border: none;
        }

        .btn-hero-primary:hover {
            background: #f8f9fa;
            color: #667eea;
            transform: translateY(-2px);
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.2);
        }

        .btn-hero-outline {
            background: transparent;
            color: white;
            border: 2px solid white;
        }

        .btn-hero-outline:hover {
            background: white;
            color: #667eea;
            transform: translateY(-2px);
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.2);
        }

        /* Features Section */
        .features-section {
            padding: 80px 0;
            background: #f8f9fa;
        }

        .feature-card {
            background: white;
            border-radius: 15px;
            padding: 30px;
            text-align: center;
            transition: all 0.3s ease;
            border: none;
            height: 100%;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1);
        }

        .feature-card:hover {
            transform: translateY(-10px);
            box-shadow: 0 15px 40px rgba(0, 0, 0, 0.15);
        }

        .feature-icon {
            width: 80px;
            height: 80px;
            margin: 0 auto 20px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 2rem;
            color: white;
        }

        /* Stats Section */
        .stats-section {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            padding: 60px 0;
            color: white;
        }

        .stat-item {
            text-align: center;
            padding: 20px;
        }

        .stat-number {
            font-size: 3rem;
            font-weight: 700;
            margin-bottom: 10px;
        }

        .stat-label {
            font-size: 1.1rem;
            opacity: 0.9;
        }

        /* Animations */
        @keyframes fadeInUp {
            from {
                opacity: 0;
                transform: translateY(30px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        @keyframes float {
            0%, 100% { transform: translateY(0); }
            50% { transform: translateY(-20px); }
        }

        .floating {
            animation: float 6s ease-in-out infinite;
        }

        /* Responsive */
        @media (max-width: 768px) {
            .hero-title {
                font-size: 2.5rem;
            }
            .hero-subtitle {
                font-size: 1.1rem;
            }
            .btn-hero {
                padding: 12px 30px;
                font-size: 1rem;
            }
        }
        /* Enhanced CTA Button */
        /* Enhanced CTA Button */
        .btn-cta-login {
            display: inline-block;
            padding: 18px 50px;
            font-size: 1.2rem;
            font-weight: 600;
            text-decoration: none;
            color: white;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border-radius: 50px;
            position: relative;
            overflow: hidden;
            transition: all 0.3s ease;
            box-shadow: 0 4px 15px rgba(102, 126, 234, 0.4);
            text-transform: uppercase;
            letter-spacing: 1px;
        }

        .btn-cta-login:hover {
            color: white;
            transform: translateY(-3px);
            box-shadow: 0 8px 25px rgba(102, 126, 234, 0.6);
        }

        .btn-cta-login::before {
            content: '';
            position: absolute;
            top: 0;
            left: -100%;
            width: 100%;
            height: 100%;
            background: linear-gradient(90deg, transparent, rgba(255, 255, 255, 0.3), transparent);
            transition: left 0.5s ease;
        }

        .btn-cta-login:hover::before {
            left: 100%;
        }

        .btn-cta-login i {
            display: inline-block;
            transition: transform 0.3s ease;
        }

        .btn-cta-login:hover i {
            transform: translateX(5px);
        }
        /* Back to Top Button */
        .back-to-top {
            position: fixed;
            bottom: 30px;
            right: 30px;
            width: 50px;
            height: 50px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border: none;
            border-radius: 50%;
            color: white;
            font-size: 20px;
            cursor: pointer;
            opacity: 0;
            visibility: hidden;
            transition: all 0.3s ease;
            z-index: 1000;
            box-shadow: 0 4px 15px rgba(102, 126, 234, 0.4);
        }

        .back-to-top:hover {
            transform: translateY(-5px);
            box-shadow: 0 6px 20px rgba(102, 126, 234, 0.6);
        }

        .back-to-top:active {
            transform: translateY(-2px);
        }

        .back-to-top.show {
            opacity: 1;
            visibility: visible;
        }

        /* Pulse animation on hover */
        .back-to-top:hover i {
            animation: bounce 0.5s ease infinite;
        }

        @keyframes bounce {
            0%, 100% { transform: translateY(0); }
            50% { transform: translateY(-5px); }
        }

        /* Mobile responsive */
        @media (max-width: 768px) {
            .back-to-top {
                bottom: 20px;
                right: 20px;
                width: 45px;
                height: 45px;
                font-size: 18px;
            }
        }
    </style>
</head>
<body>
<!-- Hero Section -->
<section class="hero-section">
    <div class="container">
        <div class="row align-items-center min-vh-100">
            <div class="col-lg-6 hero-content">
                <h1 class="hero-title">
                    Track Your Orders<br>
                    <span style="color: rgba(255, 255, 255, 0.9);">Effortlessly</span>
                </h1>
                <p class="hero-subtitle">
                    Welcome to our Order Tracking System. Monitor your shipments in real-time,
                    get instant updates, and manage all your orders in one place.
                </p>
                <div class="hero-buttons">
                    <a href="${pageContext.request.contextPath}/login" class="btn btn-hero btn-hero-primary me-3">
                        <i class="bi bi-box-arrow-in-right me-2"></i>Login Now
                    </a>
                    <a href="#features" class="btn btn-hero btn-hero-outline">
                        Learn More
                    </a>
                </div>

                <div class="mt-5">
                    <small class="text-white opacity-75">
                        <i class="bi bi-shield-check me-2"></i>Secure & Reliable Tracking System
                    </small>
                </div>
            </div>

            <div class="col-lg-6 text-center">
                <div class="floating">
                    <i class="bi bi-box-seam" style="font-size: 15rem; color: rgba(255, 255, 255, 0.1);"></i>
                </div>
            </div>
        </div>
    </div>
</section>

<!-- Features Section -->
<section id="features" class="features-section">
    <div class="container">
        <div class="text-center mb-5">
            <h2 class="display-5 fw-bold">Why Choose Our System?</h2>
            <p class="lead text-muted">Everything you need to manage and track your orders efficiently</p>
        </div>

        <div class="row g-4">
            <div class="col-md-4">
                <div class="feature-card">
                    <div class="feature-icon">
                        <i class="bi bi-lightning-charge"></i>
                    </div>
                    <h4>Real-Time Tracking</h4>
                    <p class="text-muted">
                        Get instant updates on your order status with our live tracking system
                    </p>
                </div>
            </div>

            <div class="col-md-4">
                <div class="feature-card">
                    <div class="feature-icon">
                        <i class="bi bi-graph-up"></i>
                    </div>
                    <h4>Detailed Analytics</h4>
                    <p class="text-muted">
                        View comprehensive statistics and insights about your order history
                    </p>
                </div>
            </div>

            <div class="col-md-4">
                <div class="feature-card">
                    <div class="feature-icon">
                        <i class="bi bi-shield-lock"></i>
                    </div>
                    <h4>Secure Platform</h4>
                    <p class="text-muted">
                        Your data is protected with enterprise-grade security measures
                    </p>
                </div>
            </div>

            <div class="col-md-4">
                <div class="feature-card">
                    <div class="feature-icon">
                        <i class="bi bi-clock-history"></i>
                    </div>
                    <h4>Order History</h4>
                    <p class="text-muted">
                        Access your complete order history anytime, anywhere
                    </p>
                </div>
            </div>

            <div class="col-md-4">
                <div class="feature-card">
                    <div class="feature-icon">
                        <i class="bi bi-bell"></i>
                    </div>
                    <h4>Smart Notifications</h4>
                    <p class="text-muted">
                        Receive timely alerts about your order status changes
                    </p>
                </div>
            </div>

            <div class="col-md-4">
                <div class="feature-card">
                    <div class="feature-icon">
                        <i class="bi bi-headset"></i>
                    </div>
                    <h4>24/7 Support</h4>
                    <p class="text-muted">
                        Our support team is always ready to help you
                    </p>
                </div>
            </div>
        </div>
    </div>
</section>

<!-- Stats Section -->
<section class="stats-section">
    <div class="container">
        <div class="row">
            <div class="col-md-3 col-6">
                <div class="stat-item">
                    <div class="stat-number">20+</div>
                    <div class="stat-label">Active Users</div>
                </div>
            </div>
            <div class="col-md-3 col-6">
                <div class="stat-item">
                    <div class="stat-number">100+</div>
                    <div class="stat-label">Orders Tracked</div>
                </div>
            </div>
            <div class="col-md-3 col-6">
                <div class="stat-item">
                    <div class="stat-number">99.9%</div>
                    <div class="stat-label">Uptime</div>
                </div>
            </div>
            <div class="col-md-3 col-6">
                <div class="stat-item">
                    <div class="stat-number">24/7</div>
                    <div class="stat-label">Support</div>
                </div>
            </div>
        </div>
    </div>
</section>

<!-- Call to Action -->
<section class="py-5 bg-light">
    <div class="container text-center">
        <h2 class="display-5 fw-bold mb-4">Ready to Get Started?</h2>
        <p class="lead text-muted mb-4">Join thousands of users who trust our platform for order tracking</p>
        <a href="${pageContext.request.contextPath}/login" class="btn-cta-login">
            <i class="bi bi-box-arrow-in-right me-2"></i>
            <span>Login to Your Account</span>
        </a>
    </div>
</section>

<!-- Footer -->
<footer class="bg-dark text-white py-4">
    <div class="container text-center">
        <p class="mb-0">© 2024 Order Tracking System. All rights reserved.</p>
    </div>
</footer>

<!-- Back to Top Button -->
<button id="backToTop" class="back-to-top">
    <i class="bi bi-arrow-up"></i>
</button>
<!-- Bootstrap JS Bundle -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

<!-- Smooth Scroll -->
<script>
    document.querySelectorAll('a[href^="#"]').forEach(anchor => {
        anchor.addEventListener('click', function (e) {
            e.preventDefault();
            const target = document.querySelector(this.getAttribute('href'));
            if (target) {
                target.scrollIntoView({ behavior: 'smooth' });
            }
        });
    });
    // Back to Top Button Functionality
    document.addEventListener('DOMContentLoaded', function() {
        const backToTopButton = document.getElementById('backToTop');

        // Show button when scrolled down 300px
        window.addEventListener('scroll', function() {
            if (window.scrollY > 300) {
                backToTopButton.classList.add('show');
            } else {
                backToTopButton.classList.remove('show');
            }
        });

        // Smooth scroll to top when clicked
        backToTopButton.addEventListener('click', function() {
            window.scrollTo({
                top: 0,
                behavior: 'smooth'
            });
        });
    });
</script>
</body>
</html>