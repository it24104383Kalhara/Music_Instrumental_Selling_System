package com.dao;

import com.model.Order;
import com.util.DB;
import java.math.BigDecimal;
import java.sql.*;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

public class OrderDAO {

    /**
     * Get recent orders by user (SIMPLIFIED - NO JOINS)
     */
    public List<Order> recentByUser(int userId, int limit) throws SQLException {
        String sql =
                "SELECT o.order_id, o.order_datetime, o.subtotal, o.delivery_fee, o.total, " +
                        "       o.status, o.created_at " +
                        "FROM music.[Order] o " +
                        "INNER JOIN music.Places pl ON o.order_id = pl.order_id " +
                        "WHERE pl.user_id = ? " +
                        "ORDER BY o.created_at DESC " +
                        "OFFSET 0 ROWS FETCH NEXT ? ROWS ONLY";

        List<Order> list = new ArrayList<>();
        try (Connection con = DB.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setInt(2, limit);
            ps.setQueryTimeout(5);  // 5 second timeout

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Order o = new Order();
                    o.setOrderId(rs.getInt("order_id"));
                    o.setOrderDatetime(rs.getObject("order_datetime", LocalDateTime.class));
                    o.setSubtotal(rs.getBigDecimal("subtotal"));
                    o.setDeliveryFee(rs.getBigDecimal("delivery_fee"));
                    o.setTotal(rs.getBigDecimal("total"));
                    o.setStatus(rs.getString("status"));
                    o.setCreatedAt(rs.getObject("created_at", LocalDateTime.class));

                    // Set defaults for missing data
                    o.setPaymentStatus("Pending");
                    o.setShipmentStatus("Not Shipped");

                    list.add(o);
                }
            }
        } catch (SQLException e) {
            System.err.println("ERROR in recentByUser: " + e.getMessage());
            e.printStackTrace();
            throw e;
        }
        return list;
    }
    /**
     * Get all orders (for admin dashboard)
     */
    public List<Order> getAllOrders() throws SQLException {
        String sql =
                "SELECT o.order_id, o.order_datetime, o.subtotal, o.delivery_fee, o.total, " +
                        "       o.status, o.created_at, " +
                        "       p.payment_id, p.status AS payment_status, " +
                        "       s.shipment_id, s.status AS shipment_status, " +
                        "       u.first_name, u.last_name, pl.user_id " +
                        "FROM music.[Order] o " +
                        "INNER JOIN music.Places pl ON o.order_id = pl.order_id " +
                        "INNER JOIN music.[User] u ON pl.user_id = u.user_id " +
                        "LEFT JOIN music.OrderPayment op ON o.order_id = op.order_id " +
                        "LEFT JOIN music.PaymentAttempt p ON op.payment_id = p.payment_id " +
                        "LEFT JOIN music.OrderShipment os ON o.order_id = os.order_id " +
                        "LEFT JOIN music.Shipment s ON os.shipment_id = s.shipment_id " +
                        "ORDER BY o.created_at DESC";

        List<Order> list = new ArrayList<>();
        try (Connection con = DB.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapWithDetails(rs));
                }
            }
        }
        return list;
    }

    /**
     * Find order by ID and user
     */
    public Order findByIdAndUser(int orderId, int userId) throws SQLException {
        String sql =
                "SELECT o.order_id, o.order_datetime, o.subtotal, o.delivery_fee, o.total, " +
                        "       o.status, o.created_at, " +
                        "       p.payment_id, p.status AS payment_status, " +
                        "       s.shipment_id, s.status AS shipment_status, s.tracking_no, " +
                        "       s.shipped_at, s.delivered_at, " +
                        "       u.first_name, u.last_name, " +
                        "       sa.line1, sa.city, sa.postal_code " +
                        "FROM music.[Order] o " +
                        "INNER JOIN music.Places pl ON o.order_id = pl.order_id " +
                        "INNER JOIN music.[User] u ON pl.user_id = u.user_id " +
                        "LEFT JOIN music.OrderPayment op ON o.order_id = op.order_id " +
                        "LEFT JOIN music.PaymentAttempt p ON op.payment_id = p.payment_id " +
                        "LEFT JOIN music.OrderShipment os ON o.order_id = os.order_id " +
                        "LEFT JOIN music.Shipment s ON os.shipment_id = s.shipment_id " +
                        "LEFT JOIN music.OrderShippingAddress osa ON o.order_id = osa.order_id " +
                        "LEFT JOIN music.ShippingAddress sa ON osa.address_id = sa.address_id " +
                        "WHERE o.order_id = ? AND pl.user_id = ?";

        try (Connection con = DB.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, orderId);
            ps.setInt(2, userId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Order order = mapWithDetails(rs);
                    // Add shipping address
                    String addr = rs.getString("line1");
                    if (addr != null) {
                        order.setShippingAddress(addr + ", " +
                                rs.getString("city") + " " +
                                rs.getString("postal_code"));
                    }
                    return order;
                }
                return null;
            }
        }
    }

    /**
     * Get order status
     */
    public String getStatus(int orderId, int userId) throws SQLException {
        String sql =
                "SELECT o.status FROM music.[Order] o " +
                        "INNER JOIN music.Places p ON o.order_id = p.order_id " +
                        "WHERE o.order_id = ? AND p.user_id = ?";

        try (Connection con = DB.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, orderId);
            ps.setInt(2, userId);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? rs.getString(1) : null;
            }
        }
    }

    /**
     * Insert new order (creates order and links to user via Places table)
     */
    public int insert(int userId, BigDecimal subtotal, BigDecimal deliveryFee, BigDecimal total) throws SQLException {
        Connection conn = null;
        try {
            conn = DB.getConnection();
            conn.setAutoCommit(false);

            int orderId;

            // 1. Insert into Order table
            String sqlOrder =
                    "INSERT INTO music.[Order] (order_datetime, subtotal, delivery_fee, total, status) " +
                            "VALUES (GETDATE(), ?, ?, ?, 'Unconfirmed')";
            try (PreparedStatement ps = conn.prepareStatement(sqlOrder, Statement.RETURN_GENERATED_KEYS)) {
                ps.setBigDecimal(1, subtotal);
                ps.setBigDecimal(2, deliveryFee);
                ps.setBigDecimal(3, total);
                ps.executeUpdate();

                try (ResultSet keys = ps.getGeneratedKeys()) {
                    if (keys.next()) {
                        orderId = keys.getInt(1);
                    } else {
                        throw new SQLException("Failed to get order_id");
                    }
                }
            }

            // 2. Link to user via Places table
            String sqlPlaces =
                    "INSERT INTO music.Places (user_id, order_id) VALUES (?, ?)";
            try (PreparedStatement ps = conn.prepareStatement(sqlPlaces)) {
                ps.setInt(1, userId);
                ps.setInt(2, orderId);
                ps.executeUpdate();
            }

            conn.commit();
            return orderId;

        } catch (SQLException e) {
            if (conn != null) {
                try {
                    conn.rollback();
                } catch (SQLException ex) {
                    ex.printStackTrace();
                }
            }
            throw e;
        } finally {
            if (conn != null) {
                try {
                    conn.setAutoCommit(true);
                    conn.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
        }
    }

    /**
     * Map ResultSet to Order object (basic fields only)
     */
    private Order mapBasic(ResultSet rs) throws SQLException {
        Order o = new Order();
        o.setOrderId(rs.getInt("order_id"));
        o.setOrderDatetime(rs.getObject("order_datetime", LocalDateTime.class));
        o.setSubtotal(rs.getBigDecimal("subtotal"));
        o.setDeliveryFee(rs.getBigDecimal("delivery_fee"));
        o.setTotal(rs.getBigDecimal("total"));
        o.setStatus(rs.getString("status"));
        o.setCreatedAt(rs.getObject("created_at", LocalDateTime.class));
        return o;
    }

    /**
     * Map ResultSet to Order with payment and shipment details
     */
    private Order mapWithDetails(ResultSet rs) throws SQLException {
        Order o = mapBasic(rs);

        // Add payment status
        String paymentStatus = rs.getString("payment_status");
        o.setPaymentStatus(paymentStatus != null ? paymentStatus : "Pending");

        // Add shipment status
        String shipmentStatus = rs.getString("shipment_status");
        o.setShipmentStatus(shipmentStatus != null ? shipmentStatus : "Not Shipped");

        // Add customer name
        String firstName = rs.getString("first_name");
        String lastName = rs.getString("last_name");
        if (firstName != null || lastName != null) {
            o.setCustomerName((firstName != null ? firstName : "") + " " +
                    (lastName != null ? lastName : ""));
        }

        // Add userId if present
        try {
            int userId = rs.getInt("user_id");
            if (!rs.wasNull()) {
                o.setUserId(userId);
            }
        } catch (SQLException e) {
            // Column might not be in SELECT, ignore
        }

        return o;
    }
}