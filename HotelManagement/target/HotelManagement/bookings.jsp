<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Bookings</title>
</head>
<body>
    <h2>Booking Details</h2>
    <form action="processBooking.jsp" method="post">
        <label for="roomNumber">Room Number:</label>
        <input type="text" id="roomNumber" name="roomNumber" value="<%= request.getParameter("roomNumber") %>">
        <br>
        <label for="customerName">Customer Name:</label>
        <input type="text" id="customerName" name="customerName">
        <br>
        <label for="email">Email:</label>
        <input type="email" id="email" name="email">
        <br>
        <label for="checkInDate">Check-In Date:</label>
        <input type="date" id="checkInDate" name="checkInDate">
        <br>
        <label for="checkOutDate">Check-Out Date:</label>
        <input type="date" id="checkOutDate" name="checkOutDate">
        <br>
        <button type="submit">Submit Booking</button>
    </form>
</body>
</html>
