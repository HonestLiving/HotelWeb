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
        if (name == null) {
            name = "";
        }
        String hotelChain = request.getParameter("hotelChain");
        if (hotelChain == null) {
            hotelChain = "";
        }
        double minPrice = 0;
        double maxPrice = Double.MAX_VALUE; // Set a default maximum price
        String minPriceParam = request.getParameter("minPrice");
        String maxPriceParam = request.getParameter("maxPrice");
        if (minPriceParam != null && !minPriceParam.isEmpty()) {
            minPrice = Double.parseDouble(minPriceParam);
        }
        if (maxPriceParam != null && !maxPriceParam.isEmpty()) {
            maxPrice = Double.parseDouble(maxPriceParam);
        }
        int capacity = 0;
        String capacityParam = request.getParameter("capacity");
        if (capacityParam != null && !capacityParam.isEmpty()) {
            capacity = Integer.parseInt(capacityParam);
        }
        String area = ""; // Change data type to String
        String areaParam = request.getParameter("area");
        if (areaParam != null && !areaParam.isEmpty()) {
            area = areaParam;
        }
        String hotel = request.getParameter("hotel");
                if (hotel == null) {
                    hotel = "";
                }

        // Call the searchRooms method with all parameters
        rooms = roomService.searchRooms(name, minPrice, maxPrice, capacity, area, hotelChain,hotel);
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
        <label for="minPrice">Minimum Price:</label>
        <input type="number" id="minPrice" name="minPrice" step="0.01">
        <br>
        <label for="maxPrice">Maximum Price:</label>
        <input type="number" id="maxPrice" name="maxPrice" step="0.01">
        <br>
        <label for="capacity">Capacity:</label>
        <input type="number" id="capacity" name="capacity">
        <br>
        <label for="area">Area:</label>
        <input type="text" id="area" name="area" step="0.01">
        <br>
        <label for="hotel">Hotel:</label>
        <input type="text" id="hotel" name="hotel">
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
                <th>Hotel</th>
            </tr>
        </thead>
        <tbody>
            <% if (rooms != null && !rooms.isEmpty()) { %>
                <% for (Room room : rooms) { %>
                    <tr>
                        <td><a href="bookings.jsp?roomNumber=<%= room.getRoomNumber() %>"><%= room.getRoomNumber() %></a></td>


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
                        <td><%= room.getHotel() %></td>
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
