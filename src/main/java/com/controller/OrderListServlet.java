package com.controller;

import com.dao.OrderDAO;
import com.model.Order;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

@WebServlet("/orders")
public class OrderListServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        int userId = (Integer) req.getSession().getAttribute("userId");
        try {
            List<Order> orders = new OrderDAO().recentByUser(userId, 20);
            req.setAttribute("orders", orders);
            req.getRequestDispatcher("/WEB-INF/views/order-list.jsp").forward(req, resp);

        } catch (SQLException e){
            throw new ServletException("Failed to load orders",e);
        }
    }
}
