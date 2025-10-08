package com.dao;

import com.model.User;
import com.util.DB;
import java.sql.*;
import java.time.LocalDateTime;

public class UserDAO {

    /**
     * Find user by email (joins with UserEmail table)
     */
    public User findByEmail(String email) throws SQLException {
        String sql =
                "SELECT u.user_id, u.first_name, u.last_name, u.password_hash, " +
                        "       u.status, u.created_at, u.last_login, ue.email " +
                        "FROM music.[User] u " +
                        "INNER JOIN music.UserEmail ue ON u.user_id = ue.user_id " +
                        "WHERE ue.email = ? AND ue.is_primary = 1";

        try (Connection con = DB.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, email.toLowerCase());
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    User u = new User();
                    u.setUserId(rs.getInt("user_id"));
                    u.setFirstName(rs.getString("first_name"));
                    u.setLastName(rs.getString("last_name"));
                    u.setEmail(rs.getString("email"));
                    u.setPasswordHash(rs.getString("password_hash"));
                    u.setStatus(rs.getString("status"));
                    u.setCreatedAt(rs.getObject("created_at", LocalDateTime.class));
                    u.setLastLogin(rs.getObject("last_login", LocalDateTime.class));
                    return u;
                }
                return null;
            }
        }
    }

    /**
     * Find user by ID
     */
    public User findById(int userId) throws SQLException {
        String sql =
                "SELECT u.user_id, u.first_name, u.last_name, u.password_hash, " +
                        "       u.status, u.created_at, u.last_login, ue.email " +
                        "FROM music.[User] u " +
                        "LEFT JOIN music.UserEmail ue ON u.user_id = ue.user_id AND ue.is_primary = 1 " +
                        "WHERE u.user_id = ?";

        try (Connection con = DB.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    User u = new User();
                    u.setUserId(rs.getInt("user_id"));
                    u.setFirstName(rs.getString("first_name"));
                    u.setLastName(rs.getString("last_name"));
                    u.setEmail(rs.getString("email"));
                    u.setPasswordHash(rs.getString("password_hash"));
                    u.setStatus(rs.getString("status"));
                    u.setCreatedAt(rs.getObject("created_at", LocalDateTime.class));
                    u.setLastLogin(rs.getObject("last_login", LocalDateTime.class));
                    return u;
                }
                return null;
            }
        }
    }

    /**
     * Create new user with email (inserts into User, UserEmail, and Customer tables)
     */
    public int create(String email, String firstName, String lastName, String passwordHash) throws SQLException {
        Connection conn = null;
        try {
            conn = DB.getConnection();
            conn.setAutoCommit(false); // Start transaction

            int userId;

            // 1. Insert into User table
            String sqlUser =
                    "INSERT INTO music.[User] (first_name, last_name, password_hash, status) " +
                            "VALUES (?, ?, ?, 'active')";
            try (PreparedStatement ps = conn.prepareStatement(sqlUser, Statement.RETURN_GENERATED_KEYS)) {
                ps.setString(1, firstName);
                ps.setString(2, lastName);
                ps.setString(3, passwordHash);
                ps.executeUpdate();

                try (ResultSet keys = ps.getGeneratedKeys()) {
                    if (keys.next()) {
                        userId = keys.getInt(1);
                    } else {
                        throw new SQLException("Failed to get user_id");
                    }
                }
            }

            // 2. Insert into UserEmail table
            String sqlEmail =
                    "INSERT INTO music.UserEmail (user_id, email, is_primary) VALUES (?, ?, 1)";
            try (PreparedStatement ps = conn.prepareStatement(sqlEmail)) {
                ps.setInt(1, userId);
                ps.setString(2, email.toLowerCase());
                ps.executeUpdate();
            }

            // 3. Insert into Customer table (make them a customer)
            String sqlCustomer =
                    "INSERT INTO music.Customer (user_id) VALUES (?)";
            try (PreparedStatement ps = conn.prepareStatement(sqlCustomer)) {
                ps.setInt(1, userId);
                ps.executeUpdate();
            }

            conn.commit(); // Commit transaction
            return userId;

        } catch (SQLException e) {
            if (conn != null) {
                try {
                    conn.rollback(); // Rollback on error
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
     * Update last login timestamp
     */
    public void updateLastLogin(int userId) throws SQLException {
        String sql = "UPDATE music.[User] SET last_login = GETDATE() WHERE user_id = ?";
        try (Connection conn = DB.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.executeUpdate();
        }
    }
}