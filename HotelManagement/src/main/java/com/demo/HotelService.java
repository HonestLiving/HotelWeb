package com.demo;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class HotelService {

    // Method to get all hotels from database
    public List<Hotel> getHotels() throws Exception {
        String sql = "SELECT * FROM hotels";
        ConnectionDB db = new ConnectionDB();
        List<Hotel> hotels = new ArrayList<>();

        try (Connection con = db.getConnection()) {
            PreparedStatement stmt = con.prepareStatement(sql);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                Hotel hotel = new Hotel(
                        rs.getString("hotel_name"),
                        rs.getString("address"),
                        rs.getString("email"),
                        rs.getString("phone_number"),
                        rs.getInt("rating")
                );
                hotels.add(hotel);
            }

            rs.close();
            stmt.close();
            con.close();
            db.close();

            return hotels;
        } catch (Exception e) {
            throw new Exception(e.getMessage());
        }
    }

    // Method to create a hotel in the database
    public String createHotel(Hotel hotel) throws Exception {
        String message = "";
        Connection con = null;
        ConnectionDB db = new ConnectionDB();

        String insertHotelQuery = "INSERT INTO hotels (address, email, phone_number, rating) VALUES (?, ?, ?, ?)";

        try {
            con = db.getConnection();
            PreparedStatement stmt = con.prepareStatement(insertHotelQuery);

            stmt.setString(1, hotel.getHotel_name());
            stmt.setString(2, hotel.getAddress());
            stmt.setString(3, hotel.getEmail());
            stmt.setString(4, hotel.getPhoneNumber());
            stmt.setInt(5, hotel.getRating());

            int output = stmt.executeUpdate();

            stmt.close();
            db.close();

            if (output > 0)
                message = "Hotel successfully inserted!";
            else
                message = "Failed to insert hotel.";

        } catch (Exception e) {
            message = "Error while inserting hotel: " + e.getMessage();
        } finally {
            if (con != null)
                con.close();
        }

        return message;
    }

    // Method to update hotel
    public String updateHotel(Hotel hotel) throws Exception {
        Connection con = null;
        String message = "";

        String sql = "UPDATE hotels SET address=?, email=?, phone_number=?, rating=? WHERE id=?";
        ConnectionDB db = new ConnectionDB();

        try {
            con = db.getConnection();
            PreparedStatement stmt = con.prepareStatement(sql);

            stmt.setString(1, hotel.getAddress());
            stmt.setString(2, hotel.getEmail());
            stmt.setString(3, hotel.getPhoneNumber());
            stmt.setInt(4, hotel.getRating());

            int output = stmt.executeUpdate();

            stmt.close();

            if (output > 0)
                message = "Hotel successfully updated!";
            else
                message = "Failed to update hotel.";

        } catch (Exception e) {
            message = "Error while updating hotel: " + e.getMessage();
        } finally {
            if (con != null)
                con.close();
        }

        return message;
    }
}
