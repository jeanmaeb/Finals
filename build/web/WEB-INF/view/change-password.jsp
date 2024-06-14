<%-- 
    Document   : change-password
    Created on : Jun 7, 2024, 11:02:48 AM
    Author     : talai
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Change Password</title>
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
            text-align: center;
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
            <h1>Change Password</h1>
            <form id="changePassForm" method="post" action="changepassword">
                <input type="hidden" name="email" value="${param.email}">
                <label for="newPassword">New Password:</label>
                <input type="password" id="newPassword" name="newPassword" required>
                <button type="submit" id="changePassBtn">Change Password</button>
            </form>
            <%
            String message = (String) request.getAttribute("messageChangePass");
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
                if (e.key === "F12" || (e.ctrlKey && (e.key === "u" || e.key === "c" || e.key === "v"))) {
                    alert("Don't try to inspect or copy page elements");
                    return false;
                }
            }

            const changePassBtn = document.getElementById('changePassBtn');
            const changePassForm = document.getElementById('changePassForm');

            changePassBtn.addEventListener('click', function(event) {
                const changePass = document.getElementById('newPassword').value;
                
                if (changePass === '') {
                    alert("Enter New Password!");
                    event.preventDefault();
                    return;
                }
                
                if (changePass.length < 8) {
                    alert("Password must be at least 8 characters long.");
                    event.preventDefault();
                }
            });
        </script>
    </body>
</html>
