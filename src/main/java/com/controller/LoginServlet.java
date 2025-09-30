package com.controller;

import com.dao.UserDAO;
import com.model.User;
import com.util.PasswordUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.getRequestDispatcher("/WEB-INF/views/login.jsp").forward(req,resp);

    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");

        String email = req.getParameter("email");
        String password = req.getParameter("password");

        if (email != null) email = email.trim().toLowerCase();
        if (password == null) password = "";

        try {
            UserDAO userDAO = new UserDAO();
            User user = userDAO.findByEmail(email);
            if (user != null && PasswordUtil.verify(password,user.getPasswordHash())) {
                HttpSession session = req.getSession(true);
                session.setAttribute("userId", user.getId());
                session.setAttribute("userEmail", user.getEmail());
                session.setAttribute("userName", user.getFullName());

                resp.sendRedirect(req.getContextPath() + "/dashboard");
                return;
            } else {
                req.setAttribute("error", "Invalid email or password");
                req.getRequestDispatcher("/WEB-INF/views/login.jsp").forward(req, resp);

            }

        } catch (SQLException e) {
            throw new ServletException("Login failed", e);
        }
    }
}
