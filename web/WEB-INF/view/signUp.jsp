<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Sign Up Form</title>
    <!-- Bootstrap CSS -->
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css">
    <!-- jQuery and Bootstrap JS -->
    <script src="https://code.jquery.com/jquery-3.3.1.slim.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.7/umd/popper.min.js"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/js/bootstrap.min.js"></script>
    
    <link href='https://fonts.googleapis.com/css?family=Nunito:400,300' rel='stylesheet' type='text/css'>
    <style>
        *, *:before, *:after {
            box-sizing: border-box;
        }

        body {
            font-family: 'Nunito', sans-serif;
            color: #384047;
            background-image: url('https://i.pinimg.com/originals/09/67/39/09673964915d81d838cadcfba7b52429.jpg');
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 100vh;
            margin: 0;
            padding: 20px;
        }

        form {
            max-width: 480px;
            width: 100%;
            padding: 10px 20px;
            background: #f4f7f8;
            border-radius: 8px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
        }

        h1 {
            margin: 0 0 30px 0;
            text-align: center;
        }

        input[type="text"],
        input[type="password"],
        input[type="email"] {
            background: rgba(255,255,255,0.1);
            border: none;
            font-size: 16px;
            height: auto;
            margin: 0;
            outline: 0;
            padding: 15px;
            width: 100%;
            background-color: #e8eeef;
            color: #8a97a0;
            box-shadow: 0 1px 0 rgba(0,0,0,0.03) inset;
            margin-bottom: 30px;
        }

        input[type="submit"] {
            padding: 19px 39px 18px 39px;
            color: #FFF;
            background-color: #4bc970;
            font-size: 18px;
            text-align: center;
            font-style: normal;
            border-radius: 5px;
            width: 100%;
            border: 1px solid #3ac162;
            border-width: 1px 1px 3px;
            box-shadow: 0 -1px 0 rgba(255,255,255,0.1) inset;
            margin-bottom: 10px;
        }

        fieldset {
            margin-bottom: 30px;
            border: none;
        }

        legend {
            font-size: 1.4em;
            margin-bottom: 10px;
        }

        label {
            display: block;
            margin-bottom: 8px;
        }

        .number {
            background-color: #5fcf80;
            color: #fff;
            height: 30px;
            width: 30px;
            display: inline-block;
            font-size: 0.8em;
            margin-right: 4px;
            line-height: 30px;
            text-align: center;
            text-shadow: 0 1px 0 rgba(255,255,255,0.2);
            border-radius: 100%;
        }

        .radio-group {
            display: flex;
            justify-content: center;
            gap: 10px;
            margin-bottom: 30px;
        }

        .radio-group label {
            display: flex;
            align-items: center;
        }
    </style>
    <script>
        document.oncontextmenu = () => {
            alert("Don't try right-clicking!");
            return false;
        }

        document.onkeydown = e => {
            if (e.key == "F12") {
                alert("Don't try to inspect element");
                return false;
            }
            if (e.ctrlKey && e.key == "u") {
                alert("Don't try to view page sources");
                return false;
            }
            if (e.ctrlKey && e.key == "c") {
                alert("Don't try to copy page element");
                return false;
            }
            if (e.ctrlKey && e.key == "v") {
                alert("Don't try to paste anything to the page");
                return false;
            }
        }

        function showAlert(message) {
            if (message) {
                alert(message);
                window.close();
            }
        }
    </script>
</head>
<body>
    <form action="/register" method="post">
        <h1> Sign Up </h1>
        <fieldset>
            <label for="fName">Full Name:</label>
            <input type="text" id="fName" name="fName" placeholder="Enter Full Name" value="<%= request.getAttribute("fName") != null ? request.getAttribute("fName") : "" %>" required>
            <label for="uName">Username:</label>
            <input type="text" id="uName" name="uName" placeholder="Enter Username" value="<%= request.getAttribute("uName") != null ? request.getAttribute("uName") : "" %>" required>
            <label for="email">Email:</label>
            <input type="email" id="email" name="email" placeholder="Enter Email" value="<%= request.getAttribute("email") != null ? request.getAttribute("email") : "" %>" required>
            <label for="password">Password:</label>
            <input type="password" id="password" name="password" placeholder="Enter Minimum of 8 Characters" required>
            <label for="cPassword">Confirm Password:</label>
            <input type="password" id="cPassword" name="cPassword" placeholder="Enter Minimum of 8 Characters" required>
            <center><span style="color:red;"><%= request.getAttribute("error") != null ? request.getAttribute("error") : "" %></span></center>
            
            <div class="radio-group">
                <label for="categoryEmployee">
                    <input type="radio" id="categoryEmployee" name="category" value="employee" checked> Employee
                </label>
                <label for="categoryCashier">
                    <input type="radio" id="categoryCashier" name="category" value="cashier"> Cashier
                </label>
                <label for="categoryAdmin">
                    <input type="radio" id="categoryAdmin" name="category" value="admin"> Admin
                </label>
            </div>
        </fieldset>
        <input type="submit" value="REGISTER">
    </form>
</body>
</html>
