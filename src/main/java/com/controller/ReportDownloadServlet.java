package com.controller;

// iText imports - Use full package names for clarity
import com.itextpdf.kernel.pdf.PdfDocument;
import com.itextpdf.kernel.pdf.PdfWriter;
import com.itextpdf.layout.Document;
import com.itextpdf.layout.element.Paragraph;
import com.itextpdf.layout.element.Table;
import com.itextpdf.kernel.colors.ColorConstants;

// Apache POI imports
import org.apache.poi.ss.usermodel.*;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;

// Database & Servlet
import com.util.DatabaseConfig;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

// Standard Java
import java.io.IOException;
import java.io.OutputStreamWriter;
import java.sql.*;
import java.time.LocalDate;

@WebServlet("/admin/reports/download")
public class ReportDownloadServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || !"Admin".equals(session.getAttribute("userRole"))) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        String reportType = request.getParameter("type");
        String format = request.getParameter("format");
        String startDate = request.getParameter("startDate");
        String endDate = request.getParameter("endDate");
        String status = request.getParameter("status");

        if (startDate == null || startDate.isEmpty()) {
            startDate = LocalDate.now().minusDays(30).toString();
        }
        if (endDate == null || endDate.isEmpty()) {
            endDate = LocalDate.now().toString();
        }

        try {
            switch (format.toLowerCase()) {
                case "pdf":
                    generatePDF(response, reportType, startDate, endDate, status);
                    break;
                case "excel":
                    generateExcel(response, reportType, startDate, endDate, status);
                    break;
                default:
                    response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid format");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                    "Error generating report: " + e.getMessage());
        }
    }

    // ==================== PDF GENERATION ====================
    private void generatePDF(HttpServletResponse response, String reportType,
                             String startDate, String endDate, String status) throws Exception {

        response.setContentType("application/pdf");
        response.setHeader("Content-Disposition",
                "attachment; filename=" + reportType + "_report_" + LocalDate.now() + ".pdf");

        PdfWriter writer = new PdfWriter(response.getOutputStream());
        PdfDocument pdf = new PdfDocument(writer);
        Document document = new Document(pdf);

        // Add title
        Paragraph title = new Paragraph(reportType.toUpperCase() + " REPORT")
                .setFontSize(20)
                .setBold();
        document.add(title);

        // Add date range
        Paragraph dateRange = new Paragraph("Period: " + startDate + " to " + endDate)
                .setFontSize(12)
                .setMarginBottom(20);
        document.add(dateRange);

        switch (reportType.toLowerCase()) {
            case "sales":
                generateSalesPDF(document, startDate, endDate, status);
                break;
            case "orders":
                generateOrdersPDF(document, startDate, endDate, status);
                break;
            case "customers":
                generateCustomersPDF(document, startDate, endDate);
                break;
            case "inventory":
                generateInventoryPDF(document);
                break;
        }

        document.close();
    }

    private void generateSalesPDF(Document document, String startDate, String endDate, String status)
            throws SQLException {

        try (Connection conn = DatabaseConfig.getDataSource().getConnection()) {

            document.add(new Paragraph("SALES STATISTICS").setBold().setFontSize(14));

            String statsSql = "SELECT COUNT(DISTINCT o.id) as totalOrders, " +
                    "COALESCE(SUM(o.total_amount), 0) as totalRevenue, " +
                    "COALESCE(AVG(o.total_amount), 0) as avgOrderValue " +
                    "FROM customer_order o " +
                    "WHERE o.created_at BETWEEN ? AND ?" +
                    (status != null && !status.isEmpty() ? " AND o.status = ?" : "");

            try (PreparedStatement pstmt = conn.prepareStatement(statsSql)) {
                pstmt.setString(1, startDate + " 00:00:00");
                pstmt.setString(2, endDate + " 23:59:59");
                if (status != null && !status.isEmpty()) {
                    pstmt.setString(3, status);
                }

                ResultSet rs = pstmt.executeQuery();
                if (rs.next()) {
                    document.add(new Paragraph("Total Orders: " + rs.getInt("totalOrders")));
                    document.add(new Paragraph("Total Revenue: $" +
                            String.format("%.2f", rs.getDouble("totalRevenue"))));
                    document.add(new Paragraph("Average Order Value: $" +
                            String.format("%.2f", rs.getDouble("avgOrderValue"))));
                }
            }

            document.add(new Paragraph("\n"));
            document.add(new Paragraph("TOP SELLING PRODUCTS").setBold().setFontSize(14));

            // Using full class name to avoid conflict
            Table table = new Table(new float[]{1, 3, 2, 2});
            table.setWidth(500);

            // Header cells - use full class name
            table.addHeaderCell(new com.itextpdf.layout.element.Cell()
                    .add(new Paragraph("Rank").setBold())
                    .setBackgroundColor(ColorConstants.LIGHT_GRAY));
            table.addHeaderCell(new com.itextpdf.layout.element.Cell()
                    .add(new Paragraph("Product Name").setBold())
                    .setBackgroundColor(ColorConstants.LIGHT_GRAY));
            table.addHeaderCell(new com.itextpdf.layout.element.Cell()
                    .add(new Paragraph("Quantity Sold").setBold())
                    .setBackgroundColor(ColorConstants.LIGHT_GRAY));
            table.addHeaderCell(new com.itextpdf.layout.element.Cell()
                    .add(new Paragraph("Revenue").setBold())
                    .setBackgroundColor(ColorConstants.LIGHT_GRAY));

            String productsSql = "SELECT TOP 10 i.name, " +
                    "SUM(oi.quantity) as quantitySold, " +
                    "SUM(oi.quantity * oi.unit_price) as revenue " +
                    "FROM order_item oi " +
                    "JOIN instrument i ON oi.instrument_id = i.id " +
                    "JOIN customer_order o ON oi.order_id = o.id " +
                    "WHERE o.created_at BETWEEN ? AND ? " +
                    (status != null && !status.isEmpty() ? "AND o.status = ? " : "") +
                    "GROUP BY i.id, i.name " +
                    "ORDER BY quantitySold DESC";

            try (PreparedStatement pstmt = conn.prepareStatement(productsSql)) {
                pstmt.setString(1, startDate + " 00:00:00");
                pstmt.setString(2, endDate + " 23:59:59");
                if (status != null && !status.isEmpty()) {
                    pstmt.setString(3, status);
                }

                ResultSet rs = pstmt.executeQuery();
                int rank = 1;
                while (rs.next()) {
                    table.addCell(String.valueOf(rank++));
                    table.addCell(rs.getString("name"));
                    table.addCell(String.valueOf(rs.getInt("quantitySold")));
                    table.addCell("$" + String.format("%.2f", rs.getDouble("revenue")));
                }
            }

            document.add(table);
        }
    }

    private void generateOrdersPDF(Document document, String startDate, String endDate, String status)
            throws SQLException {

        try (Connection conn = DatabaseConfig.getDataSource().getConnection()) {

            document.add(new Paragraph("ORDER STATISTICS").setBold().setFontSize(14));

            String statsSql = "SELECT " +
                    "COUNT(*) as totalOrders, " +
                    "SUM(CASE WHEN status = 'Processing' THEN 1 ELSE 0 END) as processingOrders, " +
                    "SUM(CASE WHEN status = 'Shipped' THEN 1 ELSE 0 END) as shippedOrders, " +
                    "SUM(CASE WHEN status = 'Delivered' THEN 1 ELSE 0 END) as deliveredOrders, " +
                    "SUM(CASE WHEN status = 'Cancelled' THEN 1 ELSE 0 END) as cancelledOrders " +
                    "FROM customer_order " +
                    "WHERE created_at BETWEEN ? AND ?" +
                    (status != null && !status.isEmpty() ? " AND status = ?" : "");

            try (PreparedStatement pstmt = conn.prepareStatement(statsSql)) {
                pstmt.setString(1, startDate + " 00:00:00");
                pstmt.setString(2, endDate + " 23:59:59");
                if (status != null && !status.isEmpty()) {
                    pstmt.setString(3, status);
                }

                ResultSet rs = pstmt.executeQuery();
                if (rs.next()) {
                    document.add(new Paragraph("Total Orders: " + rs.getInt("totalOrders")));
                    document.add(new Paragraph("Processing: " + rs.getInt("processingOrders")));
                    document.add(new Paragraph("Shipped: " + rs.getInt("shippedOrders")));
                    document.add(new Paragraph("Delivered: " + rs.getInt("deliveredOrders")));
                    document.add(new Paragraph("Cancelled: " + rs.getInt("cancelledOrders")));
                }
            }

            document.add(new Paragraph("\n"));
            document.add(new Paragraph("ORDER DETAILS").setBold().setFontSize(14));

            Table table = new Table(new float[]{2, 2, 2, 1.5f, 2});
            table.setWidth(500);

            table.addHeaderCell(new com.itextpdf.layout.element.Cell()
                    .add(new Paragraph("Order #").setBold())
                    .setBackgroundColor(ColorConstants.LIGHT_GRAY));
            table.addHeaderCell(new com.itextpdf.layout.element.Cell()
                    .add(new Paragraph("Customer").setBold())
                    .setBackgroundColor(ColorConstants.LIGHT_GRAY));
            table.addHeaderCell(new com.itextpdf.layout.element.Cell()
                    .add(new Paragraph("Amount").setBold())
                    .setBackgroundColor(ColorConstants.LIGHT_GRAY));
            table.addHeaderCell(new com.itextpdf.layout.element.Cell()
                    .add(new Paragraph("Status").setBold())
                    .setBackgroundColor(ColorConstants.LIGHT_GRAY));
            table.addHeaderCell(new com.itextpdf.layout.element.Cell()
                    .add(new Paragraph("Date").setBold())
                    .setBackgroundColor(ColorConstants.LIGHT_GRAY));

            String ordersSql = "SELECT o.order_number, u.full_name, o.total_amount, " +
                    "o.status, o.created_at " +
                    "FROM customer_order o " +
                    "JOIN app_user u ON o.user_id = u.id " +
                    "WHERE o.created_at BETWEEN ? AND ? " +
                    (status != null && !status.isEmpty() ? "AND o.status = ? " : "") +
                    "ORDER BY o.created_at DESC";

            try (PreparedStatement pstmt = conn.prepareStatement(ordersSql)) {
                pstmt.setString(1, startDate + " 00:00:00");
                pstmt.setString(2, endDate + " 23:59:59");
                if (status != null && !status.isEmpty()) {
                    pstmt.setString(3, status);
                }

                ResultSet rs = pstmt.executeQuery();
                while (rs.next()) {
                    table.addCell(rs.getString("order_number"));
                    table.addCell(rs.getString("full_name"));
                    table.addCell("$" + String.format("%.2f", rs.getDouble("total_amount")));
                    table.addCell(rs.getString("status"));
                    table.addCell(rs.getTimestamp("created_at").toString().substring(0, 10));
                }
            }

            document.add(table);
        }
    }

    private void generateCustomersPDF(Document document, String startDate, String endDate)
            throws SQLException {

        try (Connection conn = DatabaseConfig.getDataSource().getConnection()) {

            document.add(new Paragraph("CUSTOMER STATISTICS").setBold().setFontSize(14));

            String sql1 = "SELECT COUNT(*) as total FROM app_user WHERE role = 'Customer'";
            try (PreparedStatement pstmt = conn.prepareStatement(sql1)) {
                ResultSet rs = pstmt.executeQuery();
                if (rs.next()) {
                    document.add(new Paragraph("Total Customers: " + rs.getInt("total")));
                }
            }

            document.add(new Paragraph("\n"));
            document.add(new Paragraph("TOP CUSTOMERS BY SPENDING").setBold().setFontSize(14));

            Table table = new Table(new float[]{1, 3, 2, 2});
            table.setWidth(500);

            table.addHeaderCell(new com.itextpdf.layout.element.Cell()
                    .add(new Paragraph("Rank").setBold())
                    .setBackgroundColor(ColorConstants.LIGHT_GRAY));
            table.addHeaderCell(new com.itextpdf.layout.element.Cell()
                    .add(new Paragraph("Customer Name").setBold())
                    .setBackgroundColor(ColorConstants.LIGHT_GRAY));
            table.addHeaderCell(new com.itextpdf.layout.element.Cell()
                    .add(new Paragraph("Orders").setBold())
                    .setBackgroundColor(ColorConstants.LIGHT_GRAY));
            table.addHeaderCell(new com.itextpdf.layout.element.Cell()
                    .add(new Paragraph("Total Spent").setBold())
                    .setBackgroundColor(ColorConstants.LIGHT_GRAY));

            String topCustomersSql = "SELECT TOP 10 u.full_name, " +
                    "COUNT(o.id) as orderCount, " +
                    "COALESCE(SUM(o.total_amount), 0) as totalSpent " +
                    "FROM app_user u " +
                    "JOIN customer_order o ON u.id = o.user_id " +
                    "WHERE o.created_at BETWEEN ? AND ? " +
                    "GROUP BY u.id, u.full_name " +
                    "ORDER BY totalSpent DESC";

            try (PreparedStatement pstmt = conn.prepareStatement(topCustomersSql)) {
                pstmt.setString(1, startDate + " 00:00:00");
                pstmt.setString(2, endDate + " 23:59:59");

                ResultSet rs = pstmt.executeQuery();
                int rank = 1;
                while (rs.next()) {
                    table.addCell(String.valueOf(rank++));
                    table.addCell(rs.getString("full_name"));
                    table.addCell(String.valueOf(rs.getInt("orderCount")));
                    table.addCell("$" + String.format("%.2f", rs.getDouble("totalSpent")));
                }
            }

            document.add(table);
        }
    }

    private void generateInventoryPDF(Document document) throws SQLException {

        try (Connection conn = DatabaseConfig.getDataSource().getConnection()) {

            document.add(new Paragraph("INVENTORY STATISTICS").setBold().setFontSize(14));

            String statsSql = "SELECT COUNT(*) as totalProducts, " +
                    "SUM(CASE WHEN in_stock = 1 THEN 1 ELSE 0 END) as inStockProducts, " +
                    "COALESCE(SUM(price * stock_quantity), 0) as totalValue " +
                    "FROM instrument";

            try (PreparedStatement pstmt = conn.prepareStatement(statsSql)) {
                ResultSet rs = pstmt.executeQuery();
                if (rs.next()) {
                    document.add(new Paragraph("Total Products: " + rs.getInt("totalProducts")));
                    document.add(new Paragraph("In Stock: " + rs.getInt("inStockProducts")));
                    document.add(new Paragraph("Inventory Value: $" +
                            String.format("%.2f", rs.getDouble("totalValue"))));
                }
            }

            document.add(new Paragraph("\n"));
            document.add(new Paragraph("INVENTORY DETAILS").setBold().setFontSize(14));

            Table table = new Table(new float[]{3, 2, 2, 2});
            table.setWidth(500);

            table.addHeaderCell(new com.itextpdf.layout.element.Cell()
                    .add(new Paragraph("Product Name").setBold())
                    .setBackgroundColor(ColorConstants.LIGHT_GRAY));
            table.addHeaderCell(new com.itextpdf.layout.element.Cell()
                    .add(new Paragraph("Price").setBold())
                    .setBackgroundColor(ColorConstants.LIGHT_GRAY));
            table.addHeaderCell(new com.itextpdf.layout.element.Cell()
                    .add(new Paragraph("Stock").setBold())
                    .setBackgroundColor(ColorConstants.LIGHT_GRAY));
            table.addHeaderCell(new com.itextpdf.layout.element.Cell()
                    .add(new Paragraph("Value").setBold())
                    .setBackgroundColor(ColorConstants.LIGHT_GRAY));

            String inventorySql = "SELECT name, price, stock_quantity FROM instrument ORDER BY name";

            try (PreparedStatement pstmt = conn.prepareStatement(inventorySql)) {
                ResultSet rs = pstmt.executeQuery();
                while (rs.next()) {
                    table.addCell(rs.getString("name"));
                    table.addCell("$" + String.format("%.2f", rs.getDouble("price")));
                    table.addCell(String.valueOf(rs.getInt("stock_quantity")));
                    double value = rs.getDouble("price") * rs.getInt("stock_quantity");
                    table.addCell("$" + String.format("%.2f", value));
                }
            }

            document.add(table);
        }
    }

    // ==================== EXCEL GENERATION ====================
    private void generateExcel(HttpServletResponse response, String reportType,
                               String startDate, String endDate, String status) throws Exception {

        response.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
        response.setHeader("Content-Disposition",
                "attachment; filename=" + reportType + "_report_" + LocalDate.now() + ".xlsx");

        Workbook workbook = new XSSFWorkbook();
        Sheet sheet = workbook.createSheet(reportType.toUpperCase() + " Report");

        CellStyle headerStyle = workbook.createCellStyle();
        Font headerFont = workbook.createFont();
        headerFont.setBold(true);
        headerStyle.setFont(headerFont);
        headerStyle.setFillForegroundColor(IndexedColors.GREY_25_PERCENT.getIndex());
        headerStyle.setFillPattern(FillPatternType.SOLID_FOREGROUND);

        switch (reportType.toLowerCase()) {
            case "sales":
                generateSalesExcel(sheet, headerStyle, startDate, endDate, status);
                break;
            case "orders":
                generateOrdersExcel(sheet, headerStyle, startDate, endDate, status);
                break;
            case "customers":
                generateCustomersExcel(sheet, headerStyle, startDate, endDate);
                break;
            case "inventory":
                generateInventoryExcel(sheet, headerStyle);
                break;
        }

        for (int i = 0; i < sheet.getRow(0).getLastCellNum(); i++) {
            sheet.autoSizeColumn(i);
        }

        workbook.write(response.getOutputStream());
        workbook.close();
    }

    private void generateSalesExcel(Sheet sheet, CellStyle headerStyle,
                                    String startDate, String endDate, String status) throws SQLException {

        try (Connection conn = DatabaseConfig.getDataSource().getConnection()) {

            Row headerRow = sheet.createRow(0);
            String[] headers = {"Rank", "Product Name", "Quantity Sold", "Revenue"};
            for (int i = 0; i < headers.length; i++) {
                org.apache.poi.ss.usermodel.Cell cell = headerRow.createCell(i);
                cell.setCellValue(headers[i]);
                cell.setCellStyle(headerStyle);
            }

            String sql = "SELECT TOP 10 i.name, " +
                    "SUM(oi.quantity) as quantitySold, " +
                    "SUM(oi.quantity * oi.unit_price) as revenue " +
                    "FROM order_item oi " +
                    "JOIN instrument i ON oi.instrument_id = i.id " +
                    "JOIN customer_order o ON oi.order_id = o.id " +
                    "WHERE o.created_at BETWEEN ? AND ? " +
                    (status != null && !status.isEmpty() ? "AND o.status = ? " : "") +
                    "GROUP BY i.id, i.name " +
                    "ORDER BY quantitySold DESC";

            try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
                pstmt.setString(1, startDate + " 00:00:00");
                pstmt.setString(2, endDate + " 23:59:59");
                if (status != null && !status.isEmpty()) {
                    pstmt.setString(3, status);
                }

                ResultSet rs = pstmt.executeQuery();
                int rowNum = 1;
                int rank = 1;
                while (rs.next()) {
                    Row row = sheet.createRow(rowNum++);
                    row.createCell(0).setCellValue(rank++);
                    row.createCell(1).setCellValue(rs.getString("name"));
                    row.createCell(2).setCellValue(rs.getInt("quantitySold"));
                    row.createCell(3).setCellValue(rs.getDouble("revenue"));
                }
            }
        }
    }

    private void generateOrdersExcel(Sheet sheet, CellStyle headerStyle,
                                     String startDate, String endDate, String status) throws SQLException {

        try (Connection conn = DatabaseConfig.getDataSource().getConnection()) {

            Row headerRow = sheet.createRow(0);
            String[] headers = {"Order Number", "Customer", "Amount", "Status", "Date"};
            for (int i = 0; i < headers.length; i++) {
                org.apache.poi.ss.usermodel.Cell cell = headerRow.createCell(i);
                cell.setCellValue(headers[i]);
                cell.setCellStyle(headerStyle);
            }

            String sql = "SELECT o.order_number, u.full_name, o.total_amount, " +
                    "o.status, o.created_at " +
                    "FROM customer_order o " +
                    "JOIN app_user u ON o.user_id = u.id " +
                    "WHERE o.created_at BETWEEN ? AND ? " +
                    (status != null && !status.isEmpty() ? "AND o.status = ? " : "") +
                    "ORDER BY o.created_at DESC";

            try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
                pstmt.setString(1, startDate + " 00:00:00");
                pstmt.setString(2, endDate + " 23:59:59");
                if (status != null && !status.isEmpty()) {
                    pstmt.setString(3, status);
                }

                ResultSet rs = pstmt.executeQuery();
                int rowNum = 1;
                while (rs.next()) {
                    Row row = sheet.createRow(rowNum++);
                    row.createCell(0).setCellValue(rs.getString("order_number"));
                    row.createCell(1).setCellValue(rs.getString("full_name"));
                    row.createCell(2).setCellValue(rs.getDouble("total_amount"));
                    row.createCell(3).setCellValue(rs.getString("status"));
                    row.createCell(4).setCellValue(rs.getTimestamp("created_at").toString());
                }
            }
        }
    }

    private void generateCustomersExcel(Sheet sheet, CellStyle headerStyle,
                                        String startDate, String endDate) throws SQLException {

        try (Connection conn = DatabaseConfig.getDataSource().getConnection()) {

            Row headerRow = sheet.createRow(0);
            String[] headers = {"Rank", "Customer Name", "Email", "Order Count", "Total Spent"};
            for (int i = 0; i < headers.length; i++) {
                org.apache.poi.ss.usermodel.Cell cell = headerRow.createCell(i);
                cell.setCellValue(headers[i]);
                cell.setCellStyle(headerStyle);
            }

            String sql = "SELECT TOP 10 u.full_name, u.email, " +
                    "COUNT(o.id) as orderCount, " +
                    "COALESCE(SUM(o.total_amount), 0) as totalSpent " +
                    "FROM app_user u " +
                    "JOIN customer_order o ON u.id = o.user_id " +
                    "WHERE o.created_at BETWEEN ? AND ? " +
                    "GROUP BY u.id, u.full_name, u.email " +
                    "ORDER BY totalSpent DESC";

            try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
                pstmt.setString(1, startDate + " 00:00:00");
                pstmt.setString(2, endDate + " 23:59:59");

                ResultSet rs = pstmt.executeQuery();
                int rowNum = 1;
                int rank = 1;
                while (rs.next()) {
                    Row row = sheet.createRow(rowNum++);
                    row.createCell(0).setCellValue(rank++);
                    row.createCell(1).setCellValue(rs.getString("full_name"));
                    row.createCell(2).setCellValue(rs.getString("email"));
                    row.createCell(3).setCellValue(rs.getInt("orderCount"));
                    row.createCell(4).setCellValue(rs.getDouble("totalSpent"));
                }
            }
        }
    }

    private void generateInventoryExcel(Sheet sheet, CellStyle headerStyle) throws SQLException {

        try (Connection conn = DatabaseConfig.getDataSource().getConnection()) {

            Row headerRow = sheet.createRow(0);
            String[] headers = {"Product Name", "Price", "Stock Quantity", "Total Value"};
            for (int i = 0; i < headers.length; i++) {
                org.apache.poi.ss.usermodel.Cell cell = headerRow.createCell(i);
                cell.setCellValue(headers[i]);
                cell.setCellStyle(headerStyle);
            }

            String sql = "SELECT name, price, stock_quantity FROM instrument ORDER BY name";

            try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
                ResultSet rs = pstmt.executeQuery();
                int rowNum = 1;
                while (rs.next()) {
                    Row row = sheet.createRow(rowNum++);
                    row.createCell(0).setCellValue(rs.getString("name"));
                    row.createCell(1).setCellValue(rs.getDouble("price"));
                    row.createCell(2).setCellValue(rs.getInt("stock_quantity"));
                    double value = rs.getDouble("price") * rs.getInt("stock_quantity");
                    row.createCell(3).setCellValue(value);
                }
            }
        }
    }


}