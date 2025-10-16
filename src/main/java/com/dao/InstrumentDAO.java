package com.dao;

import com.model.Instrument;
import com.util.DB;
import java.math.BigDecimal;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class InstrumentDAO {

    /**
     * Get all instruments
     */
    public List<Instrument> getAllInstruments() throws SQLException {
        String sql =
                "SELECT id, name, description, price, in_stock, stock_quantity, created_at " +
                        "FROM dbo.instrument " +
                        "ORDER BY created_at DESC";

        List<Instrument> list = new ArrayList<>();
        try (Connection con = DB.getConnection();
             Statement stmt = con.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {

            while (rs.next()) {
                list.add(mapResultSetToInstrument(rs));
            }
        }
        return list;
    }

    /**
     * Get instruments that are in stock
     */
    public List<Instrument> getInStockInstruments() throws SQLException {
        String sql =
                "SELECT id, name, description, price, in_stock, stock_quantity, created_at " +
                        "FROM dbo.instrument " +
                        "WHERE in_stock = 1 AND stock_quantity > 0 " +
                        "ORDER BY created_at DESC";

        List<Instrument> list = new ArrayList<>();
        try (Connection con = DB.getConnection();
             Statement stmt = con.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {

            while (rs.next()) {
                list.add(mapResultSetToInstrument(rs));
            }
        }
        return list;
    }

    /**
     * Get instrument by ID
     */
    public Instrument findById(int id) throws SQLException {
        String sql =
                "SELECT id, name, description, price, in_stock, stock_quantity, created_at " +
                        "FROM dbo.instrument " +
                        "WHERE id = ?";

        try (Connection con = DB.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToInstrument(rs);
                }
                return null;
            }
        }
    }

    /**
     * Search instruments by name
     */
    public List<Instrument> searchByName(String searchTerm) throws SQLException {
        String sql =
                "SELECT id, name, description, price, in_stock, stock_quantity, created_at " +
                        "FROM dbo.instrument " +
                        "WHERE name LIKE ? " +
                        "ORDER BY name";

        List<Instrument> list = new ArrayList<>();
        try (Connection con = DB.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, "%" + searchTerm + "%");
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapResultSetToInstrument(rs));
                }
            }
        }
        return list;
    }

    /**
     * Filter instruments by price range
     */
    public List<Instrument> filterByPriceRange(BigDecimal minPrice, BigDecimal maxPrice) throws SQLException {
        String sql =
                "SELECT id, name, description, price, in_stock, stock_quantity, created_at " +
                        "FROM dbo.instrument " +
                        "WHERE price BETWEEN ? AND ? " +
                        "ORDER BY price";

        List<Instrument> list = new ArrayList<>();
        try (Connection con = DB.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setBigDecimal(1, minPrice);
            ps.setBigDecimal(2, maxPrice);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapResultSetToInstrument(rs));
                }
            }
        }
        return list;
    }

    /**
     * Update stock quantity (for cart/checkout)
     */
    public boolean updateStock(int instrumentId, int newQuantity) throws SQLException {
        String sql =
                "UPDATE dbo.instrument " +
                        "SET stock_quantity = ?, in_stock = CASE WHEN ? > 0 THEN 1 ELSE 0 END " +
                        "WHERE id = ?";

        try (Connection conn = DB.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, newQuantity);
            ps.setInt(2, newQuantity);
            ps.setInt(3, instrumentId);

            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;
        }
    }

    /**
     * Insert new instrument (for admin)
     */
    public int insert(String name, String description, BigDecimal price, int stockQuantity) throws SQLException {
        String sql =
                "INSERT INTO dbo.instrument (name, description, price, in_stock, stock_quantity) " +
                        "VALUES (?, ?, ?, ?, ?)";

        try (Connection conn = DB.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, name);
            ps.setString(2, description);
            ps.setBigDecimal(3, price);
            ps.setBoolean(4, stockQuantity > 0);
            ps.setInt(5, stockQuantity);
            ps.executeUpdate();

            try (ResultSet keys = ps.getGeneratedKeys()) {
                if (keys.next()) {
                    return keys.getInt(1);
                } else {
                    throw new SQLException("Failed to get instrument id");
                }
            }
        }
    }

    /**
     * Update instrument (for admin)
     */
    public boolean update(int id, String name, String description, BigDecimal price, int stockQuantity) throws SQLException {
        String sql =
                "UPDATE dbo.instrument " +
                        "SET name = ?, description = ?, price = ?, stock_quantity = ?, " +
                        "    in_stock = CASE WHEN ? > 0 THEN 1 ELSE 0 END " +
                        "WHERE id = ?";

        try (Connection conn = DB.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, name);
            ps.setString(2, description);
            ps.setBigDecimal(3, price);
            ps.setInt(4, stockQuantity);
            ps.setInt(5, stockQuantity);
            ps.setInt(6, id);

            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;
        }
    }

    /**
     * Delete instrument (for admin)
     */
    public boolean delete(int id) throws SQLException {
        String sql = "DELETE FROM dbo.instrument WHERE id = ?";

        try (Connection conn = DB.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;
        }
    }

    /**
     * Helper method to map ResultSet to Instrument object
     */
    private Instrument mapResultSetToInstrument(ResultSet rs) throws SQLException {
        Instrument instrument = new Instrument();
        instrument.setId(rs.getInt("id"));
        instrument.setName(rs.getString("name"));
        instrument.setDescription(rs.getString("description"));
        instrument.setPrice(rs.getBigDecimal("price"));
        instrument.setInStock(rs.getBoolean("in_stock"));
        instrument.setStockQuantity(rs.getInt("stock_quantity"));
        instrument.setCreatedAt(rs.getTimestamp("created_at").toLocalDateTime());
        return instrument;
    }
}