package com.controller;

import com.dao.OrderDAO;
import com.dao.PaymentDAO;
import com.model.Order;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

@WebServlet("/admin/dashboard")
public class AdminDashboardServlet extends HttpServlet {

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
            // Not an admin, redirect to customer dashboard
            response.sendRedirect(request.getContextPath() + "/dashboard");
            return;
        }

        try {
            OrderDAO orderDAO = new OrderDAO();

            // Fetch ALL orders with customer information
            List<Order> allOrders = orderDAO.getAllOrdersWithCustomerInfo();

            // Get payment statistics
            PaymentDAO paymentDAO = new PaymentDAO();
            int pendingPaymentsCount = paymentDAO.getPaymentCountByStatus("Pending");

            // Add to request attributes
            request.setAttribute("pendingPaymentsCount", pendingPaymentsCount);

            // Get statistics
            int totalOrders = orderDAO.getTotalOrdersCount();
            int processingCount = orderDAO.getOrderCountByStatus("Processing");
            int shippedCount = orderDAO.getOrderCountByStatus("Shipped");
            int deliveredCount = orderDAO.getOrderCountByStatus("Delivered");
            int cancelledCount = orderDAO.getOrderCountByStatus("Cancelled");

            // Set attributes for JSP
            request.setAttribute("orders", allOrders);
            request.setAttribute("totalOrders", totalOrders);
            request.setAttribute("processingCount", processingCount);
            request.setAttribute("shippedCount", shippedCount);
            request.setAttribute("deliveredCount", deliveredCount);
            request.setAttribute("cancelledCount", cancelledCount);

            // Forward to admin dashboard JSP
            request.getRequestDispatcher("/WEB-INF/views/admin-dashboard.jsp").forward(request, response);

        } catch (SQLException e) {
            throw new ServletException("Failed to load admin dashboard", e);
        }
    }
}