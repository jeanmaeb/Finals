package controller;

import javax.servlet.*;
import javax.servlet.http.*;
import java.io.*;
import static java.lang.System.out;
import java.sql.*;
import javax.servlet.annotation.WebServlet;

@WebServlet("/changepassword")
public class ChangePasswordServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String email = request.getParameter("email");
        String newPassword = request.getParameter("newPassword");

        if (email == null || newPassword == null || email.isEmpty() || newPassword.isEmpty()) {
            request.setAttribute("messageChangePass", "Email or new password cannot be empty.");
            RequestDispatcher rd = request.getRequestDispatcher("/WEB-INF/view/change-password.jsp");
            rd.forward(request, response);
            return;
        }
        
        if (newPassword.length() < 8) {
            request.setAttribute("messageChangePass", "Password must be at least 8 characters long.");
            RequestDispatcher rd = request.getRequestDispatcher("/WEB-INF/view/change-password.jsp");
            rd.forward(request, response);
            return;
        }

        Connection con = null;
        PreparedStatement pst = null;

        try {
            con = DB.getConnection();

            // Update the user's password only if they are in the "customer" category
            String updatePasswordQuery = "UPDATE register SET password = ? WHERE email = ? AND category = 'customer'";
            pst = con.prepareStatement(updatePasswordQuery);
            pst.setString(1, newPassword);
            pst.setString(2, email);
            int rowsUpdated = pst.executeUpdate();

            if (rowsUpdated > 0) {
                // Delete the reset token after password change
                String deleteTokenQuery = "DELETE FROM password_reset_tokens WHERE email = ?";
                pst = con.prepareStatement(deleteTokenQuery);
                pst.setString(1, email);
                pst.executeUpdate();

                HttpSession session = request.getSession();
                session.setAttribute("messageSuccess", "Password changed successfully.");
                response.sendRedirect("/main");
            } else {
                request.setAttribute("messageChangePass", "Password change failed. Please try again.");
                RequestDispatcher rd = request.getRequestDispatcher("/WEB-INF/view/change-password.jsp");
                rd.forward(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("messageChangePass", "An error occurred. Please try again.");
            RequestDispatcher rd = request.getRequestDispatcher("/WEB-INF/view/change-password.jsp");
            rd.forward(request, response);
        } finally {
            try {
                if (pst != null) pst.close();
                if (con != null) con.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
}
