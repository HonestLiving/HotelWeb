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
        // Check if a price parameter is provided in the request
        double minPrice = 0;
        double maxPrice = Double.MAX_VALUE; // Set a default maximum price
        String priceParam = request.getParameter("price");
        if (priceParam != null && !priceParam.isEmpty()) {
            try {
                minPrice = Double.parseDouble(priceParam);
            } catch (NumberFormatException e) {
                // Handle invalid price parameter
                out.println("Invalid price parameter.");
            }
        }

        // Call the searchRooms method with all parameters
        rooms = roomService.searchRooms(0, "", minPrice, maxPrice, 0, false, "", "", "", "");
    } catch (Exception e) {
        out.println("Error fetching rooms: " + e.getMessage());
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
        <label for="price">Enter maximum price:</label>
        <input type="number" id="price" name="price" step="0.01">
        <button type="submit">Search</button>
    </form>
    <table>
        <thead>
            <tr>
                <th>Room Number</th>
                <th>Name</th>
                <th>Price</th>
                <th>Capacity</th>
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
                        <td><%= room.isUpgradable() ? "Yes" : "No" %></td>
                        <td><%= room.getDamages() == null ? "None" : room.getDamages() %></td>
                        <td><%= room.getView() == null ? "N/A" : room.getView() %></td>
                        <td><%= room.getAmenities() == null ? "N/A" : room.getAmenities() %></td>
                        <td><%= room.getAddress() %></td>
                    </tr>
                <% } %>
            <% } else { %>
                <tr>
                    <td colspan="9">No rooms found within the specified price range</td>
                </tr>
            <% } %>
        </tbody>
    </table>
</body>
</html>
