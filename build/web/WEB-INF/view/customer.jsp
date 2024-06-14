<%-- 
    Document   : customer
    Created on : May 18, 2024, 3:03:39 PM
    Author     : talai
--%>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.DriverManager" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="java.util.Base64" %>
<%@ page import="javax.servlet.http.HttpSession" %>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>CUP'A BLISS</title>
    <link href = "https://fonts.googleapis.com/css?family=Oswald|Roboto:100" rel = "stylesheet">
    <style>
        legend{
            border: 1px solid black;
            background-color:  #967969;
            padding: 5px 10px 5px 10px;
            border-radius: 50px;
        }
        form{
            
        }
        body{
            background-color: beige;
            background: url("https://i.pinimg.com/originals/09/67/39/09673964915d81d838cadcfba7b52429.jpg");
            background-size: cover;
            background-repeat: no-repeat; 
            background-position: center; 
            background-attachment: fixed; 
            height: 100vh;
            margin: 0;
            padding: 0;
            font-family: Arial, sans-serif;
            align-items: center;
            justify-content: center;
        }
        fieldset{
            background-color: antiquewhite;
            display: block;
            margin-bottom: 30px;
            border-radius: 5px;
        }
        label, input{
            margin-bottom: 8px;
        }

        table {
            border-collapse: collapse;
            width: 100%;
          }

          th, td {
            padding: 8px;
            text-align: left;
          }

          footer {
            background-color: #333;
            color: #fff;
            padding: 20px; 
            text-align: center;
            width: 100%;
            box-sizing: border-box; 
            margin-top: 25px;
            background-image: url(images/header.jpg);
            background-repeat: no-repeat;
            background-size: cover;
        }
        
        header{
            padding: 10px;
            display: flex;
            background: url("https://thumbs.dreamstime.com/b/light-wood-background-text-copy-space-80917745.jpg");
            background-size: cover;
            background-repeat: no-repeat; 
            background-position: center; 
            background-attachment: fixed;   
            margin-bottom: 25px;
        }
        ul{
            padding:20px;
        }

        .horizontal-container {
            display: flex;
            align-items: center;
        }

        .temperature-div {
            margin: 0 10px; /* Adjust spacing between elements */
        }

        .quantity-input {
            width: 70px; /* Adjust input width */
        }

        label, input {
            transition: opacity 0.3s ease-in-out;
            opacity: 1;
        }

          label.hidden, input.hidden {
            opacity: 0;
            pointer-events: none;
        }

        .buttons {
            display: flex;
            justify-content: space-between;
        }

        .buttons button {
            padding: 10px 20px;
            background-color: #967969;
            color: white;
            border: none;
            border-radius: 5px;
            cursor: pointer;
        }

        .buttons button:hover {
            background-color: #76513f;
        }

        .summary {
            background-color: #f2e8dc;
            padding: 20px;
            border-radius: 5px;
            margin-top: 20px;
        }
        
        .productTable{
            width: 600px;
        }
        
        table {
            width: 100%;
            border-collapse: collapse;
        }
        
        th, td {
            text-align: center;
        }
        
        .container{
            width:50%;
            height: auto;
            padding: 0 25%;
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
        
        .products:hover{
            border: 1px solid black;
            background-color: beige;
            border-radius: 50px; 
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
            z-index: 1;
            margin-left: 20px;

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
        
        #clock{
            padding-top:10px;
            position: absolute;
            font-size: 1.5vw;
            color: black;
            font-family: 'Roboto', sans-serif;
            padding-left: 80vw;
            font-weight: bold;
        }
        
        #address-container, #time-container {
            transition: opacity 0.5s ease, max-height 0.5s ease;
            overflow: hidden;
        }

        #address-container.hidden, #time-container.hidden {
            opacity: 0;
            max-height: 0;
            pointer-events: none;
        }

        #address-container, #time-container {
            opacity: 1;
            max-height: 100px;
        }
    </style>
</head>

<body onload = "realtimeClock()">
    <%  
        String fullname = (String) session.getAttribute("fullname");
        String category = (String) session.getAttribute("category");
        String email = (String) session.getAttribute("email");
        
        response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
        response.setHeader("Pragma", "no-cache");
        response.setHeader("Expires", "0");
        
        if (fullname == null || !"customer".equals(category)) {
            response.sendRedirect("/main");
            return;
        }
        
        Double price_iced = 0.0;
    %>
    
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
<header>
    <button id="logOutBtn" class="logout">LOGOUT</button>
    <div style ="font-size: 1.5vw; padding-top: 12px; padding-left: 35vw;">Hello! <%= (String) session.getAttribute("fullname") %></div>
    <div id = "clock" style = "justify-content: flex-end;"></div>
</header>
<div class = "container">
    <!--Basic Information-->
    <fieldset>
        <legend>Basic Information</legend>
        <label for="customerName">Customer Name:</label>
        <input type="text" id="customerName" name="customerName" readonly required value="<%= (String) session.getAttribute("fullname") %>" style = "width: 190px;">
        <label for="email" style = "padding-left: 20px;">E-mail:</label>
        <input type="email" id="email" name="email" readonly required value="<%= (String) session.getAttribute("email") %>" style = "width: 190px;">
        <label for="contactNumber">Contact Number:</label>
        <input type="tel" id="contactNumber" name="contactNumber" required style = "width: 190px;">
        
    <label style="padding-left: 20px">
        <input type="radio" name="orderType" value="Pick-up" onclick="disableAddress()" checked> Pick-up
    </label>
    <label>
        <input type="radio" name="orderType" value="Delivery" onclick="enableAddress()"> Delivery
    </label>
    <br>

    <div id="address-container">
        <label>
            Address: <input type="text" id="address" name="address" style="width: 535px;">
        </label>
        <label>
            <input type="radio" id = "transactionType" name="transactionType" value="COD"> Cash-On-Delivery
        </label>
        <br>
    </div>

    <div id="time-container">
        <label>
            Pick-up Time: <input type="time" id="time" name="time" min="08:00" max="17:00" required>
        </label>
    </div>
    </fieldset>
        
        
    <!--Products-->
    <fieldset>
        <legend>Products</legend>
        <!--Coffee/Latte-->
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
                        price_iced = rs.getDouble("price_iced");
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
    </fieldset>

            
    <!--OrderList-->
    <fieldset>
        <legend>Order Summary</legend>
        <form id="orderForm">
            <input type="hidden" id="platform" name="platform" value="Online">
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
                </tbody>
            </table>
                
            <!-- HIDDEN VALUES -->
                <input type="hidden" id="formData" name="formData">
            <div class="buttons" style="justify-content: flex-end; ">
                <button id="verifyOrderBtn">Verify Order</button>
            </div>
        </div>
        </form>
    </fieldset> 
</div>
            
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
                <input type="radio" name="type" value="Iced"> Iced (+<%= price_iced%>)
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
    const orderForm = document.getElementById("orderForm");
    let currentItem = null;
    let totalAmount = 0;

    // CLOCK
    let hours = 0;
    let minutes = 0;
    let seconds = 0;
    let amPm = '';
    let year = 0;
    let month = 0;
    let day = 0;

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
        const email = document.getElementById('email').value;
        const contactNumber = document.getElementById('contactNumber').value;
        const address = document.getElementById('address').value;
        let time = document.getElementById('time').value;
        const transactionTypeChecked = !!document.querySelector('input[name="transactionType"]:checked');
        let transactionType = '';
        const orderType = document.querySelector('input[name="orderType"]:checked').value;
        const amount = parseInt(totalAmount);
        let formData = "";

        if (transactionTypeChecked && orderType === 'Delivery') {
            // If a transaction type is checked, get its value
            transactionType = document.querySelector('input[name="transactionType"]:checked').value;
            time = '00:00:00';
        } else if (orderType === 'Pick-up'){
            // If no transaction type is checked, set it to 'Onsite'
            transactionType = 'Onsite';
        }

        // Current date and time
        const currentDate = new Date();
        // Selected time for pick-up
        const selectedTime = new Date();
        const timeParts = time.split(':');
        selectedTime.setHours(timeParts[0], timeParts[1], 0, 0);

        // Setting maximum time to 5:00 PM
        const maxTime = new Date();
        maxTime.setHours(17, 0, 0, 0);

        if (contactNumber.length < 11)  {
            alert("Enter Contact Number!");
            return;
        } else if (orderType === 'Pick-up' && (!time || time.trim() === '')) {
            alert("Select Time!");
            return;
        } else if (orderType === 'Pick-up' && (selectedTime < currentDate || selectedTime > maxTime)) {
            alert("Select a valid time. Pick-up time must not be before the current time and must be no later than 5:00 PM.");
            return;
        } else if (orderType === 'Delivery' && (!address || address.trim() === '')) {
            alert("Enter Address!");
            return;
        } else if (orderType === 'Delivery' && transactionType ==='') {
            alert("Enter Transaction Type!");
            return;
        } else if (summaryRows.length === 0) {
            alert('No items added to the order.');
            return;
        } else {
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

            const orderDate = new Date();
            const year = orderDate.getFullYear();
            const month = orderDate.getMonth() + 1;
            const day = orderDate.getDate();
            const hours = orderDate.getHours();
            const minutes = orderDate.getMinutes();
            const seconds = orderDate.getSeconds();
            const amPm = hours >= 12 ? 'PM' : 'AM';
            orderSummaryText = month + "/" + day + "/" + year + " " + hours + ":" + minutes + ":" + seconds + " " + amPm + '\nOrder Successful';
            alert(orderSummaryText);

            // Set formData in hidden field and submit the form
            var hiddenField = document.getElementById("formData");
            hiddenField.value = formData;

            var customerNameField = document.createElement("input");
            customerNameField.type = "hidden";
            customerNameField.name = "customerName";
            customerNameField.value = customerName;
            document.getElementById("orderForm").appendChild(customerNameField);

            var emailField = document.createElement("input");
            emailField.type = "hidden";
            emailField.name = "email";
            emailField.value = email;
            document.getElementById("orderForm").appendChild(emailField);

            var contactNumberField = document.createElement("input");
            contactNumberField.type = "hidden";
            contactNumberField.name = "contactNumber";
            contactNumberField.value = contactNumber;
            document.getElementById("orderForm").appendChild(contactNumberField);

            var addressField = document.createElement("input");
            addressField.type = "hidden";
            addressField.name = "address";
            addressField.value = address;
            document.getElementById("orderForm").appendChild(addressField);

            var timeField = document.createElement("input");
            timeField.type = "hidden";
            timeField.name = "time";
            timeField.value = time;
            document.getElementById("orderForm").appendChild(timeField);

            var orderTypeField = document.createElement("input");
            orderTypeField.type = "hidden";
            orderTypeField.name = "orderType";
            orderTypeField.value = orderType;
            document.getElementById("orderForm").appendChild(orderTypeField);

            var transactionTypeField = document.createElement("input");
            transactionTypeField.type = "hidden";
            transactionTypeField.name = "transactionType";
            transactionTypeField.value = transactionType;
            document.getElementById("orderForm").appendChild(transactionTypeField);

            var amountField = document.createElement("input");
            amountField.type = "hidden";
            amountField.name = "totalAmount";
            amountField.value = amount;
            document.getElementById("orderForm").appendChild(amountField);

            orderForm.action = "orderOnline";
            orderForm.method = "post";
            orderForm.submit();

            alert("Order successfully submitted and processed.");

            // Reset
            reset();
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

    document.getElementById('logOutBtn').addEventListener('click', function() {
        alert("Logged Out!");
        // Change window location
        window.location.href = '<%= request.getContextPath() %>/logout';
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
        
        //This is for the address and time
        if (document.querySelector('input[name="orderType"]:checked').value === 'Pick-up') {
                disableAddress();
            } else {
                enableAddress();
            }
    }

    function reset() {
        setTimeout(function() {
            document.getElementById("time").value = '';
            document.getElementById("address").value = ''
            document.querySelector('input[name="transactionType"]:checked').checked = false;
            orderSummaryBody.innerHTML = '';
            totalAmount = 0;
            updateTotalAmount();
        }, 500);
    }

    function disableAddress() {
        const addressContainer = document.getElementById('address-container');
        const timeContainer = document.getElementById('time-container');
        const checkedRadio = document.querySelector('input[name="transactionType"]:checked');

        // Reset address input value
        document.getElementById('address').value = '';
        if (checkedRadio) {
            checkedRadio.checked = false;
        }
        addressContainer.classList.add('hidden');
        timeContainer.classList.remove('hidden');
        
        setTimeout(() => {
            addressContainer.style.opacity = 0;
            addressContainer.style.maxHeight = 0;
            addressContainer.style.pointerEvents = 'none';

            timeContainer.style.opacity = 1;
            timeContainer.style.maxHeight = '100px';
            timeContainer.style.pointerEvents = 'auto';
        }, 10);
    }

    function enableAddress() {
        const addressContainer = document.getElementById('address-container');
        const timeContainer = document.getElementById('time-container');

        // Reset pick-up time input value
        document.getElementById('time').value = '';

        addressContainer.classList.remove('hidden');
        timeContainer.classList.add('hidden');

        setTimeout(() => {
            addressContainer.style.opacity = 1;
            addressContainer.style.maxHeight = '100px';
            addressContainer.style.pointerEvents = 'auto';

            timeContainer.style.opacity = 0;
            timeContainer.style.maxHeight = 0;
            timeContainer.style.pointerEvents = 'none';
        }, 10);
    }
</script>
</body>
</html>
