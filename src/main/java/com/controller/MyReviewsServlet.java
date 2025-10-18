package com.controller;

import com.dao.FeedbackDAO;
import com.model.Feedback;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

@WebServlet("/reviews/my-reviews")
public class MyReviewsServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        int userId = (int) session.getAttribute("userId");

        try {
            FeedbackDAO feedbackDAO = new FeedbackDAO();
            List<Feedback> myReviews = feedbackDAO.getReviewsByUser(userId);

            // Also get reviewable orders (delivered items not yet reviewed)
            List<FeedbackDAO.ReviewableOrder> reviewableOrders = feedbackDAO.getReviewableOrders(userId);

            request.setAttribute("myReviews", myReviews);
            request.setAttribute("reviewableOrders", reviewableOrders);

            // Check for success message
            String success = request.getParameter("success");
            if ("true".equals(success)) {
                request.setAttribute("successMessage", "Review submitted successfully!");
            }

            request.getRequestDispatcher("/WEB-INF/views/my-reviews.jsp").forward(request, response);

        } catch (SQLException e) {
            throw new ServletException("Failed to load reviews", e);
        }
    }
}