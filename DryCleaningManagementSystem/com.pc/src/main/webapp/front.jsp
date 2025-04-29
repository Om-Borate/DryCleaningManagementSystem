<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Dry-Cleaning Form</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-EVSTQN3/azprG1Anm3QDgpJLIm9Nao0Yz1ztcQTwFspd3yD65VohhpuuCOmLASjC" crossorigin="anonymous">
<style>
  body {
    padding: 20px;
    font-family: Arial, sans-serif;
  }
  header {
    text-align: center;
    font-size: 24px;
    font-weight: bold;
  }
  .note-container {
    margin-top: 20px;
    font-size: 14px;
    color: gray;
  }
  .alert {
    margin-top: 10px;
  }
  textarea {
    resize: none;
}
</style>
</head>
<body>
  <form id="dry-cleaning-form">
    <header>|| Shri ||</header>
    <div class="text-center"><b>Mob: 7972977838</b></div>
    <h1 class="text-center my-3">OM SAI Dry-Cleaning</h1>
    <div class="text-center"><strong>Datta Colony, Jai Malhar Nagar, Thergoan-33</strong></div>
    <div class="corner-box">
        <textarea rows="1" cols="12" placeholder="Type here..."></textarea>
    </div>

    <div class="mb-3">
      <label for="phone" class="form-label">Phone Number:</label>
      <input id="phone" type="tel" name="Pno" class="form-control" placeholder="Enter a valid 10-digit phone number" required pattern="[0-9]{10}">
    </div>

    <div class="mb-3">
      <label for="name" class="form-label">Customer Name:</label>
      <input id="name" type="text" name="CustomerName" class="form-control" placeholder="Customer Name" required>
    </div>

    <div class="my-3">
      <h2>Date and Time</h2>
      <p id="datetime"></p>
    </div>

    <div class="note-container">
      <div>Color runs no guarantee.</div>
      <div>Note: This color may fade over time.</div>
    </div>

    <div class="scrollable-table">
      <table id="data-table" class="table table-bordered">
        <thead>
          <tr>
            <th>Garments</th>
            <th>Qty</th>
            <th>Bal-Clothes</th>
            <th>Amount</th>
          </tr>
        </thead>
        <tbody>
          <!-- Default row -->
        </tbody>
      </table>
    </div>

    <div class="mb-3">
      <label for="prev.Amount" class="form-label">Prev.Amount:</label>
      <input id="prev.Amount" name="prevAmount" class="form-control" placeholder="0.0">
    </div>

    <div class="mb-3">
      <label for="total" class="form-label">Total:</label>
      <input id="total" type="text" name="Total" class="form-control" placeholder="0.0" readonly>
    </div>

    <div class="text-center">
      <button type="button" onclick="submitData()" class="btn btn-primary">Save</button>
      <button type="button" onclick="insertRow()" class="btn btn-secondary">Add Item</button>
      <button type="button" onclick="printBill()" class="btn btn-success">Print Bill</button>
    </div>
  </form>

<script>
document.addEventListener('DOMContentLoaded', () => {
    // Update date and time
    function updateDateTime() {
        const now = new Date();
        document.getElementById('datetime').innerText = now.toLocaleString();
    }
    updateDateTime();
    setInterval(updateDateTime, 1000);
});

function insertRow() {
    const tableBody = document.querySelector("#data-table tbody");
    const newRow = document.createElement("tr");

    newRow.innerHTML = `
      <td><input type="text" name="garments" class="form-control" placeholder="Garments" required></td>
      <td><input type="number" name="Qty" class="form-control" placeholder="Qty" min="0" required></td>
      <td><input type="number" name="Balance" class="form-control" placeholder="Balance" min="0" required></td>
      <td><input type="number" name="Amount" class="form-control amount-input" placeholder="Amount" min="0" required></td>
      <td><button type="button" onclick="deleteRow(this)" class="btn btn-danger">Delete</button></td>
    `;
    tableBody.appendChild(newRow);
    updateTotal();
}
function deleteRow(button) { 
	const row = button.parentElement.parentElement; 
	row.remove(); updateTotal(); }
// Update total amount whenever rows are added/edited
function updateTotal() {
    const amountInputs = document.querySelectorAll(".amount-input");
    let total = 0;

    amountInputs.forEach(input => {
    	const value = parseFloat(input.value) || 0;
        total += value; // Add value or default to 0
    });
	
    const prevAmount = parseFloat(document.getElementById("prev.Amount").value) || 0;
    total += prevAmount;
    
    console.log("Total Amount Calculated:", total);
    document.getElementById("total").value = total.toFixed(2); // Show total in Total field
}

function submitData() {
    const table = document.getElementById("data-table");
    const rows = table.querySelectorAll("tbody tr");
    const garments = [];

    rows.forEach(row => {
        const cells = row.querySelectorAll("input");
        garments.push({
            garments: cells[0].value,
            Qty: parseInt(cells[1].value),
            Balance: parseInt(cells[2].value),
            Amount: parseFloat(cells[3].value),
        });
    });

    const data = {
        phone_No: document.getElementById('phone').value,
        CustomerName: document.getElementById('name').value,
        prevAmount: document.getElementById('prev.Amount').value,
        total: document.getElementById('total').value,
        garments: garments,
    };

    fetch('BillingServlet', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json',
        },
        body: JSON.stringify(data),
    })
    .then(response => {
        if (!response.ok) {
            throw new Error('Network response was not ok');
        }
        return response.json();
    })
    .then(data => {
        console.log('Success:', data);
        alert('Data submitted successfully!');
    })
    .catch((error) => {
        console.error('Error:', error);
        alert('Error submitting data: ' + error.message);
    });
}
function printBill() { 
	window.print(); }

</script>
</body>
</html>