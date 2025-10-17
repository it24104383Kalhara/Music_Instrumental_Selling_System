package com.controller;

import com.model.CartItem;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.math.BigDecimal;
import java.util.Map;

@WebServlet("/cart")
public class CartServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(true);

        @SuppressWarnings("unchecked")
        Map<Integer, CartItem> cart = (Map<Integer, CartItem>) session.getAttribute("cart");

        // Calculate totals
        BigDecimal subtotal = BigDecimal.ZERO;
        int totalItems = 0;

        if (cart != null && !cart.isEmpty()) {
            for (CartItem item : cart.values()) {
                subtotal = subtotal.add(item.getSubtotal());
                totalItems += item.getQuantity();
            }
        }

        // Delivery fee logic (example: free for orders above $500)
        BigDecimal deliveryFee = BigDecimal.ZERO;
        if (subtotal.compareTo(BigDecimal.ZERO) > 0 && subtotal.compareTo(new BigDecimal("500")) < 0) {
            deliveryFee = new BigDecimal("25.00");
        }

        BigDecimal total = subtotal.add(deliveryFee);

        // Set attributes
        request.setAttribute("cart", cart);
        request.setAttribute("subtotal", subtotal);
        request.setAttribute("deliveryFee", deliveryFee);
        request.setAttribute("total", total);
        request.setAttribute("totalItems", totalItems);

        // Forward to cart page
        request.getRequestDispatcher("/WEB-INF/views/cart.jsp").forward(request, response);
    }
}