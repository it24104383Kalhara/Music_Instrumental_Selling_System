package com.controller;


import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/logout")
public class LogoutServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, jakarta.servlet.http.HttpServletResponse resp) throws IOException {
        if (req.getSession(false) != null) req.getSession(false).invalidate();
        resp.sendRedirect(req.getContextPath() + "/login?logout=1");


    }
}
