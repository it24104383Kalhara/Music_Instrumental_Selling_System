package com.controller;

import com.dao.PaymentDAO;
import com.model.Payment;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.math.BigDecimal;
import java.sql.SQLException;
import java.util.List;

@WebServlet("/admin/payments")
public class AdminPaymentsServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        // Security check: Ensure user is logged in and is admin
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String userRole = (String) session.getAttribute("userRole");
        if (!"Admin".equalsIgnoreCase(userRole)) {
            response.sendRedirect(request.getContextPath() + "/dashboard");
            return;
        }

        try {
            PaymentDAO paymentDAO = new PaymentDAO();

            // Get filter parameter
            String filter = request.getParameter("filter");

            List<Payment> payments;
            if ("pending".equalsIgnoreCase(filter)) {
                payments = paymentDAO.getPendingPayments();
            } else {
                payments = paymentDAO.getAllPayments();
            }

            // Get statistics
            int pendingCount = paymentDAO.getPaymentCountByStatus("Pending");
            int completedCount = paymentDAO.getPaymentCountByStatus("Completed");
            int failedCount = paymentDAO.getPaymentCountByStatus("Failed");
            BigDecimal totalRevenue = paymentDAO.getTotalRevenue();

            // Set attributes
            request.setAttribute("payments", payments);
            request.setAttribute("pendingCount", pendingCount);
            request.setAttribute("completedCount", completedCount);
            request.setAttribute("failedCount", failedCount);
            request.setAttribute("totalRevenue", totalRevenue);
            request.setAttribute("currentFilter", filter);

            // Forward to admin payments page
            request.getRequestDispatcher("/WEB-INF/views/admin-payments.jsp").forward(request, response);

        } catch (SQLException e) {
            throw new ServletException("Failed to load payments", e);
        }
    }
}