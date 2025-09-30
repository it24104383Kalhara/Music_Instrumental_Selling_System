package com.dao;

import com.model.User;
import com.util.DB;
import java.sql.*;

public class UserDAO {

    public User findByEmail(String email) throws SQLException{
        String sql = "SELECT id, email, full_name, password_hash FROM dbo.app_user WHERE email = ?";
        try (Connection con = DB.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)){
            ps.setString(1, email.toLowerCase());
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    User u = new User();
                    u.setId(rs.getInt("id"));
                    u.setEmail(rs.getString("email"));
                    u.setFullName(rs.getString("full_name"));
                    u.setPasswordHash(rs.getString("password_hash"));
                    return u;
                }
                return null;
            }
        }
    }

    public int create(String email, String fullName, String passwordHash) throws SQLException {
        String sql = "INSERT INTO dbo.app_user (email, full_name, password_hash) VALUES (?,?,?)";
        try (Connection conn = DB.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, email.toLowerCase());
            ps.setString(2, fullName);
            ps.setString(3, passwordHash);
            ps.executeUpdate();
            try (ResultSet keys = ps.getGeneratedKeys()) {
                if (keys.next()) return keys.getInt(1);

            }
        }
        return -1;
    }

}
