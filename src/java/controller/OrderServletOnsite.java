/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.math.BigDecimal;
import java.net.URLDecoder;
import java.sql.Connection;
import java.sql.PreparedStatement;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import com.itextpdf.text.Document;
import com.itextpdf.text.Element;
import com.itextpdf.text.Font;
import com.itextpdf.text.Font.FontFamily;
import com.itextpdf.text.Paragraph;
import com.itextpdf.text.Rectangle;
import com.itextpdf.text.pdf.PdfPTable;
import com.itextpdf.text.pdf.PdfPCell;
import com.itextpdf.text.pdf.PdfPageEvent;
import com.itextpdf.text.pdf.PdfWriter;

@WebServlet("/orderOnsite")
public class OrderServletOnsite extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String formData = request.getParameter("formData");
        String customerName = request.getParameter("customerName");
        String cashierName = request.getParameter("cashierName");
        String payment = request.getParameter("payment");
        String platform = request.getParameter("platform");
        String orderType = request.getParameter("orderType");
        String totalAmount = request.getParameter("totalAmount");
        String changeAmount = request.getParameter("changeAmount");
        String employee = "None";
        String[] pairs = formData.split("&");

        Connection con = DB.getConnection();
        PreparedStatement ps = null;
        
        if(totalAmount != null || customerName != null || payment != null){
            try {
                // PDF generation setup
                ByteArrayOutputStream outputStream = new ByteArrayOutputStream();
                Document document = new Document();
                PdfWriter writer = PdfWriter.getInstance(document, outputStream);
                
                 // Set the custom footer event
                Footer event = new Footer();
                writer.setBoxSize("footer", new Rectangle(36, 54, 559, 806));
                writer.setPageEvent((PdfPageEvent) event);
                
                document.open();
                
                // Set up Font
                Font font = new Font(FontFamily.HELVETICA, 20, Font.BOLD);
                
                // Shop Name
                Paragraph shopName = new Paragraph("CUP'A BLISS", font);
                shopName.setAlignment(Element.ALIGN_CENTER);
                document.add(shopName);
                
                // Shop Address
                Paragraph address = new Paragraph("Tagbilaran City, Bohol");
                address.setAlignment(Element.ALIGN_CENTER);
                document.add(address);
                
                // Tin number
                Paragraph tinNum = new Paragraph("TIN: 00-00000-00000");
                tinNum.setAlignment(Element.ALIGN_CENTER);
                document.add(tinNum);
                
                //ADD SPACER
                document.add(new Paragraph("\n"));
                
                // Add centered receipt header
                Paragraph header = new Paragraph("INVOICE");
                header.setAlignment(Element.ALIGN_CENTER);
                document.add(header);
                
                //ADD SPACER
                document.add(new Paragraph("\n"));
                
                // Add centered customer and cashier information
                Paragraph customerInfo = new Paragraph("Customer: " + customerName);
                customerInfo.setAlignment(Element.ALIGN_CENTER);
                document.add(customerInfo);

                Paragraph cashierInfo = new Paragraph("Cashier: " + cashierName);
                cashierInfo.setAlignment(Element.ALIGN_CENTER);
                document.add(cashierInfo);

                // Add centered platform and order type information
                Paragraph platformInfo = new Paragraph("Platform: " + platform);
                platformInfo.setAlignment(Element.ALIGN_CENTER);
                document.add(platformInfo);

                Paragraph orderTypeInfo = new Paragraph("Order Type: " + orderType);
                orderTypeInfo.setAlignment(Element.ALIGN_CENTER);
                document.add(orderTypeInfo);
                
                Paragraph Line = new Paragraph("----------------------------------------------------------------------------------------------------------------------------------");
                Line.setAlignment(Element.ALIGN_JUSTIFIED);
                                
                // Add items header
                document.add(Line);
                Paragraph headerDes = new Paragraph("Description");
                headerDes.setAlignment(Element.ALIGN_CENTER); // Corrected alignment setting
                document.add(headerDes); // Add the header
                document.add(Line);

                // Create a table with column headers
                PdfPTable table = new PdfPTable(5); // 5 columns
                table.setWidthPercentage(100); // Full width
                table.setSpacingBefore(10f); // Space before table
                table.setSpacingAfter(10f); // Space after table

                // Add table headers
                String[] headers = {"Quantity", "Item Name", "Size", "Type", "Price (PHP)"};
                for (String headerTitle : headers) {
                    PdfPCell headerCell = new PdfPCell(new Paragraph(headerTitle));
                    headerCell.setHorizontalAlignment(Element.ALIGN_CENTER);
                    table.addCell(headerCell);
                }

                // Process form data and add rows to the table
                for (int i = 0; i < pairs.length; i += 5) {
                    String quantityPair = pairs[i];
                    String itemNamePair = pairs[i + 1];
                    String sizePair = pairs[i + 2];
                    String typePair = pairs[i + 3];
                    String pricePair = pairs[i + 4];

                    String quantity = URLDecoder.decode(quantityPair.split("=")[1], "UTF-8");
                    String itemName = URLDecoder.decode(itemNamePair.split("=")[1], "UTF-8");
                    String size = URLDecoder.decode(sizePair.split("=")[1], "UTF-8");
                    String type = URLDecoder.decode(typePair.split("=")[1], "UTF-8");
                    String price = URLDecoder.decode(pricePair.split("=")[1], "UTF-8");

                    // Insert each row of data into the database
                    String sql = "INSERT INTO orderlist (Platform, OrderType, Customer, Cashier, Item_Quantity, Item_Name, Size, Type, Price, Done, ConfirmedBy) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
                    ps = con.prepareStatement(sql);
                    ps.setString(1, platform);
                    ps.setString(2, orderType);
                    ps.setString(3, customerName);
                    ps.setString(4, cashierName);
                    ps.setInt(5, Integer.parseInt(quantity));
                    ps.setString(6, itemName);
                    ps.setString(7, size);
                    ps.setString(8, type);
                    ps.setBigDecimal(9, new BigDecimal(price));
                    ps.setBoolean(10, false); // Initial value for 'done' field
                    ps.setString(11, employee);
                    ps.executeUpdate();

                    // Add item details to the table
                    // Add item details to the table, centering the text
                    PdfPCell quantityCell = new PdfPCell(new Paragraph(quantity));
                    quantityCell.setHorizontalAlignment(Element.ALIGN_CENTER);
                    table.addCell(quantityCell);

                    PdfPCell itemNameCell = new PdfPCell(new Paragraph(itemName));
                    itemNameCell.setHorizontalAlignment(Element.ALIGN_CENTER);
                    table.addCell(itemNameCell);

                    PdfPCell sizeCell = new PdfPCell(new Paragraph(size));
                    sizeCell.setHorizontalAlignment(Element.ALIGN_CENTER);
                    table.addCell(sizeCell);

                    PdfPCell typeCell = new PdfPCell(new Paragraph(type));
                    typeCell.setHorizontalAlignment(Element.ALIGN_CENTER);
                    table.addCell(typeCell);

                    PdfPCell priceCell = new PdfPCell(new Paragraph(price));
                    priceCell.setHorizontalAlignment(Element.ALIGN_CENTER);
                    table.addCell(priceCell);
                }

                // Add the table to the document
                document.add(table);
                document.add(Line);
                
                Font amountFont = new Font(FontFamily.HELVETICA, 12, Font.BOLD);
                // Display Total Amount
                Paragraph amount = new Paragraph("Total Amount (PHP):   " + totalAmount, amountFont);
                amount.setAlignment(Element.ALIGN_RIGHT);
                document.add(amount);
                
                // Display Payment
                Paragraph paymentAmount = new Paragraph("Payment (PHP):   " + payment , amountFont);
                paymentAmount.setAlignment(Element.ALIGN_RIGHT);
                document.add(paymentAmount);
                
                // Display Change
                Paragraph change = new Paragraph("Change (PHP):   " + changeAmount , amountFont);
                change.setAlignment(Element.ALIGN_RIGHT);
                document.add(change);
                document.add(Line);
                
                //CLOSE DOCUMENT
                document.close();
                
                // Save the PDF to the server
                String filePath = getServletContext().getRealPath("/") + "receipts/";
                File directory = new File(filePath);
                if (!directory.exists()) {
                    directory.mkdirs();
                }
                String fileName = "receipt_" + System.currentTimeMillis() + ".pdf";
                FileOutputStream fileOutputStream = new FileOutputStream(new File(directory, fileName));
                fileOutputStream.write(outputStream.toByteArray());
                fileOutputStream.close();

                // Set the response content type to PDF
                response.setContentType("application/pdf");
                response.setHeader("Content-Disposition", "attachment; filename=\"receipt.pdf\"");

                // Write the PDF to the response output stream
                response.getOutputStream().write(outputStream.toByteArray());
                response.getOutputStream().flush();
            } catch (Exception e) {
                System.out.println(e.getMessage());
                response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, e.getMessage());
            } finally {
                try {
                    if (ps != null) ps.close();
                    if (con != null) con.close();
                } catch (Exception e) {
                    System.out.println(e.getMessage());
                }
            }
        }
    }
}
