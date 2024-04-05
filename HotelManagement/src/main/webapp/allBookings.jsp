<%@ page import="java.util.List" %>
<%@ page import="com.demo.Booking" %>
<%@ page import="com.demo.allBookings" %>
<%@ page import="com.demo.BookingStatus" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%

    allBookings allBookingsObj = new allBookings();
    List<Booking> bookings = null;

    try {
        bookings = allBookingsObj.getAllBookings();
        request.setAttribute("Bookings", bookings);
    } catch (RuntimeException e) {

        e.printStackTrace();
        throw new RuntimeException("Error fetching bookings: " + e.getMessage());

    }
%>
<html>
<head>
    <title>Bookings List</title>
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
    <h2>Bookings List</h2>
    <%-- Debug: Print the size of the bookings list --%>
    <%
        out.println("Number of bookings retrieved: " + (bookings != null ? bookings.size() : 0));
    %>
    <table>
        <thead>
            <tr>
                <th>Room Number</th>
                <th>Customer Name</th>
                <th>Email</th>
                <th>Check-In Date</th>
                <th>Check-Out Date</th>
                <th>Hotel</th>
                <th>Id</th>
                <th>Status</th>
            </tr>
        </thead>
        <tbody>
            <% 
                List<Booking> retrievedBookings = (List<Booking>) request.getAttribute("Bookings");
                if (retrievedBookings != null && !retrievedBookings.isEmpty()) {
                    for (Booking booking : retrievedBookings) {
            %>
                        <tr>
                            <td><%= booking.getRoomNumber() %></td>
                            <td><%= booking.getCustomerName() %></td>
                            <td><%= booking.getEmail() %></td>
                            <td><%= booking.getCheckInDate() %></td>
                            <td><%= booking.getCheckOutDate() %></td>
                            <td><%= booking.getHotel() %></td>
                            <td><%= booking.getId() %></td>
                            <td>
                                <form action="updateStatus.jsp" method="post">
                                    <input type="hidden" name="roomNumber" value="<%= booking.getRoomNumber() %>">
                                    <select name="status" onchange="this.form.submit()">
                                        <option value="Booked" <%= booking.getStatus().equals("Booked") ? "selected" : "" %>>Booked</option>
                                        <option value="Rented" <%= booking.getStatus().equals("Rented") ? "selected" : "" %>>Rented</option>
                                        <option value="Done" <%= booking.getStatus().equals("Done") ? "selected" : "" %>>Done</option>
                                    </select>
                                </form>
                            </td>
                                                
                        </tr>
            <%      }
                } else {
            %>
                    <tr>
                        <td colspan="8">No bookings found</td>
                    </tr>
            <%  }
            %>
        </tbody>
    </table>
   <h3><a href="http://localhost:8080/HotelManagement/allArchives.jsp"><span>Archives</span></a></h3> 
</body>
</html>
