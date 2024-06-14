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

@WebServlet("/orderdoneonsite")
public class OrderDoneServletOnsite extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String customer = request.getParameter("customer");
        String orderDate = request.getParameter("order_date");
        String orderType = request.getParameter("orderType");
        String platform = request.getParameter("platform");
        String employeeName = request.getParameter("employeeName");

        // Debugging: Print parameters to check if they are correctly passed
        System.out.println("Received Parameters:");
        System.out.println("Customer: " + customer);
        System.out.println("Order Date: " + orderDate);
        System.out.println("Order Type: " + orderType);
        System.out.println("Platform: " + platform);
        System.out.println("Employee Name: " + employeeName);

        try {
            Class.forName("com.mysql.jdbc.Driver");
            String url = "jdbc:mysql://localhost:3306/coffeeweb";
            String username = "root";
            String password = "";
            Connection con = DriverManager.getConnection(url, username, password);

            String sql = "UPDATE orderlist SET Done = TRUE, ConfirmedBy = ? WHERE Customer = ? AND Order_Date = ? AND OrderType = ? AND Platform = ?";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, employeeName);
            ps.setString(2, customer);
            ps.setString(3, orderDate);
            ps.setString(4, orderType);
            ps.setString(5, platform);

            int rowsUpdated = ps.executeUpdate();
            HttpSession session = request.getSession();
            if (rowsUpdated > 0) {
                session.setAttribute("orderMessage", "Order marked as done.");
            } else {
                session.setAttribute("orderMessage", "Order not found.");
            }
            response.sendRedirect("/employee");
            ps.close();
            con.close();
        } catch (Exception e) {
            response.getWriter().write("Error: " + e.getMessage());
        }
    }
}
