package com.controller;

import com.dao.FeedbackDAO;
import com.model.Feedback;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

@WebServlet("/admin/reviews")
public class AdminReviewsServlet extends HttpServlet {

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
        if (!"Admin".equalsIgnoreCase(userRole)) {
            response.sendRedirect(request.getContextPath() + "/dashboard");
            return;
        }

        try {
            FeedbackDAO feedbackDAO = new FeedbackDAO();
            List<Feedback> allReviews = feedbackDAO.getAllReviews();

            request.setAttribute("reviews", allReviews);

            // Check for success messages
            String deleted = request.getParameter("deleted");
            if ("true".equals(deleted)) {
                request.setAttribute("successMessage", "Review deleted successfully");
            }

            request.getRequestDispatcher("/WEB-INF/views/admin-reviews.jsp").forward(request, response);

        } catch (SQLException e) {
            throw new ServletException("Failed to load reviews", e);
        }
    }
}