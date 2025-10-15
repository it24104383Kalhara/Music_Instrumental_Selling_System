package com.dao;

import com.model.Order;
import com.util.DB;
import java.math.BigDecimal;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class OrderDAO {

    /**
     * Get orders by user ID (for customer dashboard)
     */
    public List<Order> recentByUser(int userId, int limit) throws SQLException {
        String sql =
                "SELECT id, user_id, order_number, status, total_amount, " +
                        "       created_at, updated_at, shipping_address " +
                        "FROM dbo.customer_order " +
                        "WHERE user_id = ? " +
                        "ORDER BY created_at DESC " +
                        "OFFSET 0 ROWS FETCH NEXT ? ROWS ONLY";

        List<Order> list = new ArrayList<>();
        try (Connection con = DB.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setInt(2, limit);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapBasic(rs));
                }
            }
        }
        return list;
    }

    /**
     * Get ALL orders by user (no limit)
     */
    public List<Order> getAllByUser(int userId) throws SQLException {
        String sql =
                "SELECT id, user_id, order_number, status, total_amount, " +
                        "       created_at, updated_at, shipping_address " +
                        "FROM dbo.customer_order " +
                        "WHERE user_id = ? " +
                        "ORDER BY created_at DESC";

        List<Order> list = new ArrayList<>();
        try (Connection con = DB.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, userId);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapBasic(rs));
                }
            }
        }
        return list;
    }

    /**
     * Get ALL orders with customer info (for admin dashboard)
     */
    public List<Order> getAllOrdersWithCustomerInfo() throws SQLException {
        String sql =
                "SELECT o.id, o.user_id, o.order_number, o.status, o.total_amount, " +
                        "       o.created_at, o.updated_at, o.shipping_address, " +
                        "       u.full_name, u.email " +
                        "FROM dbo.customer_order o " +
                        "INNER JOIN dbo.app_user u ON o.user_id = u.id " +
                        "ORDER BY o.created_at DESC";

        List<Order> list = new ArrayList<>();
        try (Connection con = DB.getConnection();
             Statement stmt = con.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {

            while (rs.next()) {
                Order order = mapBasic(rs);
                order.setCustomerName(rs.getString("full_name"));
                order.setCustomerEmail(rs.getString("email"));
                list.add(order);
            }
        }
        return list;
    }

    /**
     * Get order by ID and user
     */
    public Order findByIdAndUser(long orderId, int userId) throws SQLException {
        String sql =
                "SELECT o.id, o.user_id, o.order_number, o.status, o.total_amount, " +
                        "       o.created_at, o.updated_at, o.shipping_address, " +
                        "       u.full_name, u.email " +
                        "FROM dbo.customer_order o " +
                        "INNER JOIN dbo.app_user u ON o.user_id = u.id " +
                        "WHERE o.id = ? AND o.user_id = ?";

        try (Connection con = DB.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setLong(1, orderId);
            ps.setInt(2, userId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Order order = mapBasic(rs);
                    order.setCustomerName(rs.getString("full_name"));
                    order.setCustomerEmail(rs.getString("email"));
                    return order;
                }
                return null;
            }
        }
    }

    /**
     * Update order status (ADMIN ONLY)
     */
    public boolean updateOrderStatus(long orderId, String newStatus) throws SQLException {
        String sql =
                "UPDATE dbo.customer_order " +
                        "SET status = ?, updated_at = SYSUTCDATETIME() " +
                        "WHERE id = ?";

        try (Connection conn = DB.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, newStatus);
            ps.setLong(2, orderId);

            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;
        }
    }

    /**
     * Get order count by status (for admin statistics)
     */
    public int getOrderCountByStatus(String status) throws SQLException {
        String sql = "SELECT COUNT(*) as count FROM dbo.customer_order WHERE status = ?";

        try (Connection conn = DB.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                return rs.getInt("count");
            }
        }
        return 0;
    }

    /**
     * Get order status by order ID and user ID
     * Used by OrderStatusApiServlet for tracking
     */
    public String getStatus(int orderId, int userId) throws SQLException {
        String sql =
                "SELECT status FROM dbo.customer_order " +
                        "WHERE id = ? AND user_id = ?";

        try (Connection con = DB.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, orderId);
            ps.setInt(2, userId);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? rs.getString("status") : null;
            }
        }
    }

    /**
     * Get total orders count
     */
    public int getTotalOrdersCount() throws SQLException {
        String sql = "SELECT COUNT(*) as count FROM dbo.customer_order";

        try (Connection conn = DB.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {

            if (rs.next()) {
                return rs.getInt("count");
            }
        }
        return 0;
    }

    /**
     * Insert new order
     */
    public long insert(int userId, String orderNumber, BigDecimal totalAmount, String shippingAddress) throws SQLException {
        String sql =
                "INSERT INTO dbo.customer_order (user_id, order_number, status, total_amount, shipping_address) " +
                        "VALUES (?, ?, 'Processing', ?, ?)";

        try (Connection conn = DB.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, userId);
            ps.setString(2, orderNumber);
            ps.setBigDecimal(3, totalAmount);
            ps.setString(4, shippingAddress);
            ps.executeUpdate();

            try (ResultSet keys = ps.getGeneratedKeys()) {
                if (keys.next()) {
                    return keys.getLong(1);
                } else {
                    throw new SQLException("Failed to get order id");
                }
            }
        }
    }

    /**
     * Map ResultSet to Order object
     */
    private Order mapBasic(ResultSet rs) throws SQLException {
        Order o = new Order();
        o.setId(rs.getLong("id"));
        o.setUserId(rs.getInt("user_id"));
        o.setOrderNumber(rs.getString("order_number"));
        o.setStatus(rs.getString("status"));
        o.setTotalAmount(rs.getBigDecimal("total_amount"));
        o.setCreatedAt(rs.getTimestamp("created_at").toLocalDateTime());
        o.setUpdatedAt(rs.getTimestamp("updated_at").toLocalDateTime());
        o.setShippingAddress(rs.getString("shipping_address"));
        return o;
    }
}