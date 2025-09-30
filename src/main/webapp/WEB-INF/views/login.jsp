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
    <title>Login - Order Tracking System</title>
    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Bootstrap Icons -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
    <style>
        body {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            display: flex;
            align-items: center;
            position: relative;
            overflow: hidden;
        }

        /* Add the '+' pattern overlay - same as index page */
        body::before {
            content: '';
            position: absolute;
            width: 200%;
            height: 200%;
            top: -50%;
            left: -50%;
            background: url("data:image/svg+xml,%3Csvg width='60' height='60' viewBox='0 0 60 60' xmlns='http://www.w3.org/2000/svg'%3E%3Cg fill='none' fill-rule='evenodd'%3E%3Cg fill='%23ffffff' fill-opacity='0.05'%3E%3Cpath d='M36 34v-4h-2v4h-4v2h4v4h2v-4h4v-2h-4zm0-30V0h-2v4h-4v2h4v4h2V6h4V4h-4zM6 34v-4H4v4H0v2h4v4h2v-4h4v-2H6zM6 4V0H4v4H0v2h4v4h2V6h4V4H6z'/%3E%3C/g%3E%3C/g%3E%3C/svg%3E");
            z-index: 0;
        }

        /* Ensure container is above the pattern */
        .container {
            position: relative;
            z-index: 1;
        }

        .login-container {
            max-width: 400px;
            width: 100%;
            margin: 0 auto;
        }

        .login-card {
            border: none;
            border-radius: 15px;
            box-shadow: 0 10px 40px rgba(0,0,0,0.1);
            backdrop-filter: blur(10px);
            background: rgba(255, 255, 255, 0.98);
        }

        .login-header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border-radius: 15px 15px 0 0 !important;
            padding: 2rem;
            text-align: center;
        }

        .form-control:focus {
            border-color: #667eea;
            box-shadow: 0 0 0 0.2rem rgba(102, 126, 234, 0.25);
        }

        .btn-login {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border: none;
            padding: 12px;
            font-weight: 600;
            letter-spacing: 0.5px;
            transition: transform 0.2s;
        }

        .btn-login:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(102, 126, 234, 0.4);
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="login-container">
            <div class="card login-card">
                <div class="card-header login-header">
                    <i class="bi bi-box-seam fs-1 mb-3"></i>
                    <h3 class="mb-0">Order Tracking System</h3>
                </div>
                <div class="card-body p-4">
                    <h5 class="text-center mb-4 text-muted">Sign in to your account</h5>

                    <!-- Error message -->
                    <c:if test="${not empty error}">
                        <div class="alert alert-danger alert-dismissible fade show" role="alert">
                            <i class="bi bi-exclamation-triangle-fill me-2"></i>
                            ${error}
                            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                        </div>
                    </c:if>

                    <!-- Login Form -->
                    <form method="post" action="${pageContext.request.contextPath}/login" class="needs-validation" novalidate>
                        <!-- Email Field -->
                        <div class="mb-3">
                            <label for="email" class="form-label">
                                <i class="bi bi-envelope me-1"></i> Email Address
                            </label>
                            <input type="email"
                                class="form-control form-control-lg"
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
                                    class="form-control form-control-lg"
                                    id="password"
                                    name="password"
                                    placeholder="Enter your password"
                                    required>
                                <button class="btn btn-outline-secondary" type="button" id="togglePassword" tabindex="-1">
                                    <i class="bi bi-eye" id="toggleIcon"></i>
                                </button>
                            </div>
                            <div class="invalid-feedback">
                                Password is required.
                            </div>
                        </div>

                        <!-- Remember me Checkbox (optional) -->
                        <div class="mb-4 form-check">
                            <input type="checkbox" class="form-check-input" id="remember">
                            <label class="form-check-label" for="remember">
                                Remember me
                            </label>
                        </div>

                        <!-- Submit Button -->
                        <button type="submit" class="btn btn-primary btn-lg btn-login w-100">
                            <i class="bi bi-box-arrow-in-right me-2"></i> Sign In
                        </button>
                    </form>

                    <!-- Additional links (optional) -->
                    <div class="text-center mt-4">
                        <small class="text-muted">
                            <i class="bi bi-shield-check me-1"></i> Secure Login
                        </small>
                    </div>
                </div>
            </div>

            <!-- Footer Text -->
            <p class="text-center text-white mt-3">
                <small>© 2024 Order Tracking System</small>
            </p>
        </div>
    </div>

    <!-- Bootstrap JS Bundle -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

    <!-- Custom JavaScript for form validation and password toggle -->
    <script>
        //Bootstrap form validation
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

        //Password toggle visibility
        document.getElementById('togglePassword').addEventListener('click', function (e){
            e.preventDefault();

            const password = document.getElementById('password');
            const toggleIcon  = document.getElementById('toggleIcon');

            const type = password.getAttribute('type') === 'password' ? 'text' : 'password';
            password.setAttribute('type', type);

            //Toggle the icon
            toggleIcon.classList.toggle('bi-eye');
            toggleIcon.classList.toggle('bi-eye-slash');
        });
    </script>
</body>
</html>
