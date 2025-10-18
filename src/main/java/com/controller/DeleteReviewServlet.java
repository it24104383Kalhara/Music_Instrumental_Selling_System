package com.controller;

import com.dao.FeedbackDAO;
import com.model.Feedback;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/reviews/delete")
public class DeleteReviewServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String feedbackIdStr = request.getParameter("feedbackId");
        String redirectUrl = request.getParameter("redirectUrl");

        if (feedbackIdStr == null) {
            response.sendRedirect(request.getContextPath() + "/dashboard");
            return;
        }

        try {
            long feedbackId = Long.parseLong(feedbackIdStr);
            int userId = (int) session.getAttribute("userId");
            String userRole = (String) session.getAttribute("userRole");

            FeedbackDAO feedbackDAO = new FeedbackDAO();
            Feedback feedback = feedbackDAO.findById(feedbackId);

            if (feedback == null) {
                response.sendRedirect(request.getContextPath() + "/dashboard");
                return;
            }

            // Check authorization: must be owner or admin
            boolean isOwner = (feedback.getUserId() == userId);
            boolean isAdmin = "Admin".equalsIgnoreCase(userRole);

            if (!isOwner && !isAdmin) {
                response.sendRedirect(request.getContextPath() + "/dashboard");
                return;
            }

            // Delete review
            feedbackDAO.deleteReview(feedbackId);

            // Redirect back
            if (redirectUrl != null && !redirectUrl.isEmpty()) {
                response.sendRedirect(redirectUrl);
            } else if (isAdmin) {
                response.sendRedirect(request.getContextPath() + "/admin/reviews?deleted=true");
            } else {
                response.sendRedirect(request.getContextPath() + "/reviews/my-reviews?deleted=true");
            }

        } catch (NumberFormatException | SQLException e) {
            throw new ServletException("Failed to delete review", e);
        }
    }
}