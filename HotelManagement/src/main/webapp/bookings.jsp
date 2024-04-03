<%@ page import="com.demo.Booking" %>
<%@ page import="com.demo.BookingService" %>
<%@ page import="java.sql.Date" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    // Retrieve form parameters
    int roomNumber = Integer.parseInt(request.getParameter("roomNumber"));
    String customerName = request.getParameter("customerName");
    String email = request.getParameter("email");
    Date checkInDate = null;
    Date checkOutDate = null;
    try {
        checkInDate = Date.valueOf(request.getParameter("checkInDate"));
        checkOutDate = Date.valueOf(request.getParameter("checkOutDate"));
    } catch (IllegalArgumentException e) {
        out.println("Invalid date format. Please enter dates in yyyy-MM-dd format.");
        return;
    }

    // Create Booking object
    Booking booking = new Booking();
    booking.setRoomNumber(roomNumber);
    booking.setCustomerName(customerName);
    booking.setEmail(email);
    booking.setCheckInDate(checkInDate);
    booking.setCheckOutDate(checkOutDate);

    // Insert booking into the database
    BookingService bookingService = new BookingService();
    String message = bookingService.createBooking(booking);

    // Redirect to a confirmation page
    response.sendRedirect("confirmation.jsp?message=" + message);
%>



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
