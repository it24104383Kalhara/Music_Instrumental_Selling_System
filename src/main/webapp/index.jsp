<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Welcome - Musical Instruments Store</title>

    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Bootstrap Icons -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">

    <style>
        :root {
            /* Softer Musical Color Palette */
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
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Poppins', sans-serif;
            overflow-x: hidden;
            background: var(--white);
        }

        /* Navigation Bar */
        .navbar {
            background: var(--white);
            box-shadow: 0 2px 10px rgba(0,0,0,0.05);
            padding: 1rem 0;
            position: fixed;
            width: 100%;
            top: 0;
            z-index: 1000;
        }

        .navbar-brand {
            color: var(--primary-orange) !important;
            font-weight: 600;
            font-size: 1.4rem;
        }

        .nav-link {
            color: var(--text-dark) !important;
            font-weight: 500;
            margin: 0 0.5rem;
            transition: color 0.3s;
            font-size: 0.95rem;
        }

        .nav-link:hover {
            color: var(--primary-orange) !important;
        }

        /* Hero Section - Softer */
        .hero-section {
            background: linear-gradient(135deg, var(--primary-cream) 0%, var(--bg-light) 100%);
            min-height: 100vh;
            display: flex;
            align-items: center;
            position: relative;
            overflow: hidden;
            margin-top: 70px;
        }

        /* Subtle decorative circles */
        .decorative-circle {
            position: absolute;
            border-radius: 50%;
            background: rgba(255, 140, 97, 0.05);
        }

        .circle-1 {
            width: 300px;
            height: 300px;
            top: -100px;
            right: -100px;
        }

        .circle-2 {
            width: 200px;
            height: 200px;
            bottom: -50px;
            left: -50px;
            background: rgba(244, 196, 48, 0.05);
        }

        .circle-3 {
            width: 150px;
            height: 150px;
            top: 50%;
            right: 20%;
            background: rgba(194, 120, 92, 0.05);
        }

        .hero-content {
            position: relative;
            z-index: 2;
        }

        .hero-title {
            font-size: 3rem;
            font-weight: 700;
            color: var(--dark-brown);
            margin-bottom: 1.5rem;
            animation: fadeInUp 0.8s ease;
        }

        .hero-title span {
            color: var(--primary-orange);
        }

        .hero-subtitle {
            font-size: 1.2rem;
            color: var(--text-dark);
            margin-bottom: 2rem;
            animation: fadeInUp 0.8s ease 0.2s;
            animation-fill-mode: both;
            line-height: 1.6;
        }

        .btn-hero {
            padding: 14px 40px;
            font-size: 1rem;
            font-weight: 600;
            border-radius: 50px;
            transition: all 0.3s ease;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            text-decoration: none;
        }

        .btn-hero-primary {
            background: linear-gradient(135deg, var(--primary-orange) 0%, var(--primary-orange-soft) 100%);
            color: white;
            border: none;
            box-shadow: 0 5px 15px rgba(255, 140, 97, 0.2);
        }

        .btn-hero-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 20px rgba(255, 140, 97, 0.3);
            color: white;
        }

        .btn-hero-outline {
            background: transparent;
            color: var(--primary-orange);
            border: 2px solid var(--primary-orange);
            margin-left: 1rem;
        }

        .btn-hero-outline:hover {
            background: var(--primary-orange);
            color: white;
            transform: translateY(-2px);
            box-shadow: 0 8px 20px rgba(255, 140, 97, 0.2);
        }

        /* Musical Illustration - Subtle */
        .hero-illustration {
            position: relative;
            font-size: 6rem;
            color: rgba(255, 140, 97, 0.15);
        }

        .instrument-icon {
            display: inline-block;
            margin: 0 0.5rem;
            animation: float 6s ease-in-out infinite;
        }

        .instrument-icon:nth-child(2) {
            animation-delay: 2s;
        }

        .instrument-icon:nth-child(3) {
            animation-delay: 4s;
        }

        /* Categories Section */
        .categories-section {
            padding: 80px 0;
            background: var(--white);
        }

        .section-title {
            color: var(--dark-brown);
            font-weight: 600;
            margin-bottom: 0.5rem;
        }

        .section-subtitle {
            color: var(--text-light);
            font-size: 1.1rem;
        }

        .category-card {
            background: var(--white);
            border-radius: 15px;
            padding: 30px;
            text-align: center;
            transition: all 0.3s ease;
            border: 1px solid #F0F0F0;
            height: 100%;
            cursor: pointer;
        }

        .category-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
            border-color: var(--primary-orange-soft);
        }

        .category-icon {
            width: 80px;
            height: 80px;
            margin: 0 auto 20px;
            background: var(--primary-cream);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 2.5rem;
            transition: all 0.3s ease;
        }

        .category-card:hover .category-icon {
            background: linear-gradient(135deg, var(--primary-orange-soft) 0%, var(--accent-gold-soft) 100%);
            transform: scale(1.1);
        }

        .category-title {
            color: var(--dark-brown);
            font-weight: 600;
            font-size: 1.2rem;
            margin-bottom: 10px;
        }

        .category-description {
            color: var(--text-light);
            font-size: 0.9rem;
        }

        /* Features Section */
        .features-section {
            padding: 80px 0;
            background: var(--bg-light);
        }

        .feature-card {
            background: white;
            border-radius: 12px;
            padding: 30px;
            text-align: center;
            transition: all 0.3s ease;
            border: none;
            height: 100%;
            box-shadow: 0 3px 10px rgba(0, 0, 0, 0.05);
        }

        .feature-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 8px 20px rgba(0, 0, 0, 0.1);
        }

        .feature-icon {
            width: 70px;
            height: 70px;
            margin: 0 auto 20px;
            background: linear-gradient(135deg, var(--primary-orange-soft) 0%, var(--accent-gold-soft) 100%);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.8rem;
            color: white;
        }

        .feature-title {
            color: var(--dark-brown);
            font-weight: 600;
            font-size: 1.1rem;
            margin-bottom: 10px;
        }

        /* Stats Section - Much Softer */
        .stats-section {
            background: linear-gradient(135deg, var(--primary-cream) 0%, var(--light-peach) 50%, var(--primary-cream) 100%);
            padding: 60px 0;
        }

        .stat-item {
            text-align: center;
            padding: 20px;
        }

        .stat-number {
            font-size: 2.5rem;
            font-weight: 700;
            margin-bottom: 10px;
            color: var(--primary-orange);
        }

        .stat-label {
            font-size: 1rem;
            color: var(--text-dark);
        }

        /* CTA Section */
        .cta-section {
            padding: 80px 0;
            background: var(--white);
        }

        .btn-cta {
            display: inline-block;
            padding: 16px 45px;
            font-size: 1rem;
            font-weight: 600;
            text-decoration: none;
            color: white;
            background: linear-gradient(135deg, var(--primary-orange) 0%, var(--primary-orange-soft) 100%);
            border-radius: 50px;
            transition: all 0.3s ease;
            box-shadow: 0 5px 15px rgba(255, 140, 97, 0.2);
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .btn-cta:hover {
            color: white;
            transform: translateY(-2px);
            box-shadow: 0 8px 20px rgba(255, 140, 97, 0.3);
        }

        /* Footer */
        .footer {
            background: var(--bg-light);
            color: var(--text-dark);
            padding: 40px 0 20px;
            border-top: 1px solid #F0F0F0;
        }

        .footer h5, .footer h6 {
            color: var(--primary-orange);
            font-weight: 600;
            margin-bottom: 1rem;
        }

        .footer-link {
            color: var(--text-light);
            text-decoration: none;
            transition: color 0.3s;
            font-size: 0.95rem;
        }

        .footer-link:hover {
            color: var(--primary-orange);
        }

        .footer-bottom {
            border-top: 1px solid #E8E8E8;
            margin-top: 2rem;
            padding-top: 2rem;
            color: var(--text-light);
            font-size: 0.9rem;
        }

        /* Back to Top Button */
        .back-to-top {
            position: fixed;
            bottom: 30px;
            right: 30px;
            width: 50px;
            height: 50px;
            background: linear-gradient(135deg, var(--primary-orange) 0%, var(--primary-orange-soft) 100%);
            border: none;
            border-radius: 50%;
            color: white;
            font-size: 20px;
            cursor: pointer;
            opacity: 0;
            visibility: hidden;
            transition: all 0.3s ease;
            z-index: 1000;
            box-shadow: 0 4px 15px rgba(255, 140, 97, 0.3);
        }

        .back-to-top:hover {
            transform: translateY(-5px);
            box-shadow: 0 6px 20px rgba(255, 140, 97, 0.4);
        }

        .back-to-top.show {
            opacity: 1;
            visibility: visible;
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
            0%, 100% { transform: translateY(0) rotate(0deg); }
            50% { transform: translateY(-20px) rotate(5deg); }
        }

        /* Responsive */
        @media (max-width: 768px) {
            .hero-title {
                font-size: 2.2rem;
            }
            .hero-subtitle {
                font-size: 1rem;
            }
            .btn-hero {
                padding: 12px 30px;
                font-size: 0.9rem;
            }
            .hero-illustration {
                font-size: 4rem;
            }
        }
    </style>
</head>
<body>
<!-- Navigation -->
<nav class="navbar navbar-expand-lg">
    <div class="container">
        <a class="navbar-brand" href="#">
            🎵 Musical Store
        </a>
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
            <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse justify-content-end" id="navbarNav">
            <ul class="navbar-nav">
                <li class="nav-item">
                    <a class="nav-link" href="#categories">Instruments</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="#features">Features</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="#about">About</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="${pageContext.request.contextPath}/login">
                        <i class="bi bi-person-circle"></i> Login
                    </a>
                </li>
            </ul>
        </div>
    </div>
</nav>

<!-- Hero Section -->
<section class="hero-section">
    <!-- Subtle decorative circles -->
    <div class="decorative-circle circle-1"></div>
    <div class="decorative-circle circle-2"></div>
    <div class="decorative-circle circle-3"></div>

    <div class="container">
        <div class="row align-items-center min-vh-100">
            <div class="col-lg-6 hero-content">
                <h1 class="hero-title">
                    Find Your Perfect<br>
                    <span>Musical Instrument</span>
                </h1>
                <p class="hero-subtitle">
                    Discover premium quality instruments from guitars to pianos.
                    Start your musical journey with the perfect companion from our carefully curated collection.
                </p>
                <div class="hero-buttons">
                    <a href="${pageContext.request.contextPath}/shop" class="btn btn-hero btn-hero-primary">
                        <i class="bi bi-music-note-beamed me-2"></i>Shop Now
                    </a>
                    <a href="#categories" class="btn btn-hero btn-hero-outline">
                        Browse Catalog
                    </a>
                </div>

                <div class="mt-5">
                    <small style="color: var(--text-light);">
                        <i class="bi bi-shield-check me-2" style="color: var(--primary-orange);"></i>
                        Authentic Instruments • Free Shipping • Expert Support
                    </small>
                </div>
            </div>

            <div class="col-lg-6 text-center">
                <div class="hero-illustration">
                    <span class="instrument-icon">🎸</span>
                    <span class="instrument-icon">🎹</span>
                    <span class="instrument-icon">🎻</span>
                </div>
            </div>
        </div>
    </div>
</section>

<!-- Categories Section -->
<section id="categories" class="categories-section">
    <div class="container">
        <div class="text-center mb-5">
            <h2 class="display-5 section-title">Explore Our Collection</h2>
            <p class="section-subtitle">Quality instruments for every musician</p>
        </div>

        <div class="row g-4">
            <div class="col-md-4">
                <div class="category-card">
                    <div class="category-icon">🎸</div>
                    <h4 class="category-title">Guitars</h4>
                    <p class="category-description">
                        Acoustic, Electric & Bass guitars from top brands
                    </p>
                </div>
            </div>

            <div class="col-md-4">
                <div class="category-card">
                    <div class="category-icon">🎹</div>
                    <h4 class="category-title">Keyboards & Pianos</h4>
                    <p class="category-description">
                        Digital pianos, synthesizers & MIDI keyboards
                    </p>
                </div>
            </div>

            <div class="col-md-4">
                <div class="category-card">
                    <div class="category-icon">🥁</div>
                    <h4 class="category-title">Drums & Percussion</h4>
                    <p class="category-description">
                        Drum sets, percussion instruments & accessories
                    </p>
                </div>
            </div>

            <div class="col-md-4">
                <div class="category-card">
                    <div class="category-icon">🎻</div>
                    <h4 class="category-title">String Instruments</h4>
                    <p class="category-description">
                        Violins, cellos, harps & traditional strings
                    </p>
                </div>
            </div>

            <div class="col-md-4">
                <div class="category-card">
                    <div class="category-icon">🎺</div>
                    <h4 class="category-title">Wind Instruments</h4>
                    <p class="category-description">
                        Flutes, saxophones, trumpets & more
                    </p>
                </div>
            </div>

            <div class="col-md-4">
                <div class="category-card">
                    <div class="category-icon">🎵</div>
                    <h4 class="category-title">Accessories</h4>
                    <p class="category-description">
                        Strings, picks, cases & maintenance tools
                    </p>
                </div>
            </div>
        </div>
    </div>
</section>

<!-- Features Section -->
<section id="features" class="features-section">
    <div class="container">
        <div class="text-center mb-5">
            <h2 class="display-5 section-title">Why Choose Us?</h2>
            <p class="section-subtitle">Your trusted partner in musical excellence</p>
        </div>

        <div class="row g-4">
            <div class="col-md-4">
                <div class="feature-card">
                    <div class="feature-icon">
                        <i class="bi bi-award"></i>
                    </div>
                    <h4 class="feature-title">Premium Quality</h4>
                    <p class="text-muted">
                        Carefully selected instruments from renowned manufacturers
                    </p>
                </div>
            </div>

            <div class="col-md-4">
                <div class="feature-card">
                    <div class="feature-icon">
                        <i class="bi bi-truck"></i>
                    </div>
                    <h4 class="feature-title">Free Shipping</h4>
                    <p class="text-muted">
                        Free delivery on orders above $500 with safe packaging
                    </p>
                </div>
            </div>

            <div class="col-md-4">
                <div class="feature-card">
                    <div class="feature-icon">
                        <i class="bi bi-headset"></i>
                    </div>
                    <h4 class="feature-title">Expert Support</h4>
                    <p class="text-muted">
                        Get advice from professional musicians and technicians
                    </p>
                </div>
            </div>

            <div class="col-md-4">
                <div class="feature-card">
                    <div class="feature-icon">
                        <i class="bi bi-shield-check"></i>
                    </div>
                    <h4 class="feature-title">Warranty</h4>
                    <p class="text-muted">
                        Comprehensive warranty and easy return policy
                    </p>
                </div>
            </div>

            <div class="col-md-4">
                <div class="feature-card">
                    <div class="feature-icon">
                        <i class="bi bi-credit-card"></i>
                    </div>
                    <h4 class="feature-title">Secure Payment</h4>
                    <p class="text-muted">
                        Multiple payment options with secure checkout
                    </p>
                </div>
            </div>

            <div class="col-md-4">
                <div class="feature-card">
                    <div class="feature-icon">
                        <i class="bi bi-tools"></i>
                    </div>
                    <h4 class="feature-title">Setup Service</h4>
                    <p class="text-muted">
                        Professional instrument setup and maintenance
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
                    <div class="stat-number">500+</div>
                    <div class="stat-label">Instruments</div>
                </div>
            </div>
            <div class="col-md-3 col-6">
                <div class="stat-item">
                    <div class="stat-number">1000+</div>
                    <div class="stat-label">Happy Customers</div>
                </div>
            </div>
            <div class="col-md-3 col-6">
                <div class="stat-item">
                    <div class="stat-number">50+</div>
                    <div class="stat-label">Brands</div>
                </div>
            </div>
            <div class="col-md-3 col-6">
                <div class="stat-item">
                    <div class="stat-number">5⭐</div>
                    <div class="stat-label">Rating</div>
                </div>
            </div>
        </div>
    </div>
</section>

<!-- Call to Action -->
<section class="cta-section">
    <div class="container text-center">
        <h2 class="display-5 section-title mb-4">Ready to Start Your Musical Journey?</h2>
        <p class="section-subtitle mb-4">Browse our collection and find your perfect instrument today</p>
        <a href="${pageContext.request.contextPath}/login" class="btn-cta">
            <i class="bi bi-music-note-beamed me-2"></i>
            Start Shopping
        </a>
    </div>
</section>

<!-- Footer -->
<footer class="footer">
    <div class="container">
        <div class="row">
            <div class="col-md-4 mb-4">
                <h5>🎵 Musical Store</h5>
                <p class="mt-3" style="color: var(--text-light); font-size: 0.95rem;">
                    Your trusted destination for quality musical instruments since 2024.
                </p>
            </div>
            <div class="col-md-4 mb-4">
                <h6>Quick Links</h6>
                <ul class="list-unstyled mt-3">
                    <li class="mb-2"><a href="#" class="footer-link">About Us</a></li>
                    <li class="mb-2"><a href="#" class="footer-link">Contact</a></li>
                    <li class="mb-2"><a href="#" class="footer-link">Terms & Conditions</a></li>
                </ul>
            </div>
            <div class="col-md-4 mb-4">
                <h6>Contact Info</h6>
                <p class="mt-3" style="color: var(--text-light); font-size: 0.95rem;">
                    <i class="bi bi-envelope me-2"></i> info@musicalstore.com<br>
                    <i class="bi bi-phone me-2"></i> +1 234 567 890
                </p>
            </div>
        </div>
        <div class="footer-bottom text-center">
            © 2024 Musical Instruments Store. All rights reserved.
        </div>
    </div>
</footer>

<!-- Back to Top Button -->
<button id="backToTop" class="back-to-top">
    <i class="bi bi-arrow-up"></i>
</button>

<!-- Bootstrap JS Bundle -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

<!-- Custom Scripts -->
<script>
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

    // Back to top button
    const backToTopButton = document.getElementById('backToTop');

    window.addEventListener('scroll', function() {
        if (window.scrollY > 300) {
            backToTopButton.classList.add('show');
        } else {
            backToTopButton.classList.remove('show');
        }
    });

    backToTopButton.addEventListener('click', function() {
        window.scrollTo({
            top: 0,
            behavior: 'smooth'
        });
    });
</script>
</body>
</html>