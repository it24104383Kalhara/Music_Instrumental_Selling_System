package com.controller;

import com.model.CartItem;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.io.PrintWriter;
import java.math.BigDecimal;
import java.util.Map;

@WebServlet("/cart/remove")
public class RemoveFromCartServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();

        try {
            String instrumentIdStr = request.getParameter("instrumentId");

            if (instrumentIdStr == null) {
                out.print("{\"success\": false, \"message\": \"Missing instrument ID\"}");
                return;
            }

            int instrumentId = Integer.parseInt(instrumentIdStr);

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

            // Remove item from cart
            cart.remove(instrumentId);

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
                    "{\"success\": true, \"message\": \"Item removed\", " +
                            "\"subtotal\": \"%.2f\", \"deliveryFee\": \"%.2f\", " +
                            "\"total\": \"%.2f\", \"cartCount\": %d}",
                    subtotal, deliveryFee, total, totalItems
            );
            out.print(json);

        } catch (NumberFormatException e) {
            out.print("{\"success\": false, \"message\": \"Invalid parameters\"}");
        }
    }
}