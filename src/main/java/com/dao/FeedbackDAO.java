package com.dao;

import com.model.Feedback;
import com.util.DB;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class FeedbackDAO {

    /**
     * Insert new feedback
     */
    public long insert(int userId, int instrumentId, long orderId, int rating, String comment) throws SQLException {
        String sql =
                "INSERT INTO dbo.product_feedback (user_id, instrument_id, order_id, rating, comment, is_approved) " +
                        "VALUES (?, ?, ?, ?, ?, 1)";

        try (Connection conn = DB.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            ps.setInt(1, userId);
            ps.setInt(2, instrumentId);
            ps.setLong(3, orderId);
            ps.setInt(4, rating);
            ps.setString(5, comment);
            ps.executeUpdate();

            try (ResultSet keys = ps.getGeneratedKeys()) {
                if (keys.next()) {
                    return keys.getLong(1);
                } else {
                    throw new SQLException("Failed to get feedback id");
                }
            }
        }
    }

    /**
     * Get approved reviews for an instrument (public view)
     */
    public List<Feedback> getApprovedReviewsByInstrument(int instrumentId) throws SQLException {
        String sql =
                "SELECT f.id, f.user_id, f.instrument_id, f.order_id, f.rating, f.comment, " +
                        "       f.is_approved, f.created_at, u.full_name " +
                        "FROM dbo.product_feedback f " +
                        "INNER JOIN dbo.app_user u ON f.user_id = u.id " +
                        "WHERE f.instrument_id = ? AND f.is_approved = 1 " +
                        "ORDER BY f.created_at DESC";

        List<Feedback> list = new ArrayList<>();
        try (Connection con = DB.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, instrumentId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Feedback feedback = mapResultSetToFeedback(rs);
                    feedback.setUserName(rs.getString("full_name"));
                    list.add(feedback);
                }
            }
        }
        return list;
    }

    /**
     * Get all reviews by user (for customer's "My Reviews" page)
     */
    public List<Feedback> getReviewsByUser(int userId) throws SQLException {
        String sql =
                "SELECT f.id, f.user_id, f.instrument_id, f.order_id, f.rating, f.comment, " +
                        "       f.is_approved, f.created_at, i.name as instrument_name, o.order_number " +
                        "FROM dbo.product_feedback f " +
                        "INNER JOIN dbo.instrument i ON f.instrument_id = i.id " +
                        "INNER JOIN dbo.customer_order o ON f.order_id = o.id " +
                        "WHERE f.user_id = ? " +
                        "ORDER BY f.created_at DESC";

        List<Feedback> list = new ArrayList<>();
        try (Connection con = DB.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Feedback feedback = mapResultSetToFeedback(rs);
                    feedback.setInstrumentName(rs.getString("instrument_name"));
                    feedback.setOrderNumber(rs.getString("order_number"));
                    list.add(feedback);
                }
            }
        }
        return list;
    }

    /**
     * Get all reviews (for admin)
     */
    public List<Feedback> getAllReviews() throws SQLException {
        String sql =
                "SELECT f.id, f.user_id, f.instrument_id, f.order_id, f.rating, f.comment, " +
                        "       f.is_approved, f.created_at, " +
                        "       u.full_name, i.name as instrument_name, o.order_number " +
                        "FROM dbo.product_feedback f " +
                        "INNER JOIN dbo.app_user u ON f.user_id = u.id " +
                        "INNER JOIN dbo.instrument i ON f.instrument_id = i.id " +
                        "INNER JOIN dbo.customer_order o ON f.order_id = o.id " +
                        "ORDER BY f.created_at DESC";

        List<Feedback> list = new ArrayList<>();
        try (Connection con = DB.getConnection();
             Statement stmt = con.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {

            while (rs.next()) {
                Feedback feedback = mapResultSetToFeedback(rs);
                feedback.setUserName(rs.getString("full_name"));
                feedback.setInstrumentName(rs.getString("instrument_name"));
                feedback.setOrderNumber(rs.getString("order_number"));
                list.add(feedback);
            }
        }
        return list;
    }

    /**
     * Get pending reviews (for admin)
     */
    public List<Feedback> getPendingReviews() throws SQLException {
        String sql =
                "SELECT f.id, f.user_id, f.instrument_id, f.order_id, f.rating, f.comment, " +
                        "       f.is_approved, f.created_at, " +
                        "       u.full_name, i.name as instrument_name, o.order_number " +
                        "FROM dbo.product_feedback f " +
                        "INNER JOIN dbo.app_user u ON f.user_id = u.id " +
                        "INNER JOIN dbo.instrument i ON f.instrument_id = i.id " +
                        "INNER JOIN dbo.customer_order o ON f.order_id = o.id " +
                        "WHERE f.is_approved = 0 " +
                        "ORDER BY f.created_at DESC";

        List<Feedback> list = new ArrayList<>();
        try (Connection con = DB.getConnection();
             Statement stmt = con.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {

            while (rs.next()) {
                Feedback feedback = mapResultSetToFeedback(rs);
                feedback.setUserName(rs.getString("full_name"));
                feedback.setInstrumentName(rs.getString("instrument_name"));
                feedback.setOrderNumber(rs.getString("order_number"));
                list.add(feedback);
            }
        }
        return list;
    }

    /**
     * Check if user already reviewed this instrument for this order
     */
    public boolean hasUserReviewedInstrument(int userId, int instrumentId, long orderId) throws SQLException {
        String sql =
                "SELECT COUNT(*) as count FROM dbo.product_feedback " +
                        "WHERE user_id = ? AND instrument_id = ? AND order_id = ?";

        try (Connection con = DB.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setInt(2, instrumentId);
            ps.setLong(3, orderId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("count") > 0;
                }
            }
        }
        return false;
    }

    /**
     * Get average rating for an instrument
     */
    public double getAverageRating(int instrumentId) throws SQLException {
        String sql =
                "SELECT AVG(CAST(rating AS FLOAT)) as avg_rating " +
                        "FROM dbo.product_feedback " +
                        "WHERE instrument_id = ? AND is_approved = 1";

        try (Connection con = DB.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, instrumentId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getDouble("avg_rating");
                }
            }
        }
        return 0.0;
    }

    /**
     * Get review count for an instrument
     */
    public int getReviewCount(int instrumentId) throws SQLException {
        String sql =
                "SELECT COUNT(*) as count FROM dbo.product_feedback " +
                        "WHERE instrument_id = ? AND is_approved = 1";

        try (Connection con = DB.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, instrumentId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("count");
                }
            }
        }
        return 0;
    }

    /**
     * Approve review (admin action)
     */
    public boolean approveReview(long feedbackId) throws SQLException {
        String sql = "UPDATE dbo.product_feedback SET is_approved = 1 WHERE id = ?";

        try (Connection conn = DB.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setLong(1, feedbackId);
            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;
        }
    }

    /**
     * Reject/Unapprove review (admin action)
     */
    public boolean rejectReview(long feedbackId) throws SQLException {
        String sql = "UPDATE dbo.product_feedback SET is_approved = 0 WHERE id = ?";

        try (Connection conn = DB.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setLong(1, feedbackId);
            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;
        }
    }

    /**
     * Delete review
     */
    public boolean deleteReview(long feedbackId) throws SQLException {
        String sql = "DELETE FROM dbo.product_feedback WHERE id = ?";

        try (Connection conn = DB.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setLong(1, feedbackId);
            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;
        }
    }

    /**
     * Get feedback by ID
     */
    public Feedback findById(long feedbackId) throws SQLException {
        String sql =
                "SELECT f.id, f.user_id, f.instrument_id, f.order_id, f.rating, f.comment, " +
                        "       f.is_approved, f.created_at " +
                        "FROM dbo.product_feedback f " +
                        "WHERE f.id = ?";

        try (Connection con = DB.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setLong(1, feedbackId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToFeedback(rs);
                }
                return null;
            }
        }
    }

    /**
     * Get delivered orders with instruments that user can review
     */
    public List<ReviewableOrder> getReviewableOrders(int userId) throws SQLException {
        String sql =
                "SELECT o.id as order_id, o.order_number, o.created_at, " +
                        "       i.id as instrument_id, i.name as instrument_name, " +
                        "       CASE WHEN f.id IS NOT NULL THEN CAST(1 AS BIT) ELSE CAST(0 AS BIT) END as already_reviewed " +
                        "FROM dbo.customer_order o " +
                        "INNER JOIN dbo.order_item oi ON o.id = oi.order_id " +
                        "INNER JOIN dbo.instrument i ON oi.instrument_id = i.id " +
                        "LEFT JOIN dbo.product_feedback f ON f.order_id = o.id " +
                        "       AND f.instrument_id = i.id AND f.user_id = ? " +
                        "WHERE o.user_id = ? AND o.status = 'Delivered' " +
                        "ORDER BY o.created_at DESC";

        List<ReviewableOrder> list = new ArrayList<>();
        try (Connection con = DB.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setInt(2, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    ReviewableOrder ro = new ReviewableOrder();
                    ro.orderId = rs.getLong("order_id");
                    ro.orderNumber = rs.getString("order_number");
                    ro.instrumentId = rs.getInt("instrument_id");
                    ro.instrumentName = rs.getString("instrument_name");
                    ro.alreadyReviewed = rs.getBoolean("already_reviewed");
                    list.add(ro);
                }
            }
        }
        return list;
    }

    /**
     * Helper method to map ResultSet to Feedback object
     */
    private Feedback mapResultSetToFeedback(ResultSet rs) throws SQLException {
        Feedback feedback = new Feedback();
        feedback.setId(rs.getLong("id"));
        feedback.setUserId(rs.getInt("user_id"));
        feedback.setInstrumentId(rs.getInt("instrument_id"));
        feedback.setOrderId(rs.getLong("order_id"));
        feedback.setRating(rs.getInt("rating"));
        feedback.setComment(rs.getString("comment"));
        feedback.setApproved(rs.getBoolean("is_approved"));

        Timestamp createdAt = rs.getTimestamp("created_at");
        if (createdAt != null) {
            feedback.setCreatedAt(createdAt.toLocalDateTime());
        }

        return feedback;
    }

    /**
     * Inner class for reviewable orders
     */
    public static class ReviewableOrder {
        public long orderId;
        public String orderNumber;
        public int instrumentId;
        public String instrumentName;
        public boolean alreadyReviewed;

        // Getters (required for JSP EL)
        public long getOrderId() {
            return orderId;
        }

        public String getOrderNumber() {
            return orderNumber;
        }

        public int getInstrumentId() {
            return instrumentId;
        }

        public String getInstrumentName() {
            return instrumentName;
        }

        public boolean isAlreadyReviewed() {
            return alreadyReviewed;
        }
    }
}