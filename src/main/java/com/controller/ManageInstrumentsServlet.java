package com.controller;

import com.dao.InstrumentDAO;
import com.model.Instrument;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

@WebServlet("/staff/instruments")
public class ManageInstrumentsServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        try {
            InstrumentDAO instrumentDAO = new InstrumentDAO();

            // Get filter parameter
            String filter = request.getParameter("filter");
            List<Instrument> instruments;

            if ("low-stock".equals(filter)) {
                instruments = instrumentDAO.getAllInstruments().stream()
                        .filter(i -> i.getStockQuantity() > 0 && i.getStockQuantity() <= 5)
                        .toList();
            } else if ("out-of-stock".equals(filter)) {
                instruments = instrumentDAO.getAllInstruments().stream()
                        .filter(i -> i.getStockQuantity() == 0)
                        .toList();
            } else {
                instruments = instrumentDAO.getAllInstruments();
            }

            request.setAttribute("instruments", instruments);
            request.setAttribute("currentFilter", filter);

            // Check for success/error messages
            if ("added".equals(request.getParameter("success"))) {
                request.setAttribute("successMessage", "Instrument added successfully!");
            } else if ("updated".equals(request.getParameter("success"))) {
                request.setAttribute("successMessage", "Instrument updated successfully!");
            } else if ("deleted".equals(request.getParameter("success"))) {
                request.setAttribute("successMessage", "Instrument deleted successfully!");
            }

            request.getRequestDispatcher("/WEB-INF/views/manage-instruments.jsp").forward(request, response);

        } catch (SQLException e) {
            throw new ServletException("Failed to load instruments", e);
        }
    }
}