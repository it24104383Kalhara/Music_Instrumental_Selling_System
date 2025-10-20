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

@WebServlet("/admin/reports/orders")
public class OrderReportServlet extends HttpServlet {

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
        String status = request.getParameter("status");

        if (startDate == null || startDate.isEmpty()) {
            startDate = LocalDate.now().minusDays(30).toString();
        }
        if (endDate == null || endDate.isEmpty()) {
            endDate = LocalDate.now().toString();
        }

        try (Connection conn = DatabaseConfig.getDataSource().getConnection()) {

            // Get order statistics
            Map<String, Object> stats = getOrderStatistics(conn, startDate, endDate, status);
            request.setAttribute("totalOrders", stats.get("totalOrders"));
            request.setAttribute("processingOrders", stats.get("processingOrders"));
            request.setAttribute("shippedOrders", stats.get("shippedOrders"));
            request.setAttribute("deliveredOrders", stats.get("deliveredOrders"));
            request.setAttribute("cancelledOrders", stats.get("cancelledOrders"));

            // Get orders by status for pie chart
            Map<String, Integer> ordersByStatus = getOrdersByStatus(conn, startDate, endDate);
            request.setAttribute("ordersByStatus", ordersByStatus);

            // Get daily order count for line chart
            List<Map<String, Object>> dailyOrders = getDailyOrders(conn, startDate, endDate, status);
            request.setAttribute("dailyOrders", dailyOrders);

            // Get detailed order list
            List<Map<String, Object>> orderList = getOrderList(conn, startDate, endDate, status);
            request.setAttribute("orderList", orderList);

            request.getRequestDispatcher("/WEB-INF/views/orderReport.jsp").forward(request, response);

        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Error generating order report: " + e.getMessage());
            request.getRequestDispatcher("/WEB-INF/views/orderReport.jsp").forward(request, response);
        }
    }

    private Map<String, Object> getOrderStatistics(Connection conn, String startDate,
                                                   String endDate, String status) throws SQLException {
        Map<String, Object> stats = new HashMap<>();

        String sql = "SELECT " +
                "COUNT(*) as totalOrders, " +
                "SUM(CASE WHEN status = 'Processing' THEN 1 ELSE 0 END) as processingOrders, " +
                "SUM(CASE WHEN status = 'Shipped' THEN 1 ELSE 0 END) as shippedOrders, " +
                "SUM(CASE WHEN status = 'Delivered' THEN 1 ELSE 0 END) as deliveredOrders, " +
                "SUM(CASE WHEN status = 'Cancelled' THEN 1 ELSE 0 END) as cancelledOrders " +
                "FROM customer_order " +
                "WHERE created_at BETWEEN ? AND ?" +
                (status != null && !status.isEmpty() ? " AND status = ?" : "");

        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, startDate + " 00:00:00");
            pstmt.setString(2, endDate + " 23:59:59");
            if (status != null && !status.isEmpty()) {
                pstmt.setString(3, status);
            }

            ResultSet rs = pstmt.executeQuery();
            if (rs.next()) {
                stats.put("totalOrders", rs.getInt("totalOrders"));
                stats.put("processingOrders", rs.getInt("processingOrders"));
                stats.put("shippedOrders", rs.getInt("shippedOrders"));
                stats.put("deliveredOrders", rs.getInt("deliveredOrders"));
                stats.put("cancelledOrders", rs.getInt("cancelledOrders"));
            }
        }

        return stats;
    }

    private Map<String, Integer> getOrdersByStatus(Connection conn, String startDate,
                                                   String endDate) throws SQLException {
        Map<String, Integer> statusMap = new HashMap<>();

        String sql = "SELECT status, COUNT(*) as count " +
                "FROM customer_order " +
                "WHERE created_at BETWEEN ? AND ? " +
                "GROUP BY status";

        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, startDate + " 00:00:00");
            pstmt.setString(2, endDate + " 23:59:59");

            ResultSet rs = pstmt.executeQuery();
            while (rs.next()) {
                statusMap.put(rs.getString("status"), rs.getInt("count"));
            }
        }

        return statusMap;
    }

    private List<Map<String, Object>> getDailyOrders(Connection conn, String startDate,
                                                     String endDate, String status) throws SQLException {
        List<Map<String, Object>> dailyOrders = new ArrayList<>();

        StringBuilder sql = new StringBuilder(
                "SELECT CONVERT(DATE, created_at) as date, COUNT(*) as orderCount " +
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
            while (rs.next()) {
                Map<String, Object> day = new HashMap<>();
                day.put("date", rs.getDate("date").toString());
                day.put("count", rs.getInt("orderCount"));
                dailyOrders.add(day);
            }
        }

        return dailyOrders;
    }

    private List<Map<String, Object>> getOrderList(Connection conn, String startDate,
                                                   String endDate, String status) throws SQLException {
        List<Map<String, Object>> orders = new ArrayList<>();

        StringBuilder sql = new StringBuilder(
                "SELECT o.order_number, o.status, o.total_amount, o.created_at, " +
                        "u.full_name, u.email, o.shipping_address " +
                        "FROM customer_order o " +
                        "JOIN app_user u ON o.user_id = u.id " +
                        "WHERE o.created_at BETWEEN ? AND ? "
        );

        if (status != null && !status.isEmpty()) {
            sql.append("AND o.status = ? ");
        }

        sql.append("ORDER BY o.created_at DESC");

        try (PreparedStatement pstmt = conn.prepareStatement(sql.toString())) {
            pstmt.setString(1, startDate + " 00:00:00");
            pstmt.setString(2, endDate + " 23:59:59");
            if (status != null && !status.isEmpty()) {
                pstmt.setString(3, status);
            }

            ResultSet rs = pstmt.executeQuery();
            while (rs.next()) {
                Map<String, Object> order = new HashMap<>();
                order.put("orderNumber", rs.getString("order_number"));
                order.put("status", rs.getString("status"));
                order.put("totalAmount", rs.getDouble("total_amount"));
                order.put("createdAt", rs.getTimestamp("created_at"));
                order.put("customerName", rs.getString("full_name"));
                order.put("customerEmail", rs.getString("email"));
                order.put("shippingAddress", rs.getString("shipping_address"));
                orders.add(order);
            }
        }

        return orders;
    }
}