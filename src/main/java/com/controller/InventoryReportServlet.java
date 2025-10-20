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
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet("/admin/reports/inventory")
public class InventoryReportServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || !"Admin".equals(session.getAttribute("userRole"))) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        try (Connection conn = DatabaseConfig.getDataSource().getConnection()) {

            // Get inventory statistics
            Map<String, Object> stats = getInventoryStatistics(conn);
            request.setAttribute("totalProducts", stats.get("totalProducts"));
            request.setAttribute("inStockProducts", stats.get("inStockProducts"));
            request.setAttribute("lowStockProducts", stats.get("lowStockProducts"));
            request.setAttribute("totalInventoryValue", stats.get("totalInventoryValue"));

            // Get all instruments with stock info
            List<Map<String, Object>> inventory = getInventoryList(conn);
            request.setAttribute("inventory", inventory);

            // Get low stock items
            List<Map<String, Object>> lowStockItems = getLowStockItems(conn);
            request.setAttribute("lowStockItems", lowStockItems);

            request.getRequestDispatcher("/WEB-INF/views/inventoryReport.jsp").forward(request, response);

        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Error generating inventory report: " + e.getMessage());
            request.getRequestDispatcher("/WEB-INF/views/inventoryReport.jsp").forward(request, response);
        }
    }

    private Map<String, Object> getInventoryStatistics(Connection conn) throws SQLException {
        Map<String, Object> stats = new HashMap<>();

        String sql = "SELECT " +
                "COUNT(*) as totalProducts, " +
                "SUM(CASE WHEN in_stock = 1 THEN 1 ELSE 0 END) as inStockProducts, " +
                "SUM(CASE WHEN stock_quantity < 5 AND stock_quantity > 0 THEN 1 ELSE 0 END) as lowStockProducts, " +
                "COALESCE(SUM(price * stock_quantity), 0) as totalValue " +
                "FROM instrument";

        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            ResultSet rs = pstmt.executeQuery();
            if (rs.next()) {
                stats.put("totalProducts", rs.getInt("totalProducts"));
                stats.put("inStockProducts", rs.getInt("inStockProducts"));
                stats.put("lowStockProducts", rs.getInt("lowStockProducts"));
                stats.put("totalInventoryValue", rs.getDouble("totalValue"));
            }
        }

        return stats;
    }

    private List<Map<String, Object>> getInventoryList(Connection conn) throws SQLException {
        List<Map<String, Object>> inventory = new ArrayList<>();

        String sql = "SELECT id, name, price, stock_quantity, in_stock " +
                "FROM instrument " +
                "ORDER BY name";

        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            ResultSet rs = pstmt.executeQuery();
            while (rs.next()) {
                Map<String, Object> item = new HashMap<>();
                item.put("id", rs.getInt("id"));
                item.put("name", rs.getString("name"));
                item.put("price", rs.getDouble("price"));
                item.put("stockQuantity", rs.getInt("stock_quantity"));
                item.put("inStock", rs.getBoolean("in_stock"));
                item.put("totalValue", rs.getDouble("price") * rs.getInt("stock_quantity"));
                inventory.add(item);
            }
        }

        return inventory;
    }

    private List<Map<String, Object>> getLowStockItems(Connection conn) throws SQLException {
        List<Map<String, Object>> lowStock = new ArrayList<>();

        String sql = "SELECT name, stock_quantity, price " +
                "FROM instrument " +
                "WHERE stock_quantity < 5 AND stock_quantity > 0 " +
                "ORDER BY stock_quantity ASC";

        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            ResultSet rs = pstmt.executeQuery();
            while (rs.next()) {
                Map<String, Object> item = new HashMap<>();
                item.put("name", rs.getString("name"));
                item.put("stockQuantity", rs.getInt("stock_quantity"));
                item.put("price", rs.getDouble("price"));
                lowStock.add(item);
            }
        }

        return lowStock;
    }
}