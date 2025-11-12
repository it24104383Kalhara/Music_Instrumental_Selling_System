<%--
  Created by IntelliJ IDEA.
  User: vinod
  Date: 8/31/2025
  Time: 9:30 AM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login - Musical Instruments Store</title>
    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Bootstrap Icons -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">

    <style>
        :root {
            /* Warm Musical Color Palette - Softer Version */
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
        }

        * {
            font-family: 'Poppins', sans-serif;
        }

        body {
            background: var(--bg-light);
            min-height: 100vh;
            display: flex;
            align-items: center;
            position: relative;
            overflow: hidden;
        }

        /* Subtle decorative elements */
        body::before {
            content: '';
            position: absolute;
            width: 500px;
            height: 500px;
            border-radius: 50%;
            background: linear-gradient(135deg, var(--primary-cream) 0%, var(--light-peach) 100%);
            top: -200px;
            right: -200px;
            opacity: 0.6;
        }

        body::after {
            content: '';
            position: absolute;
            width: 400px;
            height: 400px;
            border-radius: 50%;
            background: linear-gradient(135deg, var(--primary-cream) 0%, rgba(255, 218, 185, 0.3) 100%);
            bottom: -150px;
            left: -150px;
            opacity: 0.5;
        }

        /* Subtle music notes */
        .music-decoration {
            position: absolute;
            font-size: 1.5rem;
            opacity: 0.05;
            color: var(--primary-orange);
            animation: float 8s ease-in-out infinite;
        }

        .note-1 { top: 10%; left: 10%; animation-delay: 0s; }
        .note-2 { top: 20%; right: 10%; animation-delay: 2s; }
        .note-3 { bottom: 20%; left: 5%; animation-delay: 4s; }
        .note-4 { bottom: 10%; right: 15%; animation-delay: 6s; }

        @keyframes float {
            0%, 100% { transform: translateY(0) rotate(0deg); }
            50% { transform: translateY(-20px) rotate(10deg); }
        }

        .container {
            position: relative;
            z-index: 1;
        }

        .login-container {
            max-width: 420px;
            width: 100%;
            margin: 0 auto;
        }

        .login-card {
            border: none;
            border-radius: 20px;
            box-shadow: 0 10px 40px rgba(0,0,0,0.08);
            background: var(--white);
            overflow: hidden;
        }

        .login-header {
            background: linear-gradient(135deg, var(--primary-orange-soft) 0%, var(--accent-gold-soft) 100%);
            color: var(--dark-brown);
            padding: 2rem;
            text-align: center;
            position: relative;
        }

        .login-header::after {
            content: '';
            position: absolute;
            bottom: 0;
            left: 50%;
            transform: translateX(-50%);
            width: 60px;
            height: 3px;
            background: var(--primary-orange);
            border-radius: 2px;
        }

        .header-icon {
            font-size: 3rem;
            margin-bottom: 0.5rem;
            display: inline-block;
        }

        .login-header h3 {
            font-weight: 600;
            font-size: 1.5rem;
            margin-bottom: 0.25rem;
            color: var(--dark-brown);
        }

        .login-header p {
            font-size: 0.9rem;
            color: var(--text-dark);
            opacity: 0.8;
            margin: 0;
        }

        .card-body {
            padding: 2rem !important;
            background: var(--white);
        }

        .welcome-text {
            color: var(--dark-brown);
            font-weight: 600;
            margin-bottom: 0.5rem;
        }

        .form-label {
            color: var(--text-dark);
            font-weight: 500;
            font-size: 0.9rem;
            margin-bottom: 0.5rem;
        }

        .form-label i {
            color: var(--primary-orange);
            font-size: 0.9rem;
        }

        .form-control {
            border: 1.5px solid #E8E8E8;
            border-radius: 10px;
            padding: 12px 15px;
            font-size: 0.95rem;
            transition: all 0.3s ease;
            background: var(--white);
        }

        .form-control:focus {
            border-color: var(--primary-orange-soft);
            box-shadow: 0 0 0 3px rgba(255, 140, 97, 0.1);
            background: var(--white);
        }

        .input-group .form-control {
            border-right: none;
            border-radius: 10px 0 0 10px;
        }

        .password-toggle {
            background: var(--white);
            border: 1.5px solid #E8E8E8;
            border-left: none;
            border-radius: 0 10px 10px 0;
            color: var(--text-light);
            transition: all 0.3s ease;
        }

        .password-toggle:hover {
            background: var(--bg-light);
            border-color: var(--primary-orange-soft);
            color: var(--primary-orange);
        }

        .form-check-input:checked {
            background-color: var(--primary-orange);
            border-color: var(--primary-orange);
        }

        .form-check-input:focus {
            border-color: var(--primary-orange-soft);
            box-shadow: 0 0 0 0.2rem rgba(255, 140, 97, 0.15);
        }

        .form-check-label {
            font-size: 0.9rem;
        }

        .btn-login {
            background: linear-gradient(135deg, var(--primary-orange) 0%, var(--primary-orange-soft) 100%);
            border: none;
            border-radius: 10px;
            padding: 12px;
            font-weight: 600;
            letter-spacing: 0.3px;
            transition: all 0.3s ease;
            font-size: 1rem;
            color: white;
        }

        .btn-login:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(255, 140, 97, 0.3);
            background: linear-gradient(135deg, var(--primary-terracotta) 0%, var(--primary-orange) 100%);
        }

        .alert-danger {
            background: #FFF5F5;
            border: 1px solid #FFE0E0;
            color: #D32F2F;
            border-radius: 10px;
            font-size: 0.9rem;
        }

        .divider {
            text-align: center;
            margin: 1.5rem 0;
            position: relative;
        }

        .divider::before {
            content: '';
            position: absolute;
            top: 50%;
            left: 0;
            right: 0;
            height: 1px;
            background: #E8E8E8;
        }

        .divider span {
            background: var(--white);
            padding: 0 1rem;
            color: var(--text-light);
            position: relative;
            font-size: 0.85rem;
        }

        .register-link {
            color: var(--primary-orange);
            text-decoration: none;
            font-weight: 500;
            transition: color 0.3s ease;
        }

        .register-link:hover {
            color: var(--primary-terracotta);
            text-decoration: underline;
        }

        .footer-text {
            color: var(--text-light);
            font-size: 0.85rem;
        }

        .security-badge {
            font-size: 0.85rem;
            color: var(--text-light);
        }

        .security-badge i {
            color: var(--primary-orange);
        }
    </style>
</head>
<body>
<!-- Subtle music notes -->
<div class="music-decoration note-1">♪</div>
<div class="music-decoration note-2">♫</div>
<div class="music-decoration note-3">♪</div>
<div class="music-decoration note-4">♬</div>

<div class="container">
    <div class="login-container">
        <div class="card login-card">
            <div class="card-header login-header">
                <div class="header-icon">🎵</div>
                <h3>Musical Instruments Store</h3>
                <p>Your gateway to musical excellence</p>
            </div>
            <div class="card-body">
                <h5 class="welcome-text text-center mb-1">Welcome Back!</h5>
                <p class="text-center text-muted mb-4" style="font-size: 0.9rem;">Sign in to continue shopping</p>

                <!-- Error message -->
                <c:if test="${not empty error}">
                    <div class="alert alert-danger alert-dismissible fade show" role="alert">
                        <i class="bi bi-exclamation-circle me-2"></i>
                            ${error}
                        <button type="button" class="btn-close btn-sm" data-bs-dismiss="alert"></button>
                    </div>
                    <%-- This is important! It removes the message from the session  so it doesn't appear again on the next page load. --%>
                    <c:remove var="successMessage" scope="session" />
                </c:if>

                <!-- Login Form -->
                <form method="post" action="${pageContext.request.contextPath}/login" class="needs-validation" novalidate>
                    <!-- Email Field -->
                    <div class="mb-3">
                        <label for="email" class="form-label">
                            <i class="bi bi-envelope me-1"></i> Email Address
                        </label>
                        <input type="email"
                               class="form-control"
                               id="email"
                               name="email"
                               placeholder="Enter your email"
                               required>
                        <div class="invalid-feedback">
                            Please enter a valid email address.
                        </div>
                    </div>

                    <!-- Password Field -->
                    <div class="mb-4">
                        <label for="password" class="form-label">
                            <i class="bi bi-lock me-1"></i> Password
                        </label>
                        <div class="input-group">
                            <input type="password"
                                   class="form-control"
                                   id="password"
                                   name="password"
                                   placeholder="Enter your password"
                                   required>
                            <button class="btn password-toggle" type="button" id="togglePassword" tabindex="-1">
                                <i class="bi bi-eye" id="toggleIcon"></i>
                            </button>
                        </div>
                        <div class="invalid-feedback">
                            Password is required.
                        </div>
                    </div>

                    <!-- Remember me Checkbox -->
                    <div class="mb-4 form-check">
                        <input type="checkbox" class="form-check-input" id="remember">
                        <label class="form-check-label text-muted" for="remember">
                            Remember me
                        </label>
                    </div>

                    <!-- Submit Button -->
                    <button type="submit" class="btn btn-primary btn-lg btn-login w-100">
                        <i class="bi bi-box-arrow-in-right me-2"></i> Sign In
                    </button>
                </form>

                <!-- Divider -->
                <div class="divider">
                    <span>New to our store?</span>
                </div>

                <!-- Register Link -->
                <div class="text-center">
                    <p class="mb-0" style="font-size: 0.9rem;">
                        Don't have an account?
                        <a href="${pageContext.request.contextPath}/register" class="register-link">
                            Create Account
                        </a>
                    </p>
                </div>

                <!-- Security Badge -->
                <div class="text-center mt-4">
                    <small class="security-badge">
                        <i class="bi bi-shield-check me-1"></i>
                        Secure Login
                    </small>
                </div>
            </div>
        </div>

        <!-- Footer Text -->
        <p class="text-center footer-text mt-3">
            © 2024 Musical Instruments Store. All rights reserved.
        </p>
    </div>
</div>

<!-- Bootstrap JS Bundle -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

<!-- Custom JavaScript for form validation and password toggle -->
<script>
    // Bootstrap form validation
    (function () {
        'use strict';
        window.addEventListener('load', function () {
            var forms = document.getElementsByClassName('needs-validation');
            var validation = Array.prototype.filter.call(forms, function (form) {
                form.addEventListener('submit', function(event) {
                    if (form.checkValidity() === false) {
                        event.preventDefault();
                        event.stopPropagation();
                    }
                    form.classList.add('was-validated');
                }, false);
            });
        }, false);
    })();

    // Password toggle visibility
    document.getElementById('togglePassword').addEventListener('click', function (e){
        e.preventDefault();
        const password = document.getElementById('password');
        const toggleIcon = document.getElementById('toggleIcon');
        const type = password.getAttribute('type') === 'password' ? 'text' : 'password';
        password.setAttribute('type', type);
        toggleIcon.classList.toggle('bi-eye');
        toggleIcon.classList.toggle('bi-eye-slash');
    });
</script>
</body>
</html>