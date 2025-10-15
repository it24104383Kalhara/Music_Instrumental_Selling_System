package com.controller;

import com.dao.OrderDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.SQLException;

@WebServlet("/admin/updateOrderStatus")
public class UpdateOrderStatusServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();

        HttpSession session = request.getSession(false);

        // Security check
        if (session == null || session.getAttribute("userId") == null) {
            out.print("{\"success\": false, \"message\": \"Unauthorized\"}");
            return;
        }

        String userRole = (String) session.getAttribute("userRole");
        if (!"Admin".equalsIgnoreCase(userRole)) {
            out.print("{\"success\": false, \"message\": \"Access denied\"}");
            return;
        }

        // Get parameters
        String orderIdStr = request.getParameter("orderId");
        String newStatus = request.getParameter("status");

        if (orderIdStr == null || newStatus == null) {
            out.print("{\"success\": false, \"message\": \"Missing parameters\"}");
            return;
        }

        try {
            long orderId = Long.parseLong(orderIdStr);

            OrderDAO orderDAO = new OrderDAO();
            boolean success = orderDAO.updateOrderStatus(orderId, newStatus);

            if (success) {
                out.print("{\"success\": true, \"message\": \"Order status updated successfully\"}");
            } else {
                out.print("{\"success\": false, \"message\": \"Failed to update order status\"}");
            }
        } catch (NumberFormatException e) {
            out.print("{\"success\": false, \"message\": \"Invalid order ID\"}");
        } catch (SQLException e) {
            out.print("{\"success\": false, \"message\": \"Database error: " + e.getMessage() + "\"}");
        }
    }
}