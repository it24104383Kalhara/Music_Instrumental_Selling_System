package com.controller;

import com.dao.InstrumentDAO;
import com.model.CartItem;
import com.model.Instrument;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.io.PrintWriter;
import java.math.BigDecimal;
import java.sql.SQLException;
import java.util.Map;

@WebServlet("/cart/update")
public class UpdateCartServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();

        try {
            String instrumentIdStr = request.getParameter("instrumentId");
            String quantityStr = request.getParameter("quantity");

            if (instrumentIdStr == null || quantityStr == null) {
                out.print("{\"success\": false, \"message\": \"Missing parameters\"}");
                return;
            }

            int instrumentId = Integer.parseInt(instrumentIdStr);
            int quantity = Integer.parseInt(quantityStr);

            if (quantity < 1) {
                out.print("{\"success\": false, \"message\": \"Quantity must be at least 1\"}");
                return;
            }

            // Check stock availability
            InstrumentDAO instrumentDAO = new InstrumentDAO();
            Instrument instrument = instrumentDAO.findById(instrumentId);

            if (instrument == null) {
                out.print("{\"success\": false, \"message\": \"Instrument not found\"}");
                return;
            }

            if (quantity > instrument.getStockQuantity()) {
                out.print("{\"success\": false, \"message\": \"Only " + instrument.getStockQuantity() + " available in stock\"}");
                return;
            }

            // Update cart
            HttpSession session = request.getSession(false);
            if (session == null) {
                out.print("{\"success\": false, \"message\": \"No active session\"}");
                return;
            }

            @SuppressWarnings("unchecked")
            Map<Integer, CartItem> cart = (Map<Integer, CartItem>) session.getAttribute("cart");

            if (cart == null || !cart.containsKey(instrumentId)) {
                out.print("{\"success\": false, \"message\": \"Item not in cart\"}");
                return;
            }

            // Update quantity
            CartItem item = cart.get(instrumentId);
            item.setQuantity(quantity);

            // Calculate new totals
            BigDecimal subtotal = cart.values().stream()
                    .map(CartItem::getSubtotal)
                    .reduce(BigDecimal.ZERO, BigDecimal::add);

            int totalItems = cart.values().stream()
                    .mapToInt(CartItem::getQuantity)
                    .sum();

            BigDecimal deliveryFee = BigDecimal.ZERO;
            if (subtotal.compareTo(BigDecimal.ZERO) > 0 && subtotal.compareTo(new BigDecimal("500")) < 0) {
                deliveryFee = new BigDecimal("25.00");
            }

            BigDecimal total = subtotal.add(deliveryFee);

            // Return success with updated values
            String json = String.format(
                    "{\"success\": true, \"message\": \"Cart updated\", " +
                            "\"itemSubtotal\": \"%.2f\", \"subtotal\": \"%.2f\", " +
                            "\"deliveryFee\": \"%.2f\", \"total\": \"%.2f\", \"cartCount\": %d}",
                    item.getSubtotal(), subtotal, deliveryFee, total, totalItems
            );
            out.print(json);

        } catch (NumberFormatException e) {
            out.print("{\"success\": false, \"message\": \"Invalid parameters\"}");
        } catch (SQLException e) {
            out.print("{\"success\": false, \"message\": \"Database error\"}");
            e.printStackTrace();
        }
    }
}