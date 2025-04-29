<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Billing System</title>
  <link rel="stylesheet" href="styles.css">
</head>
<body>
  <div class="container">
    <h1>Bill Receipt</h1>
    <form id="billing-form">
      <div>
        <label for="customerName">Customer Name:</label>
        <input type="text" id="customerName" required>
      </div>
      <div>
        <label for="customerMobile">Customer Mobile No:</label>
        <input type="text" id="customerMobile" pattern="[0-9]{10}" required>
      </div>
      <div>
        <label for="productName">Product Name:</label>
        <input type="text" id="productName" required>
      </div>
      <div>
        <label for="productQuantity">Quantity:</label>
        <input type="number" id="productQuantity" min="1" required>
      </div>
      <div>
        <label for="productPrice">Price (Per Quantity):</label>
        <input type="number" id="productPrice" step="0.01" min="0" required>
      </div>
      <button type="button" id="addItemButton">Add Items</button>
      <button type="button" id="printButton">Print</button>
    </form>
    <table id="billTable">
      <thead>
        <tr>
          <th>Sr No</th>
          <th>Name</th>
          <th>Quantity</th>
          <th>Price Per Unit</th>
          <th>Total</th>
        </tr>
      </thead>
      <tbody></tbody>
    </table>
    <div id="totalAmount">Total Amount: 0</div>
  </div>
  <script src="script.js"></script>
</body>
</html>
