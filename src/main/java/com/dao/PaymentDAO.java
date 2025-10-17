package com.dao;

import com.model.Payment;
import com.util.DB;
import java.math.BigDecimal;
import java.sql.*;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

public class PaymentDAO {

    /**
     * Insert new payment record
     */
    public long insert(long orderId, BigDecimal amount, String paymentMethod, String transactionId, String notes) throws SQLException {
        String sql =
                "INSERT INTO dbo.payment (order_id, amount, payment_method, payment_status, " +
                        "transaction_id, payment_date, is_verified, notes) " +
                        "VALUES (?, ?, ?, 'Pending', ?, SYSUTCDATETIME(), 0, ?)";

        try (Connection conn = DB.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            ps.setLong(1, orderId);
            ps.setBigDecimal(2, amount);
            ps.setString(3, paymentMethod);
            ps.setString(4, transactionId);
            ps.setString(5, notes);
            ps.executeUpdate();

            try (ResultSet keys = ps.getGeneratedKeys()) {
                if (keys.next()) {
                    return keys.getLong(1);
                } else {
                    throw new SQLException("Failed to get payment id");
                }
            }
        }
    }

    /**
     * Get payment by order ID
     */
    public Payment findByOrderId(long orderId) throws SQLException {
        String sql =
                "SELECT id, order_id, amount, payment_method, payment_status, " +
                        "       transaction_id, payment_date, is_verified, verified_by, verified_at, notes " +
                        "FROM dbo.payment WHERE order_id = ?";

        try (Connection con = DB.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setLong(1, orderId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToPayment(rs);
                }
                return null;
            }
        }
    }

    /**
     * Get all pending payments (for admin verification)
     */
    public List<Payment> getPendingPayments() throws SQLException {
        String sql =
                "SELECT p.id, p.order_id, p.amount, p.payment_method, p.payment_status, " +
                        "       p.transaction_id, p.payment_date, p.is_verified, p.verified_by, p.verified_at, p.notes, " +
                        "       o.order_number, u.full_name as customer_name " +
                        "FROM dbo.payment p " +
                        "INNER JOIN dbo.customer_order o ON p.order_id = o.id " +
                        "INNER JOIN dbo.app_user u ON o.user_id = u.id " +
                        "WHERE p.is_verified = 0 AND p.payment_status = 'Pending' " +
                        "ORDER BY p.payment_date DESC";

        List<Payment> list = new ArrayList<>();
        try (Connection con = DB.getConnection();
             Statement stmt = con.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {

            while (rs.next()) {
                Payment payment = mapResultSetToPayment(rs);
                payment.setOrderNumber(rs.getString("order_number"));
                payment.setCustomerName(rs.getString("customer_name"));
                list.add(payment);
            }
        }
        return list;
    }

    /**
     * Get all payments with customer info (for admin)
     */
    public List<Payment> getAllPayments() throws SQLException {
        String sql =
                "SELECT p.id, p.order_id, p.amount, p.payment_method, p.payment_status, " +
                        "       p.transaction_id, p.payment_date, p.is_verified, p.verified_by, p.verified_at, p.notes, " +
                        "       o.order_number, u.full_name as customer_name " +
                        "FROM dbo.payment p " +
                        "INNER JOIN dbo.customer_order o ON p.order_id = o.id " +
                        "INNER JOIN dbo.app_user u ON o.user_id = u.id " +
                        "ORDER BY p.payment_date DESC";

        List<Payment> list = new ArrayList<>();
        try (Connection con = DB.getConnection();
             Statement stmt = con.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {

            while (rs.next()) {
                Payment payment = mapResultSetToPayment(rs);
                payment.setOrderNumber(rs.getString("order_number"));
                payment.setCustomerName(rs.getString("customer_name"));
                list.add(payment);
            }
        }
        return list;
    }

    /**
     * Verify payment (admin action)
     */
    public boolean verifyPayment(long paymentId, int adminUserId, String notes) throws SQLException {
        String sql =
                "UPDATE dbo.payment " +
                        "SET is_verified = 1, verified_by = ?, verified_at = SYSUTCDATETIME(), " +
                        "    payment_status = 'Completed', notes = ? " +
                        "WHERE id = ?";

        try (Connection conn = DB.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, adminUserId);
            ps.setString(2, notes);
            ps.setLong(3, paymentId);

            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;
        }
    }

    /**
     * Update payment status
     */
    public boolean updatePaymentStatus(long paymentId, String newStatus) throws SQLException {
        String sql = "UPDATE dbo.payment SET payment_status = ? WHERE id = ?";

        try (Connection conn = DB.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, newStatus);
            ps.setLong(2, paymentId);

            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;
        }
    }

    /**
     * Get payment statistics (for admin dashboard/reports)
     */
    public int getPaymentCountByStatus(String status) throws SQLException {
        String sql = "SELECT COUNT(*) as count FROM dbo.payment WHERE payment_status = ?";

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
     * Get total revenue (verified payments only)
     */
    public BigDecimal getTotalRevenue() throws SQLException {
        String sql = "SELECT SUM(amount) as total FROM dbo.payment WHERE is_verified = 1";

        try (Connection conn = DB.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {

            if (rs.next()) {
                BigDecimal total = rs.getBigDecimal("total");
                return total != null ? total : BigDecimal.ZERO;
            }
        }
        return BigDecimal.ZERO;
    }

    /**
     * Helper method to map ResultSet to Payment object
     */
    private Payment mapResultSetToPayment(ResultSet rs) throws SQLException {
        Payment payment = new Payment();
        payment.setId(rs.getLong("id"));
        payment.setOrderId(rs.getLong("order_id"));
        payment.setAmount(rs.getBigDecimal("amount"));
        payment.setPaymentMethod(rs.getString("payment_method"));
        payment.setPaymentStatus(rs.getString("payment_status"));
        payment.setTransactionId(rs.getString("transaction_id"));

        Timestamp paymentDate = rs.getTimestamp("payment_date");
        if (paymentDate != null) {
            payment.setPaymentDate(paymentDate.toLocalDateTime());
        }

        payment.setVerified(rs.getBoolean("is_verified"));

        int verifiedBy = rs.getInt("verified_by");
        if (!rs.wasNull()) {
            payment.setVerifiedBy(verifiedBy);
        }

        Timestamp verifiedAt = rs.getTimestamp("verified_at");
        if (verifiedAt != null) {
            payment.setVerifiedAt(verifiedAt.toLocalDateTime());
        }

        payment.setNotes(rs.getString("notes"));

        return payment;
    }
}