package com.demo;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

public class BookingStatus {

    public String updateStatus(int roomNumber, String status) {
        String message = "";
        ConnectionDB db = new ConnectionDB();
        String updateQuery = "";
        
        // Determine the appropriate SQL query based on the selected status
        switch (status) {
            case "Booked":
                updateQuery = "UPDATE Bookings SET status = 'Booked' WHERE room_number = ?";
                break;
            case "Rented":
                updateQuery = "UPDATE Bookings SET status = 'Rented' WHERE room_number = ?";
                break;
            case "Done":
                updateQuery = "UPDATE Bookings SET status = 'Done' WHERE room_number = ?";
                break;
            default:
                // Handle invalid status
                return "Invalid status";
        }

        try {
            // Attempt to establish a connection and execute the update query
            try (Connection con = db.getConnection();
                 PreparedStatement stmt = con.prepareStatement(updateQuery)) {
                stmt.setInt(1, roomNumber);
                int rowsAffected = stmt.executeUpdate();
                if (rowsAffected > 0) {
                    message = "Status updated successfully";
                } else {
                    message = "No rows updated";
                }
            } catch (SQLException e) {
                // Handle SQL exceptions
                message = "Error while updating status: " + e.getMessage();
            }
        } catch (Exception e) {
            // Handle any other exceptions
            message = "Error: " + e.getMessage();
        }

        return message;
    }
}
