<%-- 
    Document   : admin
    Created on : May 18, 2024, 3:14:46 PM
    Author     : talai
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Admin Dashboard</title>
  <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-icons/1.8.1/font/bootstrap-icons.min.css">
  <script src="https://code.jquery.com/jquery-3.5.1.min.js"></script>
  <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.16.1/umd/popper.min.js"></script>
  <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
  <style>
    @import url('https://fonts.googleapis.com/css2?family=Barlow&display=swap');

    body {
        font-family: 'Barlow', sans-serif;
        background: url("https://i.pinimg.com/originals/09/67/39/09673964915d81d838cadcfba7b52429.jpg");
        background-size: cover;
        background-position: center, no-repeat;
    }

    a:hover {
      text-decoration: none;
    }
    
    nav{
        background-color: #CFBCA3;
        border-bottom: 2px solid black;
    }
    
    #sidebar{
        background: url("https://images.pexels.com/photos/326333/pexels-photo-326333.jpeg");
        background-size: cover;
        background-position: center, no-repeat;
    }

    .border-left {
      border-left: 2px solid var(--primary) !important;
    }

    .sidebar {
      top: 0;
      left: 0;
      z-index: 100;
      overflow-y: auto;
    }
    
    .loginButton{
        padding: 2px;
        background-color: antiquewhite;
    }
    
    .adminName{
        font-size: 25px;
        font-weight: bold;
        font-family: 'Helvetica', sans-serif;
    }

    .overlay {
      background-color: rgb(0 0 0 / 45%);
      z-index: 99;
    }

    /* sidebar for small screens */
    @media screen and (max-width: 767px) {
      .sidebar {
        max-width: 18rem;
        transform: translateX(-100%);
        transition: transform 0.4s ease-out;
      }

      .sidebar.active {
        transform: translateX(0);
      }
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
        
        if (fullname == null || !"admin".equals(category)) {
            response.sendRedirect("/main");
            return;
        }
        
        Double price_iced = 0.0;
    %>
  <!-- overlay -->
  <div id="sidebar-overlay" class="overlay w-100 vh-100 position-fixed d-none"></div>

  <!-- sidebar -->
  <div class="col-md-3 col-lg-2 px-0 position-fixed h-100 bg-white shadow-sm sidebar" id="sidebar">
    <h1 class="bi bi-bootstrap text-primary d-flex my-4 justify-content-center"></h1>
    <div class="list-group rounded-0">
      <a href="/admin/main" class="list-group-item list-group-item-action active border-0 d-flex align-items-center" target="content-frame">
        <span class="bi bi-border-all"></span>
        <span class="ml-2">Dashboard</span>
      </a>
      <a href="/admin/products" class="list-group-item list-group-item-action border-0 align-items-center" target="content-frame">
        <span class="bi bi-box"></span>
        <span class="ml-2">Products</span>
      </a>

      <button class="list-group-item list-group-item-action border-0 d-flex justify-content-between align-items-center" data-toggle="collapse" data-target="#sale-collapse">
        <div>
          <span class="bi bi-cart-dash"></span>
          <span class="ml-2">Sale</span>
        </div>
        <span class="bi bi-chevron-down small"></span>
      </button>
      <div class="collapse" id="sale-collapse" data-parent="#sidebar">
        <div class="list-group">
          <a href="/admin/customerlist" class="list-group-item list-group-item-action border-0 pl-5" target="content-frame">Customers</a>
          <a href="/admin/sales" class="list-group-item list-group-item-action border-0 pl-5" target="content-frame">Sales</a>
        </div>
      </div>

      <button class="list-group-item list-group-item-action border-0 d-flex justify-content-between align-items-center" data-toggle="collapse" data-target="#purchase-collapse">
        <div>
          <span class="bi bi-cart-plus"></span>
          <span class="ml-2">Management</span>
        </div>
        <span class="bi bi-chevron-down small"></span>
      </button>
      <div class="collapse" id="purchase-collapse" data-parent="#sidebar">
        <div class="list-group">
          <a href="/admin/signup" class="list-group-item list-group-item-action border-0 pl-5">Add Account</a>
          <a href="/admin/employeelist" class="list-group-item list-group-item-action border-0 pl-5" target="content-frame">Employee</a>
        </div>
      </div>
    </div>
  </div>

  <div class="col-md-9 col-lg-10 ml-md-auto px-0 ms-md-auto">
    <!-- top nav -->      
    <nav class="w-100 d-flex px-4 py-2 mb-4 shadow-sm">
      <!-- close sidebar -->
      <button class="btn py-0 d-lg-none" id="open-sidebar">
        <span class="bi bi-list text-primary h3"></span>
      </button>
      <div class ="adminName">Hello, <%= fullname%>!</div>
      <div class="dropdown ml-auto">
        <button class="btn py-0 d-flex align-items-center" id="logout-dropdown" data-toggle="dropdown" aria-expanded="false">
          <span class="bi bi-person text-primary h4"></span>
          <span class="bi bi-chevron-down ml-1 mb-2 small"></span>
        </button>
        <div class="dropdown-menu dropdown-menu-right border-0 shadow-sm" aria-labelledby="logout-dropdown">
            <a class="dropdown-item" href="/logout">Logout</a>
        </div>
      </div>
    </nav>

    <!-- main content in iframe -->
    <main class="p-4 min-vh-100">
      <iframe src="/admin/main" name="content-frame" class="w-100" style="height: calc(100vh - 56px); border: none;"></iframe>
    </main>
  </div>

  <script>
    $(document).ready(() => {
      // Check if jQuery is loaded
      if (typeof jQuery == 'undefined') {
        console.error('jQuery is not loaded');
      } else {
        console.log('jQuery is loaded');
      }

      $('#open-sidebar').click(() => {
        // add class active on #sidebar
        $('#sidebar').addClass('active');
        
        // show sidebar overlay
        $('#sidebar-overlay').removeClass('d-none');
      });

      $('#sidebar-overlay').click(function () {
        // remove class active on #sidebar
        $('#sidebar').removeClass('active');
        
        // hide sidebar overlay
        $(this).addClass('d-none');
      });

      // Initialize Bootstrap dropdown
      $('#logout-dropdown').dropdown();

      $('.dropdown-toggle').dropdown();
    });
  </script>
</body>
</html>
