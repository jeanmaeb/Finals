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
import javax.servlet.http.HttpSession;

@WebServlet("/orderdoneonline")
public class OrderDoneServletOnline extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String customer = request.getParameter("customer");
        String orderDate = request.getParameter("order_date");
        String orderType = request.getParameter("orderType");
        String platform = request.getParameter("platform");
        String employeeName = request.getParameter("employeeName");

        Connection con = null;
        PreparedStatement ps = null;

        try {
            Class.forName("com.mysql.jdbc.Driver");
            String url = "jdbc:mysql://localhost:3306/coffeeweb";
            String username = "root";  // Replace with your MySQL username
            String password = "";  // Replace with your MySQL password
            con = DriverManager.getConnection(url, username, password);

            String updateSQL = "UPDATE orderlist_online SET Done = TRUE, ConfirmedBy = ? WHERE customer = ? AND order_date = ? AND OrderType = ? AND Platform = ?";
            ps = con.prepareStatement(updateSQL);
            ps.setString(1, employeeName);
            ps.setString(2, customer);
            ps.setString(3, orderDate);
            ps.setString(4, orderType);
            ps.setString(5, platform);

            int rowsUpdated = ps.executeUpdate();

            HttpSession order = request.getSession();
            if (rowsUpdated > 0) {
                order.setAttribute("orderMessage", "Order marked as done.");
            } else {
                order.setAttribute("orderMessage", "Order not found.");
            }
            response.sendRedirect("/employee");

        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().write(e.getMessage());
        } finally {
            try {
                if (ps != null) ps.close();
                if (con != null) con.close();
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }
}

