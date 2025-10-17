package com.controller;

import com.dao.OrderDAO;
import com.dao.PaymentDAO;
import com.model.Order;
import com.model.Payment;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/order-confirmation")
public class OrderConfirmationServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String orderIdStr = request.getParameter("orderId");
        if (orderIdStr == null) {
            response.sendRedirect(request.getContextPath() + "/dashboard");
            return;
        }

        try {
            long orderId = Long.parseLong(orderIdStr);
            int userId = (int) session.getAttribute("userId");

            OrderDAO orderDAO = new OrderDAO();
            Order order = orderDAO.findByIdAndUser(orderId, userId);

            if (order == null) {
                response.sendRedirect(request.getContextPath() + "/dashboard");
                return;
            }

            // Get payment info
            PaymentDAO paymentDAO = new PaymentDAO();
            Payment payment = paymentDAO.findByOrderId(orderId);

            request.setAttribute("order", order);
            request.setAttribute("payment", payment);

            request.getRequestDispatcher("/WEB-INF/views/order-confirmation.jsp").forward(request, response);

        } catch (NumberFormatException | SQLException e) {
            throw new ServletException("Failed to load order confirmation", e);
        }
    }
}