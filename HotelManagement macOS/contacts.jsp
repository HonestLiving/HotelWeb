<%@ page import="com.demo.HotelService" %>
<%@ page import="com.demo.Hotel" %>
<%@ page import="java.util.List" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Contacts</title>
</head>
<body>

<%
    HotelService hotelService = new HotelService();
    List<Hotel> hotels = null;

    try {
        hotels = hotelService.getHotels();
    } catch (Exception e) {
        out.println("Error: " + e.getMessage());
    }

    if (hotels != null && !hotels.isEmpty()) {
%>

    <h1>Hotels</h1>
    <table border="1">
        <tr>
            <th>Hotel Name</th>
            <th>Address</th>
            <th>Email</th>
            <th>Phone Number</th>
            <th>Rating</th>
        </tr>
        <% for (Hotel hotel : hotels) { %>
            <tr>
                <td><%= hotel.getHotel_name() %></td>
                <td><%= hotel.getAddress() %></td>
                <td><%= hotel.getEmail() %></td>
                <td><%= hotel.getPhoneNumber() %></td>
                <td><%= hotel.getRating() %></td>
            </tr>
        <% } %>
    </table>

<%
    } else {
        out.println("<p>No hotels found.</p>");
    }
%>

</body>
</html>
