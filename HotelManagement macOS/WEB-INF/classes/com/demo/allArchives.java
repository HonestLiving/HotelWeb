package com.demo;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class allArchives {

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
                        rs.getString("hotel"),
                        rs.getString("id")
                );
                archivedBookings.add(archiveBooking);
            }

            rs.close();
            stmt.close();
            con.close();
        } catch (SQLException e) {
            e.printStackTrace();
            throw new RuntimeException("Error fetching archived bookings: " + e.getMessage());
        } catch (Exception e) {
            e.printStackTrace();
            throw new RuntimeException("Error: " + e.getMessage());
        }

        return archivedBookings;
    }
}
