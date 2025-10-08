package com.dao;

import com.model.Order;
import com.util.DB;
import java.sql.*;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

public class OrderDAO {

    public List<Order> recentByUser(int userId, int limit) throws SQLException {
        String sql =
                "SELECT id, order_number, status, created_at, updated_at " +
                        "FROM dbo.customer_order WHERE user_id = ? " +
                        "ORDER BY created_at DESC " +
                        "OFFSET 0 ROWS FETCH NEXT ? ROWS ONLY";
        List<Order> list = new ArrayList<>();
        try (Connection con = DB.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setInt(2, limit);
            try (ResultSet rs = ps.executeQuery()){
                while (rs.next()) {
                    list.add(map(rs));
                }
            }
        }
        return list;
    }

    public int countByUserId(int userId) throws SQLException {
        String sql = "SELECT COUNT(*) FROM dbo.customer_order WHERE user_id = ?";
        try (Connection con = DB.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? rs.getInt(1) : 0;
            }
        }
    }
    public List<Order> getAllOrders() throws SQLException {
        String sql = "SELECT id, order_number, status, created_at, updated_at " +
                "FROM dbo.customer_order " +
                "ORDER BY created_at DESC";  // NOT SELECT COUNT(*)!
        List<Order> list = new ArrayList<>();
        try (Connection con = DB.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(map(rs));
                }
            }
        }
        return list;
    }
    public Order findByIdAndUser(long id, int userId) throws  SQLException {
        String sql = "SELECT id, order_number, status, created_at, updated_at "+
                "FROM dbo.customer_order WHERE id = ? AND user_id = ?";
        try (Connection con = DB.getConnection();
        PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setLong(1, id);
            ps.setInt(2, userId);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? map(rs) : null;
            }
        }
    }

    public String getStatus(long id, int userId) throws SQLException {
        String sql = "SELECT status FROM dbo.customer_order WHERE id = ? AND user_id = ?";
        try (Connection con = DB.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)){
            ps.setLong(1, id);
            ps.setInt(2, userId);
            try (ResultSet rs = ps.executeQuery()){
                return rs.next() ? rs.getString(1) : null;
            }
        }
    }

    public long insert(int userId, String orderNumber, String status) throws SQLException {
        String sql = "INSERT INTO dbo.customer_order (user_id, order_number, status) VALUES (?,?,?)";
        try (Connection con = DB.getConnection();
        PreparedStatement ps = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)){
           ps.setLong(1,userId);
           ps.setString(2, orderNumber);
           ps.setString(3,status);
           ps.executeUpdate();
           try(ResultSet keys = ps.getGeneratedKeys()) {
               return keys.next() ? keys.getLong(1) : -1L;
           }
        }
    }

    private Order map(ResultSet rs) throws SQLException {
        Order o = new Order();
        o.setId(rs.getLong("id"));
        o.setOrderNumber(rs.getString("order_number"));
        o.setStatus(rs.getString("status"));
        o.setCreatedAt(rs.getObject("created_at", LocalDateTime.class));
        o.setUpdatedAt(rs.getObject("updated_at", LocalDateTime.class));
        return o;
    }


}
