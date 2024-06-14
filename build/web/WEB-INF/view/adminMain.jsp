<%-- 
    Document   : adminMain
    Created on : Jun 9, 2024, 9:34:10 PM
    Author     : talai
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Main Content</title>
  <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-icons/1.8.1/font/bootstrap-icons.min.css">
</head>
<body>
  <!-- main content -->
  <main class="p-4 min-vh-100">
    <div class="jumbotron jumbotron-fluid rounded bg-white border-0 shadow-sm border-left px-4">
      <div class="container">
        <h1 class="display-4 mb-2 text-primary">CUP'A BLISS</h1>
        <p class="lead text-muted">Admin Dashboard</p>
      </div>
    </div>
    <section class="row">
      <div class="col-md-6 col-lg-4">
        <!-- card -->
        <article class="p-4 rounded shadow-sm border-left mb-4">
          <a href="/admin/products" class="d-flex align-items-center" target = "content-frame">
            <span class="bi bi-box h5"></span>
            <h5 class="ml-2">Products</h5>
          </a>
        </article>
      </div>
      <div class="col-md-6 col-lg-4">
        <article class="p-4 rounded shadow-sm border-left mb-4">
          <a href="/admin/customerlist" class="d-flex align-items-center" target = "content-frame">
            <span class="bi bi-person h5"></span>
            <h5 class="ml-2">Customers</h5>
          </a>
        </article>
      </div>
      <div class="col-md-6 col-lg-4">
        <article class="p-4 rounded shadow-sm border-left mb-4">
          <a href="/admin/employeelist" class="d-flex align-items-center" target = "content-frame">
            <span class="bi bi-person-check h5"></span>
            <h5 class="ml-2">Employee</h5>
          </a>
        </article>
      </div>
    </section>
  </main>
</body>
</html>

