<%-- 
    Document   : enter-token
    Created on : Jun 7, 2024, 10:24:56 AM
    Author     : talai
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Enter Token - CUP'A BLISS</title>
    <style>
    html, body {
        height: 100%;
        margin: 0;
        padding: 0;
        font-family: sans-serif;
        background: url('https://i.pinimg.com/originals/09/67/39/09673964915d81d838cadcfba7b52429.jpg') no-repeat center center fixed;
        background-size: cover;
        display: flex;
        justify-content: center;
        align-items: center;
    }

    .login-box {
        width: 400px;
        padding: 40px;
        background: rgba(0, 0, 0, 0.5);
        border: 1px solid #ff4655;
        box-shadow: 0 15px 25px rgba(0, 0, 0, 0.6);
        border-radius: 10px;
        text-align: center;
        color: #fff;
    }

    .login-box h1 {
        margin: 0 0 30px;
    }

    .login-box form {
        display: flex;
        flex-direction: column;
    }

    .login-box label {
        margin-bottom: 10px;
        color: #ff4655;
        font-weight: bold;
    }

    .login-box input {
        width: 100%;
        padding: 10px;
        margin-bottom: 20px;
        border: 1px solid #ff4655;
        border-radius: 5px;
        background: transparent;
        color: #fff;
        font-size: 16px;
    }

    .login-box button {
        width: 100%;
        padding: 10px;
        border: none;
        border-radius: 5px;
        background: #ff4655;
        color: #fff;
        font-size: 16px;
        font-weight: bold;
        text-transform: uppercase;
        cursor: pointer;
        transition: background 0.3s;
    }

    .login-box button:hover {
        background: #e03a4e;
    }

    .login-box p {
        margin: 0;
        padding: 10px 0;
        color: red;
    }
    </style>
</head>
<body>
    <div class="login-box">
        <h1>Enter Token</h1>
        <%
            HttpSession S = request.getSession();
            String email = (String) S.getAttribute("Email");
        %>
        <form action="validate-token" method="post">
            <label for="email">Email:</label>
            <input type="email" id="email" name="email" required readonly value="<%= email %>" style= "text-align: center;">
            <label for="token">Token:</label>
            <input type="text" id="token" name="token" required style= "text-align: center;">
            <button type="submit">Validate Token</button>
        </form>
            <%
            String message = (String) request.getAttribute("messageToken");
                if (message != null) {
            %>
                <p><%= message %></p>
            <%
                }
            %>
    </div>
<script>
    document.oncontextmenu = () => {
        alert("Don't try right-clicking!");
        return false;
    }

    document.onkeydown = e => {
        if (e.key == "F12" || (e.ctrlKey && (e.key === "u" || e.key === "c" || e.key === "v"))) {
            alert("Don't try to inspect or copy page elements");
            return false;
        }
    }
</script>
</body>
</html>
