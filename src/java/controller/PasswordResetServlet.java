package controller;

import javax.servlet.*;
import javax.servlet.http.*;
import java.io.*;
import java.util.*;
import javax.mail.*;
import javax.mail.internet.*;
import java.sql.*;
import javax.servlet.annotation.WebServlet;

@WebServlet("/reset-pass")
public class PasswordResetServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        PrintWriter out = response.getWriter();
        
        String email = request.getParameter("email");
        HttpSession S = request.getSession();
        S.setAttribute("Email", email);

        // Verify if the email exists in the users database and category is "customer"
        boolean isValidUser = false;

        try {
            Connection con = DB.getConnection();
            PreparedStatement pst = con.prepareStatement("SELECT * FROM register WHERE email = ? AND category = ?");
            pst.setString(1, email);
            pst.setString(2, "customer");
            ResultSet rs = pst.executeQuery();

            if (rs.next()) {
                isValidUser = true;
            }
            con.close();
        } catch (Exception e) {
            e.printStackTrace();
        }

        if (isValidUser) {
            // Generate a 6-digit token
            String token = String.format("%06d", new Random().nextInt(999999));

            // Save token in the database with expiration time (e.g., 10 minutes)
            try {
                Connection con = DB.getConnection();
                PreparedStatement pst = con.prepareStatement("INSERT INTO password_reset_tokens (email, token, expiration) VALUES (?, ?, DATE_ADD(NOW(), INTERVAL 10 MINUTE))");
                pst.setString(1, email);
                pst.setString(2, token);
                pst.executeUpdate();
                con.close();
            } catch (Exception e) {
                e.printStackTrace();
            }

            // Send email with token
            String host = "smtp.gmail.com";
            final String user = "cupabliss@gmail.com";
            final String password = "fqzg lliv ssdr wxjb";  // Ensure this is your app-specific password if using 2FA

            String to = email;

            // Get the session object
            Properties props = new Properties();
            props.put("mail.smtp.host", host);
            props.put("mail.smtp.auth", "true");
            props.put("mail.smtp.port", "587");
            props.put("mail.smtp.starttls.enable", "true");

            Session session = Session.getInstance(props, new javax.mail.Authenticator() {
                protected PasswordAuthentication getPasswordAuthentication() {
                    return new PasswordAuthentication(user, password);
                }
            });

            try {
                MimeMessage message = new MimeMessage(session);
                message.setFrom(new InternetAddress(user));
                message.addRecipient(Message.RecipientType.TO, new InternetAddress(to));
                message.setSubject("Password Reset Token");
                message.setText("Your password reset token is: " + token);

                // Send message
                Transport.send(message);

                System.out.println("Token sent successfully...");
                response.sendRedirect("/enter-token");
            } catch (MessagingException e) {
                e.printStackTrace();
                response.getWriter().write("Failed to send email: " + e.getMessage());
            }
        } else {
            request.setAttribute("messageR", "Email Does Not Exist!");
            RequestDispatcher rd = request.getRequestDispatcher("/WEB-INF/view/forgot-pass.jsp");
            rd.forward(request, response);
        }
    }
}
