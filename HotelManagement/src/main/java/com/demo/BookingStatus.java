package com.demo;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

public class BookingStatus {

    public String updateStatus(int roomNumber, String status) {
        String message = "";
        ConnectionDB db = new ConnectionDB();
        String updateQuery = "";

        try {
            try (Connection con = db.getConnection()) {
                switch (status) {
                    case "Booked":
                        updateQuery = "UPDATE Bookings SET status = 'Booked' WHERE room_number = ?";
                        break;
                    case "Rented":
                        updateQuery = "UPDATE Bookings SET status = 'Rented' WHERE room_number = ?";
                        break;
                    case "Done":
                        updateQuery = "UPDATE Bookings SET status = 'Done' WHERE room_number = ?";
                        updateRoomAvailability(con, roomNumber, true);
                        archiveBooking(con, roomNumber);
                        break;
                    default:
                        return "Invalid status";
                }

                try (PreparedStatement stmt = con.prepareStatement(updateQuery)) {
                    stmt.setInt(1, roomNumber);
                    int rowsAffected = stmt.executeUpdate();
                    if (rowsAffected > 0) {
                        message = "Status updated successfully";
                    } else {
                        message = "Status updated succesfully";
                    }
                }
            } catch (SQLException e) {
                message = "Error while updating status: " + e.getMessage();
            }
        } catch (Exception e) {
            message = "Error: " + e.getMessage();
        }

        return message;
    }

    private void updateRoomAvailability(Connection con, int roomNumber, boolean available) throws SQLException {
        String updateRoomQuery = "UPDATE Rooms SET availability = ? WHERE room_number = ?";
        try (PreparedStatement stmt = con.prepareStatement(updateRoomQuery)) {
            stmt.setBoolean(1, available);
            stmt.setInt(2, roomNumber);
            stmt.executeUpdate();
        }
    }

    private void archiveBooking(Connection con, int roomNumber) throws SQLException {
        String insertQuery = "INSERT INTO BookingsArchive (room_number, Cname, email, in_date, out_date, hotel, id) " +
                "SELECT room_number, Cname, email, in_date, out_date, hotel, id FROM Bookings WHERE room_number = ?";
        try (PreparedStatement insertStmt = con.prepareStatement(insertQuery)) {
            insertStmt.setInt(1, roomNumber);
            insertStmt.executeUpdate();
        }

        String deleteQuery = "DELETE FROM Bookings WHERE room_number = ?";
        try (PreparedStatement deleteStmt = con.prepareStatement(deleteQuery)) {
            deleteStmt.setInt(1, roomNumber);
            deleteStmt.executeUpdate();
        }
    }
    
}
