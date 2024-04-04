<%@ page import="java.util.List" %>
<%@ page import="com.demo.Archive" %>
<%@ page import="com.demo.allArchives" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page errorPage="error.jsp" %>
<%
    // Instantiate the AllArchives class to access bookings
    allArchives allArchivesObj = new allArchives();

    List<Archive> archives = null; // Initialize the list outside the try-catch block

    try {
        // Retrieve all archived bookings from the database
        archives = allArchivesObj.getAllArchives();

        // Set the list of archived bookings as an attribute in the request
        request.setAttribute("Archives", archives);
    } catch (RuntimeException e) {
        // Handle runtime exception
        e.printStackTrace(); // Log the exception for debugging
        throw new RuntimeException("Error fetching archives: " + e.getMessage());
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
    <h2>Archives List</h2>
    <%-- Debug: Print the size of the Archives list --%>
    <%
        out.println("Number of archived bookings retrieved: " + (archives != null ? archives.size() : 0));
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
            </tr>
        </thead>
        <tbody>
            <%
                List<Archive> retrievedArchives = (List<Archive>) request.getAttribute("Archives");
                if (retrievedArchives != null && !retrievedArchives.isEmpty()) {
                    for (Archive archive : retrievedArchives) {
            %>
                        <tr>
                            <td><%= archive.getRoomNumber() %></td>
                            <td><%= archive.getCustomerName() %></td>
                            <td><%= archive.getEmail() %></td>
                            <td><%= archive.getCheckInDate() %></td>
                            <td><%= archive.getCheckOutDate() %></td>
                            <td><%= archive.getHotel() %></td>
                        </tr>
            <%      }
                } else {
            %>
                    <tr>
                        <td colspan="6">No Archived Bookings found</td>
                    </tr>
            <%  }
            %>
        </tbody>
    </table>
</body>
</html>
