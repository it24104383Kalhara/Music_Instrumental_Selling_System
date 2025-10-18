<%--
  Created by IntelliJ IDEA.
  User: vinod
  Date: 10/18/2025
  Time: 10:33 AM
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
    <title>Manage Inventory - Staff Dashboard</title>

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

        /* Page Header */
        .page-header {
            background: linear-gradient(135deg, var(--staff-purple) 0%, var(--staff-purple-soft) 100%);
            border-radius: 15px;
            padding: 2rem;
            margin-bottom: 2rem;
            color: white;
        }

        .page-header h2 {
            font-weight: 600;
            margin-bottom: 0.5rem;
        }

        /* Filter & Search */
        .filter-section {
            background: var(--white);
            border-radius: 12px;
            padding: 1.5rem;
            margin-bottom: 2rem;
            box-shadow: 0 3px 10px rgba(0,0,0,0.05);
        }

        .search-box .input-group-text {
            background: var(--white);
            border: 2px solid #E8E8E8;
            border-right: none;
            color: var(--staff-purple);
        }

        .search-box .form-control {
            border: 2px solid #E8E8E8;
            border-left: none;
        }

        .search-box .form-control:focus {
            border-color: var(--staff-purple);
            box-shadow: none;
        }

        .filter-btn {
            border: 2px solid var(--primary-cream);
            background: var(--white);
            color: var(--text-dark);
            padding: 0.5rem 1.2rem;
            border-radius: 25px;
            font-weight: 500;
            transition: all 0.3s ease;
            margin: 0.25rem;
            cursor: pointer;
            text-decoration: none;
            display: inline-block;
        }

        .filter-btn:hover {
            background: var(--primary-cream);
            border-color: var(--staff-purple);
            color: var(--staff-purple);
        }

        .filter-btn.active {
            background: var(--staff-purple);
            color: white;
            border-color: var(--staff-purple);
        }

        .btn-add-new {
            background: linear-gradient(135deg, var(--staff-purple) 0%, var(--staff-purple-soft) 100%);
            border: none;
            color: white;
            padding: 0.6rem 1.5rem;
            border-radius: 25px;
            font-weight: 600;
            transition: all 0.3s ease;
        }

        .btn-add-new:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(156, 39, 176, 0.3);
            color: white;
        }

        /* Table */
        .inventory-card {
            background: var(--white);
            border-radius: 12px;
            box-shadow: 0 3px 10px rgba(0,0,0,0.05);
        }

        .inventory-card .card-header {
            background: var(--white);
            border-bottom: 1px solid #F0F0F0;
            padding: 1.25rem;
        }

        .inventory-card h5 {
            color: var(--dark-brown);
            font-weight: 600;
        }

        .table {
            font-size: 0.95rem;
        }

        .table thead {
            background: var(--bg-light);
        }

        .table thead th {
            border: none;
            font-weight: 600;
            color: var(--dark-brown);
            padding: 1rem;
        }

        .table-hover tbody tr:hover {
            background-color: #F3E5F5;
        }

        .table tbody td {
            padding: 1rem;
            vertical-align: middle;
            color: var(--text-dark);
        }

        /* Stock Badges */
        .stock-badge {
            padding: 0.4rem 0.8rem;
            border-radius: 20px;
            font-size: 0.85rem;
            font-weight: 500;
        }

        .stock-instock {
            background: #E8F5E9;
            color: #4CAF50;
        }

        .stock-lowstock {
            background: #FFF5E6;
            color: #F4A261;
        }

        .stock-outstock {
            background: #FFEBEE;
            color: #F44336;
        }

        /* Action Buttons */
        .btn-edit {
            background: #E6F3FF;
            border: none;
            color: #4A90E2;
            padding: 0.4rem 1rem;
            border-radius: 20px;
            font-weight: 500;
            transition: all 0.3s ease;
            font-size: 0.85rem;
        }

        .btn-edit:hover {
            background: #4A90E2;
            color: white;
        }

        .btn-delete {
            background: #FFEBEE;
            border: none;
            color: #F44336;
            padding: 0.4rem 1rem;
            border-radius: 20px;
            font-weight: 500;
            transition: all 0.3s ease;
            font-size: 0.85rem;
            margin-left: 0.5rem;
        }

        .btn-delete:hover {
            background: #F44336;
            color: white;
        }

        /* Alert */
        .alert {
            border-radius: 10px;
            border: none;
        }

        /* Empty State */
        .empty-state {
            text-align: center;
            padding: 4rem 2rem;
        }

        .empty-state i {
            font-size: 5rem;
            color: var(--staff-purple-soft);
            opacity: 0.5;
        }

        .empty-state h3 {
            color: var(--dark-brown);
            margin-top: 1.5rem;
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
            <ul class="navbar-nav">
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
            </ul>
        </div>
    </div>
</nav>

<!-- Main Content -->
<div class="container-fluid py-4">
    <!-- Page Header -->
    <div class="page-header">
        <div class="d-flex justify-content-between align-items-center">
            <div>
                <h2><i class="bi bi-box-seam me-2"></i>Inventory Management</h2>
                <p class="mb-0">Manage products and stock levels</p>
            </div>
            <a href="${pageContext.request.contextPath}/staff/instruments/add" class="btn btn-add-new">
                <i class="bi bi-plus-circle me-2"></i>Add New Instrument
            </a>
        </div>
    </div>

    <!-- Success Message -->
    <c:if test="${not empty successMessage}">
        <div class="alert alert-success">
            <i class="bi bi-check-circle me-2"></i>${successMessage}
        </div>
    </c:if>

    <!-- Filter Section -->
    <div class="filter-section">
        <div class="row g-3 align-items-center">
            <div class="col-md-6">
                <div class="input-group search-box">
                    <span class="input-group-text">
                        <i class="bi bi-search"></i>
                    </span>
                    <input type="text" class="form-control" id="searchInput"
                           placeholder="Search instruments..." onkeyup="filterTable()">
                </div>
            </div>
            <div class="col-md-6">
                <div class="d-flex flex-wrap align-items-center">
                    <small class="text-muted me-2">Filter:</small>
                    <a href="${pageContext.request.contextPath}/staff/instruments"
                       class="filter-btn ${empty currentFilter ? 'active' : ''}">
                        All
                    </a>
                    <a href="${pageContext.request.contextPath}/staff/instruments?filter=low-stock"
                       class="filter-btn ${currentFilter == 'low-stock' ? 'active' : ''}">
                        <i class="bi bi-exclamation-triangle me-1"></i>Low Stock
                    </a>
                    <a href="${pageContext.request.contextPath}/staff/instruments?filter=out-of-stock"
                       class="filter-btn ${currentFilter == 'out-of-stock' ? 'active' : ''}">
                        <i class="bi bi-x-circle me-1"></i>Out of Stock
                    </a>
                </div>
            </div>
        </div>
    </div>

    <!-- Inventory Table -->
    <div class="inventory-card">
        <div class="card-header">
            <h5 class="mb-0">
                <i class="bi bi-list-ul me-2"></i>
                Product Inventory (${fn:length(instruments)} items)
            </h5>
        </div>
        <div class="card-body p-0">
            <c:choose>
                <c:when test="${empty instruments}">
                    <div class="empty-state">
                        <i class="bi bi-inbox"></i>
                        <h3>No instruments found</h3>
                        <p class="text-muted">Start by adding your first instrument to the inventory</p>
                        <a href="${pageContext.request.contextPath}/staff/instruments/add" class="btn btn-add-new mt-3">
                            <i class="bi bi-plus-circle me-2"></i>Add Instrument
                        </a>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="table-responsive">
                        <table class="table table-hover mb-0" id="inventoryTable">
                            <thead>
                            <tr>
                                <th class="px-4">Instrument Name</th>
                                <th>Price</th>
                                <th>Stock Quantity</th>
                                <th>Status</th>
                                <th>Actions</th>
                            </tr>
                            </thead>
                            <tbody>
                            <c:forEach var="instrument" items="${instruments}">
                                <tr data-search="${fn:toLowerCase(instrument.name)}">
                                    <td class="px-4">
                                        <i class="bi bi-music-note-beamed me-2" style="color: var(--staff-purple);"></i>
                                        <strong>${instrument.name}</strong>
                                        <c:if test="${not empty instrument.description}">
                                            <br><small class="text-muted">${instrument.description}</small>
                                        </c:if>
                                    </td>
                                    <td>
                                        <strong style="color: var(--primary-orange);">
                                            $<fmt:formatNumber value="${instrument.price}" pattern="#,##0.00"/>
                                        </strong>
                                    </td>
                                    <td>
                                        <strong>${instrument.stockQuantity}</strong> units
                                    </td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${instrument.stockQuantity == 0}">
                                                    <span class="stock-badge stock-outstock">
                                                        <i class="bi bi-x-circle me-1"></i>Out of Stock
                                                    </span>
                                            </c:when>
                                            <c:when test="${instrument.stockQuantity <= 5}">
                                                    <span class="stock-badge stock-lowstock">
                                                        <i class="bi bi-exclamation-triangle me-1"></i>Low Stock
                                                    </span>
                                            </c:when>
                                            <c:otherwise>
                                                    <span class="stock-badge stock-instock">
                                                        <i class="bi bi-check-circle me-1"></i>In Stock
                                                    </span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <a href="${pageContext.request.contextPath}/staff/instruments/edit?id=${instrument.id}"
                                           class="btn btn-sm btn-edit">
                                            <i class="bi bi-pencil"></i> Edit
                                        </a>
                                        <form action="${pageContext.request.contextPath}/staff/instruments/delete"
                                              method="post" style="display: inline;"
                                              onsubmit="return confirm('Are you sure you want to delete ${fn:escapeXml(instrument.name)}?')">
                                            <input type="hidden" name="id" value="${instrument.id}">
                                            <button type="submit" class="btn btn-sm btn-delete">
                                                <i class="bi bi-trash"></i> Delete
                                            </button>
                                        </form>
                                    </td>
                                </tr>
                            </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
    function filterTable() {
        const searchValue = document.getElementById('searchInput').value.toLowerCase();
        const rows = document.querySelectorAll('#inventoryTable tbody tr');

        rows.forEach(row => {
            const searchText = row.getAttribute('data-search');
            if (searchText.includes(searchValue)) {
                row.style.display = '';
            } else {
                row.style.display = 'none';
            }
        });
    }
</script>
</body>
</html>