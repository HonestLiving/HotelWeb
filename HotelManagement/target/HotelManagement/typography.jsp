<%@ page import="java.util.List" %>
<%@ page import="com.demo.Room" %>
<%@ page import="com.demo.RoomService" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    // Instantiate RoomService to access room data
    RoomService roomService = new RoomService();

    // Retrieve list of rooms
    List<Room> rooms = null;
    try {
        // Check if parameters are provided in the request
        String name = request.getParameter("name");
        double minPrice = 0;
        double maxPrice = Double.MAX_VALUE; // Set a default maximum price
        int capacity = 0;
        double area = 0;
        String hotelChain = request.getParameter("hotelChain");

        // Call the searchRooms method with all parameters
        rooms = roomService.searchRooms(name, minPrice, maxPrice, capacity, area, hotelChain);
    } catch (Exception e) {
        out.println("Error fetching rooms: " + e.getMessage());
        return;
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Room List</title>
    <style>
        table {
            border-collapse: collapse;
            width: 100%;
        }
        th, td {
            border: 1px solid #dddddd;
            text-align: left;
            padding: 8px;
        }
        th {
            background-color: #f2f2f2;
        }
    </style>
</head>
<body>
    <h2>Room List</h2>
    <form action="" method="get">
        <label for="name">Room Name:</label>
        <input type="text" id="name" name="name">
        <br>
        <label for="hotelChain">Hotel Chain:</label>
        <input type="text" id="hotelChain" name="hotelChain">
        <br>
        <button type="submit">Search</button>
    </form>
    <table>
        <thead>
            <tr>
                <th>Room Number</th>
                <th>Name</th>
                <th>Price</th>
                <th>Capacity</th>
                <th>Area</th> <!-- New table header for Area -->
                <th>Hotel Chain</th> <!-- New table header for Hotel Chain -->
                <th>Upgradable</th>
                <th>Damages</th>
                <th>View</th>
                <th>Amenities</th>
                <th>Address</th>
            </tr>
        </thead>
        <tbody>
            <% if (rooms != null && !rooms.isEmpty()) { %>
                <% for (Room room : rooms) { %>
                    <tr>
                        <td><%= room.getRoomNumber() %></td>
                        <td><%= room.getName() %></td>
                        <td>$<%= room.getPrice() %></td>
                        <td><%= room.getCapacity() %></td>
                        <td><%= room.getArea() %></td> <!-- Display Area -->
                        <td><%= room.getHotelChain() %></td> <!-- Display Hotel Chain -->
                        <td><%= room.isUpgradable() ? "Yes" : "No" %></td>
                        <td><%= room.getDamages() == null ? "None" : room.getDamages() %></td>
                        <td><%= room.getView() == null ? "N/A" : room.getView() %></td>
                        <td><%= room.getAmenities() == null ? "N/A" : room.getAmenities() %></td>
                        <td><%= room.getAddress() %></td>
                    </tr>
                <% } %>
            <% } else { %>
                <tr>
                    <td colspan="11">No rooms found within the specified criteria</td> <!-- Adjust colspan to accommodate the new columns -->
                </tr>
            <% } %>
        </tbody>
    </table>
</body>
</html>
