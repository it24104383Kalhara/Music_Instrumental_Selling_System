package com.controller;

import com.dao.InstrumentDAO;
import com.model.Instrument;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.math.BigDecimal;
import java.sql.SQLException;
import java.util.List;

@WebServlet("/shop")
public class ShopServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            InstrumentDAO instrumentDAO = new InstrumentDAO();

            // Get filter parameters
            String search = request.getParameter("search");
            String filter = request.getParameter("filter");
            String minPriceStr = request.getParameter("minPrice");
            String maxPriceStr = request.getParameter("maxPrice");

            List<Instrument> instruments;

            // Apply filters
            if (search != null && !search.trim().isEmpty()) {
                // Search by name
                instruments = instrumentDAO.searchByName(search.trim());
            } else if (minPriceStr != null && maxPriceStr != null) {
                // Filter by price range
                try {
                    BigDecimal minPrice = new BigDecimal(minPriceStr);
                    BigDecimal maxPrice = new BigDecimal(maxPriceStr);
                    instruments = instrumentDAO.filterByPriceRange(minPrice, maxPrice);
                } catch (NumberFormatException e) {
                    instruments = instrumentDAO.getAllInstruments();
                }
            } else if ("instock".equals(filter)) {
                // Show only in-stock items
                instruments = instrumentDAO.getInStockInstruments();
            } else {
                // Default: show all instruments
                instruments = instrumentDAO.getAllInstruments();
            }

            // Set attributes
            request.setAttribute("instruments", instruments);
            request.setAttribute("currentSearch", search);
            request.setAttribute("currentFilter", filter);

            // Forward to JSP
            request.getRequestDispatcher("/WEB-INF/views/shop.jsp").forward(request, response);

        } catch (SQLException e) {
            throw new ServletException("Failed to load instruments", e);
        }
    }
}