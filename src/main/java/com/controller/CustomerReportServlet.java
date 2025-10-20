package com.controller;

import com.util.DatabaseConfig;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.*;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet("/admin/reports/customers")
public class CustomerReportServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || !"Admin".equals(session.getAttribute("userRole"))) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        String startDate = request.getParameter("startDate");
        String endDate = request.getParameter("endDate");

        if (startDate == null || startDate.isEmpty()) {
            startDate = LocalDate.now().minusDays(30).toString();
        }
        if (endDate == null || endDate.isEmpty()) {
            endDate = LocalDate.now().toString();
        }

        try (Connection conn = DatabaseConfig.getDataSource().getConnection()) {

            // Get customer statistics
            Map<String, Object> stats = getCustomerStatistics(conn, startDate, endDate);
            request.setAttribute("totalCustomers", stats.get("totalCustomers"));
            request.setAttribute("newCustomers", stats.get("newCustomers"));
            request.setAttribute("activeCustomers", stats.get("activeCustomers"));
            request.setAttribute("totalRevenue", stats.get("totalRevenue"));

            // Get top customers
            List<Map<String, Object>> topCustomers = getTopCustomers(conn, startDate, endDate);
            request.setAttribute("topCustomers", topCustomers);

            // Get customer growth data
            List<Map<String, Object>> customerGrowth = getCustomerGrowth(conn, startDate, endDate);
            request.setAttribute("customerGrowth", customerGrowth);

            request.getRequestDispatcher("/WEB-INF/views/customerReport.jsp").forward(request, response);

        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Error generating customer report: " + e.getMessage());
            request.getRequestDispatcher("/WEB-INF/views/customerReport.jsp").forward(request, response);
        }
    }

    private Map<String, Object> getCustomerStatistics(Connection conn, String startDate,
                                                      String endDate) throws SQLException {
        Map<String, Object> stats = new HashMap<>();

        // Total customers
        String sql1 = "SELECT COUNT(*) as total FROM app_user WHERE role = 'Customer'";
        try (PreparedStatement pstmt = conn.prepareStatement(sql1)) {
            ResultSet rs = pstmt.executeQuery();
            if (rs.next()) {
                stats.put("totalCustomers", rs.getInt("total"));
            }
        }

        // New customers in date range
        String sql2 = "SELECT COUNT(*) as newCustomers FROM app_user " +
                "WHERE role = 'Customer' AND created_at BETWEEN ? AND ?";
        try (PreparedStatement pstmt = conn.prepareStatement(sql2)) {
            pstmt.setString(1, startDate + " 00:00:00");
            pstmt.setString(2, endDate + " 23:59:59");
            ResultSet rs = pstmt.executeQuery();
            if (rs.next()) {
                stats.put("newCustomers", rs.getInt("newCustomers"));
            }
        }

        // Active customers (made at least one order in date range)
        String sql3 = "SELECT COUNT(DISTINCT user_id) as activeCustomers " +
                "FROM customer_order WHERE created_at BETWEEN ? AND ?";
        try (PreparedStatement pstmt = conn.prepareStatement(sql3)) {
            pstmt.setString(1, startDate + " 00:00:00");
            pstmt.setString(2, endDate + " 23:59:59");
            ResultSet rs = pstmt.executeQuery();
            if (rs.next()) {
                stats.put("activeCustomers", rs.getInt("activeCustomers"));
            }
        }

        // Total revenue from customers
        String sql4 = "SELECT COALESCE(SUM(total_amount), 0) as revenue " +
                "FROM customer_order WHERE created_at BETWEEN ? AND ?";
        try (PreparedStatement pstmt = conn.prepareStatement(sql4)) {
            pstmt.setString(1, startDate + " 00:00:00");
            pstmt.setString(2, endDate + " 23:59:59");
            ResultSet rs = pstmt.executeQuery();
            if (rs.next()) {
                stats.put("totalRevenue", rs.getDouble("revenue"));
            }
        }

        return stats;
    }

    private List<Map<String, Object>> getTopCustomers(Connection conn, String startDate,
                                                      String endDate) throws SQLException {
        List<Map<String, Object>> customers = new ArrayList<>();

        String sql = "SELECT TOP 10 u.full_name, u.email, " +
                "COUNT(o.id) as orderCount, " +
                "COALESCE(SUM(o.total_amount), 0) as totalSpent " +
                "FROM app_user u " +
                "JOIN customer_order o ON u.id = o.user_id " +
                "WHERE o.created_at BETWEEN ? AND ? " +
                "GROUP BY u.id, u.full_name, u.email " +
                "ORDER BY totalSpent DESC";

        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, startDate + " 00:00:00");
            pstmt.setString(2, endDate + " 23:59:59");

            ResultSet rs = pstmt.executeQuery();
            while (rs.next()) {
                Map<String, Object> customer = new HashMap<>();
                customer.put("name", rs.getString("full_name"));
                customer.put("email", rs.getString("email"));
                customer.put("orderCount", rs.getInt("orderCount"));
                customer.put("totalSpent", rs.getDouble("totalSpent"));
                customers.add(customer);
            }
        }

        return customers;
    }

    private List<Map<String, Object>> getCustomerGrowth(Connection conn, String startDate,
                                                        String endDate) throws SQLException {
        List<Map<String, Object>> growth = new ArrayList<>();

        String sql = "SELECT CONVERT(DATE, created_at) as date, COUNT(*) as newCustomers " +
                "FROM app_user " +
                "WHERE role = 'Customer' AND created_at BETWEEN ? AND ? " +
                "GROUP BY CONVERT(DATE, created_at) " +
                "ORDER BY date";

        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, startDate + " 00:00:00");
            pstmt.setString(2, endDate + " 23:59:59");

            ResultSet rs = pstmt.executeQuery();
            while (rs.next()) {
                Map<String, Object> day = new HashMap<>();
                day.put("date", rs.getDate("date").toString());
                day.put("count", rs.getInt("newCustomers"));
                growth.add(day);
            }
        }

        return growth;
    }
}