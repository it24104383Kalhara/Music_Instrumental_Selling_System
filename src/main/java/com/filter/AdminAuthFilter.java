package com.filter;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebFilter("/admin/*")
public class AdminAuthFilter implements Filter {

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;
        HttpSession session = httpRequest.getSession(false);

        // Check if user is logged in
        boolean loggedIn = (session != null && session.getAttribute("userId") != null);

        if (!loggedIn) {
            // Not logged in, redirect to login
            httpResponse.sendRedirect(httpRequest.getContextPath() + "/login");
            return;
        }

        // Check if user is admin
        String userRole = (String) session.getAttribute("userRole");
        boolean isAdmin = "Admin".equalsIgnoreCase(userRole);

        if (!isAdmin) {
            // Not an admin, redirect to customer dashboard
            httpResponse.sendRedirect(httpRequest.getContextPath() + "/dashboard");
            return;
        }

        // User is admin, allow access
        chain.doFilter(request, response);
    }
}