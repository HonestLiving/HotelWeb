package com.demo;

/**
 * Employee class to store employee data
 */
public class Employee {

    private Integer id;
    private String name;
    private String sin;
    private String position;
    private String address;

    /**
     * Constructor to save employee's data (without id)
     *
     * @param name     name of employee
     * @param sin      Social Insurance Number of employee
     * @param position position of employee
     * @param address  address of employee
     */
    public Employee(String name, String sin, String position, String address) {
        this.name = name;
        this.sin = sin;
        this.position = position;
        this.address = address;
    }

    /**
     * Constructor to save employee's data (with id)
     *
     * @param id       id of employee
     * @param name     name of employee
     * @param sin      Social Insurance Number of employee
     * @param position position of employee
     * @param address  address of employee
     */
    public Employee(Integer id, String name, String sin, String position, String address) {
        this.id = id;
        this.name = name;
        this.sin = sin;
        this.position = position;
        this.address = address;
    }

    //getters
    public Integer getId() {
        return this.id;
    }

    public String getName() {
        return this.name;
    }

    public String getSin() {
        return this.sin;
    }

    public String getPosition() {
        return this.position;
    }

    public String getAddress() {
        return this.address;
    }

    //setters
    public void setId(Integer id) {
        this.id = id;
    }

    public void setName(String name) {
        this.name = name;
    }

    public void setSin(String sin) {
        this.sin = sin;
    }

    public void setPosition(String position) {
        this.position = position;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    @Override
    public String toString() {
        return "<ul>"
                + "<li>Name: " + name + "</li>"
                + "<li>SIN: " + sin + "</li>"
                + "<li>Position: " + position + "</li>"
                + "<li>Address: " + address + "</li>"
                + "</ul>";
    }
}
