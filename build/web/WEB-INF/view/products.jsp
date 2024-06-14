<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.DriverManager" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="java.util.Base64" %>
<%@ page import="javax.servlet.http.HttpSession" %>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Products</title>
        <style>
            body, html {
                margin: 0;
                padding: 0;
                height: 100%;
                width: 100%;
                font-family: Arial, sans-serif;
                box-sizing: border-box;
                overflow: auto;
            }
            .product {
                width: 100%;
                max-width: 1200px;
                margin: auto;
            }
            .productTable {
                width: 100%;
                border-collapse: collapse;
                background-color: white;
                box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
                overflow-x: auto;
            }
            .productTable th, .productTable td {
                padding: 10px;
                border: 1px solid #ddd;
                text-align: left;
            }
            .productTable th {
                background-color: #f4f4f4;
            }
            .productTable img {
                max-width: 100px;
                height: auto;
            }
            .button {
                padding: 10px 15px;
                background-color: #007BFF;
                color: white;
                border: none;
                cursor: pointer;
                text-decoration: none;
                display: inline-block;
                margin-bottom: 10px;
            }
            .button.edit {
                background-color: #28a745;
            }
            .button.delete {
                background-color: #dc3545;
            }
        </style>
    </head>
    <body>
        <div class="product">
            <a href="/admin/createmenu?action=add" class="button">Add New Product</a>
            <table id="productTable" class="productTable">
                <thead>
                    <tr>
                        <th>Item Price</th>
                        <th>Item Image</th>
                        <th>Item Name</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                <%
                    try {
                        Class.forName("com.mysql.jdbc.Driver");
                        String url = "jdbc:mysql://localhost:3306/coffeeweb";
                        String username = "root";  // Replace with your MySQL username
                        String password = "";  // Replace with your MySQL password
                        Connection con = DriverManager.getConnection(url, username, password);
                        System.out.println("Menu Displayed");

                        PreparedStatement ps = con.prepareStatement("SELECT * FROM menu");
                        ResultSet rs = ps.executeQuery();
                        while (rs.next()) {
                            int id = rs.getInt("ID");
                            String name = rs.getString("item_name");
                            Double price_small = rs.getDouble("price_small");
                            Double price_medium = rs.getDouble("price_medium");
                            Double price_large = rs.getDouble("price_large");
                            Double price_iced = rs.getDouble("price_iced");
                            byte[] imageData = rs.getBytes("item_image");
                            String image = Base64.getEncoder().encodeToString(imageData);
                %>
                    <tr data-item-number="<%= id %>" data-item-name="<%= name %>" data-item-price-small="<%= price_small %>" data-item-price-medium="<%= price_medium %>" data-item-price-large="<%= price_large %>" data-item-price-iced="<%= price_iced %>">
                        <td style="padding-left: 10px;">
                            <%
                            if ("Espresso".equals(name)) {
                            %>
                            1 shot = <%= price_small %><br>
                            2 shots = <%= price_medium %>
                            <%
                            } else {
                            %>
                            Small = <%= price_small %><br>
                            Medium = <%= price_medium %><br>
                            Large = <%= price_large %>
                            <%
                            }
                            %>
                        </td>
                        <td>
                            <img src="data:image/png;base64,<%= image %>" alt="Item Image" />
                        </td>
                        <td>
                            <%= name %>
                        </td>
                        <td>
                            <a href="/admin/createmenu?action=edit&id=<%= id %>" class="button edit">Edit</a>
                            <button onclick="deleteItem(<%= id %>)" class="button delete-button delete">Delete</button>
                            <form id="deleteForm_<%= id %>" action="/submit_item" method="post" style="display: none;">
                                <input type="hidden" name="action" value="delete">
                                <input type="hidden" name="id" id="deleteId_<%= id %>" value="">
                            </form>
                        </td>
                    </tr>
                <%
                        }
                        if (rs != null) rs.close();
                        if (ps != null) ps.close();
                        if (con != null) con.close();
                    } catch (Exception e) {
                        System.out.println("Database Not Connected");
                        System.out.println(e.getMessage());
                    }
                %>
                </tbody>
            </table>
        </div>
        <script>
            function deleteItem(id) {
                if (confirm("Are you sure you want to delete this item?")) {
                    document.getElementById('deleteId_' + id).value = id;
                    document.getElementById('deleteForm_' + id).submit();
                }
            }
        </script>
    </body>
</html>
