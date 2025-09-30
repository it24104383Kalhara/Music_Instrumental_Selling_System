package com.filter;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebFilter("/*")
public class AuthFilter implements Filter {
    @Override
    public void doFilter (ServletRequest request, ServletResponse response, FilterChain chain)
    throws IOException, ServletException {
        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse resp = (HttpServletResponse) response;
        String ctx  =req.getContextPath();
        String path = req.getRequestURI().substring(ctx.length());

        //public paths
        boolean publicPath = path.startsWith("/login")
                || path.startsWith("/dev-seed")  //dev only
                || path.startsWith("/css/")
                || path.startsWith("/js/")
                || path.equals("/");   // allow home of you want

        if (publicPath) {
            chain.doFilter(request, response);
            return;
        }

        HttpSession session = req.getSession(false);
        boolean loggedIn = (session != null && session.getAttribute("userId") != null);

        if (!loggedIn) {
            resp.sendRedirect(ctx + "/login");
            return;
        }

        chain.doFilter(request, response);
    }
}
