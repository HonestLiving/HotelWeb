package com.demo;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class allArchives {

    // Method to retrieve all bookings from the database
    public List<Archive> getAllArchives() {
        String sql = "SELECT * FROM BookingsArchive;";
        ConnectionDB db = new ConnectionDB();
        List<Archive> archivedBookings = new ArrayList<>();

        try {
            Connection con = db.getConnection();
            PreparedStatement stmt = con.prepareStatement(sql);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                Archive archiveBooking = new Archive(
                        rs.getInt("room_number"),
                        rs.getString("Cname"),
                        rs.getString("email"),
                        rs.getDate("in_date"),
                        rs.getDate("out_date"),
                        rs.getString("hotel")
                );
                archivedBookings.add(archiveBooking);
            }

            rs.close();
            stmt.close();
            con.close(); // Close the connection
        } catch (SQLException e) {
            // Log the exception or handle it appropriately
            e.printStackTrace();
            // Rethrow it as a runtime exception to maintain the method signature
            throw new RuntimeException("Error fetching archived bookings: " + e.getMessage());
        } catch (Exception e) {
            // Handle other exceptions, if any
            e.printStackTrace();
            // Rethrow it as a runtime exception
            throw new RuntimeException("Error: " + e.getMessage());
        }

        return archivedBookings;
    }
}
