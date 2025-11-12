package com.controller;

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
    }
}
