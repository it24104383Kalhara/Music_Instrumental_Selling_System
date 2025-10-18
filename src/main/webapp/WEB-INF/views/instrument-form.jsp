<%--
  Created by IntelliJ IDEA.
  User: vinod
  Date: 10/18/2025
  Time: 12:44 PM
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
    <title>${mode == 'edit' ? 'Edit' : 'Add'} Instrument - Staff Dashboard</title>

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
            --staff-purple: #9C27B0;
            --staff-purple-soft: #BA68C8;
        }

        * {
            font-family: 'Poppins', sans-serif;
        }

        body {
            background-color: var(--bg-light);
            min-height: 100vh;
            display: flex;
            flex-direction: column;
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

        .navbar .nav-link.active {
            color: var(--primary-orange) !important;
            background: var(--primary-cream);
        }

        .staff-badge {
            background: linear-gradient(135deg, var(--staff-purple) 0%, var(--staff-purple-soft) 100%);
            color: white;
            padding: 0.3rem 0.8rem;
            border-radius: 20px;
            font-size: 0.75rem;
            font-weight: 600;
            margin-left: 0.5rem;
            text-transform: uppercase;
        }

        /* Form Container */
        .form-container {
            flex: 1;
            display: flex;
            align-items: center;
            padding: 3rem 0;
        }

        .form-card {
            background: var(--white);
            border-radius: 20px;
            box-shadow: 0 10px 40px rgba(0,0,0,0.1);
            max-width: 700px;
            width: 100%;
            margin: 0 auto;
            overflow: hidden;
        }

        .form-header {
            background: linear-gradient(135deg, var(--staff-purple) 0%, var(--staff-purple-soft) 100%);
            padding: 2.5rem 2rem;
            color: white;
            text-align: center;
        }

        .form-header h2 {
            font-weight: 700;
            margin-bottom: 0.5rem;
        }

        .form-header p {
            margin: 0;
            opacity: 0.9;
        }

        .form-header .icon {
            font-size: 3rem;
            margin-bottom: 1rem;
        }

        .form-body {
            padding: 2.5rem 2rem;
        }

        /* Form Elements */
        .form-label {
            color: var(--text-dark);
            font-weight: 600;
            margin-bottom: 0.5rem;
        }

        .required {
            color: #F44336;
        }

        .form-control, .form-select {
            border: 2px solid #F0F0F0;
            border-radius: 10px;
            padding: 0.75rem 1rem;
            transition: all 0.3s ease;
            font-size: 0.95rem;
        }

        .form-control:focus, .form-select:focus {
            border-color: var(--staff-purple-soft);
            box-shadow: 0 0 0 0.2rem rgba(156, 39, 176, 0.15);
        }

        .form-text {
            color: var(--text-light);
            font-size: 0.85rem;
        }

        /* Stock Preview */
        .stock-preview {
            background: #F3E5F5;
            border-radius: 10px;
            padding: 1rem;
            margin-top: 0.5rem;
            display: none;
        }

        .stock-preview.show {
            display: block;
        }

        .stock-status {
            font-weight: 600;
            font-size: 1rem;
        }

        .status-instock { color: #4CAF50; }
        .status-lowstock { color: #F4A261; }
        .status-outstock { color: #F44336; }

        /* Buttons */
        .btn-submit {
            background: linear-gradient(135deg, var(--staff-purple) 0%, var(--staff-purple-soft) 100%);
            border: none;
            color: white;
            padding: 0.85rem;
            border-radius: 50px;
            font-weight: 600;
            width: 100%;
            transition: all 0.3s ease;
            margin-top: 1.5rem;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .btn-submit:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 20px rgba(156, 39, 176, 0.3);
            color: white;
        }

        .btn-cancel {
            border: 2px solid var(--staff-purple);
            background: transparent;
            color: var(--staff-purple);
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
            background: var(--staff-purple);
            color: white;
        }

        /* Alert */
        .alert {
            border-radius: 10px;
            border: none;
        }

        /* Input Icons */
        .input-group-text {
            background: #F3E5F5;
            border: 2px solid #F0F0F0;
            border-right: none;
            color: var(--staff-purple);
        }

        .input-group .form-control {
            border-left: none;
        }

        .input-group .form-control:focus {
            border-left: none;
        }

        .input-group:focus-within .input-group-text {
            border-color: var(--staff-purple-soft);
        }
    </style>
</head>
<body>
<!-- Navigation Bar -->
<nav class="navbar navbar-expand-lg">
    <div class="container-fluid">
        <a class="navbar-brand" href="${pageContext.request.contextPath}/staff/dashboard">
            🎵 Musical Store <span class="staff-badge">Staff</span>
        </a>
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
            <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse" id="navbarNav">
            <ul class="navbar-nav me-auto">
                <li class="nav-item">
                    <a class="nav-link" href="${pageContext.request.contextPath}/staff/dashboard">
                        <i class="bi bi-speedometer2 me-1"></i>Dashboard
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link active" href="${pageContext.request.contextPath}/staff/instruments">
                        <i class="bi bi-box-seam me-1"></i>Manage Inventory
                    </a>
                </li>
            </ul>
        </div>
    </div>
</nav>

<!-- Form Container -->
<div class="form-container">
    <div class="container">
        <div class="form-card">
            <!-- Form Header -->
            <div class="form-header">
                <div class="icon">
                    <c:choose>
                        <c:when test="${mode == 'edit'}">
                            <i class="bi bi-pencil-square"></i>
                        </c:when>
                        <c:otherwise>
                            <i class="bi bi-plus-circle"></i>
                        </c:otherwise>
                    </c:choose>
                </div>
                <h2>
                    <c:choose>
                        <c:when test="${mode == 'edit'}">Edit Instrument</c:when>
                        <c:otherwise>Add New Instrument</c:otherwise>
                    </c:choose>
                </h2>
                <p>
                    <c:choose>
                        <c:when test="${mode == 'edit'}">Update instrument details and inventory</c:when>
                        <c:otherwise>Add a new product to your inventory</c:otherwise>
                    </c:choose>
                </p>
            </div>

            <!-- Form Body -->
            <div class="form-body">
                <!-- Error Message -->
                <c:if test="${not empty error}">
                    <div class="alert alert-danger">
                        <i class="bi bi-exclamation-triangle me-2"></i>${error}
                    </div>
                </c:if>

                <!-- Form -->
                <form action="${mode == 'edit' ? pageContext.request.contextPath.concat('/staff/instruments/edit') : pageContext.request.contextPath.concat('/staff/instruments/add')}"
                      method="post" id="instrumentForm">

                    <!-- Hidden ID field for edit mode -->
                    <c:if test="${mode == 'edit'}">
                        <input type="hidden" name="id" value="${instrument.id}">
                    </c:if>

                    <!-- Instrument Name -->
                    <div class="mb-3">
                        <label for="name" class="form-label">
                            Instrument Name <span class="required">*</span>
                        </label>
                        <div class="input-group">
                            <span class="input-group-text">
                                <i class="bi bi-music-note-beamed"></i>
                            </span>
                            <input type="text"
                                   class="form-control"
                                   id="name"
                                   name="name"
                                   value="${mode == 'edit' ? instrument.name : ''}"
                                   placeholder="e.g., Acoustic Guitar, Digital Piano"
                                   required>
                        </div>
                        <small class="form-text">Enter the full name of the instrument</small>
                    </div>

                    <!-- Description -->
                    <div class="mb-3">
                        <label for="description" class="form-label">
                            Description
                        </label>
                        <textarea class="form-control"
                                  id="description"
                                  name="description"
                                  rows="3"
                                  placeholder="Describe the instrument, its features, and specifications...">${mode == 'edit' ? instrument.description : ''}</textarea>
                        <small class="form-text">Optional - Add product description for customers</small>
                    </div>

                    <!-- Price -->
                    <div class="mb-3">
                        <label for="price" class="form-label">
                            Price (USD) <span class="required">*</span>
                        </label>
                        <div class="input-group">
                            <span class="input-group-text">
                                <i class="bi bi-currency-dollar"></i>
                            </span>
                            <input type="number"
                                   class="form-control"
                                   id="price"
                                   name="price"
                                   step="0.01"
                                   min="0.01"
                                   value="${mode == 'edit' ? instrument.price : ''}"
                                   placeholder="0.00"
                                   required>
                        </div>
                        <small class="form-text">Enter the selling price (minimum $0.01)</small>
                    </div>

                    <!-- Stock Quantity -->
                    <div class="mb-3">
                        <label for="stockQuantity" class="form-label">
                            Stock Quantity <span class="required">*</span>
                        </label>
                        <div class="input-group">
                            <span class="input-group-text">
                                <i class="bi bi-box"></i>
                            </span>
                            <input type="number"
                                   class="form-control"
                                   id="stockQuantity"
                                   name="stockQuantity"
                                   min="0"
                                   value="${mode == 'edit' ? instrument.stockQuantity : '0'}"
                                   placeholder="0"
                                   required
                                   onchange="updateStockPreview()">
                        </div>
                        <small class="form-text">Number of units available in stock</small>

                        <!-- Stock Status Preview -->
                        <div id="stockPreview" class="stock-preview">
                            <i class="bi bi-info-circle me-2"></i>
                            <span class="stock-status" id="stockStatus"></span>
                        </div>
                    </div>

                    <!-- Required Fields Note -->
                    <div class="alert alert-info">
                        <small>
                            <i class="bi bi-info-circle me-2"></i>
                            Fields marked with <span class="required">*</span> are required
                        </small>
                    </div>

                    <!-- Submit Button -->
                    <button type="submit" class="btn btn-submit">
                        <i class="bi bi-check-circle me-2"></i>
                        <c:choose>
                            <c:when test="${mode == 'edit'}">Update Instrument</c:when>
                            <c:otherwise>Add Instrument</c:otherwise>
                        </c:choose>
                    </button>

                    <!-- Cancel Button -->
                    <a href="${pageContext.request.contextPath}/staff/instruments" class="btn-cancel">
                        <i class="bi bi-x-circle me-2"></i>Cancel
                    </a>
                </form>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
    // Stock preview update
    function updateStockPreview() {
        const stockInput = document.getElementById('stockQuantity');
        const stockPreview = document.getElementById('stockPreview');
        const stockStatus = document.getElementById('stockStatus');
        const quantity = parseInt(stockInput.value) || 0;

        if (quantity === 0) {
            stockStatus.innerHTML = '<i class="bi bi-x-circle me-2"></i>Out of Stock - This item will not be available for purchase';
            stockStatus.className = 'stock-status status-outstock';
            stockPreview.classList.add('show');
        } else if (quantity <= 5) {
            stockStatus.innerHTML = '<i class="bi bi-exclamation-triangle me-2"></i>Low Stock - Consider restocking soon (' + quantity + ' units)';
            stockStatus.className = 'stock-status status-lowstock';
            stockPreview.classList.add('show');
        } else {
            stockStatus.innerHTML = '<i class="bi bi-check-circle me-2"></i>In Stock - Product available for purchase (' + quantity + ' units)';
            stockStatus.className = 'stock-status status-instock';
            stockPreview.classList.add('show');
        }
    }

    // Form validation
    document.getElementById('instrumentForm').addEventListener('submit', function(e) {
        const name = document.getElementById('name').value.trim();
        const price = parseFloat(document.getElementById('price').value);
        const stock = parseInt(document.getElementById('stockQuantity').value);

        if (name === '') {
            e.preventDefault();
            alert('Please enter instrument name');
            return false;
        }

        if (price <= 0) {
            e.preventDefault();
            alert('Price must be greater than $0');
            return false;
        }

        if (stock < 0) {
            e.preventDefault();
            alert('Stock quantity cannot be negative');
            return false;
        }

        const mode = '${mode}';
        const confirmMsg = mode === 'edit'
            ? 'Update this instrument?'
            : 'Add this instrument to inventory?';

        return confirm(confirmMsg);
    });

    // Initialize stock preview on page load
    window.addEventListener('load', function() {
        updateStockPreview();
    });

    // Real-time price formatting
    document.getElementById('price').addEventListener('blur', function() {
        if (this.value) {
            this.value = parseFloat(this.value).toFixed(2);
        }
    });
</script>
</body>
</html>