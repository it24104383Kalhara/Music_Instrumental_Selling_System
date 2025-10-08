package com.controller;

import com.dao.OrderDAO;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/api/order-status")
public class OrderStatusApiServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        Integer userId = (Integer) req.getSession().getAttribute("userId");
        String idStr = req.getParameter("id");
        if (userId == null || idStr == null) {
            resp.setStatus(400);
            resp.setContentType("application/json");
            resp.getWriter().write("{\"error\":\"missing parameters\"}");
            return;
        }
        int id = Integer.parseInt(idStr);
        try {
            String status = new OrderDAO().getStatus(id, userId);
            if (status == null) {
                resp.setStatus(400);
                resp.getWriter().write("{\"error\":\"not found\"}");
                return;
            }
            resp.setContentType("application/json");
            resp.getWriter().write("{\"id\":" + id + ",\"status\":\"" + status + "\"}");
        } catch (SQLException e) {
            resp.setStatus(400);
            resp.getWriter().write("{\"error\":\"server\"}");
        }
    }
}
