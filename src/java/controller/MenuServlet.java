/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import java.io.IOException;
import java.io.InputStream;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.Part;

@WebServlet("/submit_item")
@MultipartConfig(maxFileSize = 16177215) // File size limit (16MB)
public class MenuServlet extends HttpServlet {

    private String dbURL = "jdbc:mysql://localhost:3306/coffeeweb";
    private String dbUser = "root";
    private String dbPass = ""; // Replace with your MySQL password

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");

        if ("delete".equals(action)) {
            deleteItem(request, response);
        } else {
            handleAddOrEdit(request, response, action);
        }
    }

    private void handleAddOrEdit(HttpServletRequest request, HttpServletResponse response, String action) throws IOException, ServletException {
        String itemName = request.getParameter("item_name");
        double priceSmall = Double.parseDouble(request.getParameter("price_small"));
        double priceMedium = Double.parseDouble(request.getParameter("price_medium"));
        double priceLarge = Double.parseDouble(request.getParameter("price_large"));
        double priceIced = Double.parseDouble(request.getParameter("price_iced"));

        InputStream inputStream = null; // Input stream of the upload file

        // Obtains the upload file part in this multipart request
        Part filePart = request.getPart("item_image");
        if (filePart != null && filePart.getSize() > 0) {
            // Obtains input stream of the upload file
            inputStream = filePart.getInputStream();
        }

        try {
            Class.forName("com.mysql.jdbc.Driver");
            Connection con = DriverManager.getConnection(dbURL, dbUser, dbPass);

            String sql = "";
            if ("add".equals(action)) {
                sql = "INSERT INTO menu (item_name, price_small, price_medium, price_large, price_iced, item_image) values (?, ?, ?, ?, ?, ?)";
            } else if ("edit".equals(action)) {
                int id = Integer.parseInt(request.getParameter("item_id"));
                sql = "UPDATE menu SET item_name=?, price_small=?, price_medium=?, price_large=?, price_iced=?, item_image=? WHERE ID=?";
            }

            PreparedStatement statement = con.prepareStatement(sql);
            statement.setString(1, itemName);
            statement.setDouble(2, priceSmall);
            statement.setDouble(3, priceMedium);
            statement.setDouble(4, priceLarge);
            statement.setDouble(5, priceIced);

            if (inputStream != null) {
                statement.setBlob(6, inputStream);
            } else {
                statement.setNull(6, java.sql.Types.BLOB);
            }

            if ("edit".equals(action)) {
                int id = Integer.parseInt(request.getParameter("item_id"));
                statement.setInt(7, id);
            }

            int row = statement.executeUpdate();
            if (row > 0) {
                response.getWriter().println("Item saved successfully!");
            }
            con.close();
        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("Error: " + e.getMessage());
        }
    }

    private void deleteItem(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String idString = request.getParameter("id");
        if (idString != null && !idString.isEmpty()) {
            int id = Integer.parseInt(idString);

            try {
                Class.forName("com.mysql.jdbc.Driver");
                Connection con = DriverManager.getConnection(dbURL, dbUser, dbPass);

                String sql = "DELETE FROM menu WHERE ID=?";
                PreparedStatement statement = con.prepareStatement(sql);
                statement.setInt(1, id);

                int row = statement.executeUpdate();
                if (row > 0) {
                    response.getWriter().println("Item deleted successfully!");
                }
                con.close();
            } catch (Exception e) {
                e.printStackTrace();
                response.getWriter().println("Error: " + e.getMessage());
            }
        } else {
            System.out.println(idString);
            response.getWriter().println("Error: ID parameter is empty or null");
        }
    }
}
