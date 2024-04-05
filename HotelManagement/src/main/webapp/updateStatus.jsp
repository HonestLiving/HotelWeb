<%@ page import="com.demo.BookingStatus" %>
<%@ page contentType="text/plain;charset=UTF-8" language="java" %>
<%
    int roomNumber = Integer.parseInt(request.getParameter("roomNumber"));
    String newStatus = request.getParameter("status");

    BookingStatus bookingStatus = new BookingStatus();
    String updateMessage = bookingStatus.updateStatus(roomNumber, newStatus);
    out.print(updateMessage);
%>
