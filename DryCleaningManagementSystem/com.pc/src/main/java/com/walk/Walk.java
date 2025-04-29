package com.walk;

import java.io.BufferedReader;
import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import org.json.JSONArray;
import org.json.JSONObject;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/BillingServlet")
public class Walk extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        // Database connection settings
        String jdbcURL = "jdbc:mysql://localhost:3306/om";
        String dbUser = "root";
        String dbPassword = "W7301@jqir#";

        Connection connection = null;

        try {
            // Load JDBC driver
            Class.forName("com.mysql.cj.jdbc.Driver");
            connection = DriverManager.getConnection(jdbcURL, dbUser, dbPassword);

            // Read JSON input from the request
            StringBuilder jsonBuilder = new StringBuilder();
            BufferedReader reader = request.getReader();
            String line;
            while ((line = reader.readLine()) != null) {
                jsonBuilder.append(line);
            }

            // Parse the JSON input
            JSONObject jsonData = new JSONObject(jsonBuilder.toString());
            String Pno = jsonData.getString("phone_No");
            String CustomerName = jsonData.getString("CustomerName");
            String prevAmount = jsonData.getString("prevAmount");
            String totalAmount = jsonData.getString("total");
            JSONArray garmentsArray = jsonData.getJSONArray("garments");

            // Convert JSONArray to JSON string for storage
            String garmentsJSON = garmentsArray.toString();

            // Check if entry exists
            String checkIndustrySQL = "SELECT COUNT(*) FROM industry WHERE phone_No = ?";
            PreparedStatement checkIndustryStmt = connection.prepareStatement(checkIndustrySQL);
            checkIndustryStmt.setString(1, Pno);

            ResultSet rsIndustry = checkIndustryStmt.executeQuery();
            rsIndustry.next();
            int industryCount = rsIndustry.getInt(1);

            if (industryCount > 0) {
                // Update `industry` table
                String updateIndustrySQL = "UPDATE industry SET prev_Amount = ?, Total = ?, garment_data = ? WHERE phone_No = ?";
                PreparedStatement updateIndustryStmt = connection.prepareStatement(updateIndustrySQL);
                updateIndustryStmt.setString(1, prevAmount);
                updateIndustryStmt.setString(2, totalAmount);
                updateIndustryStmt.setString(3, garmentsJSON);
                updateIndustryStmt.setString(4, Pno);
                updateIndustryStmt.executeUpdate();
                updateIndustryStmt.close();
                
                System.out.println("Customer Update Successfully  !");
                
            } else {
                // Insert into `industry` table
                String insertIndustrySQL = "INSERT INTO industry(phone_No, customer_name, prev_Amount, Total, garment_data) VALUES (?,?,?,?,?)";
                PreparedStatement insertIndustryStmt = connection.prepareStatement(insertIndustrySQL);
                insertIndustryStmt.setString(1, Pno);
                insertIndustryStmt.setString(2, CustomerName);
                insertIndustryStmt.setString(3, prevAmount);
                insertIndustryStmt.setString(4, totalAmount);
                insertIndustryStmt.setString(5, garmentsJSON);
                insertIndustryStmt.executeUpdate();
                insertIndustryStmt.close();
                
                System.out.println("User Added Successfully  !");
            }

            // Respond with success
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8"); 
            response.setStatus(HttpServletResponse.SC_OK); 
            response.getWriter().write("{\"message\": \"Data processed successfully!\"}");
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error processing data: " + e.getMessage());
        } finally {
            // Ensure resources are closed
            try {
                if (connection != null && !connection.isClosed()) {
                    connection.close();
                }
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
}
