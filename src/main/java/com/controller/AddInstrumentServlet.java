package com.controller;

import com.dao.InstrumentDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.math.BigDecimal;
import java.sql.SQLException;

@WebServlet("/staff/instruments/add")
public class AddInstrumentServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // Set mode to "add"
        request.setAttribute("mode", "add");
        request.getRequestDispatcher("/WEB-INF/views/instrument-form.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        try {
            // Get form data
            String name = request.getParameter("name");
            String description = request.getParameter("description");
            BigDecimal price = new BigDecimal(request.getParameter("price"));
            int stockQuantity = Integer.parseInt(request.getParameter("stockQuantity"));

            // Validate
            if (name == null || name.trim().isEmpty()) {
                request.setAttribute("error", "Instrument name is required");
                request.setAttribute("mode", "add");
                request.getRequestDispatcher("/WEB-INF/views/instrument-form.jsp").forward(request, response);
                return;
            }

            if (price.compareTo(BigDecimal.ZERO) <= 0) {
                request.setAttribute("error", "Price must be greater than 0");
                request.setAttribute("mode", "add");
                request.getRequestDispatcher("/WEB-INF/views/instrument-form.jsp").forward(request, response);
                return;
            }

            // Insert instrument
            InstrumentDAO instrumentDAO = new InstrumentDAO();
            instrumentDAO.insert(name, description, price, stockQuantity);

            // Redirect to instruments list with success message
            response.sendRedirect(request.getContextPath() + "/staff/instruments?success=added");

        } catch (NumberFormatException e) {
            request.setAttribute("error", "Invalid price or stock quantity");
            request.setAttribute("mode", "add");
            request.getRequestDispatcher("/WEB-INF/views/instrument-form.jsp").forward(request, response);
        } catch (SQLException e) {
            throw new ServletException("Failed to add instrument", e);
        }
    }
}