<%@ page import="java.sql.*, java.util.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Total Sales</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f9f9f9;
            color: #333;
            padding: 20px;
        }
        h1 {
            color: #444;
            text-align: center;
        }
        .salesTable {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
            box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
        }
        .salesTable, .salesTable th, .salesTable td {
            border: 1px solid #ddd;
        }
        .salesTable th, .salesTable td {
            padding: 12px;
            text-align: left;
            background-color: #fff;
        }
        .salesTable th {
            background-color: #f4f4f4;
            font-weight: bold;
        }
        .salesTable tr:hover {
            background-color: #f1f1f1;
        }
        form {
            text-align: center;
            margin-bottom: 20px;
        }
        label {
            font-weight: bold;
            margin-right: 10px;
        }
        input[type="date"] {
            padding: 8px;
            border: 1px solid #ccc;
            border-radius: 4px;
            margin-right: 10px;
        }
        input[type="submit"] {
            padding: 8px 16px;
            background-color: #5cb85c;
            border: none;
            border-radius: 4px;
            color: #fff;
            cursor: pointer;
            font-weight: bold;
        }
        input[type="submit"]:hover {
            background-color: #4cae4c;
        }
    </style>
</head>
<body>
    <%
        double totalSales = 0.0;
        Map<String, Map<String, Map<String, double[]>>> salesData = new HashMap<>();
        String selectedDate = request.getParameter("salesDate");

        try {
            Class.forName("com.mysql.jdbc.Driver");
            String url = "jdbc:mysql://localhost:3306/coffeeweb";
            String username = "root";  // Replace with your MySQL username
            String password = "";  // Replace with your MySQL password
            Connection con = DriverManager.getConnection(url, username, password);
            System.out.println("Sales Data Retrieved");

            // Prepare the SQL query, with or without the date filter
            String query = 
                "SELECT Item_Name, Size, Type, SUM(Item_Quantity) as total_quantity, SUM(Price) as total_price " +
                "FROM (" +
                "    SELECT Item_Name, Size, Type, Item_Quantity, Price FROM orderlist WHERE Done = TRUE " +
                (selectedDate != null && !selectedDate.isEmpty() ? "AND DATE(Order_Date) = ? " : "") +
                "    UNION ALL " +
                "    SELECT Item_Name, Size, Type, Item_Quantity, Price FROM orderlist_online WHERE Done = TRUE " +
                (selectedDate != null && !selectedDate.isEmpty() ? "AND DATE(Order_Date) = ?" : "") +
                ") AS combined_orders " +
                "GROUP BY Item_Name, Size, Type";

            PreparedStatement ps = con.prepareStatement(query);

            // If a date is selected, set the date parameters
            if (selectedDate != null && !selectedDate.isEmpty()) {
                ps.setString(1, selectedDate);
                ps.setString(2, selectedDate);
            }

            ResultSet rs = ps.executeQuery();

            // Process the result set
            while (rs.next()) {
                String itemName = rs.getString("Item_Name");
                String size = rs.getString("Size");
                String type = rs.getString("Type");
                int quantity = rs.getInt("total_quantity");
                double price = rs.getDouble("total_price");

                salesData.putIfAbsent(itemName, new HashMap<>());
                salesData.get(itemName).putIfAbsent(size, new HashMap<>());
                salesData.get(itemName).get(size).putIfAbsent(type, new double[2]);

                salesData.get(itemName).get(size).get(type)[0] += quantity;
                salesData.get(itemName).get(size).get(type)[1] += price;
                totalSales += price; // Ensure price is added to totalSales

                // Debug output
                System.out.println("Item Name: " + itemName + ", Size: " + size + ", Type: " + type + ", Price: " + price);
            }

            // Close connections
            if (rs != null) rs.close();
            if (ps != null) ps.close();
            if (con != null) con.close();
        } catch (Exception e) {
            System.out.println("Database Not Connected");
            System.out.println(e.getMessage());
        }

        System.out.println("Total Sales: " + totalSales); // Debug output
    %>
    
    <h1>Total Sales (PHP): <%= totalSales %></h1>
    
    <form method="get">
        <label for="salesDate">Select Date:</label>
        <input type="date" id="salesDate" name="salesDate" value="<%= selectedDate != null ? selectedDate : "" %>">
        <input type="submit" value="View Sales">
    </form>

    <table id="salesTable" class="salesTable">
        <thead>
            <tr>
                <th>Item Quantity</th>
                <th>Size</th>
                <th>Type</th>
                <th>Item Name</th>
                <th>Price</th>
            </tr>
        </thead>
        <tbody>
        <%
            // Ensure all types are present for each item and size
            String[] types = {"Hot", "Iced"};

            for (Map.Entry<String, Map<String, Map<String, double[]>>> itemEntry : salesData.entrySet()) {
                String itemName = itemEntry.getKey();
                String[] sizes;

                if (itemName.equals("Espresso")) {
                    sizes = new String[]{"1 shot", "2 shots"};
                } else {
                    sizes = new String[]{"Small", "Medium", "Large"};
                }

                for (String size : sizes) {
                    for (String type : types) {
                        double[] data = itemEntry.getValue().getOrDefault(size, new HashMap<>()).getOrDefault(type, new double[]{0, 0});
        %>
                        <tr>
                            <td><%= data[0] %></td>
                            <td><%= size %></td>
                            <td><%= type %></td>
                            <td><%= itemName %></td>
                            <td><%= data[1] %></td>
                        </tr>
        <%
                    }
                }
            }
        %>
        </tbody>
    </table>
</body>
</html>
