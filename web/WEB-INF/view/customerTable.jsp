<%-- 
    Document   : customerTable
    Created on : Jun 10, 2024, 10:41:56 AM
    Author     : talai
--%>

<%@ page import="java.sql.*, java.util.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Customer List</title>
    <style>
        .customerTable {
            width: 100%;
            border-collapse: collapse;
        }
        .customerTable, .customerTable th, .customerTable td {
            border: 1px solid black;
        }
        .customerTable th, .customerTable td {
            padding: 8px;
            text-align: left;
            background-color: #f4f4f4;
        }
        .customerTable th {
            background-color: #f2f2f2;
        }
    </style>
</head>
<body>
    <h1>Customer List</h1>
    <table class="customerTable">
        <thead>
            <tr>
                <th>Full Name</th>
                <th>Username</th>
                <th>Email</th>
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
                System.out.println("Database Connected");

                PreparedStatement ps = con.prepareStatement(
                    "SELECT fullname, username, email FROM register WHERE category = 'customer'"
                );
                ResultSet rs = ps.executeQuery();

                while (rs.next()) {
                    String fullName = rs.getString("fullname");
                    String userName = rs.getString("username");
                    String email = rs.getString("email");
        %>
                    <tr>
                        <td><%= fullName %></td>
                        <td><%= userName %></td>
                        <td><%= email %></td>
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
</body>
</html>

