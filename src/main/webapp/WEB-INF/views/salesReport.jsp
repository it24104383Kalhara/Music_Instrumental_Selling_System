<%--
  Created by IntelliJ IDEA.
  User: vinod
  Date: 10/19/2025
  Time: 6:32 PM
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
    <title>Sales Report - Musical Instruments Store</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.0/dist/chart.umd.min.js"></script>

    <style>
        :root {
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

        * { font-family: 'Poppins', sans-serif; }
        body { background-color: var(--bg-light); }

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

        .admin-badge {
            background: linear-gradient(135deg, var(--accent-gold) 0%, var(--accent-gold-soft) 100%);
            color: var(--dark-brown);
            padding: 0.3rem 0.8rem;
            border-radius: 20px;
            font-size: 0.75rem;
            font-weight: 600;
            margin-left: 0.5rem;
        }

        .report-header {
            background: linear-gradient(135deg, var(--primary-orange) 0%, var(--primary-orange-soft) 100%);
            border-radius: 15px;
            padding: 2rem;
            margin-bottom: 2rem;
            color: white;
        }

        .report-title {
            font-weight: 600;
            margin-bottom: 0.5rem;
            font-size: 1.8rem;
        }

        .filter-card {
            background: var(--white);
            border-radius: 12px;
            padding: 1.5rem;
            box-shadow: 0 3px 10px rgba(0,0,0,0.05);
            margin-bottom: 2rem;
        }

        .filter-card h6 {
            color: var(--dark-brown);
            font-weight: 600;
            margin-bottom: 1rem;
        }

        .form-control, .form-select {
            border: 2px solid #F0F0F0;
            border-radius: 8px;
            padding: 0.6rem 1rem;
            transition: all 0.3s ease;
        }

        .form-control:focus, .form-select:focus {
            border-color: var(--primary-orange-soft);
            box-shadow: 0 0 0 0.2rem rgba(255, 140, 97, 0.15);
        }

        .btn-filter {
            background: linear-gradient(135deg, var(--primary-orange) 0%, var(--primary-orange-soft) 100%);
            color: white;
            border: none;
            border-radius: 8px;
            padding: 0.6rem 2rem;
            font-weight: 600;
            transition: all 0.3s ease;
        }

        .btn-filter:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(255, 140, 97, 0.3);
            color: white;
        }

        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(240px, 1fr));
            gap: 1.5rem;
            margin-bottom: 2rem;
        }

        .stat-card {
            background: var(--white);
            border-radius: 12px;
            padding: 1.5rem;
            box-shadow: 0 3px 10px rgba(0,0,0,0.05);
            transition: transform 0.3s ease;
        }

        .stat-card:hover { transform: translateY(-5px); }

        .stat-icon {
            width: 50px;
            height: 50px;
            border-radius: 12px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 24px;
            margin-bottom: 1rem;
        }

        .stat-icon.revenue { background: #E8F5E9; color: #4CAF50; }
        .stat-icon.orders { background: #E6F3FF; color: #4A90E2; }
        .stat-icon.average { background: var(--primary-cream); color: var(--primary-orange); }
        .stat-icon.products { background: #FFF5E6; color: #F4A261; }

        .stat-label {
            color: var(--text-light);
            font-size: 0.9rem;
            margin-bottom: 0.5rem;
        }

        .stat-value {
            color: var(--dark-brown);
            font-size: 2rem;
            font-weight: 700;
        }

        .chart-card {
            background: var(--white);
            border-radius: 12px;
            padding: 2rem;
            box-shadow: 0 3px 10px rgba(0,0,0,0.05);
            margin-bottom: 2rem;
        }

        .chart-card h5 {
            color: var(--dark-brown);
            font-weight: 600;
            margin-bottom: 1.5rem;
        }

        .table-card {
            background: var(--white);
            border-radius: 12px;
            box-shadow: 0 3px 10px rgba(0,0,0,0.05);
            overflow: hidden;
        }

        .table thead {
            background: var(--bg-light);
        }

        .table thead th {
            border: none;
            font-weight: 600;
            padding: 1rem;
            color: var(--dark-brown);
        }

        .table tbody td {
            padding: 1rem;
            vertical-align: middle;
        }

        .table-hover tbody tr:hover {
            background-color: var(--primary-cream);
        }

        .download-section {
            background: var(--white);
            border-radius: 12px;
            padding: 1.5rem;
            box-shadow: 0 3px 10px rgba(0,0,0,0.05);
            margin-bottom: 2rem;
        }

        .btn-download {
            border: 2px solid var(--primary-orange);
            color: var(--primary-orange);
            background: white;
            border-radius: 8px;
            padding: 0.6rem 1.5rem;
            font-weight: 600;
            margin-right: 1rem;
            margin-bottom: 0.5rem;
            transition: all 0.3s ease;
        }

        .btn-download:hover {
            background: var(--primary-orange);
            color: white;
            transform: translateY(-2px);
        }

        .btn-download i {
            margin-right: 0.5rem;
        }

        .back-link {
            color: white !important;
            text-decoration: none;
            transition: all 0.3s ease;
        }

        .back-link:hover {
            opacity: 0.8;
        }
    </style>
</head>
<body>
<nav class="navbar navbar-expand-lg">
    <div class="container-fluid">
        <a class="navbar-brand" href="${pageContext.request.contextPath}/index.jsp">
            🎵 Musical Store <span class="admin-badge">Admin</span>
        </a>
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
            <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse" id="navbarNav">
            <ul class="navbar-nav me-auto">
                <li class="nav-item">
                    <a class="nav-link" href="${pageContext.request.contextPath}/admin/dashboard">
                        <i class="bi bi-speedometer2 me-1"></i>Dashboard
                    </a>
                </li>
            </ul>
        </div>
    </div>
</nav>

<div class="container-fluid py-4">
    <div class="report-header">
        <a href="${pageContext.request.contextPath}/admin/dashboard#reportsSection" class="back-link">
            <i class="bi bi-arrow-left me-2"></i>Back to Dashboard
        </a>
        <h2 class="report-title mt-2">
            <i class="bi bi-graph-up me-2"></i>Sales Report
        </h2>
        <p class="mb-0 opacity-90">Analyze sales performance and revenue trends</p>
    </div>

    <!-- Filters -->
    <div class="filter-card">
        <h6><i class="bi bi-funnel me-2"></i>Filter Report</h6>
        <form method="get" action="${pageContext.request.contextPath}/admin/reports/sales">
            <div class="row g-3">
                <div class="col-md-3">
                    <label class="form-label">Start Date</label>
                    <input type="date" class="form-control" name="startDate"
                           value="${param.startDate}" required>
                </div>
                <div class="col-md-3">
                    <label class="form-label">End Date</label>
                    <input type="date" class="form-control" name="endDate"
                           value="${param.endDate}" required>
                </div>
                <div class="col-md-3">
                    <label class="form-label">Status</label>
                    <select class="form-select" name="status">
                        <option value="">All Statuses</option>
                        <option value="Processing" ${param.status == 'Processing' ? 'selected' : ''}>Processing</option>
                        <option value="Shipped" ${param.status == 'Shipped' ? 'selected' : ''}>Shipped</option>
                        <option value="Delivered" ${param.status == 'Delivered' ? 'selected' : ''}>Delivered</option>
                    </select>
                </div>
                <div class="col-md-3">
                    <label class="form-label">&nbsp;</label>
                    <button type="submit" class="btn btn-filter w-100">
                        <i class="bi bi-search me-2"></i>Apply Filter
                    </button>
                </div>
            </div>
        </form>
    </div>

    <!-- Statistics -->
    <div class="stats-grid">
        <div class="stat-card">
            <div class="stat-icon revenue">
                <i class="bi bi-currency-dollar"></i>
            </div>
            <p class="stat-label">Total Revenue</p>
            <h3 class="stat-value">$<fmt:formatNumber value="${totalRevenue}" pattern="#,##0.00"/></h3>
        </div>
        <div class="stat-card">
            <div class="stat-icon orders">
                <i class="bi bi-cart-check"></i>
            </div>
            <p class="stat-label">Total Orders</p>
            <h3 class="stat-value">${totalOrders}</h3>
        </div>
        <div class="stat-card">
            <div class="stat-icon average">
                <i class="bi bi-graph-up-arrow"></i>
            </div>
            <p class="stat-label">Average Order Value</p>
            <h3 class="stat-value">$<fmt:formatNumber value="${averageOrderValue}" pattern="#,##0.00"/></h3>
        </div>
        <div class="stat-card">
            <div class="stat-icon products">
                <i class="bi bi-music-note-list"></i>
            </div>
            <p class="stat-label">Products Sold</p>
            <h3 class="stat-value">${totalProductsSold}</h3>
        </div>
    </div>

    <!-- Download Section -->
    <div class="download-section">
        <h6 class="mb-3"><i class="bi bi-download me-2"></i>Export Report</h6>
        <button class="btn btn-download" onclick="downloadPDF()">
            <i class="bi bi-file-pdf"></i>Download PDF
        </button>
        <button class="btn btn-download" onclick="downloadExcel()">
            <i class="bi bi-file-excel"></i>Download Excel
        </button>
    </div>

    <!-- Charts -->
    <div class="row">
        <div class="col-lg-8">
            <div class="chart-card">
                <h5><i class="bi bi-bar-chart me-2" style="color: var(--primary-orange);"></i>
                    Sales Trend</h5>
                <canvas id="salesTrendChart" height="100"></canvas>
            </div>
        </div>
        <div class="col-lg-4">
            <div class="chart-card">
                <h5><i class="bi bi-pie-chart me-2" style="color: var(--primary-orange);"></i>
                    Sales by Status</h5>
                <canvas id="salesStatusChart"></canvas>
            </div>
        </div>
    </div>

    <!-- Top Products Table -->
    <div class="chart-card">
        <h5><i class="bi bi-trophy me-2" style="color: var(--accent-gold);"></i>
            Top Selling Products</h5>
        <div class="table-card">
            <div class="table-responsive">
                <table class="table table-hover">
                    <thead>
                    <tr>
                        <th>Rank</th>
                        <th>Product Name</th>
                        <th>Category</th>
                        <th>Quantity Sold</th>
                        <th>Revenue</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:forEach var="product" items="${topProducts}" varStatus="status">
                        <tr>
                            <td>
                                <c:choose>
                                    <c:when test="${status.index == 0}">
                                        <span style="font-size: 1.5rem;">🥇</span>
                                    </c:when>
                                    <c:when test="${status.index == 1}">
                                        <span style="font-size: 1.5rem;">🥈</span>
                                    </c:when>
                                    <c:when test="${status.index == 2}">
                                        <span style="font-size: 1.5rem;">🥉</span>
                                    </c:when>
                                    <c:otherwise>
                                        <strong>${status.index + 1}</strong>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td>
                                <i class="bi bi-music-note-beamed me-2" style="color: var(--primary-orange);"></i>
                                <strong>${product.name}</strong>
                            </td>
                            <td>${product.category}</td>
                            <td><strong>${product.quantitySold}</strong> units</td>
                            <td><strong>$<fmt:formatNumber value="${product.revenue}" pattern="#,##0.00"/></strong></td>
                        </tr>
                    </c:forEach>
                    <c:if test="${empty topProducts}">
                        <tr>
                            <td colspan="5" class="text-center py-4">
                                <i class="bi bi-inbox" style="font-size: 3rem; color: var(--text-light); opacity: 0.5;"></i>
                                <p class="mt-2 text-muted">No sales data available for this period</p>
                            </td>
                        </tr>
                    </c:if>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

<script>
    // Sales Trend Chart
    const salesTrendCtx = document.getElementById('salesTrendChart').getContext('2d');
    new Chart(salesTrendCtx, {
        type: 'line',
        data: {
            labels: [<c:forEach var="day" items="${salesByDay}" varStatus="status">'${day.date}'<c:if test="${!status.last}">,</c:if></c:forEach>],
            datasets: [{
                label: 'Daily Revenue ($)',
                data: [<c:forEach var="day" items="${salesByDay}" varStatus="status">${day.revenue}<c:if test="${!status.last}">,</c:if></c:forEach>],
                borderColor: '#FF8C61',
                backgroundColor: 'rgba(255, 140, 97, 0.1)',
                borderWidth: 3,
                fill: true,
                tension: 0.4,
                pointRadius: 5,
                pointHoverRadius: 7,
                pointBackgroundColor: '#FF8C61',
                pointBorderColor: '#fff',
                pointBorderWidth: 2
            }]
        },
        options: {
            responsive: true,
            plugins: {
                legend: { display: true },
                tooltip: {
                    backgroundColor: 'rgba(0, 0, 0, 0.8)',
                    padding: 12,
                    callbacks: {
                        label: function(context) {
                            return 'Revenue: $' + context.parsed.y.toFixed(2);
                        }
                    }
                }
            },
            scales: {
                y: {
                    beginAtZero: true,
                    ticks: {
                        callback: function(value) {
                            return '$' + value;
                        }
                    }
                }
            }
        }
    });

    // Sales Status Chart
    const salesStatusCtx = document.getElementById('salesStatusChart').getContext('2d');
    new Chart(salesStatusCtx, {
        type: 'doughnut',
        data: {
            labels: ['Processing', 'Shipped', 'Delivered'],
            datasets: [{
                data: [${processingCount}, ${shippedCount}, ${deliveredCount}],
                backgroundColor: ['#4A90E2', '#F4A261', '#4CAF50']
            }]
        },
        options: {
            responsive: true,
            plugins: {
                legend: { position: 'bottom' }
            }
        }
    });

    // Download Functions
    function downloadPDF() {
        const params = new URLSearchParams(window.location.search);
        params.set('format', 'pdf');
        window.location.href = '${pageContext.request.contextPath}/admin/reports/download?type=sales&' + params.toString();
    }

    function downloadExcel() {
        const params = new URLSearchParams(window.location.search);
        params.set('format', 'excel');
        window.location.href = '${pageContext.request.contextPath}/admin/reports/download?type=sales&' + params.toString();
    }

    function downloadCSV() {
        const params = new URLSearchParams(window.location.search);
        params.set('format', 'csv');
        window.location.href = '${pageContext.request.contextPath}/admin/reports/download?type=sales&' + params.toString();
    }

    // Set default dates
    window.addEventListener('DOMContentLoaded', function() {
        const startDateInput = document.querySelector('input[name="startDate"]');
        const endDateInput = document.querySelector('input[name="endDate"]');

        if (!startDateInput.value) {
            const thirtyDaysAgo = new Date();
            thirtyDaysAgo.setDate(thirtyDaysAgo.getDate() - 30);
            startDateInput.value = thirtyDaysAgo.toISOString().split('T')[0];
        }

        if (!endDateInput.value) {
            endDateInput.value = new Date().toISOString().split('T')[0];
        }
    });
</script>
</body>
</html>