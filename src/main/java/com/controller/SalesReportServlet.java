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
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet("/admin/reports/sales")
public class SalesReportServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userRole") == null ||
                !"Admin".equals(session.getAttribute("userRole"))) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        // Get filter parameters
        String startDate = request.getParameter("startDate");
        String endDate = request.getParameter("endDate");
        String status = request.getParameter("status");

        // Set default dates if not provided (last 30 days)
        if (startDate == null || startDate.isEmpty()) {
            startDate = LocalDate.now().minusDays(30).toString();
        }
        if (endDate == null || endDate.isEmpty()) {
            endDate = LocalDate.now().toString();
        }

        try (Connection conn = DatabaseConfig.getDataSource().getConnection()) {

            // Get sales statistics
            Map<String, Object> stats = getSalesStatistics(conn, startDate, endDate, status);
            request.setAttribute("totalRevenue", stats.get("totalRevenue"));
            request.setAttribute("totalOrders", stats.get("totalOrders"));
            request.setAttribute("averageOrderValue", stats.get("averageOrderValue"));
            request.setAttribute("totalProductsSold", stats.get("totalProductsSold"));

            // Get status counts
            Map<String, Integer> statusCounts = getStatusCounts(conn, startDate, endDate);
            request.setAttribute("processingCount", statusCounts.getOrDefault("Processing", 0));
            request.setAttribute("shippedCount", statusCounts.getOrDefault("Shipped", 0));
            request.setAttribute("deliveredCount", statusCounts.getOrDefault("Delivered", 0));

            // Get sales by day for chart
            List<Map<String, Object>> salesByDay = getSalesByDay(conn, startDate, endDate, status);
            request.setAttribute("salesByDay", salesByDay);

            // Get top selling products
            List<Map<String, Object>> topProducts = getTopProducts(conn, startDate, endDate, status);
            request.setAttribute("topProducts", topProducts);

            request.getRequestDispatcher("/WEB-INF/views/salesReport.jsp").forward(request, response);

        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Error generating sales report: " + e.getMessage());
            request.getRequestDispatcher("/WEB-INF/views/salesReport.jsp").forward(request, response);
        }
    }

    private Map<String, Object> getSalesStatistics(Connection conn, String startDate,
                                                   String endDate, String status) throws SQLException {
        Map<String, Object> stats = new HashMap<>();

        StringBuilder sql = new StringBuilder(
                "SELECT " +
                        "COUNT(DISTINCT o.id) as totalOrders, " +
                        "COALESCE(SUM(o.total_amount), 0) as totalRevenue, " +
                        "COALESCE(AVG(o.total_amount), 0) as avgOrderValue, " +
                        "COALESCE(SUM(oi.quantity), 0) as totalProducts " +
                        "FROM customer_order o " +
                        "LEFT JOIN order_item oi ON o.id = oi.order_id " +
                        "WHERE o.created_at BETWEEN ? AND ? "
        );

        if (status != null && !status.isEmpty()) {
            sql.append("AND o.status = ? ");
        }

        try (PreparedStatement pstmt = conn.prepareStatement(sql.toString())) {
            pstmt.setString(1, startDate + " 00:00:00");
            pstmt.setString(2, endDate + " 23:59:59");
            if (status != null && !status.isEmpty()) {
                pstmt.setString(3, status);
            }

            ResultSet rs = pstmt.executeQuery();
            if (rs.next()) {
                stats.put("totalOrders", rs.getInt("totalOrders"));
                stats.put("totalRevenue", rs.getDouble("totalRevenue"));
                stats.put("averageOrderValue", rs.getDouble("avgOrderValue"));
                stats.put("totalProductsSold", rs.getInt("totalProducts"));
            }
        }

        return stats;
    }

    private Map<String, Integer> getStatusCounts(Connection conn, String startDate,
                                                 String endDate) throws SQLException {
        Map<String, Integer> counts = new HashMap<>();

        String sql = "SELECT status, COUNT(*) as count " +
                "FROM customer_order " +
                "WHERE created_at BETWEEN ? AND ? " +
                "GROUP BY status";

        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, startDate + " 00:00:00");
            pstmt.setString(2, endDate + " 23:59:59");

            ResultSet rs = pstmt.executeQuery();
            while (rs.next()) {
                counts.put(rs.getString("status"), rs.getInt("count"));
            }
        }

        return counts;
    }

    private List<Map<String, Object>> getSalesByDay(Connection conn, String startDate,
                                                    String endDate, String status) throws SQLException {
        List<Map<String, Object>> salesByDay = new ArrayList<>();

        StringBuilder sql = new StringBuilder(
                "SELECT CONVERT(DATE, created_at) as date, " +
                        "SUM(total_amount) as revenue " +
                        "FROM customer_order " +
                        "WHERE created_at BETWEEN ? AND ? "
        );

        if (status != null && !status.isEmpty()) {
            sql.append("AND status = ? ");
        }

        sql.append("GROUP BY CONVERT(DATE, created_at) ORDER BY date");

        try (PreparedStatement pstmt = conn.prepareStatement(sql.toString())) {
            pstmt.setString(1, startDate + " 00:00:00");
            pstmt.setString(2, endDate + " 23:59:59");
            if (status != null && !status.isEmpty()) {
                pstmt.setString(3, status);
            }

            ResultSet rs = pstmt.executeQuery();
            DateTimeFormatter formatter = DateTimeFormatter.ofPattern("MMM dd");

            while (rs.next()) {
                Map<String, Object> day = new HashMap<>();
                LocalDate date = rs.getDate("date").toLocalDate();
                day.put("date", date.format(formatter));
                day.put("revenue", rs.getDouble("revenue"));
                salesByDay.add(day);
            }
        }

        return salesByDay;
    }

    private List<Map<String, Object>> getTopProducts(Connection conn, String startDate,
                                                     String endDate, String status) throws SQLException {
        List<Map<String, Object>> products = new ArrayList<>();

        StringBuilder sql = new StringBuilder(
                "SELECT i.name, 'Musical Instrument' as category, " +
                        "SUM(oi.quantity) as quantitySold, " +
                        "SUM(oi.quantity * oi.unit_price) as revenue " +
                        "FROM order_item oi " +
                        "JOIN instrument i ON oi.instrument_id = i.id " +
                        "JOIN customer_order o ON oi.order_id = o.id " +
                        "WHERE o.created_at BETWEEN ? AND ? "
        );

        if (status != null && !status.isEmpty()) {
            sql.append("AND o.status = ? ");
        }

        sql.append("GROUP BY i.id, i.name " +
                "ORDER BY quantitySold DESC");

        try (PreparedStatement pstmt = conn.prepareStatement(sql.toString())) {
            pstmt.setString(1, startDate + " 00:00:00");
            pstmt.setString(2, endDate + " 23:59:59");
            if (status != null && !status.isEmpty()) {
                pstmt.setString(3, status);
            }

            ResultSet rs = pstmt.executeQuery();
            int rank = 0;
            while (rs.next() && rank < 10) {
                Map<String, Object> product = new HashMap<>();
                product.put("name", rs.getString("name"));
                product.put("category", rs.getString("category"));
                product.put("quantitySold", rs.getInt("quantitySold"));
                product.put("revenue", rs.getDouble("revenue"));
                products.add(product);
                rank++;
            }
        }

        return products;
    }
}