package com.demo;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class allBookings {

    public List<Booking> getAllBookings() {
        String sql = "SELECT * FROM Bookings";
        ConnectionDB db = new ConnectionDB();
        List<Booking> bookings = new ArrayList<>();

        try {
            Connection con = db.getConnection();
            PreparedStatement stmt = con.prepareStatement(sql);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                Booking booking = new Booking(
                        rs.getInt("room_number"),
                        rs.getString("Cname"),
                        rs.getString("email"),
                        rs.getDate("in_date"),
                        rs.getDate("out_date"),
                        rs.getString("hotel"),
                        rs.getString("id"),
                        rs.getString("status")
                );
                bookings.add(booking);
            }

            rs.close();
            stmt.close();
            con.close();
        } catch (SQLException e) {
            e.printStackTrace();
            throw new RuntimeException("Error fetching bookings: " + e.getMessage());
        } catch (Exception e) {
            e.printStackTrace();
            throw new RuntimeException("Error: " + e.getMessage());
        }

        return bookings;
    }
}
