/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.DriverManager;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import com.mysql.jdbc.Connection;
import com.mysql.jdbc.PreparedStatement;
import javax.servlet.RequestDispatcher;
import javax.servlet.annotation.WebServlet;

/**
 *
 * @author talai
 */

@WebServlet("/register")
public class register extends HttpServlet {

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
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet register</title>");            
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet register at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }


    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        PrintWriter out = response.getWriter();
        
        String category = request.getParameter("category");
        String fullname = request.getParameter("fName");
        String username = request.getParameter("uName");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String confirmpass = request.getParameter("cPassword");
        
        
        
        if (!password.equals(confirmpass)) {
        // Passwords do not match, send an alert and return
            request.setAttribute("fName", fullname);
            request.setAttribute("uName", username);
            request.setAttribute("email", email);
            if(category.equals("admin") || category.equals("employee") || category.equals("cashier")){
                request.setAttribute("error", "Registration Failed: Password Does Not Match");
                RequestDispatcher rd = request.getRequestDispatcher("WEB-INF/view/signUp.jsp");
                rd.forward(request, response);
            }else{
                request.setAttribute("error", "Registration Failed: Password Does Not Match");
                RequestDispatcher rd = request.getRequestDispatcher("WEB-INF/view/main.jsp");
                rd.forward(request, response);
            }
            return; // Exit the method to prevent further processing
        }
        
        if (password.length() < 8) {
            // Password is not greater than 8 characters, send an alert and return
            request.setAttribute("fName", fullname);
            request.setAttribute("uName", username);
            request.setAttribute("email", email);
            request.setAttribute("password", password);
            request.setAttribute("cPassword", confirmpass);
            if(category.equals("admin") || category.equals("employee") || category.equals("cashier")){
                request.setAttribute("error", "Registration Failed: Password must be at least 8 characters long");
                RequestDispatcher rd = request.getRequestDispatcher("WEB-INF/view/signUp.jsp");
                rd.forward(request, response);
            }else{
                request.setAttribute("error", "Registration Failed: Password must be at least 8 characters long");
                RequestDispatcher rd = request.getRequestDispatcher("WEB-INF/view/main.jsp");
                rd.forward(request, response);
            }
            
            return; // Exit the method to prevent further processing
        }
        
        Connection con = DB.getConnection();
        try {
            String sql = "INSERT INTO register (category, fullname, username, email, password)" + "values(?,?,?,?,?)";
            PreparedStatement insertPs = (PreparedStatement) con.prepareStatement(sql);
                // Set the values for the placeholders in the query
            insertPs.setString(1, category);
            insertPs.setString(2, fullname);
            insertPs.setString(3, username);
            insertPs.setString(4, email);
            insertPs.setString(5, password);
            
            
            insertPs.executeUpdate();
            request.setAttribute("error", "Registered Successfully");
            if(category.equals("admin") || category.equals("employee") || category.equals("cashier")){
                RequestDispatcher rd = request.getRequestDispatcher("WEB-INF/view/admin.jsp");
                rd.forward(request,response);
            }else{
                RequestDispatcher rd = request.getRequestDispatcher("WEB-INF/view/main.jsp");
                rd.forward(request,response);
            }
            insertPs.close();
            con.close();
        } catch (Exception e) {
            System.out.println("Error ::" + e.getMessage());
            // Optionally, you could also set an error message attribute
            request.setAttribute("fName", fullname);
            request.setAttribute("email", email);
            if(category.equals("admin") || category.equals("employee") || category.equals("cashier")){
                request.setAttribute("error", "Registration Failed: Username Already Taken");
                RequestDispatcher rd = request.getRequestDispatcher("WEB-INF/view/signUp.jsp");
                rd.forward(request,response);
            }else{
                request.setAttribute("error", "Registration Failed: Username Already Taken");
                RequestDispatcher rd = request.getRequestDispatcher("WEB-INF/view/main.jsp");
                rd.forward(request, response);
            }
           
        }
    }

    @Override
    public String getServletInfo() {
        return "Servlet for registering";
    }// </editor-fold>

}
