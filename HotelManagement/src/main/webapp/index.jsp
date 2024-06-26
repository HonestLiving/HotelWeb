<%@ page import="java.util.List" %>
<%@ page import="com.demo.Employee" %>
<%@ page import="com.demo.EmployeeService" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    EmployeeService employeeService = new EmployeeService();

    List<Employee> employees = null;
    try {
        employees = employeeService.getEmployees();
    } catch (Exception e) {
        out.println("Error fetching employees: " + e.getMessage());
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Employee List</title>
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
    <h2>Employee List</h2>
    <table>
        <thead>
            <tr>
                <th>ID</th>
                <th>Name</th>
                <th>SIN</th>
                <th>Position</th>
                <th>Address</th>
            </tr>
        </thead>
        <tbody>
            <%
            if (employees != null) { // Check if employees list is not null
                for (Employee employee : employees) {
            %>
            <tr>
                <td><%= employee.getId() %></td>
                <td><%= employee.getName() %></td>
                <td><%= employee.getSin() %></td>
                <td><%= employee.getPosition() %></td>
                <td><%= employee.getAddress() %></td>
            </tr>
            <%
                }
            } else {
            %>
            <tr>
                <td colspan="5">No employees found</td>
            </tr>
            <% } %>
        </tbody>
    </table>
</body>
</html>
