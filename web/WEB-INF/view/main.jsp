<%-- 
    Document   : main
    Created on : Mar 21, 2024, 9:22:58 PM
    Author     : user
--%>
<%@ page import="javax.servlet.http.HttpSession" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>CUP'A BLISS</title>
	<!-- Bootstrap CSS -->
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css">
    <!-- jQuery and Bootstrap JS -->
    <script src="https://code.jquery.com/jquery-3.3.1.slim.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.7/umd/popper.min.js"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/js/bootstrap.min.js"></script>
      <style>
        :root {
            /* COLORS */
            --white: #e9e9e9;
            --gray: #333;
            --blue: #0367a6;
            --lightblue: #008997;

            /* RADII */
            --button-radius: 0.7rem;

            /* SIZES */
            --max-width: 758px;
            --max-height: 550px;

            font-size: 16px;
            font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Oxygen,
            Ubuntu, Cantarell, "Open Sans", "Helvetica Neue", sans-serif;
        }

        body {
            align-items: center;
            background-color: var(--white);
            background: url("https://i.pinimg.com/originals/09/67/39/09673964915d81d838cadcfba7b52429.jpg");
            background-attachment: fixed;
            background-position: center;
            background-repeat: no-repeat;
            background-size: cover;
            display: grid;
            height: 100vh;
            place-items: center;
        }

        .form__title {
            font-weight: 300;
            margin: 0;
            margin-bottom: 1.25rem;
        }

        .link {
            color: var(--gray);
            font-size: 0.9rem;
            margin: 1.5rem 0;
            text-decoration: none;
        }

        .container {
            background-color: var(--white);
            border-radius: var(--button-radius);
            box-shadow: 0 0.9rem 1.7rem rgba(0, 0, 0, 0.25),
            0 0.7rem 0.7rem rgba(0, 0, 0, 0.22);
            height: var(--max-height);
            max-width: var(--max-width);
            overflow: hidden;
            position: relative;
            width: 100%;
        }

        .container__form {
            height: 100%;
            position: absolute;
            top: 0;
            transition: all 0.6s ease-in-out;
        }

        .container--signin {
            left: 0;
            width: 50%;
            z-index: 2;
        }

        .container.right-panel-active .container--signin {
            transform: translateX(100%);
        }

        .container--signup {
            left: 0;
            opacity: 0;
            width: 50%;
            z-index: 1;
        }

        .container.right-panel-active .container--signup {
            animation: show 0.6s;
            opacity: 1;
            transform: translateX(100%);
            z-index: 5;
        }

        .container__overlay {
            height: 100%;
            left: 50%;
            overflow: hidden;
            position: absolute;
            top: 0;
            transition: transform 0.6s ease-in-out;
            width: 50%;
            z-index: 100;
        }

        .container.right-panel-active .container__overlay {
            transform: translateX(-100%);
        }

        .overlay {
            background-color: var(--lightblue);
            background: url("https://i.pinimg.com/originals/09/67/39/09673964915d81d838cadcfba7b52429.jpg");
            background-attachment: fixed;
            background-position: center;
            background-repeat: no-repeat;
            background-size: cover;
            height: 100%;
            left: -100%;
            position: relative;
            transform: translateX(0);
            transition: transform 0.6s ease-in-out;
            width: 200%;
        }

        .container.right-panel-active .overlay {
            transform: translateX(50%);
        }

        .overlay__panel {
            align-items: center;
            display: flex;
            flex-direction: column;
            height: 100%;
            justify-content: center;
            position: absolute;
            text-align: center;
            top: 0;
            transform: translateX(0);
            transition: transform 0.6s ease-in-out;
            width: 50%;
        }

        .overlay--left {
            transform: translateX(-20%);
        }

        .container.right-panel-active .overlay--left {
            transform: translateX(0);
        }

        .overlay--right {
            right: 0;
            transform: translateX(0);
        }

        .container.right-panel-active .overlay--right {
            transform: translateX(20%);
        }

        .btn {
            background-color: var(--blue);
            background-image: linear-gradient(90deg, var(--blue) 0%, var(--lightblue) 74%);
            border-radius: 20px;
            border: 1px solid var(--blue);
            color: var(--white);
            cursor: pointer;
            font-size: 0.8rem;
            font-weight: bold;
            letter-spacing: 0.1rem;
            padding: 0.9rem 4rem;
            text-transform: uppercase;
            transition: transform 80ms ease-in;
        }

        .form > .btn {
            margin-top: 1.5rem;
        }

        .btn:active {
            transform: scale(0.95);
        }

        .btn:focus {
            outline: none;
        }

        .form {
            background-color: var(--white);
            display: flex;
            align-items: center;
            justify-content: center;
            flex-direction: column;
            padding: 0 3rem;
            height: 100%;
            text-align: center;
        }

        .input {
            background-color: #fff;
            border: 1px solid #ccc;
            padding: 0.9rem;
            margin: 0.5rem 0;
            width: 100%;
            border-radius: 5px;
        }

        @keyframes show {
            0%,
            49.99% {
                opacity: 0;
                z-index: 1;
            }

            50%,
            100% {
                opacity: 1;
                z-index: 5;
            }
        }
    </style>
</head>
<body>
    <% 
        HttpSession S = request.getSession(false);
        String messageSuccess = null;
        if (session != null) {
            messageSuccess = (String) S.getAttribute("messageSuccess");
            if (messageSuccess != null) {
    %>
                <script>
                    alert("<%= messageSuccess %>");
                </script>
    <% 
                session.removeAttribute("messageSuccess");
            }
        }
    %>
    <div class="container right-panel-active">
        <!-- Sign Up -->
        <div class="container__form container--signup">
            <form class="form" id="form1" action="register" method="post">
                <h2 class="form__title">Sign Up</h2>
                <input type ="hidden" id ="category" name ="category" value ="customer">
                
                <input class = "input" type="text" id="fName" name="fName" placeholder="Full Name" value="<%= request.getAttribute("fName") != null ? request.getAttribute("fName") : "" %>" required>

                <input class = "input" type="text" id="uName" name="uName" placeholder="Username" value="<%= request.getAttribute("uName") != null ? request.getAttribute("uName") : "" %>" required>

                <input class = "input" type="email" id="email" name="email" placeholder="Email" value="<%= request.getAttribute("email") != null ? request.getAttribute("email") : "" %>" required>

                <input class = "input" type="password" id="password" name="password" placeholder="Password" required>

                <input class = "input" type="password" id="cPassword" name="cPassword" placeholder="Confirm Password" required>
      
                <span style = "color:red;">${error}</span>
                
                <input type = "submit" value = "REGISTER" class = "btn">
            </form>
        </div>

        <!-- Sign In -->
        <div class="container__form container--signin">
            <form class="form" id="form2" action="login" method="post">
                <h2 class="form__title">Sign In</h2>
                <input type="text" placeholder="Username" name="username" id="username" class="input" />
                <input type="password" placeholder="Password" name="loginPassword" id="loginPassword" class="input" />
                <span style="color:red;">${message}</span>
                <a href="/forgot-pass" class="link">Forgot your password?</a>
                <input type="submit" value="Sign In" class="btn">
            </form>
        </div>

        <!-- Overlay -->
        <div class="container__overlay">
            <div class="overlay">
                <div class="overlay__panel overlay--left">
                    <button class="btn" id="signIn">Sign In</button>
                </div>
                <div class="overlay__panel overlay--right">
                    <button class="btn" id="signUp">Sign Up</button>
                </div>
            </div>
        </div>
    </div>

    <script>
        const signInBtn = document.getElementById("signIn");
        const signUpBtn = document.getElementById("signUp");
        const container = document.querySelector(".container");
        const forgotPassword = document.getElementById("fPassword");

        signInBtn.addEventListener("click", () => {
            container.classList.remove("right-panel-active");
        });

        signUpBtn.addEventListener("click", () => {
            container.classList.add("right-panel-active");
        });

        document.oncontextmenu = () => {
            alert("Don't try right-clicking!");
            return false;
        }

        document.onkeydown = e => {
            if (e.key === "F12" || (e.ctrlKey && (e.key === "u" || e.key === "c" || e.key === "v"))) {
                alert("Don't try to inspect element");
                return false;
            }
        }
        
    </script>
</body>
</html>