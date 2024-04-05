// EmployeeService.java
package com.demo;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class EmployeeService {

    // Method to get all employees from database
    public List<Employee> getEmployees() throws Exception {
        String sql = "SELECT * FROM employees";
        ConnectionDB db = new ConnectionDB();
        List<Employee> employees = new ArrayList<>();

        try (Connection con = db.getConnection()) {
            PreparedStatement stmt = con.prepareStatement(sql);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                Employee employee = new Employee(
                        rs.getInt("id"),
                        rs.getString("name"),
                        rs.getString("sin"),
                        rs.getString("position"),
                        rs.getString("address")
                );
                employees.add(employee);
            }

            rs.close();
            stmt.close();
            con.close();
            db.close();

            return employees;
        } catch (Exception e) {
            throw new Exception(e.getMessage());
        }
    }

    public String createEmployee(Employee employee) throws Exception {
        String message = "";
        Connection con = null;
        ConnectionDB db = new ConnectionDB();

        String insertEmployeeQuery = "INSERT INTO employees (name, sin, position, address) VALUES (?, ?, ?, ?)";

        try {
            con = db.getConnection();
            PreparedStatement stmt = con.prepareStatement(insertEmployeeQuery);

            stmt.setString(1, employee.getName());
            stmt.setString(2, employee.getSin());
            stmt.setString(3, employee.getPosition());
            stmt.setString(4, employee.getAddress());

            int output = stmt.executeUpdate();

            stmt.close();
            db.close();

            if (output > 0)
                message = "Employee successfully inserted!";
            else
                message = "Failed to insert employee.";

        } catch (Exception e) {
            message = "Error while inserting employee: " + e.getMessage();
        } finally {
            if (con != null)
                con.close();
        }

        return message;
    }

    public String updateEmployee(Employee employee) throws Exception {
        Connection con = null;
        String message = "";

        String sql = "UPDATE employees SET name=?, sin=?, position=?, address=? WHERE id=?";
        ConnectionDB db = new ConnectionDB();

        try {
            con = db.getConnection();
            PreparedStatement stmt = con.prepareStatement(sql);

            stmt.setString(1, employee.getName());
            stmt.setString(2, employee.getSin());
            stmt.setString(3, employee.getPosition());
            stmt.setString(4, employee.getAddress());
            stmt.setInt(5, employee.getId());

            int output = stmt.executeUpdate();

            stmt.close();

            if (output > 0)
                message = "Employee successfully updated!";
            else
                message = "Failed to update employee.";

        } catch (Exception e) {
            message = "Error while updating employee: " + e.getMessage();
        } finally {
            if (con != null)
                con.close();
        }

        return message;
    }
}
