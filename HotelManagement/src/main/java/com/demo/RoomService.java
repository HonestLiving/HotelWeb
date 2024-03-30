// RoomService.java
package com.demo;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class RoomService {

    // Method to get all rooms from database
    public List<Room> getRooms() throws Exception {
        String sql = "SELECT * FROM Rooms";
        ConnectionDB db = new ConnectionDB();
        List<Room> rooms = new ArrayList<>();

        try (Connection con = db.getConnection()) {
            PreparedStatement stmt = con.prepareStatement(sql);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                Room room = new Room(
                        rs.getInt("room_number"),
                        rs.getString("name"),
                        rs.getDouble("price"),
                        rs.getInt("capacity"),
                        rs.getBoolean("upgradable"),
                        rs.getString("damages"),
                        rs.getString("view"),
                        rs.getString("amenities"),
                        rs.getString("address")
                );
                rooms.add(room);
            }

            rs.close();
            stmt.close();
            db.close();

            return rooms;
        } catch (Exception e) {
            throw new Exception("Error fetching rooms: " + e.getMessage());
        }
    }

    // Method to create a room in the database
    public String createRoom(Room room) throws Exception {
        String message = "";
        String insertRoomQuery = "INSERT INTO Rooms (name, price, capacity, upgradable, damages, view, amenities, address) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        ConnectionDB db = new ConnectionDB();

        try (Connection con = db.getConnection();
             PreparedStatement stmt = con.prepareStatement(insertRoomQuery)) {

            stmt.setString(1, room.getName());
            stmt.setDouble(2, room.getPrice());
            stmt.setInt(3, room.getCapacity());
            stmt.setBoolean(4, room.isUpgradable());
            stmt.setString(5, room.getDamages());
            stmt.setString(6, room.getView());
            stmt.setString(7, room.getAmenities());
            stmt.setString(8, room.getAddress());

            int rowsInserted = stmt.executeUpdate();
            if (rowsInserted > 0) {
                message = "Room successfully inserted!";
            } else {
                message = "Failed to insert room.";
            }

        } catch (Exception e) {
            throw new Exception("Error while inserting room: " + e.getMessage());
        }

        return message;
    }

    // Modified method to search rooms with optional parameters
    public List<Room> searchRooms(int roomNumber, String name, double minPrice, double maxPrice, int capacity, boolean upgradable, String damages, String view, String amenities, String address) throws Exception {
        // Construct the base SQL query
        StringBuilder sqlBuilder = new StringBuilder("SELECT * FROM Rooms WHERE 1 = 1");

        // Add conditions for the provided parameters
        if (roomNumber > 0) {
            sqlBuilder.append(" AND room_number = ?");
        }
        if (name != null && !name.isEmpty()) {
            sqlBuilder.append(" AND name LIKE ?");
        }
        if (minPrice >= 0 && maxPrice >= 0) {
            sqlBuilder.append(" AND price BETWEEN ? AND ?");
        }
        if (capacity > 0) {
            sqlBuilder.append(" AND capacity = ?");
        }
        if (upgradable) {
            sqlBuilder.append(" AND upgradable = true");
        }
        if (damages != null && !damages.isEmpty()) {
            sqlBuilder.append(" AND damages LIKE ?");
        }
        if (view != null && !view.isEmpty()) {
            sqlBuilder.append(" AND view LIKE ?");
        }
        if (amenities != null && !amenities.isEmpty()) {
            sqlBuilder.append(" AND amenities LIKE ?");
        }
        if (address != null && !address.isEmpty()) {
            sqlBuilder.append(" AND address LIKE ?");
        }

        String sql = sqlBuilder.toString();

        // Execute the SQL query with the provided parameters
        ConnectionDB db = new ConnectionDB();
        List<Room> rooms = new ArrayList<>();

        try (Connection con = db.getConnection();
             PreparedStatement stmt = con.prepareStatement(sql)) {
            int parameterIndex = 1;

            if (roomNumber > 0) {
                stmt.setInt(parameterIndex++, roomNumber);
            }
            if (name != null && !name.isEmpty()) {
                stmt.setString(parameterIndex++, "%" + name + "%");
            }
            if (minPrice >= 0 && maxPrice >= 0) {
                stmt.setDouble(parameterIndex++, minPrice);
                stmt.setDouble(parameterIndex++, maxPrice);
            }
            if (capacity > 0) {
                stmt.setInt(parameterIndex++, capacity);
            }
            if (damages != null && !damages.isEmpty()) {
                stmt.setString(parameterIndex++, "%" + damages + "%");
            }
            if (view != null && !view.isEmpty()) {
                stmt.setString(parameterIndex++, "%" + view + "%");
            }
            if (amenities != null && !amenities.isEmpty()) {
                stmt.setString(parameterIndex++, "%" + amenities + "%");
            }
            if (address != null && !address.isEmpty()) {
                stmt.setString(parameterIndex++, "%" + address + "%");
            }

            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                Room room = new Room(
                        rs.getInt("room_number"),
                        rs.getString("name"),
                        rs.getDouble("price"),
                        rs.getInt("capacity"),
                        rs.getBoolean("upgradable"),
                        rs.getString("damages"),
                        rs.getString("view"),
                        rs.getString("amenities"),
                        rs.getString("address")
                );
                rooms.add(room);
            }

            rs.close();
        } catch (Exception e) {
            throw new Exception("Error fetching rooms: " + e.getMessage());
        }

        return rooms;
    }

    // Method to update room
    public String updateRoom(Room room) throws Exception {
        String message = "";
        String updateRoomQuery = "UPDATE Rooms SET name=?, price=?, capacity=?, upgradable=?, damages=?, view=?, amenities=?, address=? WHERE room_number=?";
        ConnectionDB db = new ConnectionDB();

        try (Connection con = db.getConnection();
             PreparedStatement stmt = con.prepareStatement(updateRoomQuery)) {

            stmt.setString(1, room.getName());
            stmt.setDouble(2, room.getPrice());
            stmt.setInt(3, room.getCapacity());
            stmt.setBoolean(4, room.isUpgradable());
            stmt.setString(5, room.getDamages());
            stmt.setString(6, room.getView());
            stmt.setString(7, room.getAmenities());
            stmt.setString(8, room.getAddress());
            stmt.setInt(9, room.getRoomNumber());

            int rowsUpdated = stmt.executeUpdate();
            if (rowsUpdated > 0) {
                message = "Room successfully updated!";
            } else {
                message = "Failed to update room.";
            }

        } catch (Exception e) {
            throw new Exception("Error while updating room: " + e.getMessage());
        }

        return message;
    }
}
