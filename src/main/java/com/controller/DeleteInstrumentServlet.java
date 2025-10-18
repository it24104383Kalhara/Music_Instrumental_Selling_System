package com.controller;

import com.dao.InstrumentDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/staff/instruments/delete")
public class DeleteInstrumentServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String idStr = request.getParameter("id");
        if (idStr == null) {
            response.sendRedirect(request.getContextPath() + "/staff/instruments");
            return;
        }

        try {
            int id = Integer.parseInt(idStr);
            InstrumentDAO instrumentDAO = new InstrumentDAO();
            instrumentDAO.delete(id);

            response.sendRedirect(request.getContextPath() + "/staff/instruments?success=deleted");

        } catch (NumberFormatException | SQLException e) {
            throw new ServletException("Failed to delete instrument", e);
        }
    }
}