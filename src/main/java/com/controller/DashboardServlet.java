package com.controller;

import com.dao.OrderDAO;
import com.model.Order;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/dashboard")
public class DashboardServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession();
        Integer userId = (Integer) session.getAttribute("userId");

        if (userId == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        try {
            OrderDAO orderDAO = new OrderDAO();
            List<Order> orders = orderDAO.recentByUser(userId, 20);

            System.out.println("Dashboard: Fetched " + orders.size() + " orders for user " + userId);

            req.setAttribute("orders", orders);
            req.setAttribute("user", session.getAttribute("userEmail"));

            req.getRequestDispatcher("/WEB-INF/views/dashboard.jsp").forward(req, resp);

        } catch (SQLException e) {
            throw new ServletException("Failed to load dashboard", e);
        }
    }
}