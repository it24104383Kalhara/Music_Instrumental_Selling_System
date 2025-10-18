package com.filter;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebFilter("/staff/*")
public class StaffAuthFilter implements Filter {

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;
        HttpSession session = httpRequest.getSession(false);

        // Check if user is logged in
        boolean loggedIn = (session != null && session.getAttribute("userId") != null);

        if (!loggedIn) {
            httpResponse.sendRedirect(httpRequest.getContextPath() + "/login");
            return;
        }

        // Check if user is staff or admin
        String userRole = (String) session.getAttribute("userRole");
        boolean isStaff = "Staff".equalsIgnoreCase(userRole);
        boolean isAdmin = "Admin".equalsIgnoreCase(userRole);

        if (!isStaff && !isAdmin) {
            // Not staff or admin, redirect to customer dashboard
            httpResponse.sendRedirect(httpRequest.getContextPath() + "/dashboard");
            return;
        }

        // User is staff or admin, allow access
        chain.doFilter(request, response);
    }
}