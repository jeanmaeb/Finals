<%-- 
    Document   : CreateMenu
    Created on : Jun 10, 2024, 8:33:54 AM
    Author     : talai
--%>

<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.DriverManager" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="java.util.Base64" %>
<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Item Form</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f4f4f4;
            margin: 0;
            padding: 0;
            display: flex;
            justify-content: center;
            align-items: flex-start;
            min-height: 100vh;
            overflow: auto;
        }
        .form-container {
            background-color: #fff;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
            max-width: 600px;
            width: 100%;
            margin-top: 20px;
            margin-bottom: 20px;
        }
        .form-container h2 {
            margin-top: 0;
            color: #333;
            text-align: center;
        }
        .form-container label {
            display: block;
            margin-bottom: 8px;
            color: #333;
        }
        .form-container input[type="text"],
        .form-container input[type="file"],
        .form-container input[type="number"],
        .form-container input[type="submit"] {
            width: calc(100% - 20px);
            padding: 10px;
            margin-bottom: 20px;
            border: 1px solid #ddd;
            border-radius: 4px;
            font-size: 16px;
        }
        .form-container input[type="submit"] {
            background-color: #28a745;
            color: #fff;
            border: none;
            cursor: pointer;
        }
        .form-container input[type="submit"]:hover {
            background-color: #218838;
        }
        
        .image-preview {
            display: none;
            margin-bottom: 20px;
        }
        .image-preview img {
            max-width: 100%;
            border-radius: 4px;
        }
    </style>
</head>
<body>
    <%
        String action = request.getParameter("action");
        if ("edit".equals(action) && request.getParameter("id") != null) {
            try {
                Class.forName("com.mysql.jdbc.Driver");
                String url = "jdbc:mysql://localhost:3306/coffeeweb";
                String username = "root";  // Replace with your MySQL username
                String password = "";  // Replace with your MySQL password
                Connection con = DriverManager.getConnection(url, username, password);
                
                int id = Integer.parseInt(request.getParameter("id"));
                PreparedStatement ps = con.prepareStatement("SELECT * FROM menu WHERE ID = ?");
                ps.setInt(1, id);
                ResultSet rs = ps.executeQuery();
                
                if (rs.next()) {
                    request.setAttribute("item_name", rs.getString("item_name"));
                    request.setAttribute("price_small", rs.getDouble("price_small"));
                    request.setAttribute("price_medium", rs.getDouble("price_medium"));
                    request.setAttribute("price_large", rs.getDouble("price_large"));
                    request.setAttribute("price_iced", rs.getDouble("price_iced"));
                    byte[] imageData = rs.getBytes("item_image");
                    if (imageData != null) {
                        request.setAttribute("item_image", Base64.getEncoder().encodeToString(imageData));
                    }
                }
                
                if (rs != null) rs.close();
                if (ps != null) ps.close();
                if (con != null) con.close();
            } catch (Exception e) {
                System.out.println("Database Not Connected");
                System.out.println(e.getMessage());
            }
        }
    %>
    <div class="form-container">
        <h2>Item Information Form</h2>
        <form action="/submit_item" method="post" enctype="multipart/form-data">
            <input type="hidden" id="item_id" name="item_id" value="<%= request.getParameter("id") %>">

            <label for="item_name">Item Name:</label>
            <input type="text" id="item_name" name="item_name" required value="<%= "edit".equals(action) ? request.getAttribute("item_name") : "" %>">

            <label for="item_image">Item Image:</label>
            <input type="file" id="item_image" name="item_image" accept="image/*"required>
            
            <div class="image-preview" id="imagePreview" style="<%= "edit".equals(action) && request.getAttribute("item_image") != null ? "display: block;" : "" %>">
                <img id="previewImg" src="<%= "edit".equals(action) && request.getAttribute("item_image") != null ? "data:image/png;base64," + request.getAttribute("item_image") : "#" %>" alt="Image Preview">
            </div>

            <label for="price_small">Price (Small):</label>
            <input type="number" id="price_small" name="price_small" step="0.01" required value="<%= "edit".equals(action) ? request.getAttribute("price_small") : "" %>">

            <label for="price_medium">Price (Medium):</label>
            <input type="number" id="price_medium" name="price_medium" step="0.01" required value="<%= "edit".equals(action) ? request.getAttribute("price_medium") : "" %>">
            
            <label for="price_large">Price (Large):</label>
            <input type="number" id="price_large" name="price_large" step="0.01" required value="<%= "edit".equals(action) ? request.getAttribute("price_large") : "" %>">

            <label for="price_iced">Price (Iced):</label>
            <input type="number" id="price_iced" name="price_iced" step="0.01" required value="<%= "edit".equals(action) ? request.getAttribute("price_iced") : "" %>">

            <input type = "hidden" name = "action" value = "<%= action%>">
            <input type="submit" value="Submit">
        </form>
    </div>
    <script>
        document.getElementById('item_image').addEventListener('change', function(event) {
            const input = event.target;
            const preview = document.getElementById('imagePreview');
            const previewImg = document.getElementById('previewImg');

            if (input.files && input.files[0]) {
                const reader = new FileReader();
                
                reader.onload = function(e) {
                    previewImg.src = e.target.result;
                    preview.style.display = 'block';
                }
                
                reader.readAsDataURL(input.files[0]);
            } else {
                previewImg.src = '';
                preview.style.display = 'none';
            }
        });
    </script>
</body>
</html>
