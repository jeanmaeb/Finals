/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import javax.servlet.RequestDispatcher;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 *
 * @author talai
 */
public class login extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {

        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        PrintWriter out = response.getWriter();
        
        String username = request.getParameter("username");
        String password = request.getParameter("loginPassword");
        
        if (username == null || password == null || username.isEmpty() || password.isEmpty()) {
            request.setAttribute("message", "Login Failed: Username and password must not be empty");
            response.sendRedirect("/main");
            return;
        }

        Connection con = DB.getConnection();
        try {
            String sql = "SELECT category, email, fullname FROM register WHERE BINARY username = ? AND BINARY password = ? LIMIT 1";
            PreparedStatement ps = con.prepareStatement(sql);
            
            ps.setString(1, username);
            ps.setString(2, password);

            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                // Username and password found
                String category = rs.getString("category");
                String fullname = rs.getString("fullname");
                String email = rs.getString("email");
                
                HttpSession session = request.getSession();
                session.setAttribute("fullname", fullname);
                session.setAttribute("category", category);
                session.setAttribute("email",email);
                
                switch (category) {
                    case "customer":
                        // Redirect to customer.jsp
                        response.sendRedirect("/customer");
                        break;
                    case "admin":
                        // Redirect to admin.jsp
                        response.sendRedirect("/admin");
                        break;
                    case "cashier":
                        // Redirect to cashier.jsp
                        response.sendRedirect("/cashier");
                        break;
                    case "employee":
                        // Redirect to employee.jsp
                        response.sendRedirect("/employee");
                        break;
                    default:
                        // Unknown category
                        request.setAttribute("message", "Login Failed: Invalid User Category");
                        response.sendRedirect("/main");
                        break;
                }
            } else {
                // Username and/or password not found
                request.setAttribute("message", "Login Failed: Invalid Login Credentials");
                RequestDispatcher rd = request.getRequestDispatcher("WEB-INF/view/main.jsp");
                rd.forward(request, response);
            }

            if (rs != null) rs.close();
            if (ps != null) ps.close();
            if (con != null) con.close();
        } catch (Exception e) {
            out.println("Error: " + e.getMessage());
        }
    }
}
