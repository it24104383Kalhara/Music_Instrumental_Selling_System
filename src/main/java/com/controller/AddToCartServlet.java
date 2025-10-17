package com.controller;

import com.dao.InstrumentDAO;
import com.model.CartItem;
import com.model.Instrument;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;

@WebServlet("/cart/add")
public class AddToCartServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();

        try {
            // Get parameters
            String instrumentIdStr = request.getParameter("instrumentId");
            String quantityStr = request.getParameter("quantity");

            if (instrumentIdStr == null) {
                out.print("{\"success\": false, \"message\": \"Missing instrument ID\"}");
                return;
            }

            int instrumentId = Integer.parseInt(instrumentIdStr);
            int quantity = (quantityStr != null) ? Integer.parseInt(quantityStr) : 1;

            // Fetch instrument details from database
            InstrumentDAO instrumentDAO = new InstrumentDAO();
            Instrument instrument = instrumentDAO.findById(instrumentId);

            if (instrument == null) {
                out.print("{\"success\": false, \"message\": \"Instrument not found\"}");
                return;
            }

            // Check stock availability
            if (instrument.getStockQuantity() < quantity) {
                out.print("{\"success\": false, \"message\": \"Insufficient stock\"}");
                return;
            }

            // Get or create cart from session
            HttpSession session = request.getSession(true);
            @SuppressWarnings("unchecked")
            Map<Integer, CartItem> cart = (Map<Integer, CartItem>) session.getAttribute("cart");

            if (cart == null) {
                cart = new HashMap<>();
                session.setAttribute("cart", cart);
            }

            // Add or update item in cart
            if (cart.containsKey(instrumentId)) {
                // Item already in cart, update quantity
                CartItem existingItem = cart.get(instrumentId);
                int newQuantity = existingItem.getQuantity() + quantity;

                // Check if new quantity exceeds stock
                if (newQuantity > instrument.getStockQuantity()) {
                    out.print("{\"success\": false, \"message\": \"Cannot add more than available stock\"}");
                    return;
                }

                existingItem.setQuantity(newQuantity);
            } else {
                // New item, add to cart
                CartItem cartItem = new CartItem(
                        instrument.getId(),
                        instrument.getName(),
                        instrument.getPrice(),
                        quantity
                );
                cart.put(instrumentId, cartItem);
            }

            // Calculate cart totals
            int totalItems = cart.values().stream()
                    .mapToInt(CartItem::getQuantity)
                    .sum();

            // Return success response
            out.print("{\"success\": true, \"message\": \"Added to cart\", \"cartCount\": " + totalItems + "}");

        } catch (NumberFormatException e) {
            out.print("{\"success\": false, \"message\": \"Invalid parameters\"}");
        } catch (SQLException e) {
            out.print("{\"success\": false, \"message\": \"Database error\"}");
            e.printStackTrace();
        }
    }
}