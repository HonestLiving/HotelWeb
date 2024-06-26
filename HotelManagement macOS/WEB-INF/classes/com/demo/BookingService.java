package com.demo;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

public class BookingService {
    public String createBooking(Booking booking) {
        String message = "";
        String insertBookingQuery = "INSERT INTO Bookings (room_number, Cname, email, in_date, out_date, hotel, id, status) VALUES (?, ?, ?, ?, ?, ?, ?, CAST(? AS Booking_status))";
        ConnectionDB db = new ConnectionDB();

        try (Connection con = db.getConnection();
             PreparedStatement stmt = con.prepareStatement(insertBookingQuery)) {

            stmt.setInt(1, booking.getRoomNumber());
            stmt.setString(2, booking.getCustomerName());
            stmt.setString(3, booking.getEmail());
            stmt.setDate(4, booking.getCheckInDate());
            stmt.setDate(5, booking.getCheckOutDate());
            stmt.setString(6, booking.getHotel());
            stmt.setString(7, booking.getId());
            stmt.setString(8, "Booked");

            int rowsInserted = stmt.executeUpdate();
            if (rowsInserted > 0) {
                updateRoomAvailability(con, booking.getRoomNumber(), false);
                message = "Booking successfully inserted!";
            } else {
                message = "Failed to insert booking.";
            }

        } catch (Exception e) {
            message = "Error while inserting booking: " + e.getMessage();
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
}
