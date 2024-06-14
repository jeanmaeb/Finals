/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import javax.servlet.*;
import javax.servlet.http.*;
import java.io.*;
import java.sql.*;
import javax.servlet.annotation.WebServlet;

@WebServlet("/validate-token")
public class ValidateTokenServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String email = request.getParameter("email");
        String token = request.getParameter("token");

        try {
            Connection con = DB.getConnection();
            PreparedStatement pst = con.prepareStatement("SELECT * FROM password_reset_tokens WHERE email = ? AND token = ? AND expiration > NOW()");
            pst.setString(1, email);
            pst.setString(2, token);
            ResultSet rs = pst.executeQuery();

            if (rs.next()) {
                response.sendRedirect("/change-password?email=" + email);
            } else {
                request.setAttribute("messageToken", "Invalid or expired token.");
                RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/view/enter-token.jsp");
                dispatcher.forward(request, response);
            }
            con.close();
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("messageToken", "An error occurred. Please try again.");
            RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/view/enter-token.jsp");
            dispatcher.forward(request, response);
        }
    }
}
