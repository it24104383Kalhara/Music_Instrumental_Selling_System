package com.controller;

import com.dao.PaymentDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.SQLException;

@WebServlet("/admin/verifyPayment")
public class VerifyPaymentServlet extends HttpServlet {

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
        String paymentIdStr = request.getParameter("paymentId");
        String action = request.getParameter("action"); // verify or reject
        String notes = request.getParameter("notes");

        if (paymentIdStr == null || action == null) {
            out.print("{\"success\": false, \"message\": \"Missing parameters\"}");
            return;
        }

        try {
            long paymentId = Long.parseLong(paymentIdStr);
            int adminUserId = (int) session.getAttribute("userId");

            PaymentDAO paymentDAO = new PaymentDAO();

            boolean success;
            String message;

            if ("verify".equalsIgnoreCase(action)) {
                // Verify payment
                String verifyNotes = notes != null ? notes : "Payment verified by admin";
                success = paymentDAO.verifyPayment(paymentId, adminUserId, verifyNotes);
                message = success ? "Payment verified successfully" : "Failed to verify payment";
            } else if ("reject".equalsIgnoreCase(action)) {
                // Reject payment
                success = paymentDAO.updatePaymentStatus(paymentId, "Failed");
                message = success ? "Payment rejected" : "Failed to reject payment";
            } else {
                out.print("{\"success\": false, \"message\": \"Invalid action\"}");
                return;
            }

            if (success) {
                out.print("{\"success\": true, \"message\": \"" + message + "\"}");
            } else {
                out.print("{\"success\": false, \"message\": \"" + message + "\"}");
            }

        } catch (NumberFormatException e) {
            out.print("{\"success\": false, \"message\": \"Invalid payment ID\"}");
        } catch (SQLException e) {
            out.print("{\"success\": false, \"message\": \"Database error: " + e.getMessage() + "\"}");
            e.printStackTrace();
        }
    }
}