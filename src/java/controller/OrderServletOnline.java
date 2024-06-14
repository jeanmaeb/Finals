/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.math.BigDecimal;
import java.net.URLDecoder;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.Time;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Properties;
import javax.mail.Message;
import javax.mail.MessagingException;
import javax.mail.Multipart;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeBodyPart;
import javax.mail.internet.MimeMessage;
import javax.mail.internet.MimeMultipart;
import javax.mail.internet.MimeUtility;
import javax.mail.util.ByteArrayDataSource;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import com.itextpdf.text.Document;
import com.itextpdf.text.Element;
import com.itextpdf.text.Font;
import com.itextpdf.text.Font.FontFamily;
import com.itextpdf.text.Paragraph;
import com.itextpdf.text.Rectangle;
import com.itextpdf.text.pdf.PdfPTable;
import com.itextpdf.text.pdf.PdfPCell;
import com.itextpdf.text.pdf.PdfWriter;

@WebServlet("/orderOnline")
public class OrderServletOnline extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String formData = request.getParameter("formData");
        String customerName = request.getParameter("customerName");
        String email = request.getParameter("email");
        String contactNumber = request.getParameter("contactNumber");
        String address = request.getParameter("address");
        String time = request.getParameter("time"); 
        String platform = request.getParameter("platform");
        String orderType = request.getParameter("orderType");
        String totalAmount = request.getParameter("totalAmount");
        String transactionType = request.getParameter("transactionType");
        String employee = "None";
        String[] pairs = formData.split("&");

        Connection con = DB.getConnection();
        PreparedStatement ps = null;
        
        if(totalAmount != null || customerName != null){
            try {
                // PDF generation setup
                ByteArrayOutputStream outputStream = new ByteArrayOutputStream();
                Document document = new Document();
                PdfWriter writer = PdfWriter.getInstance(document, outputStream);
                
                // Set the custom footer event
                Footer event = new Footer();
                writer.setBoxSize("footer", new Rectangle(36, 54, 559, 806));
                writer.setPageEvent(event);
                
                document.open();
                
                // Set up Font
                Font font = new Font(FontFamily.HELVETICA, 20, Font.BOLD);
                
                // Shop Name
                Paragraph shopName = new Paragraph("CUP'A BLISS", font);
                shopName.setAlignment(Element.ALIGN_CENTER);
                document.add(shopName);
                
                // Shop Address
                Paragraph addressShop = new Paragraph("Tagbilaran City, Bohol");
                addressShop.setAlignment(Element.ALIGN_CENTER);
                document.add(addressShop);
                
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

                Paragraph contactInfo = new Paragraph("Contact Number: " + contactNumber);
                contactInfo.setAlignment(Element.ALIGN_CENTER);
                document.add(contactInfo);
                
                Paragraph emailInfo = new Paragraph("Email: " + email);
                emailInfo.setAlignment(Element.ALIGN_CENTER);
                document.add(emailInfo);

                // Add centered platform and order type information
                Paragraph platformInfo = new Paragraph("Platform: " + platform);
                platformInfo.setAlignment(Element.ALIGN_CENTER);
                document.add(platformInfo);

                Paragraph orderTypeInfo = new Paragraph("Order Type: " + orderType);
                orderTypeInfo.setAlignment(Element.ALIGN_CENTER);
                document.add(orderTypeInfo);
                

                Paragraph transactionTypeInfo = new Paragraph("Transaction Type: " + transactionType);
                transactionTypeInfo.setAlignment(Element.ALIGN_CENTER);
                document.add(transactionTypeInfo);
                
                
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
                
                SimpleDateFormat timeFormat = new SimpleDateFormat("HH:mm");
                Time sqlTime = null;
                
                if (!"00:00:00".equals(time)) {
                    try {
                        java.util.Date parsedTime = timeFormat.parse(time);
                        sqlTime = new java.sql.Time(parsedTime.getTime());
                    } catch (ParseException e) {
                        e.printStackTrace();
                        // Handle the parse exception
                    }
                }else{
                    try {
                        java.util.Date parsedTime = timeFormat.parse(time);
                        sqlTime = new java.sql.Time(parsedTime.getTime());
                    } catch (ParseException e) {
                        e.printStackTrace();
                        // Handle the parse exception
                    }
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
                    String sql = "INSERT INTO orderlist_online (Platform, OrderType, TransactionType, Address, Pick_up_time, Email, Customer, Item_Quantity, Item_Name, Size, Type, Price, Done, ConfirmedBy) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
                    ps = con.prepareStatement(sql);
                    ps.setString(1, platform);
                    ps.setString(2, orderType);
                    ps.setString(3, transactionType);
                    ps.setString(4, address);
                    ps.setTime(5, sqlTime); // Set only the time
                    ps.setString(6, email);
                    ps.setString(7, customerName);
                    ps.setInt(8, Integer.parseInt(quantity));
                    ps.setString(9, itemName);
                    ps.setString(10, size);
                    ps.setString(11, type);
                    ps.setBigDecimal(12, new BigDecimal(price));
                    ps.setBoolean(13, false); // Initial value for 'done' field
                    ps.setString(14, employee);
                    ps.executeUpdate();

                    // Add item details to the table
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
                if (orderType.equals("Delivery")){
                    Paragraph addressInfo = new Paragraph("Address: " + address);
                    addressInfo.setAlignment(Element.ALIGN_CENTER);
                    document.add(addressInfo);
                } else {
                    Paragraph timeInfo = new Paragraph("Pick-up Time: " + time);
                    timeInfo.setAlignment(Element.ALIGN_CENTER);
                    document.add(timeInfo);
                }
                document.add(Line);
                
                Font amountFont = new Font(FontFamily.HELVETICA, 12, Font.BOLD);
                // Display Total Amount
                Paragraph amount = new Paragraph("Total Amount (PHP):   " + totalAmount, amountFont);
                amount.setAlignment(Element.ALIGN_RIGHT);
                document.add(amount);
                
                //CLOSE DOCUMENT
                document.close();
                
                // Convert the output stream to a byte array
                byte[] pdfBytes = outputStream.toByteArray();

                // Email properties setup
                Properties props = new Properties();
                props.put("mail.smtp.host", "smtp.gmail.com"); // Replace with your SMTP host
                props.put("mail.smtp.port", "587"); // Replace with your SMTP port
                props.put("mail.smtp.auth", "true");
                props.put("mail.smtp.starttls.enable", "true");
                
                // Authenticator setup (if needed)
                Session emailSession = Session.getInstance(props, new javax.mail.Authenticator() {
                    protected javax.mail.PasswordAuthentication getPasswordAuthentication() {
                        return new javax.mail.PasswordAuthentication("cupabliss@gmail.com", "fqzgllivssdrwxjb"); // Replace with your email and password
                    }
                });

                try {
                    // Create a MimeMessage
                    MimeMessage message = new MimeMessage(emailSession);
                    message.setFrom(new InternetAddress("cupabliss@gmail.com")); // Replace with your email
                    message.addRecipient(Message.RecipientType.TO, new InternetAddress(email));
                    message.setSubject("Your Order Receipt");

                    // Create a multipart message
                    Multipart multipart = new MimeMultipart();

                    // Body part for the email text
                    MimeBodyPart textBodyPart = new MimeBodyPart();
                    textBodyPart.setText("Dear " + customerName + ",\n\nPlease find attached your order receipt.\n\nThank you for your purchase!");

                    // Body part for the attachment
                    MimeBodyPart attachmentBodyPart = new MimeBodyPart();
                    attachmentBodyPart.setDataHandler(new javax.activation.DataHandler(new ByteArrayDataSource(pdfBytes, "application/pdf")));
                    attachmentBodyPart.setFileName(MimeUtility.encodeText("receipt.pdf"));

                    // Add both parts to the multipart
                    multipart.addBodyPart(textBodyPart);
                    multipart.addBodyPart(attachmentBodyPart);

                    // Set the complete message parts
                    message.setContent(multipart);

                    // Send the email
                    Transport.send(message);

                    // Set session attribute for success message
                    HttpSession session = request.getSession();
                    session.setAttribute("messageSuccess", "Receipt has been sent to your email.");
                    response.sendRedirect("/customer");
                } catch (MessagingException e) {
                    throw new RuntimeException(e);
                }

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
