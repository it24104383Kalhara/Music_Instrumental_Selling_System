<%--
  Created by IntelliJ IDEA.
  User: vinod
  Date: 11/13/2025
  Time: 1:00 AM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Create Account - Musical Instruments Store</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
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
            background: var(--bg-light); /* Use the light background for the page */
        }

        /* Navigation Bar (from index.jsp) */
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

        /* NEW: Styles for the Registration Form */
        .register-section {
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding-top: 100px; /* Offset for fixed navbar */
            padding-bottom: 2rem;
        }

        .register-card {
            background: var(--white);
            border-radius: 15px;
            padding: 2.5rem;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
            width: 100%;
            max-width: 450px;
        }

        .register-title {
            color: var(--dark-brown);
            font-weight: 600;
            text-align: center;
            margin-bottom: 2rem;
        }

        .form-control {
            border-radius: 8px; /* This page's theme uses 8px radius */
            padding: 0.8rem 1rem;
            border: 1px solid #E0E0E0;
        }
        .form-control:focus {
            border-color: var(--primary-orange-soft);
            box-shadow: 0 0 0 0.25rem rgba(255, 140, 97, 0.25);
        }

        /* --- NEW CSS --- */
        /* This rule (from login.jsp) removes the right border and
           rounds only the left corners of an input inside an input-group */
        .input-group .form-control {
            border-right: none;
            border-radius: 8px 0 0 8px; /* Adapted to 8px */
        }

        .form-label {
            font-weight: 500;
            color: var(--text-dark);
        }

        .btn-register {
            background: linear-gradient(135deg, var(--primary-orange) 0%, var(--primary-orange-soft) 100%);
            color: white;
            border: none;
            padding: 0.8rem;
            font-weight: 600;
            border-radius: 8px;
            transition: all 0.3s ease;
            width: 100%;
            font-size: 1rem;
        }

        /* --- MODIFIED CSS --- */
        .password-toggle {
            background: var(--white);
            border: 1px solid #E0E0E0; /* CHANGED: To match the .form-control border */
            border-left: none;
            border-radius: 0 8px 8px 0; /* CHANGED: Was 10px, now 8px to match .form-control */
            color: var(--text-light);
            transition: all 0.3s ease;
        }
        /* --- END OF CSS CHANGES --- */

        .password-toggle:hover {
            background: var(--bg-light);
            border-color: var(--primary-orange-soft);
            color: var(--primary-orange);
        }

        .btn-register:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(255, 140, 97, 0.3);
            color: white;
        }

        .login-link {
            text-align: center;
            margin-top: 1.5rem;
            font-size: 0.9rem;
            color: var(--text-light);
        }
        .login-link a {
            color: var(--primary-orange);
            text-decoration: none;
            font-weight: 500;
        }
        .login-link a:hover {
            text-decoration: underline;
        }

    </style>
</head>
<body>

<nav class="navbar navbar-expand-lg">
    <div class="container">
        <a class="navbar-brand" href="${pageContext.request.contextPath}/">
            🎵 Musical Store
        </a>
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
            <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse justify-content-end" id="navbarNav">
            <ul class="navbar-nav">
                <li class="nav-item">
                    <a class="nav-link" href="${pageContext.request.contextPath}/#categories">Instruments</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="${pageContext.request.contextPath}/#features">Features</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="${pageContext.request.contextPath}/#about">About</a>
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

<section class="register-section">
    <div class="container">
        <div class="row justify-content-center">
            <div class="col-md-7 col-lg-5">
                <div class="register-card">
                    <h2 class="register-title">Create Your Account</h2>

                    <%-- Alert for error messages (same as before) --%>
                    <c:if test="${not empty errorMessage}">
                        <div class="alert alert-danger" role="alert">
                                ${errorMessage}
                        </div>
                    </c:if>

                    <form action="${pageContext.request.contextPath}/register" method="POST">
                        <div class="mb-3">
                            <label for="fullName" class="form-label">Full Name</label>
                            <input type="text" class="form-control" id="fullName" name="fullName" required>
                        </div>

                        <div class="mb-3">
                            <label for="email" class="form-label">Email Address</label>
                            <input type="email" class="form-control" id="email" name="email" required>
                        </div>

                        <div class="mb-3">
                            <label for="password" class="form-label">Password</label>
                            <div class="input-group">
                                <input type="password" class="form-control" id="password" name="password" required>
                                <button class="btn password-toggle" type="button" id="togglePassword" tabindex="-1">
                                    <i class="bi bi-eye" id="toggleIconPassword"></i>
                                </button>
                            </div>
                        </div>

                        <div class="mb-4">
                            <label for="confirmPassword" class="form-label">Confirm Password</label>
                            <div class="input-group">
                                <input type="password" class="form-control" id="confirmPassword" name="confirmPassword" required>
                                <button class="btn password-toggle" type="button" id="toggleConfirmPassword" tabindex="-1">
                                    <i class="bi bi-eye" id="toggleIconConfirm"></i>
                                </button>
                            </div>
                        </div>
                        <div class="d-grid">
                            <button type="submit" class="btn btn-register">Create Account</button>
                        </div>
                    </form>

                    <div class="login-link">
                        Already have an account?
                        <a href="${pageContext.request.contextPath}/login">Sign In</a>
                    </div>
                </div>
            </div>
        </div>
    </div>
</section>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

<script>
    // Password toggle visibility
    document.getElementById('togglePassword').addEventListener('click', function (e){
        e.preventDefault();
        const password = document.getElementById('password');
        const toggleIcon = document.getElementById('toggleIconPassword'); // Use unique ID
        const type = password.getAttribute('type') === 'password' ? 'text' : 'password';
        password.setAttribute('type', type);
        toggleIcon.classList.toggle('bi-eye');
        toggleIcon.classList.toggle('bi-eye-slash');
    });

    // --- NEW JAVASCRIPT ---
    // Added a second listener for the confirm password field
    document.getElementById('toggleConfirmPassword').addEventListener('click', function (e){
        e.preventDefault();
        const password = document.getElementById('confirmPassword');
        const toggleIcon = document.getElementById('toggleIconConfirm'); // Use unique ID
        const type = password.getAttribute('type') === 'password' ? 'text' : 'password';
        password.setAttribute('type', type);
        toggleIcon.classList.toggle('bi-eye');
        toggleIcon.classList.toggle('bi-eye-slash');
    });
</script>
</body>
</html>