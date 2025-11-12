package com.controller;

import com.dao.UserDAO;
import com.model.User;
import jakarta.servlet.ServletConfig;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
@WebServlet("/register")
public class RegisterServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.getRequestDispatcher("/WEB-INF/views/register.jsp").forward(req,resp);
    }
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // Get all the form parameters
        String email =  req.getParameter("email");
        String fullName =  req.getParameter("fullName");
        String password =  req.getParameter("password");
        String confirmPassword = req.getParameter("confirmPassword");

        // Validate password
        if(!password.equals(confirmPassword)){
            req.setAttribute("errorMessage", "Passwords do not match. Please try again.");
            req.getRequestDispatcher("/WEB-INF/views/register.jsp").forward(req,resp);
            return;  // Stop processing this request
        }

        try {
            User existingUser = userDAO.findByEmail(email);
            if (existingUser != null){
                req.setAttribute("errorMessage", "An account from this email is already exists.");
                req.getRequestDispatcher("/WEB-INF/views/register.jsp").forward(req,resp);
                return;
            }

            // Create the new user
            userDAO.create(email,fullName, password);

            // Success. Redirect to the login page
            req.getSession().setAttribute("successMessage", "Registration successful! Please log in.");

            // Redirect to log in page
            resp.sendRedirect(req.getContextPath() + "/login");
            return;

        } catch (Exception e) {
            // This is a server-side error
            e.printStackTrace();  // Log the error
            req.setAttribute("errorMessage", "A Database error occurred. Please try again later.");
            req.getRequestDispatcher("/WEB-INF/views/register.jsp").forward(req,resp);
            return;

        }
    }

    private UserDAO userDAO;

    @Override
    public void init() throws ServletException {
        // initialize the userDAO when servlet starts
        userDAO = new UserDAO();

    }
}
