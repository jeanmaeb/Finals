/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/submit_user")
public class UserServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        String userId = request.getParameter("id");

        if ("delete".equals(action) && userId != null) {
            try {
                Class.forName("com.mysql.jdbc.Driver");
                String url = "jdbc:mysql://localhost:3306/coffeeweb";
                String username = "root";  // Replace with your MySQL username
                String password = "";  // Replace with your MySQL password
                Connection con = DriverManager.getConnection(url, username, password);

                String deleteSQL = "DELETE FROM register WHERE ID = ?";
                PreparedStatement ps = con.prepareStatement(deleteSQL);
                ps.setInt(1, Integer.parseInt(userId));
                ps.executeUpdate();

                if (ps != null) ps.close();
                if (con != null) con.close();

                response.getWriter().println("User Deleted Successfully");
            } catch (Exception e) {
                e.printStackTrace();
                response.getWriter().println(e.getMessage());
            }
        } else {
            response.getWriter().println("I Don't Know?????");  // Adjust the redirection as necessary
        }
    }
}
