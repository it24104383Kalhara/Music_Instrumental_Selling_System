package com.controller;

import com.dao.InstrumentDAO;
import com.dao.FeedbackDAO;
import com.model.Instrument;
import com.model.Feedback;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

@WebServlet("/shop/instrument")
public class InstrumentDetailsServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String instrumentIdStr = request.getParameter("id");

        if (instrumentIdStr == null) {
            response.sendRedirect(request.getContextPath() + "/shop");
            return;
        }

        try {
            int instrumentId = Integer.parseInt(instrumentIdStr);

            InstrumentDAO instrumentDAO = new InstrumentDAO();
            Instrument instrument = instrumentDAO.findById(instrumentId);

            if (instrument == null) {
                response.sendRedirect(request.getContextPath() + "/shop");
                return;
            }

            // Get approved reviews for this instrument
            FeedbackDAO feedbackDAO = new FeedbackDAO();
            List<Feedback> reviews = feedbackDAO.getApprovedReviewsByInstrument(instrumentId);

            // Get average rating and count
            double avgRating = feedbackDAO.getAverageRating(instrumentId);
            int reviewCount = feedbackDAO.getReviewCount(instrumentId);

            // Check if current user has reviewed this instrument
            boolean canReview = false;
            HttpSession session = request.getSession(false);
            if (session != null && session.getAttribute("userId") != null) {
                int userId = (int) session.getAttribute("userId");
                // User can review if they haven't reviewed this instrument yet
                // We'll check this in the JSP based on their orders
                canReview = true;
            }

            // Set attributes
            request.setAttribute("instrument", instrument);
            request.setAttribute("reviews", reviews);
            request.setAttribute("avgRating", avgRating);
            request.setAttribute("reviewCount", reviewCount);
            request.setAttribute("canReview", canReview);

            // Forward to JSP
            request.getRequestDispatcher("/WEB-INF/views/instrument-details.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/shop");
        } catch (SQLException e) {
            throw new ServletException("Failed to load instrument details", e);
        }
    }
}