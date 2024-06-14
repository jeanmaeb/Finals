<%-- 
    Document   : employeeList
    Created on : Jun 10, 2024, 12:40:25 PM
    Author     : talai
--%>

<%@ page import="java.sql.*, java.util.Base64" %>
<!DOCTYPE html>
<html>
<head>
    <title>User Management</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f8f9fa;
            margin: 0;
            padding: 20px;
        }
        h2 {
            color: #343a40;
        }
        .userTable {
            width: 100%;
            border-collapse: collapse;
            margin-bottom: 20px;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
        }
        .userTable, .userTable th, .userTable td {
            border: 1px solid #dee2e6;
        }
        .userTable th {
            background-color: #007BFF;
            color: white;
            padding: 15px;
        }
        .userTable td {
            padding: 15px;
            text-align: left;
            background-color: white;
        }
        .button {
            padding: 8px 12px;
            text-decoration: none;
            background-color: #007BFF;
            color: white;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            transition: background-color 0.3s;
        }
        .button:hover {
            background-color: #0056b3;
        }
        .delete-button {
            background-color: #DC3545;
        }
        .delete-button:hover {
            background-color: #c82333;
        }
        .container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 20px;
            background-color: white;
            border-radius: 10px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
        }
        .header {
            text-align: center;
            margin-bottom: 20px;
        }
        .header h1 {
            margin: 0;
            font-size: 2.5em;
            color: #343a40;
        }
        .category {
            margin-bottom: 40px;
        }
    </style>
    <script>
        function deleteUser(id) {
            if (confirm('Are you sure you want to delete this user?')) {
                document.getElementById('deleteId_' + id).value = id;
                document.getElementById('deleteForm_' + id).submit();
            }
        }
    </script>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1>User Management</h1>
        </div>

        <%
            try {
                Class.forName("com.mysql.jdbc.Driver");
                String url = "jdbc:mysql://localhost:3306/coffeeweb";
                String username = "root";  // Replace with your MySQL username
                String password = "";  // Replace with your MySQL password
                Connection con = DriverManager.getConnection(url, username, password);
                System.out.println("User Data Displayed");

                String[] categories = {"admin", "cashier", "employee"};
                for (String category : categories) {
        %>

        <div class="category">
            <h2><%= category.substring(0, 1).toUpperCase() + category.substring(1) %>s</h2>
            <table class="userTable">
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Full Name</th>
                        <th>Username</th>
                        <th>Email</th>
                        <th>Password</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                <%
                    PreparedStatement ps = con.prepareStatement("SELECT * FROM register WHERE category = ?");
                    ps.setString(1, category);
                    ResultSet rs = ps.executeQuery();
                    while (rs.next()) {
                        int id = rs.getInt("ID");
                        String fullname = rs.getString("fullname");
                        String uname = rs.getString("username");
                        String email = rs.getString("email");
                        String pwd = rs.getString("password");
                %>
                    <tr data-user-id="<%= id %>">
                        <td><%= id %></td>
                        <td><%= fullname %></td>
                        <td><%= uname %></td>
                        <td><%= email %></td>
                        <td><%= pwd %></td>
                        <td>
                            <button onclick="deleteUser(<%= id %>)" class="button delete-button">Delete</button>
                            <form id="deleteForm_<%= id %>" action="/submit_user" method="post" style="display: none;">
                                <input type="hidden" name="action" value="delete">
                                <input type="hidden" name="id" id="deleteId_<%= id %>" value="">
                            </form>
                        </td>
                    </tr>
                <%
                    }
                    if (rs != null) rs.close();
                    if (ps != null) ps.close();
                %>
                </tbody>
            </table>
        </div>

        <%
                }
                if (con != null) con.close();
            } catch (Exception e) {
                System.out.println("Database Not Connected");
                System.out.println(e.getMessage());
            }
        %>

    </div>
</body>
</html>
