package com.controller;

import com.dao.FeedbackDAO;
import com.dao.OrderDAO;
import com.model.Order;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/reviews/submit")
public class SubmitReviewServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        // Check if user is logged in
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String orderIdStr = request.getParameter("orderId");
        String instrumentIdStr = request.getParameter("instrumentId");

        if (orderIdStr == null || instrumentIdStr == null) {
            response.sendRedirect(request.getContextPath() + "/orders");
            return;
        }

        try {
            long orderId = Long.parseLong(orderIdStr);
            int instrumentId = Integer.parseInt(instrumentIdStr);
            int userId = (int) session.getAttribute("userId");

            // Verify this is user's order
            OrderDAO orderDAO = new OrderDAO();
            Order order = orderDAO.findByIdAndUser(orderId, userId);

            if (order == null) {
                response.sendRedirect(request.getContextPath() + "/orders");
                return;
            }

            // Check if already reviewed
            FeedbackDAO feedbackDAO = new FeedbackDAO();
            if (feedbackDAO.hasUserReviewedInstrument(userId, instrumentId, orderId)) {
                request.setAttribute("error", "You have already reviewed this instrument for this order.");
                request.getRequestDispatcher("/WEB-INF/views/error.jsp").forward(request, response);
                return;
            }

            // Set attributes for the form
            request.setAttribute("orderId", orderId);
            request.setAttribute("instrumentId", instrumentId);
            request.setAttribute("orderNumber", order.getOrderNumber());

            // Forward to review form
            request.getRequestDispatcher("/WEB-INF/views/submit-review.jsp").forward(request, response);

        } catch (NumberFormatException | SQLException e) {
            throw new ServletException("Failed to load review form", e);
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

        int userId = (int) session.getAttribute("userId");

        try {
            long orderId = Long.parseLong(request.getParameter("orderId"));
            int instrumentId = Integer.parseInt(request.getParameter("instrumentId"));
            int rating = Integer.parseInt(request.getParameter("rating"));
            String comment = request.getParameter("comment");

            // Validate rating
            if (rating < 1 || rating > 5) {
                request.setAttribute("error", "Rating must be between 1 and 5 stars");
                doGet(request, response);
                return;
            }

            // Insert review (auto-approved)
            FeedbackDAO feedbackDAO = new FeedbackDAO();
            long feedbackId = feedbackDAO.insert(userId, instrumentId, orderId, rating, comment);

            // Redirect to success page or instrument page
            response.sendRedirect(request.getContextPath() + "/reviews/my-reviews?success=true");

        } catch (SQLException | NumberFormatException e) {
            throw new ServletException("Failed to submit review", e);
        }
    }
}