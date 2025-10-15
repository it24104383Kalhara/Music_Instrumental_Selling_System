package com.controller;

import com.dao.OrderDAO;
import com.model.Order;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

@WebServlet("/dashboard")
public class DashboardServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        // Check if user is logged in
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // Get user ID from session
        int userId = (int) session.getAttribute("userId");

        try {
            OrderDAO orderDAO = new OrderDAO();

            // Fetch user's orders (all of them, or use recentByUser(userId, 10) for limit)
            List<Order> orders = orderDAO.getAllByUser(userId);

            // Set orders as request attribute
            request.setAttribute("orders", orders);

            // Forward to dashboard JSP
            request.getRequestDispatcher("/WEB-INF/views/dashboard.jsp").forward(request, response);

        } catch (SQLException e) {
            throw new ServletException("Failed to load orders", e);
        }
    }
}