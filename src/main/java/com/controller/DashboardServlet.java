package com.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;
import com.dao.OrderDAO;
import com.model.Order;
import com.model.User;

@WebServlet("/dashboard")
public class DashboardServlet extends HttpServlet {

    private OrderDAO orderDAO;

    @Override
    public void init() throws ServletException {
        orderDAO = new OrderDAO();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

        // Get the logged-in user from session
        HttpSession session = req.getSession();
        User user = (User) session.getAttribute("user");

        // Check if user is logged in
        if (user == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        // Fetch orders from database
        try {
            // Option 1: Get orders for this specific user
            //List<Order> orders = orderDAO.getOrdersByUserId(user.getId());

            // Option 2: If you want to show all orders (for admin)
            List<Order> orders = orderDAO.getAllOrders();

            // Option 3: Get recent orders (last 10 or so)
            // List<Order> orders = orderDAO.getRecentOrders(10);

            // Pass orders to JSP
            req.setAttribute("orders", orders);

        } catch (Exception e) {
            e.printStackTrace();
            // If error, pass empty list
            req.setAttribute("orders", new java.util.ArrayList<>());
        }

        // Forward to dashboard.jsp
        req.getRequestDispatcher("/WEB-INF/views/dashboard.jsp").forward(req, resp);
    }
}