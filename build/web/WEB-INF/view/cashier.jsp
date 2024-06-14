<%-- 
    Document   : customer
    Created on : May 29, 2024, 3:03:39 PM
    Author     : talai
--%>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.DriverManager" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="java.util.Base64" %>
<%@ page import="javax.servlet.http.HttpSession" %>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link href = "https://fonts.googleapis.com/css?family=Oswald|Roboto:100" rel = "stylesheet">
    <title>Product Order</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 0;
            background: url("https://i.pinimg.com/originals/09/67/39/09673964915d81d838cadcfba7b52429.jpg");
            background-repeat: no-repeat; 
            background-size: cover;
            min-height: 100vh;
            
        }

        .container {
            width: 60%;
            padding: 10px;
            position: fixed;
            
        }

        .summary {
            background: url("https://images.pexels.com/photos/129731/pexels-photo-129731.jpeg?cs=srgb&dl=pexels-fwstudio-33348-129731.jpg&fm=jpg");
            padding: 20px;
            border-left: 2px solid black;
            background-color: #fff;
            display: flex;
            flex-direction: column;
            justify-content: space-between;
            height: 100%;
            position: fixed;
            bottom: 0;
            right: 0;
            width: 40%;
            box-shadow: 0px -5px 15px rgba(0, 0, 0, 0.1); /* Add shadow for better visibility */
        }
        
        .summary input{
            font-size: 16px;
        }
        
        .amount-summary-container {
            margin-top: auto;
            padding-bottom: 20px;
        }
        
        .amount-summary td{
           width: 50%;
        }
        
        .form-container {
            height: 30%;
            position: fixed;
            display: flex;
            justify-content: space-between;
            align-items: center;
            /* optional for spacing around the container */
        }

        .form-container label {
            margin: 0 10px 0 0; /* spacing between label and input */
        }
        .input-group {
            display: flex;
            align-items: center;
            gap: 10px; /* Space between label and input */
        }
        .cashier-container {
            display: flex;
            align-items: center;
        }
        
        header{
            padding: 10px;
            display: flex;
        }
        
        table {
            width: 100%;
            border-collapse: collapse;
            background-color: #f4f4f4;
        }
        
        .productTable{
            width: 94%;
            max-height: 40%;
            overflow-y: scroll; 
            background-color: #F5F5DC; 
        }
        
        .productSign{
            background: url("https://img.freepik.com/free-photo/beige-wooden-textured-flooring-background_53876-129605.jpg?size=626&ext=jpg&ga=GA1.1.1518270500.1717372800&semt=ais_user");
             
            border: 1px solid black; 
            background-color: #F5F5DC; 
            padding: 10px; 
            width: 54%; 
            text-align: center; 
            border-radius: 50px;
        }
        
        .product {
            position: fixed;
            width: 60%;
            height: 80%;
            overflow-y: scroll;
        }
        
        .products:hover{
            border: 1px solid black;
            background-color: antiquewhite;
        }
        
        th, td {
            padding: 12px;
            border: 1px solid #ddd;
            text-align: center;
        }

        th {
            background-color: #f2f2f2;
        }

        .modal {
            display: none;
            position: fixed;
            z-index: 1;
            left: 0;
            top: 0;
            width: 100%;
            height: 100%;
            overflow: auto;
            background-color: rgba(0, 0, 0, 0.4);
        }

        .modal-content {
            background-color: #fff;
            margin: 15% auto;
            padding: 20px;
            border: 1px solid #888;
            width: 300px;
            text-align: center;
            border: 1px solid black;
            background: url("https://thumbs.dreamstime.com/b/light-wood-background-copy-space-message-93117481.jpg");
        }
        
        .modal-content > h3{
            margin-top: 10px;
            border: 1px solid black;
            background-color: #f2f2f2;
            display: inline-flex;
            padding: 10px;
        }

        .close {
            color: #aaa;
            float: right;
            font-size: 28px;
            font-weight: bold;
        }

        .close:hover,
        .close:focus {
            color: black;
            text-decoration: none;
            cursor: pointer;
        }

        .order-summary {
            background-color: #f4f4f4;
            margin-top: 150px;
            position: fixed;
            width: 40%;
            height: 45%;
            overflow-y: scroll;
        }

        .order-summary table {
            width: 100%;
            border-collapse: collapse;
        }

        .order-summary th, .order-summary td {
            padding: 10px;
            border: 1px solid #ddd;
        }

        .order-summary th {
            background-color: #f2f2f2;
        }

        .buttons {
            display: flex;
            justify-content: space-between;
            margin-top: 20px;
        }

        .buttons button {
            padding: 10px 20px;
            background-color: #5cb85c;
            color: white;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            font-weight: bold;
            font-family: 'Roboto', sans-serif;
        }

        .buttons button:hover {
            background-color: #4cae4c;
        }

        .remove-btn {
            background-color: #d9534f;
            color: white;
            border: none;
            border-radius: 5px;
            cursor: pointer;
        }

        .remove-btn:hover {
            background-color: #c9302c;
        }
        
        .logout {
            background: url('https://images.pexels.com/photos/129731/pexels-photo-129731.jpeg?cs=srgb&dl=pexels-fwstudio-33348-129731.jpg&fm=jpg');
            width: 100px;
            cursor: pointer;
            border-radius: 50px;
            padding: 10px 20px 10px 0;
            color: white;
            font-size: 16px;
            text-align: left;
            text-indent: 1000px; /* Push text out of view */
            overflow: hidden; /* Ensure that text doesn't overflow visibly */
            white-space: nowrap; /* Prevent text from wrapping */
            margin-top: 24px;
            margin-left: 5px;
            position: fixed;    

            /* Animations: */
            -webkit-transition-timing-function: ease-in-out;
            -webkit-transition-duration: .4s;
            -webkit-transition-property: all;

            -moz-transition-timing-function: ease-in-out;
            -moz-transition-duration: .4s;
            -moz-transition-property: all;
        }

        .logout:hover {
            background-image: url('https://images.pexels.com/photos/129731/pexels-photo-129731.jpeg?cs=srgb&dl=pexels-fwstudio-33348-129731.jpg&fm=jpg');
            font-family: sans-serif;
            background-position: 100px 0px;
            color: #8B0000;
            border-radius: 50px;
            border: 2px solid #8B0000;
            font-weight: bold;
            text-indent: 15px; /* Bring text back into view */
        }
           
           #clock{
               padding-top: 50px;
               width: 100vw;
               position: absolute;
               font-size: 1.3vw;
               color: black;
               font-family: 'Roboto', sans-serif;
               padding-left: 60%;
               font-weight: bold;
           }
        
    </style>
</head>
<body onload = "realtimeClock()">
    <%  
        String fullname = (String) session.getAttribute("fullname");
        String category = (String) session.getAttribute("category");
        
        response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
        response.setHeader("Pragma", "no-cache");
        response.setHeader("Expires", "0");
        
        if (fullname == null || !"cashier".equals(category)) {
            response.sendRedirect("/main");
            return;
        }
    %>
<header>
   <button id="logOutBtn" class="logout">LOGOUT</button>
   <h2 class = "productSign" >Products</h2> 
</header>
<div class="container">
    <div class = "product">
        <table id="productTable" class = "productTable">
            <thead>
                <tr>
                    <th>Item Price</th>
                    <th>Item Image</th>
                    <th>Item Name</th>
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
                    
                    PreparedStatement ps=(PreparedStatement) con.prepareStatement("SELECT  * FROM menu" );
                    ResultSet rs = ps.executeQuery();
                    while(rs.next()){
                        int id = rs.getInt("ID");
                        String name = rs.getString("item_name");
                        Double price_small = rs.getDouble("price_small");
                        Double price_medium = rs.getDouble("price_medium");
                        Double price_large = rs.getDouble("price_large");
                        Double price_iced = rs.getDouble("price_iced");
                        byte[] imageData = rs.getBytes("item_image");
                        String Image = Base64.getEncoder().encodeToString(imageData);
            %>
                <tr class = "products" data-item-number="<%= id %>" data-item-name="<%= name %>" data-item-price-small="<%= price_small %>" data-item-price-medium="<%= price_medium %>" data-item-price-large="<%= price_large %>" data-item-price-iced = "<%= price_iced%>">
                    <td style = "left: 10px;">
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
                        <img style = "width: 100px; height: auto;" src="data:image/png;base64,<%= Image %>" alt="Item Image" />
                    </td>
                    <td>
                        <%=name%>
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
</div>
            
<!-- Summary Table -->       
<form id="orderForm">
    <div class="summary">
        <h2 style = "padding-top: 30px; position: fixed;">Order Summary</h2>
        <div id = "clock" style = "justify-content: flex-end;"></div>
        <div class="form-container">
            <div class="input-group">
                <label for="customerName">Customer:</label>
                <input type="text" name="customerName" id="customerName" required style = "width: 163px">
            </div>
            <div class="input-group cashier-container">
                <label for="cashierName" style = "padding-left: 10px;">Cashier:</label>
                <input type="text" name="cashierName" id="cashierName" readonly required value="<%= (String) session.getAttribute("fullname") %>" style = "width: 163px" >
            </div>
                <input type ="hidden" id="platform" name = "platform" value ="On-Site">
        </div>
        <div class="order-summary" id="orderSummary">
            <table>
                <thead>
                    <tr>
                        <th>Quantity</th>
                        <th>Item Name</th>
                        <th>Size</th>
                        <th>Type</th>
                        <th>Price</th>
                        <th></th>
                    </tr>
                </thead>
                <tbody id="orderSummaryBody">
                    <!-- Dynamic Table will be inserted here -->
                </tbody>
            </table>
        </div>
        <div class="amount-summary-container">
            <table class="amount-summary" id="amountSummary">
                <tbody>
                    <tr>
                        <td>Total Amount (PHP):</td>
                        <td>0.00</td>
                    </tr>
                    <tr>
                        <td>Payment (PHP):</td>
                        <td><input type = "text" name = "payment" id = "payment" required style= "text-align: center;"></td>
                    </tr>
                    <tr>
                        <td colspan ="2">
                            <label>
                            <input type="radio" name="orderType" value="Dine-in" checked> Dine-In
                            </label>
                            <label>
                            <input type="radio" name="orderType" value="Take-out"> Take-Out
                            </label>
                        </td>
                    </tr>
                </tbody>
            </table>
                
            <!-- HIDDEN VALUES -->
                <input type="hidden" id="formData" name="formData">
            <div class="buttons" style="justify-content: flex-end; ">
                <button id="verifyOrderBtn">Verify Order</button>
            </div>
        </div>
    </div>
</form>
            
<div id="modal" class="modal">
    <div class="modal-content">
        <span class="close">&times;</span>
        <h3 id="modalItemName"></h3>
        <form id="modalForm">
            <div id="sizeOptions">
                <!-- Size options will be dynamically inserted here -->
            </div>
                <label>
                <input type="radio" name="type" value="Hot" checked> Hot
                </label>
                <label>
                <input type="radio" name="type" value="Iced"> Iced (+<span id="priceIced"></span>)
                </label>
                <br><br>
            <label>
                <input type="number" id="quantityInput" min="1" value="1" required> Quantity
            </label>
            <br><br>
            <button type="button" id="addOrderBtn" style = "padding: 10px;">Add to Order</button>
        </form>
    </div>
</div>
 
<script>
    const productTable = document.getElementById('productTable');
    const modal = document.getElementById('modal');
    const modalItemName = document.getElementById('modalItemName');
    const modalForm = document.getElementById('modalForm');
    const sizeOptions = document.getElementById('sizeOptions');
    const orderSummaryBody = document.getElementById('orderSummaryBody');
    const amountSummary = document.getElementById('amountSummary');
    const addOrderBtn = document.getElementById('addOrderBtn');
    const verifyOrderBtn = document.getElementById('verifyOrderBtn');
    const totalAmountContainer = document.getElementById('totalAmount');
    var orderForm = document.getElementById("orderForm");
    let currentItem = null;
    let totalAmount = 0;
    let change = 0;
    
    //CLOCK
    var hours = 0;
    var minutes = 0;
    var seconds = 0;
    var amPm = '';

    var year = 0;
    var month = 0;
    var day = 0;

    productTable.addEventListener('click', function(event) {
        if (event.target.tagName === 'TD' || event.target.tagName === 'IMG') {
            const tr = event.target.closest('tr');
            const itemNumber = tr.getAttribute('data-item-number');
            const itemName = tr.getAttribute('data-item-name');
            const priceSmall = tr.getAttribute('data-item-price-small');
            const priceMedium = tr.getAttribute('data-item-price-medium');
            const priceLarge = tr.getAttribute('data-item-price-large');
            const priceIced = tr.getAttribute('data-item-price-iced');
            currentItem = { itemNumber, itemName, priceSmall, priceMedium, priceLarge, priceIced };

            modalItemName.textContent = itemName;
            
            // Update the Iced price in the radio button label
            document.getElementById('priceIced').textContent = priceIced;
            
            // Modify size options based on item name
            if (itemName === 'Espresso') {
                sizeOptions.innerHTML = `
                    <label>
                        <input type="radio" name="size" value="1 shot" checked> 1 shot
                    </label>
                    <label>
                        <input type="radio" name="size" value="2 shots"> 2 shots
                    </label>
                    <br><br>
                `;
            } else {
                sizeOptions.innerHTML = `
                    <label>
                        <input type="radio" name="size" value="Small" checked> Small
                    </label>
                    <label>
                        <input type="radio" name="size" value="Medium"> Medium
                    </label>
                    <label>
                        <input type="radio" name="size" value="Large"> Large
                    </label>
                    <br><br>
                    
                `;
            }

            modal.style.display = 'block';
        }
    });

    document.querySelector('.close').addEventListener('click', function() {
        modal.style.display = 'none';
    });

    window.addEventListener('click', function(event) {
        if (event.target === modal) {
            modal.style.display = 'none';
        }
    });

    addOrderBtn.addEventListener('click', function() {
        const size = modalForm.elements['size'].value;
        const type = modalForm.elements['type'].value;
        const quantity = parseInt(document.getElementById('quantityInput').value);
        const price = size === 'Small' ? parseFloat(currentItem.priceSmall) :
                     size === 'Medium' ? parseFloat(currentItem.priceMedium) :
                     size === 'Large' ? parseFloat(currentItem.priceLarge) :
                     parseFloat(currentItem.priceSmall); // Default to small price if unhandled
        let totalItemPrice = quantity * price;

        // If type is Cold, add additional 10 depending on quantity
        if (type === 'Iced') {
            totalItemPrice += parseFloat(currentItem.priceIced) * quantity;
        }

        // Check if the same item already exists in the summary table
        let existingRow = null;
        orderSummaryBody.querySelectorAll('tr').forEach(row => {
            const itemName = row.children[1].textContent;
            const rowSize = row.children[2].textContent;
            const rowType = row.children[3].textContent;

            if (itemName === currentItem.itemName && rowSize === size && rowType === type) {
                existingRow = row;
                return;
            }
        });

        if (existingRow) {
            // Update quantity and price of existing item
            const existingQuantity = parseInt(existingRow.children[0].textContent);
            const existingPrice = parseFloat(existingRow.children[4].textContent);
            const newQuantity = existingQuantity + quantity;
            const newPrice = existingPrice + totalItemPrice;

            existingRow.children[0].textContent = newQuantity;
            existingRow.children[4].textContent = newPrice.toFixed(2);
        } else {
            // Append a new row if the item doesn't already exist
            const newRow = document.createElement('tr');

            const quantityCell = document.createElement('td');
            quantityCell.textContent = quantity;
            newRow.appendChild(quantityCell);

            const itemNameCell = document.createElement('td');
            itemNameCell.textContent = currentItem.itemName;
            newRow.appendChild(itemNameCell);

            const sizeCell = document.createElement('td');
            sizeCell.textContent = size;
            newRow.appendChild(sizeCell);

            const typeCell = document.createElement('td');
            typeCell.textContent = type;
            newRow.appendChild(typeCell);

            const priceCell = document.createElement('td');
            priceCell.textContent = totalItemPrice.toFixed(2);
            newRow.appendChild(priceCell);

            const removeButtonCell = document.createElement('td');
                const removeButton = document.createElement('button');
                removeButton.textContent = 'Remove';
                removeButton.classList.add('remove-btn');
                removeButtonCell.appendChild(removeButton);
                newRow.appendChild(removeButtonCell);

            orderSummaryBody.appendChild(newRow);
        }

        totalAmount += totalItemPrice;
        updateTotalAmount();

        document.getElementById('quantityInput').value = 1; // Reset quantity input
        modal.style.display = 'none';
    });

    orderSummaryBody.addEventListener('click', function(event) {
        if (event.target.classList.contains('remove-btn')) {
            const row = event.target.closest('tr');
            const price = parseFloat(row.children[4].textContent);
            totalAmount -= price;
            row.remove();
            updateTotalAmount();
        }
    });
    
    verifyOrderBtn.addEventListener('click', function(event) {
        event.preventDefault();

        const summaryRows = orderSummaryBody.querySelectorAll('tr');
        console.log('Number of items in order:', summaryRows.length);
        const customerName = document.getElementById('customerName').value;
        const payment = parseInt(document.getElementById('payment').value);
        const orderType = document.querySelector('input[name="orderType"]:checked').value;
        const amount = parseInt(totalAmount);
        var formData = "";

        if (customerName === '') {
            alert("Customer Name Needed!");
            return;
        } else if (isNaN(payment)) {
            alert("Insert Payment!");
            return;
        } else if (payment >= amount) {
            if (summaryRows.length === 0) {
                alert('No items added to the order.');
                return;
            } else {
                var change = payment - amount;
                let orderSummaryText = '';

                summaryRows.forEach((summaryRow, index) => {
                    const cells = summaryRow.querySelectorAll('td');
                    let itemData = {};

                    cells.forEach((cell, cellIndex) => {
                        const cellValue = cell.textContent;
                        switch (cellIndex) {
                            case 0:
                                itemData.quantity = cellValue;
                                break;
                            case 1:
                                itemData.itemName = cellValue;
                                break;
                            case 2:
                                itemData.size = cellValue;
                                break;
                            case 3:
                                itemData.type = cellValue;
                                break;
                            case 4:
                                itemData.price = cellValue;
                                break;
                        }
                    });

                    formData += "quantity=" + encodeURIComponent(itemData.quantity) + 
                                "&itemName=" + encodeURIComponent(itemData.itemName) + 
                                "&size=" + encodeURIComponent(itemData.size) + 
                                "&type=" + encodeURIComponent(itemData.type) + 
                                "&price=" + encodeURIComponent(itemData.price);

                    if (index < summaryRows.length - 1) {
                        formData += "&";
                    }
                });

                orderSummaryText = month + "/" + day + "/" + year + " " + hours + ":" + minutes + ":" + seconds + " " + amPm + '\nOrder Successful\nChange: ' + change;
                alert(orderSummaryText);

                // Set formData in hidden field and submit the form
                var hiddenField = document.getElementById("formData");
                hiddenField.value = formData;

                var orderTypeField = document.createElement("input");
                    orderTypeField.type = "hidden";
                    orderTypeField.name = "orderType";
                    orderTypeField.value = orderType;
                    document.getElementById("orderForm").appendChild(orderTypeField);

                var changeField = document.createElement("input");
                    changeField.type = "hidden";
                    changeField.name = "changeAmount";
                    changeField.value = change;
                    document.getElementById("orderForm").appendChild(changeField);

                var totalAmountField = document.createElement("input");
                    totalAmountField.type = "hidden";
                    totalAmountField.name = "totalAmount";
                    totalAmountField.value = amount;
                    document.getElementById("orderForm").appendChild(totalAmountField);

                orderForm.action = "orderOnsite";
                orderForm.method = "post";
                orderForm.submit();

                alert("Order successfully submitted and processed.");

                //Reset
                reset();
            }
        } else {
            alert("Payment is insufficient!");
            // Add return statement to prevent form submission
            return;
        }                
    });
    
    
    function updateTotalAmount() {
        const amountSummaryRow = amountSummary.querySelector('tr'); // Select the first row
        if (amountSummaryRow) {
            const secondTd = amountSummaryRow.querySelector('td:nth-child(2)'); // Select the second <td> element
            if (secondTd) {
                secondTd.textContent = totalAmount.toFixed(2); // Set its text content
            }
        }
    }
    
    document.getElementById('logOutBtn').addEventListener('click', function(event) {
            // Change window location
            alert("Logged Out!");
            window.location.href = '<%= request.getContextPath() %>/logout';;
        });


    function realtimeClock() {
        var rtClock = new Date();

        hours = rtClock.getHours();
        minutes = rtClock.getMinutes();
        seconds = rtClock.getSeconds();

        year = rtClock.getFullYear();
        month = rtClock.getMonth() + 1; // Months are zero-based
        day = rtClock.getDate();

        // Add AM and PM system
        amPm = (hours < 12) ? "AM" : "PM";

        // Convert the hours component to 12-hour format
        hours = (hours > 12) ? hours - 12 : hours;
        hours = (hours == 0) ? 12 : hours; // Convert '0' hours to '12' (midnight and noon)

        // Pad the hours, minutes, seconds, day, and month with leading zeroes
        hours = ("0" + hours).slice(-2);
        minutes = ("0" + minutes).slice(-2);
        seconds = ("0" + seconds).slice(-2);
        day = ("0" + day).slice(-2);
        month = ("0" + month).slice(-2);

        // Display the clock
        document.getElementById("clock").innerHTML =
            month + "/" + day + "/" + year + " " + hours + ":" + minutes + ":" + seconds + " " + amPm;

        // Update the clock every second
        var t = setTimeout(realtimeClock, 1000);
    }
    
    function reset() {
            setTimeout(function() {
                document.getElementById("customerName").value = '';
                document.getElementById("payment").value = '';
                orderSummaryBody.innerHTML = '';
                totalAmount = 0;
                updateTotalAmount();
            }, 500);
        }
    
</script>

</body>
</html>