package com.controller;

import com.dao.OrderDAO;
import com.model.Order;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/orders/view")
public class OrderDetailsServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        int userId = (Integer) req.getSession().getAttribute("userId");
        String idStr = req.getParameter("id");
        if(idStr == null) {
            resp.sendRedirect(req.getContextPath() + "/orders");
            return;
        }
        int id = Integer.parseInt(idStr);
        try {
            Order o = new OrderDAO().findByIdAndUser(id, userId);
            if (o == null){  // not this user's order or not found
                resp.sendRedirect(req.getContextPath() + "/orders");
                return;
            }
            req.setAttribute("order", o);
            req.getRequestDispatcher("/WEB-INF/views/order-details.jsp").forward(req, resp);
        } catch (SQLException e) {
            throw new ServletException("Failed to load order", e);
        }
    }
}
