<%-- 
    Document   : employee
    Created on : May 18, 2024, 3:15:15 PM
    Author     : talai
--%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.List"%>
<%@page import="java.util.Map"%>
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
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Employee Page</title>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.3/css/all.min.css"> <!-- Font Awesome for icons -->
<style>
    html, body {
        height: 100%;
        width: 100%;
        margin: 0;
        padding: 0;
    }

    body {
        background: url("https://i.pinimg.com/originals/09/67/39/09673964915d81d838cadcfba7b52429.jpg");
        background-size: cover;
        background-position: center, no-repeat;
        font-family: Arial, sans-serif;
        font-weight: bold;
        background-color: #f5f5f5;
        display: flex;
        justify-content: center;
        align-items: center;
        margin: 10px;
        overflow: hidden;
    }

    .container {
        width: 90vw; /* Adjusted to 90vw */
        max-height: 90vh; /* Adjusted to 90vh */
        margin: 20px auto;
        padding: 20px;
        background-color: beige;
        border-radius: 10px;
        box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
        overflow-y: auto; /* Ensure the container scrolls if content overflows */
    }

    .header {
        display: flex;
        justify-content: space-between;
        align-items: center;
        margin-bottom: 20px;
    }
    .logout-btn {
        background-color: black;
        color: #fff;
        border: none;
        padding: 10px 20px;
        border-radius: 5px;
        cursor: pointer;
        font-size: 16px;
        transition: background-color 0.3s;
    }
    .logout-btn:hover {
        background-color: #ff004f;
    }
    .title {
        font-size: 24px;
        color: #333;
    }
    .columns {
        display: grid;
        grid-template-columns: repeat(2, 1fr);
        grid-gap: 20px;
        background-color: transparent;
        padding: 10px;
        border-radius: 10px;
    }
    .column {
        background-color: skyblue; /* Changed column background color to skyblue */
        border: 1px solid #ff004f;
        border-radius: 10px;
        padding: 20px;
        max-height: 600px; /* Adjusted max-height */
        overflow-y: auto; /* Ensure columns scroll if content overflows */
        transition: box-shadow 0.3s;
    }
    .column:hover {
        box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
    }
    .order-icon {
        font-size: 40px;
        color: #ff004f;
        margin-bottom: 10px;
    }
    .productTable {
        width:100%;
        border-collapse: collapse;
    }
    .productTable th, .productTable td {
        border: 1px solid #ddd;
        padding: 8px;
    }

    .productContainer{
        background-color: white;
        box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
        border-radius: 5px;
        padding: 10px;
        margin: 5px;
    }

</style>
</head>
<body>
    <%  
        String fullname = (String) session.getAttribute("fullname");
        String category = (String) session.getAttribute("category");
        
        response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
        response.setHeader("Pragma", "no-cache");
        response.setHeader("Expires", "0");
        
        if (fullname == null || !"employee".equals(category)) {
            response.sendRedirect("/main");
            return;
        }
        HttpSession S = request.getSession(false);
        String orderMessage = null;
        if (session != null) {
            orderMessage = (String) S.getAttribute("orderMessage");
            if (orderMessage != null) {
    %>
                <script>
                    alert("<%= orderMessage %>");
                </script>
    <% 
                session.removeAttribute("orderMessage");
            }
        }
    %>
    <div class="container">
        <div class="header">
            <div class="title">Employee: <%= fullname %></div>
            <button class="logout-btn" id="logOutBtn"><i class="fas fa-sign-out-alt"></i> Logout</button>
        </div>
        <div class="columns">
            <div class="column">
                <h2><i class="fas fa-mug-hot order-icon"></i> Dine-in </h2>
                <div id="orders">
                    <%
                        try {
                            Class.forName("com.mysql.jdbc.Driver");
                            String url = "jdbc:mysql://localhost:3306/coffeeweb";
                            String username = "root";  // Replace with your MySQL username
                            String password = "";  // Replace with your MySQL password
                            Connection con = DriverManager.getConnection(url, username, password);
                            System.out.println("Order List Displayed");

                            // Modify the SQL query to include the 'done' filter and order by 'order_date'
                            PreparedStatement ps = con.prepareStatement(
                                "SELECT * FROM orderlist WHERE Platform = 'On-site' AND OrderType = 'Dine-in' AND Done = FALSE ORDER BY STR_TO_DATE(Order_Date, '%Y/%m/%d %H:%i:%s') ASC");
                            ResultSet rs = ps.executeQuery();

                            Map<String, List<Map<String, Object>>> groupedOrders = new HashMap<>();

                            while (rs.next()) {
                                String customer = rs.getString("customer");
                                String orderDate = rs.getString("order_date");
                                String key = customer + "_" + orderDate;

                                Map<String, Object> order = new HashMap<>();
                                order.put("item_quantity", rs.getInt("item_quantity"));
                                order.put("size", rs.getString("size"));
                                order.put("type", rs.getString("type"));
                                order.put("item_name", rs.getString("item_name"));

                                if (!groupedOrders.containsKey(key)) {
                                    groupedOrders.put(key, new ArrayList<>());
                                }
                                groupedOrders.get(key).add(order);
                            }

                            // Retrieve the employee name from the session
                            String employeeName = (String) session.getAttribute("fullname");

                            for (Map.Entry<String, List<Map<String, Object>>> entry : groupedOrders.entrySet()) {
                                String[] keyParts = entry.getKey().split("_");
                                String customer = keyParts[0];
                                String orderDate = keyParts[1];
                    %>
                        <div class="productContainer">
                            <h3>Customer: <%= customer %> </h3>
                            <h3>Order Date: <%= orderDate %></h3>
                            <table class="productTable">
                                <thead>
                                    <tr>
                                        <th>Item Quantity</th>
                                        <th>Size</th>
                                        <th>Type</th>
                                        <th>Item Name</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <%
                                        for (Map<String, Object> order : entry.getValue()) {
                                    %>
                                    <tr>
                                        <td><%= order.get("item_quantity") %></td>
                                        <td><%= order.get("size") %></td>
                                        <td><%= order.get("type") %></td>
                                        <td><%= order.get("item_name") %></td>
                                    </tr>
                                    <%
                                        }
                                    %>
                                </tbody>
                            </table>
                            <form class="orderDoneForm" action="orderdoneonsite" method="post">
                                <input type="hidden" name="customer" value="<%= customer %>">
                                <input type="hidden" name="order_date" value="<%= orderDate %>">
                                <input type="hidden" name="orderType" value="Dine-in">
                                <input type="hidden" name="platform" value="On-site">
                                <input type="hidden" name="employeeName" value="<%= employeeName %>">
                                <button type="submit">Order Done</button>
                            </form>
                        </div>
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
                </div>
            </div>
            <!--FOR THE TAKE-OUT GORA -->
            <div class="column">
                <h2><i class="fas fa-shopping-bag order-icon"></i> Take-out </h2>
                <!-- Place Take-out order content here -->
                <div id="orders">
                    <%
                        try {
                            Class.forName("com.mysql.jdbc.Driver");
                            String url = "jdbc:mysql://localhost:3306/coffeeweb";
                            String username = "root";  // Replace with your MySQL username
                            String password = "";  // Replace with your MySQL password
                            Connection con = DriverManager.getConnection(url, username, password);
                            System.out.println("Order List Displayed");

                            // Modify the SQL query to include the 'done' filter and order by 'order_date'
                            PreparedStatement ps = con.prepareStatement(
                                "SELECT * FROM orderlist WHERE Platform = 'On-site' AND OrderType = 'Take-out' AND Done = FALSE ORDER BY STR_TO_DATE(Order_Date, '%Y/%m/%d %H:%i:%s') ASC");
                            ResultSet rs = ps.executeQuery();

                            Map<String, List<Map<String, Object>>> groupedOrders = new HashMap<>();

                            while (rs.next()) {
                                String customer = rs.getString("customer");
                                String orderDate = rs.getString("order_date");
                                String key = customer + "_" + orderDate;

                                Map<String, Object> order = new HashMap<>();
                                order.put("item_quantity", rs.getInt("item_quantity"));
                                order.put("size", rs.getString("size"));
                                order.put("type", rs.getString("type"));
                                order.put("item_name", rs.getString("item_name"));

                                if (!groupedOrders.containsKey(key)) {
                                    groupedOrders.put(key, new ArrayList<>());
                                }
                                groupedOrders.get(key).add(order);
                            }

                            // Retrieve the employee name from the session
                            String employeeName = (String) session.getAttribute("fullname");

                            for (Map.Entry<String, List<Map<String, Object>>> entry : groupedOrders.entrySet()) {
                                String[] keyParts = entry.getKey().split("_");
                                String customer = keyParts[0];
                                String orderDate = keyParts[1];
                    %>
                        <div class="productContainer">
                            <h3>Customer: <%= customer %> </h3>
                            <h3>Order Date: <%= orderDate %></h3>
                            <table class="productTable">
                                <thead>
                                    <tr>
                                        <th>Item Quantity</th>
                                        <th>Size</th>
                                        <th>Type</th>
                                        <th>Item Name</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <%
                                        for (Map<String, Object> order : entry.getValue()) {
                                    %>
                                    <tr>
                                        <td><%= order.get("item_quantity") %></td>
                                        <td><%= order.get("size") %></td>
                                        <td><%= order.get("type") %></td>
                                        <td><%= order.get("item_name") %></td>
                                    </tr>
                                    <%
                                        }
                                    %>
                                </tbody>
                            </table>
                            <form class="orderDoneForm" action="orderdoneonsite" method="post">
                                <input type="hidden" name="customer" value="<%= customer %>">
                                <input type="hidden" name="order_date" value="<%= orderDate %>">
                                <input type="hidden" name="orderType" value="Take-out">
                                <input type="hidden" name="platform" value="On-site">
                                <input type="hidden" name="employeeName" value="<%= employeeName %>">
                                <button type="submit">Order Done</button>
                            </form>
                        </div>
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
                </div>
            </div>
            <!-- FORDA PICK UP -->
            <div class="column">
                <h2><i class="fas fa-hand-holding order-icon"></i> Pick-up </h2>
                <!-- Place Pick-up order content here -->
                <div id="orders">
                    <%
                        try {
                            Class.forName("com.mysql.jdbc.Driver");
                            String url = "jdbc:mysql://localhost:3306/coffeeweb";
                            String username = "root";  // Replace with your MySQL username
                            String password = "";  // Replace with your MySQL password
                            Connection con = DriverManager.getConnection(url, username, password);
                            System.out.println("Order List Displayed");

                            // Modify the SQL query to include the 'done' filter, order by 'order_date', and retrieve 'pick_up_time'
                            PreparedStatement ps = con.prepareStatement(
                                "SELECT * FROM orderlist_online WHERE Platform = 'Online' AND OrderType = 'Pick-up' AND Done = FALSE ORDER BY STR_TO_DATE(Order_Date, '%Y/%m/%d %H:%i:%s') ASC");
                            ResultSet rs = ps.executeQuery();

                            Map<String, List<Map<String, Object>>> groupedOrders = new HashMap<>();

                            while (rs.next()) {
                                String customer = rs.getString("customer");
                                String orderDate = rs.getString("order_date");
                                String pickUpTime = rs.getString("pick_up_time");
                                String key = customer + "_" + orderDate + "_" + pickUpTime;

                                Map<String, Object> order = new HashMap<>();
                                order.put("item_quantity", rs.getInt("item_quantity"));
                                order.put("size", rs.getString("size"));
                                order.put("type", rs.getString("type"));
                                order.put("item_name", rs.getString("item_name"));
                                order.put("pick_up_time", pickUpTime);

                                if (!groupedOrders.containsKey(key)) {
                                    groupedOrders.put(key, new ArrayList<>());
                                }
                                groupedOrders.get(key).add(order);
                            }

                            for (Map.Entry<String, List<Map<String, Object>>> entry : groupedOrders.entrySet()) {
                                String[] keyParts = entry.getKey().split("_");
                                String customer = keyParts[0];
                                String orderDate = keyParts[1];
                                String pickUpTime = keyParts[2];
                    %>
                        <div class="productContainer">
                            <h3>Customer: <%= customer %> </h3>
                            <h3>Order Date: <%= orderDate %></h3>
                            <h3>Pick-up Time: <%= pickUpTime %></h3>
                            <table class="productTable">
                                <thead>
                                    <tr>
                                        <th>Item Quantity</th>
                                        <th>Size</th>
                                        <th>Type</th>
                                        <th>Item Name</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <%
                                        for (Map<String, Object> order : entry.getValue()) {
                                    %>
                                    <tr>
                                        <td><%= order.get("item_quantity") %></td>
                                        <td><%= order.get("size") %></td>
                                        <td><%= order.get("type") %></td>
                                        <td><%= order.get("item_name") %></td>
                                    </tr>
                                    <%
                                        }
                                    %>
                                </tbody>
                            </table>
                            <form class="orderDoneForm" action="orderdoneonline" method="post">
                                <input type="hidden" name="customer" value="<%= customer %>">
                                <input type="hidden" name="order_date" value="<%= orderDate %>">
                                <input type="hidden" name="orderType" value="Pick-up">
                                <input type="hidden" name="platform" value="Online">
                                <input type="hidden" name="employeeName" value="<%= fullname %>"> 
                                <button type="submit">Order Done</button>
                            </form>
                        </div>
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
                </div>
            </div>
            <div class="column">
                <h2><i class="fas fa-truck order-icon"></i> Delivery </h2>
                <!-- Place Delivery order content here -->
                <div id="orders">
                <%
                    try {
                        Class.forName("com.mysql.jdbc.Driver");
                        String url = "jdbc:mysql://localhost:3306/coffeeweb";
                        String username = "root";  // Replace with your MySQL username
                        String password = "";  // Replace with your MySQL password
                        Connection con = DriverManager.getConnection(url, username, password);
                        System.out.println("Order List Displayed");

                        // Modify the SQL query to include the 'done' filter, order by 'order_date', and retrieve 'address'
                        PreparedStatement ps = con.prepareStatement(
                            "SELECT * FROM orderlist_online WHERE Platform = 'Online' AND OrderType = 'Delivery' AND Done = FALSE ORDER BY STR_TO_DATE(Order_Date, '%Y/%m/%d %H:%i:%s') ASC");
                        ResultSet rs = ps.executeQuery();

                        Map<String, List<Map<String, Object>>> groupedOrders = new HashMap<>();

                        while (rs.next()) {
                            String customer = rs.getString("customer");
                            String orderDate = rs.getString("order_date");
                            String address = rs.getString("address");
                            String key = customer + "_" + orderDate + "_" + address;

                            Map<String, Object> order = new HashMap<>();
                            order.put("item_quantity", rs.getInt("item_quantity"));
                            order.put("size", rs.getString("size"));
                            order.put("type", rs.getString("type"));
                            order.put("item_name", rs.getString("item_name"));
                            order.put("address", address);

                            if (!groupedOrders.containsKey(key)) {
                                groupedOrders.put(key, new ArrayList<>());
                            }
                            groupedOrders.get(key).add(order);
                        }

                        for (Map.Entry<String, List<Map<String, Object>>> entry : groupedOrders.entrySet()) {
                            String[] keyParts = entry.getKey().split("_");
                            String customer = keyParts[0];
                            String orderDate = keyParts[1];
                            String address = keyParts[2];
                %>
                    <div class="productContainer">
                        <h3>Customer: <%= customer %> </h3>
                        <h3>Order Date: <%= orderDate %></h3>
                        <h3>Address: <%= address %></h3>
                        <table class="productTable">
                            <thead>
                                <tr>
                                    <th>Item Quantity</th>
                                    <th>Size</th>
                                    <th>Type</th>
                                    <th>Item Name</th>
                                </tr>
                            </thead>
                            <tbody>
                                <%
                                    for (Map<String, Object> order : entry.getValue()) {
                                %>
                                <tr>
                                    <td><%= order.get("item_quantity") %></td>
                                    <td><%= order.get("size") %></td>
                                    <td><%= order.get("type") %></td>
                                    <td><%= order.get("item_name") %></td>
                                </tr>
                                <%
                                    }
                                %>
                            </tbody>
                        </table>
                        <form class="orderDoneForm" action="orderdoneonline" method="post">
                            <input type="hidden" name="customer" value="<%= customer %>">
                            <input type="hidden" name="order_date" value="<%= orderDate %>">
                            <input type="hidden" name="orderType" value="Delivery">
                            <input type="hidden" name="platform" value="Online">
                            <input type="hidden" name="address" value="<%= address %>">
                            <input type="hidden" name="employeeName" value="<%= fullname %>"> 
                            <button type="submit">Order Done</button>
                        </form>
                    </div>
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
            </div>
            </div>
        </div>
    </div>

    <script>
        function refreshPage() {
            setTimeout(function() {
                location.reload();
            }, 5000); // 5000 milliseconds = 5 seconds
        }

        document.getElementById('logOutBtn').addEventListener('click', function(event) {
            alert("Logged Out!");
            window.location.href = '<%= request.getContextPath() %>/logout';
        });
    </script>
</body>
</html>