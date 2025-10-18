package com.controller;

import com.dao.InstrumentDAO;
import com.model.Instrument;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.math.BigDecimal;
import java.sql.SQLException;

@WebServlet("/staff/instruments/edit")
public class EditInstrumentServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String idStr = request.getParameter("id");
        if (idStr == null) {
            response.sendRedirect(request.getContextPath() + "/staff/instruments");
            return;
        }

        try {
            int id = Integer.parseInt(idStr);
            InstrumentDAO instrumentDAO = new InstrumentDAO();
            Instrument instrument = instrumentDAO.findById(id);

            if (instrument == null) {
                response.sendRedirect(request.getContextPath() + "/staff/instruments");
                return;
            }

            // Set attributes
            request.setAttribute("mode", "edit");
            request.setAttribute("instrument", instrument);
            request.getRequestDispatcher("/WEB-INF/views/instrument-form.jsp").forward(request, response);

        } catch (NumberFormatException | SQLException e) {
            throw new ServletException("Failed to load instrument", e);
        }
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
            int id = Integer.parseInt(request.getParameter("id"));
            String name = request.getParameter("name");
            String description = request.getParameter("description");
            BigDecimal price = new BigDecimal(request.getParameter("price"));
            int stockQuantity = Integer.parseInt(request.getParameter("stockQuantity"));

            // Validate
            if (name == null || name.trim().isEmpty()) {
                request.setAttribute("error", "Instrument name is required");
                doGet(request, response);
                return;
            }

            // Update instrument
            InstrumentDAO instrumentDAO = new InstrumentDAO();
            instrumentDAO.update(id, name, description, price, stockQuantity);

            // Redirect with success message
            response.sendRedirect(request.getContextPath() + "/staff/instruments?success=updated");

        } catch (NumberFormatException | SQLException e) {
            throw new ServletException("Failed to update instrument", e);
        }
    }
}