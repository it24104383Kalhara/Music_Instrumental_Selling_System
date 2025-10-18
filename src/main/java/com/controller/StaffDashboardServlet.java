package com.controller;

import com.dao.InstrumentDAO;
import com.dao.OrderDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/staff/dashboard")
public class StaffDashboardServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        // Security check
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String userRole = (String) session.getAttribute("userRole");
        if (!"Staff".equalsIgnoreCase(userRole) && !"Admin".equalsIgnoreCase(userRole)) {
            response.sendRedirect(request.getContextPath() + "/dashboard");
            return;
        }

        try {
            InstrumentDAO instrumentDAO = new InstrumentDAO();
            OrderDAO orderDAO = new OrderDAO();

            // Get statistics
            int totalInstruments = instrumentDAO.getAllInstruments().size();
            int inStockCount = instrumentDAO.getInStockInstruments().size();
            int lowStockCount = getLowStockCount(instrumentDAO);
            int outOfStockCount = totalInstruments - inStockCount;

            int totalOrders = orderDAO.getTotalOrdersCount();
            int processingOrders = orderDAO.getOrderCountByStatus("Processing");

            // Set attributes
            request.setAttribute("totalInstruments", totalInstruments);
            request.setAttribute("inStockCount", inStockCount);
            request.setAttribute("lowStockCount", lowStockCount);
            request.setAttribute("outOfStockCount", outOfStockCount);
            request.setAttribute("totalOrders", totalOrders);
            request.setAttribute("processingOrders", processingOrders);

            // Forward to staff dashboard
            request.getRequestDispatcher("/WEB-INF/views/staff-dashboard.jsp").forward(request, response);

        } catch (SQLException e) {
            throw new ServletException("Failed to load staff dashboard", e);
        }
    }

    private int getLowStockCount(InstrumentDAO dao) throws SQLException {
        return (int) dao.getAllInstruments().stream()
                .filter(i -> i.getStockQuantity() > 0 && i.getStockQuantity() <= 5)
                .count();
    }
}