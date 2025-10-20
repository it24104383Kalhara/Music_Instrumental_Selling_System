<%--
  Created by IntelliJ IDEA.
  User: vinod
  Date: 10/19/2025
  Time: 6:36 PM
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
    <title>Customer Report - Musical Instruments Store</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.0/dist/chart.umd.min.js"></script>

    <style>
        :root {
            --primary-orange: #FF8C61;
            --primary-orange-soft: #FFB08A;
            --primary-cream: #FFF4E6;
            --accent-gold: #F4C430;
            --dark-brown: #6B4423;
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
            background: linear-gradient(135deg, var(--accent-gold) 0%, #F9D968 100%);
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

        .filter-card, .download-section, .chart-card {
            background: var(--white);
            border-radius: 12px;
            padding: 1.5rem;
            box-shadow: 0 3px 10px rgba(0,0,0,0.05);
            margin-bottom: 2rem;
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

        .table thead {
            background: var(--bg-light);
        }

        .table thead th {
            border: none;
            font-weight: 600;
            padding: 1rem;
            color: var(--dark-brown);
        }

        .table-hover tbody tr:hover {
            background-color: var(--primary-cream);
        }

        .btn-filter, .btn-download {
            border-radius: 8px;
            padding: 0.6rem 1.5rem;
            font-weight: 600;
            transition: all 0.3s ease;
        }

        .btn-filter {
            background: linear-gradient(135deg, var(--primary-orange) 0%, var(--primary-orange-soft) 100%);
            color: white;
            border: none;
        }

        .btn-download {
            border: 2px solid var(--primary-orange);
            color: var(--primary-orange);
            background: white;
            margin-right: 1rem;
        }

        .btn-download:hover {
            background: var(--primary-orange);
            color: white;
        }

        .back-link { color: white !important; text-decoration: none; }
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
            <i class="bi bi-people me-2"></i>Customer Report
        </h2>
        <p class="mb-0 opacity-90">Analyze customer behavior and spending patterns</p>
    </div>

    <!-- Filters -->
    <div class="filter-card">
        <h6><i class="bi bi-funnel me-2"></i>Filter Report</h6>
        <form method="get" action="${pageContext.request.contextPath}/admin/reports/customers">
            <div class="row g-3">
                <div class="col-md-4">
                    <label class="form-label">Start Date</label>
                    <input type="date" class="form-control" name="startDate" value="${param.startDate}" required>
                </div>
                <div class="col-md-4">
                    <label class="form-label">End Date</label>
                    <input type="date" class="form-control" name="endDate" value="${param.endDate}" required>
                </div>
                <div class="col-md-4">
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
            <div class="stat-icon" style="background: #E6F3FF; color: #4A90E2;">
                <i class="bi bi-people"></i>
            </div>
            <p class="stat-label">Total Customers</p>
            <h3 class="stat-value">${totalCustomers}</h3>
        </div>
        <div class="stat-card">
            <div class="stat-icon" style="background: #E8F5E9; color: #4CAF50;">
                <i class="bi bi-person-plus"></i>
            </div>
            <p class="stat-label">New Customers</p>
            <h3 class="stat-value">${newCustomers}</h3>
        </div>
        <div class="stat-card">
            <div class="stat-icon" style="background: #FFF5E6; color: #F4A261;">
                <i class="bi bi-person-check"></i>
            </div>
            <p class="stat-label">Active Customers</p>
            <h3 class="stat-value">${activeCustomers}</h3>
        </div>
        <div class="stat-card">
            <div class="stat-icon" style="background: var(--primary-cream); color: var(--primary-orange);">
                <i class="bi bi-currency-dollar"></i>
            </div>
            <p class="stat-label">Total Revenue</p>
            <h3 class="stat-value">$<fmt:formatNumber value="${totalRevenue}" pattern="#,##0.00"/></h3>
        </div>
    </div>

    <!-- Download Section -->
    <div class="download-section">
        <h6 class="mb-3"><i class="bi bi-download me-2"></i>Export Report</h6>
        <button class="btn btn-download" onclick="downloadPDF()">
            <i class="bi bi-file-pdf"></i> Download PDF
        </button>
        <button class="btn btn-download" onclick="downloadExcel()">
            <i class="bi bi-file-excel"></i> Download Excel
        </button>
    </div>

    <!-- Charts -->
    <div class="row">
        <div class="col-lg-12">
            <div class="chart-card">
                <h5><i class="bi bi-graph-up me-2" style="color: var(--primary-orange);"></i>
                    Customer Growth Trend</h5>
                <canvas id="customerGrowthChart" height="80"></canvas>
            </div>
        </div>
    </div>

    <!-- Top Customers Table -->
    <div class="chart-card">
        <h5><i class="bi bi-trophy me-2" style="color: var(--accent-gold);"></i>
            Top Customers by Spending</h5>
        <div class="table-responsive">
            <table class="table table-hover">
                <thead>
                <tr>
                    <th>Rank</th>
                    <th>Customer Name</th>
                    <th>Email</th>
                    <th>Total Orders</th>
                    <th>Total Spent</th>
                </tr>
                </thead>
                <tbody>
                <c:forEach var="customer" items="${topCustomers}" varStatus="status">
                    <tr>
                        <td>
                            <c:choose>
                                <c:when test="${status.index == 0}"><span style="font-size: 1.5rem;">🥇</span></c:when>
                                <c:when test="${status.index == 1}"><span style="font-size: 1.5rem;">🥈</span></c:when>
                                <c:when test="${status.index == 2}"><span style="font-size: 1.5rem;">🥉</span></c:when>
                                <c:otherwise><strong>${status.index + 1}</strong></c:otherwise>
                            </c:choose>
                        </td>
                        <td><strong>${customer.name}</strong></td>
                        <td>${customer.email}</td>
                        <td>${customer.orderCount} orders</td>
                        <td><strong>$<fmt:formatNumber value="${customer.totalSpent}" pattern="#,##0.00"/></strong></td>
                    </tr>
                </c:forEach>
                <c:if test="${empty topCustomers}">
                    <tr>
                        <td colspan="5" class="text-center py-4">
                            <i class="bi bi-inbox" style="font-size: 3rem; color: var(--text-light); opacity: 0.5;"></i>
                            <p class="mt-2 text-muted">No customer data available</p>
                        </td>
                    </tr>
                </c:if>
                </tbody>
            </table>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

<script>
    // Customer Growth Chart
    const growthCtx = document.getElementById('customerGrowthChart').getContext('2d');
    new Chart(growthCtx, {
        type: 'bar',
        data: {
            labels: [<c:forEach var="day" items="${customerGrowth}" varStatus="status">'${day.date}'<c:if test="${!status.last}">,</c:if></c:forEach>],
            datasets: [{
                label: 'New Customers',
                data: [<c:forEach var="day" items="${customerGrowth}" varStatus="status">${day.count}<c:if test="${!status.last}">,</c:if></c:forEach>],
                backgroundColor: 'rgba(255, 140, 97, 0.7)',
                borderColor: '#FF8C61',
                borderWidth: 2
            }]
        },
        options: {
            responsive: true,
            plugins: { legend: { display: false } },
            scales: { y: { beginAtZero: true } }
        }
    });

    function downloadPDF() {
        window.location.href = '${pageContext.request.contextPath}/admin/reports/download?type=customers&format=pdf&' + new URLSearchParams(window.location.search).toString();
    }

    function downloadExcel() {
        window.location.href = '${pageContext.request.contextPath}/admin/reports/download?type=customers&format=excel&' + new URLSearchParams(window.location.search).toString();
    }

    function downloadCSV() {
        window.location.href = '${pageContext.request.contextPath}/admin/reports/download?type=customers&format=csv&' + new URLSearchParams(window.location.search).toString();
    }

    // Set default dates
    window.addEventListener('DOMContentLoaded', function() {
        const startDateInput = document.querySelector('input[name="startDate"]');
        const endDateInput = document.querySelector('input[name="endDate"]');

        if (!startDateInput.value) {
            startDateInput.value = new Date(new Date().setDate(new Date().getDate() - 30)).toISOString().split('T')[0];
        }
        if (!endDateInput.value) {
            endDateInput.value = new Date().toISOString().split('T')[0];
        }
    });
</script>
</body>
</html>