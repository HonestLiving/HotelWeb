<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
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
    <table>
        <thead>
            <tr>
                <th>Room Number</th>
                <th>Customer Name</th>
                <th>Email</th>
                <th>Check-In Date</th>
                <th>Check-Out Date</th>
            </tr>
        </thead>
        <tbody>
            <% 
                try {
                    // Establish database connection
                    Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/your_database", "username", "password");

                    // Query to retrieve bookings
                    String query = "SELECT * FROM Bookings";
                    PreparedStatement stmt = con.prepareStatement(query);
                    ResultSet rs = stmt.executeQuery();

                    // Iterate over the result set and display each booking
                    while (rs.next()) {
                        out.println("<tr>");
                        out.println("<td>" + rs.getInt("room_number") + "</td>");
                        out.println("<td>" + rs.getString("Cname") + "</td>");
                        out.println("<td>" + rs.getString("email") + "</td>");
                        out.println("<td>" + rs.getDate("in_date") + "</td>");
                        out.println("<td>" + rs.getDate("out_date") + "</td>");
                        out.println("</tr>");
                    }

                    // Close resources
                    rs.close();
                    stmt.close();
                    con.close();
                } catch (SQLException e) {
                    out.println("Error fetching bookings: " + e.getMessage());
                }
            %>
        </tbody>
    </table>
</body>
</html>
