package com.dao;

import com.model.User;
import com.util.DB;
import java.sql.*;
import java.time.LocalDateTime;

public class UserDAO {

    /**
     * Find user by email (NEW SCHEMA: dbo.app_user)
     */
    public User findByEmail(String email) throws SQLException {
        String sql =
                "SELECT id, email, password, full_name, role, created_at " +
                        "FROM dbo.app_user " +
                        "WHERE email = ?";

        try (Connection con = DB.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, email.toLowerCase());
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    User u = new User();
                    u.setId(rs.getInt("id"));
                    u.setEmail(rs.getString("email"));
                    u.setPassword(rs.getString("password"));
                    u.setFullName(rs.getString("full_name"));
                    u.setRole(rs.getString("role"));
                    u.setCreatedAt(rs.getTimestamp("created_at").toLocalDateTime());
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
                "SELECT id, email, password, full_name, role, created_at " +
                        "FROM dbo.app_user " +
                        "WHERE id = ?";

        try (Connection con = DB.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    User u = new User();
                    u.setId(rs.getInt("id"));
                    u.setEmail(rs.getString("email"));
                    u.setPassword(rs.getString("password"));
                    u.setFullName(rs.getString("full_name"));
                    u.setRole(rs.getString("role"));
                    u.setCreatedAt(rs.getTimestamp("created_at").toLocalDateTime());
                    return u;
                }
                return null;
            }
        }
    }

    /**
     * Create new user (simplified - just one table)
     */
    public int create(String email, String fullName, String password) throws SQLException {
        String sql =
                "INSERT INTO dbo.app_user (email, password, full_name, role) " +
                        "VALUES (?, ?, ?, 'Customer')";

        try (Connection conn = DB.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, email.toLowerCase());
            ps.setString(2, password);  // Should be hashed before calling this
            ps.setString(3, fullName);
            ps.executeUpdate();

            try (ResultSet keys = ps.getGeneratedKeys()) {
                if (keys.next()) {
                    return keys.getInt(1);
                } else {
                    throw new SQLException("Failed to get user id");
                }
            }
        }
    }

    /**
     * Update last login (NOT IN NEW SCHEMA - removing this)
     * You can add a last_login column if needed
     */
    public void updateLastLogin(int userId) throws SQLException {
        // No last_login column in new schema
        // If you want this feature, add this column:
        // ALTER TABLE dbo.app_user ADD last_login DATETIME2 NULL;

        // Then use this query:
        // String sql = "UPDATE dbo.app_user SET last_login = SYSUTCDATETIME() WHERE id = ?";

        // For now, do nothing
    }
}