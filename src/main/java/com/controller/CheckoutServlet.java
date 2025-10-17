package com.controller;

import com.dao.InstrumentDAO;
import com.dao.OrderDAO;
import com.dao.PaymentDAO;
import com.model.CartItem;
import com.model.Instrument;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.math.BigDecimal;
import java.sql.*;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.Map;
import java.util.UUID;

@WebServlet("/checkout")
public class CheckoutServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        // Check if user is logged in
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        @SuppressWarnings("unchecked")
        Map<Integer, CartItem> cart = (Map<Integer, CartItem>) session.getAttribute("cart");

        // Check if cart is empty
        if (cart == null || cart.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/cart");
            return;
        }

        // Calculate totals
        BigDecimal subtotal = cart.values().stream()
                .map(CartItem::getSubtotal)
                .reduce(BigDecimal.ZERO, BigDecimal::add);

        BigDecimal deliveryFee = BigDecimal.ZERO;
        if (subtotal.compareTo(new BigDecimal("500")) < 0) {
            deliveryFee = new BigDecimal("25.00");
        }

        BigDecimal total = subtotal.add(deliveryFee);

        // Set attributes
        request.setAttribute("cart", cart);
        request.setAttribute("subtotal", subtotal);
        request.setAttribute("deliveryFee", deliveryFee);
        request.setAttribute("total", total);

        // Forward to checkout page
        request.getRequestDispatcher("/WEB-INF/views/checkout.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        // Check if user is logged in
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        int userId = (int) session.getAttribute("userId");

        @SuppressWarnings("unchecked")
        Map<Integer, CartItem> cart = (Map<Integer, CartItem>) session.getAttribute("cart");

        if (cart == null || cart.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/cart");
            return;
        }

        // Get form data
        String shippingAddress = request.getParameter("shippingAddress");
        String paymentMethod = request.getParameter("paymentMethod");
        String cardNumber = request.getParameter("cardNumber");
        String cardName = request.getParameter("cardName");

        // Validate inputs
        if (shippingAddress == null || shippingAddress.trim().isEmpty()) {
            request.setAttribute("error", "Shipping address is required");
            doGet(request, response);
            return;
        }

        if (paymentMethod == null || paymentMethod.trim().isEmpty()) {
            request.setAttribute("error", "Payment method is required");
            doGet(request, response);
            return;
        }

        Connection conn = null;
        try {
            conn = com.util.DB.getConnection();
            conn.setAutoCommit(false); // Start transaction

            // Calculate totals
            BigDecimal subtotal = cart.values().stream()
                    .map(CartItem::getSubtotal)
                    .reduce(BigDecimal.ZERO, BigDecimal::add);

            BigDecimal deliveryFee = BigDecimal.ZERO;
            if (subtotal.compareTo(new BigDecimal("500")) < 0) {
                deliveryFee = new BigDecimal("25.00");
            }

            BigDecimal total = subtotal.add(deliveryFee);

            // Generate order number
            String orderNumber = generateOrderNumber();

            // 1. Create Order
            OrderDAO orderDAO = new OrderDAO();
            long orderId = orderDAO.insert(userId, orderNumber, total, shippingAddress);

            // 2. Create Order Items
            insertOrderItems(conn, orderId, cart);

            // 3. Update instrument stock
            InstrumentDAO instrumentDAO = new InstrumentDAO();
            for (CartItem item : cart.values()) {
                Instrument instrument = instrumentDAO.findById(item.getInstrumentId());
                int newStock = instrument.getStockQuantity() - item.getQuantity();
                instrumentDAO.updateStock(item.getInstrumentId(), newStock);
            }

            // 4. Create Payment Record
            PaymentDAO paymentDAO = new PaymentDAO();
            String transactionId = generateTransactionId(paymentMethod);
            String paymentNotes = "Payment via " + paymentMethod +
                    (cardName != null ? " - " + cardName : "");

            long paymentId = paymentDAO.insert(orderId, total, paymentMethod, transactionId, paymentNotes);

            // Commit transaction
            conn.commit();

            // Clear cart
            session.removeAttribute("cart");

            // Redirect to order confirmation page
            response.sendRedirect(request.getContextPath() + "/order-confirmation?orderId=" + orderId);

        } catch (SQLException e) {
            // Rollback on error
            if (conn != null) {
                try {
                    conn.rollback();
                } catch (SQLException ex) {
                    ex.printStackTrace();
                }
            }
            e.printStackTrace();
            request.setAttribute("error", "Failed to process order. Please try again.");
            doGet(request, response);
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
     * Insert order items into database
     */
    private void insertOrderItems(Connection conn, long orderId, Map<Integer, CartItem> cart) throws SQLException {
        String sql =
                "INSERT INTO dbo.order_item (order_id, instrument_id, quantity, unit_price) " +
                        "VALUES (?, ?, ?, ?)";

        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            for (CartItem item : cart.values()) {
                ps.setLong(1, orderId);
                ps.setInt(2, item.getInstrumentId());
                ps.setInt(3, item.getQuantity());
                ps.setBigDecimal(4, item.getPrice());
                ps.addBatch();
            }
            ps.executeBatch();
        }
    }

    /**
     * Generate unique order number
     */
    private String generateOrderNumber() {
        LocalDateTime now = LocalDateTime.now();
        String timestamp = now.format(DateTimeFormatter.ofPattern("yyyyMMddHHmmss"));
        return "ORD-" + timestamp;
    }

    /**
     * Generate transaction ID based on payment method
     */
    private String generateTransactionId(String paymentMethod) {
        String prefix = paymentMethod.toUpperCase().substring(0, Math.min(3, paymentMethod.length()));
        return prefix + "-" + UUID.randomUUID().toString().substring(0, 18).toUpperCase();
    }
}