package com.demo;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class RoomService {

    public List<Room> getRooms() throws Exception {
        String sql = "SELECT * FROM Rooms WHERE availability=TRUE";
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
                        rs.getString("area"),
                        rs.getString("hotel_chain"),
                        rs.getBoolean("upgradable"),
                        rs.getString("damages"),
                        rs.getString("view"),
                        rs.getString("amenities"),
                        rs.getString("address"),
                        rs.getString("hotel")
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

    public String createRoom(Room room) throws Exception {
        String message = "";
        String insertRoomQuery = "INSERT INTO Rooms (name, price, capacity, area, hotel_chain, upgradable, damages, view, amenities, address) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        ConnectionDB db = new ConnectionDB();

        try (Connection con = db.getConnection();
             PreparedStatement stmt = con.prepareStatement(insertRoomQuery)) {

            stmt.setString(1, room.getName());
            stmt.setDouble(2, room.getPrice());
            stmt.setInt(3, room.getCapacity());
            stmt.setString(4, room.getArea());
            stmt.setString(5, room.getHotelChain());
            stmt.setBoolean(6, room.isUpgradable());
            stmt.setString(7, room.getDamages());
            stmt.setString(8, room.getView());
            stmt.setString(9, room.getAmenities());
            stmt.setString(10, room.getAddress());

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

    public List<Room> searchRooms(String name, double minPrice, double maxPrice, int capacity, String area, String hotelChain, String hotel) throws Exception {
        String sql = "SELECT * FROM Rooms WHERE availability=TRUE AND 1 = 1";
        List<Object> params = new ArrayList<>();

        if (!name.isEmpty()) {
            sql += " AND name LIKE ?";
            params.add("%" + name + "%");
        }
        if (minPrice >= 0 && maxPrice >= 0) {
            sql += " AND price BETWEEN ? AND ?";
            params.add(minPrice);
            params.add(maxPrice);
        }
        if (capacity > 0) {
            sql += " AND capacity = ?";
            params.add(capacity);
        }
        if (!area.isEmpty()) {
            sql += " AND area = ?";
            params.add(area);
        }
        if (!hotelChain.isEmpty()) {
            sql += " AND hotel_chain LIKE ?";
            params.add("%" + hotelChain + "%");
        }
        if (!hotel.isEmpty()) {
            sql += " AND hotel LIKE ?";
            params.add("%" + hotel + "%");
        }
        ConnectionDB db = new ConnectionDB();
        try (Connection con = db.getConnection();
             PreparedStatement stmt = con.prepareStatement(sql)) {
            int parameterIndex = 1;
            for (Object param : params) {
                stmt.setObject(parameterIndex++, param);
            }

            ResultSet rs = stmt.executeQuery();
            List<Room> rooms = new ArrayList<>();

            while (rs.next()) {
                Room room = new Room(
                        rs.getInt("room_number"),
                        rs.getString("name"),
                        rs.getDouble("price"),
                        rs.getInt("capacity"),
                        rs.getString("area"),
                        rs.getString("hotel_chain"),
                        rs.getBoolean("upgradable"),
                        rs.getString("damages"),
                        rs.getString("view"),
                        rs.getString("amenities"),
                        rs.getString("address"),
                        rs.getString("hotel")
                );
                rooms.add(room);
            }

            return rooms;
        } catch (SQLException e) {
            throw new Exception("Error fetching rooms: " + e.getMessage());
        }
    }

    public List<Object[]> getAvailableRoomsPerArea() throws Exception {
        String sql = "SELECT * FROM AvailableRoomsPerArea";
        ConnectionDB db = new ConnectionDB();

        try (Connection con = db.getConnection();
             PreparedStatement stmt = con.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {

            List<Object[]> data = new ArrayList<>();
            while (rs.next()) {
                Object[] row = new Object[2];
                row[0] = rs.getString("area");
                row[1] = rs.getInt("num_available_rooms");
                data.add(row);
            }
            return data;
        } catch (SQLException e) {
            throw new Exception("Error fetching available rooms per area: " + e.getMessage());
        }
    }

    public List<Object[]> getAvailableRoomsPerHotel() throws Exception {
        String sql = "SELECT * FROM AvailableRoomsPerHotel";
        ConnectionDB db = new ConnectionDB();

        try (Connection con = db.getConnection();
             PreparedStatement stmt = con.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {

            List<Object[]> data = new ArrayList<>();
            while (rs.next()) {
                Object[] row = new Object[2];
                row[0] = rs.getString("hotel");
                row[1] = rs.getInt("total_capacity");
                data.add(row);
            }
            return data;
        } catch (SQLException e) {
            throw new Exception("Error fetching hotel room capacity: " + e.getMessage());
        }
    }

    public String updateRoom(Room room) throws Exception {
        String message = "";
        String updateRoomQuery = "UPDATE Rooms SET name=?, price=?, capacity=?, area=?, hotel_chain=?, upgradable=?, damages=?, view=?, amenities=?, address=? WHERE room_number=?";
        ConnectionDB db = new ConnectionDB();

        try (Connection con = db.getConnection();
             PreparedStatement stmt = con.prepareStatement(updateRoomQuery)) {

            stmt.setString(1, room.getName());
            stmt.setDouble(2, room.getPrice());
            stmt.setInt(3, room.getCapacity());
            stmt.setString(4, room.getArea());
            stmt.setString(5, room.getHotelChain());
            stmt.setBoolean(6, room.isUpgradable());
            stmt.setString(7, room.getDamages());
            stmt.setString(8, room.getView());
            stmt.setString(9, room.getAmenities());
            stmt.setString(10, room.getAddress());
            stmt.setInt(11, room.getRoomNumber());

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
