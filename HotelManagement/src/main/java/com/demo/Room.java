package com.demo;

/**
 * Room class to store room data
 */
public class Room {

    private Integer roomNumber;
    private String name;
    private double price;
    private int capacity;
    private boolean upgradable;
    private String damages;
    private String view;
    private String amenities;
    private String address;

    // Constructors
    public Room(Integer roomNumber, String name, double price, int capacity, boolean upgradable, String damages, String view, String amenities, String address) {
        this.roomNumber = roomNumber;
        this.name = name;
        this.price = price;
        this.capacity = capacity;
        this.upgradable = upgradable;
        this.damages = damages;
        this.view = view;
        this.amenities = amenities;
        this.address = address;
    }

    // Getters and Setters
    public Integer getRoomNumber() {
        return roomNumber;
    }

    public void setRoomNumber(Integer roomNumber) {
        this.roomNumber = roomNumber;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public double getPrice() {
        return price;
    }

    public void setPrice(double price) {
        this.price = price;
    }

    public int getCapacity() {
        return capacity;
    }

    public void setCapacity(int capacity) {
        this.capacity = capacity;
    }

    public boolean isUpgradable() {
        return upgradable;
    }

    public void setUpgradable(boolean upgradable) {
        this.upgradable = upgradable;
    }

    public String getDamages() {
        return damages;
    }

    public void setDamages(String damages) {
        this.damages = damages;
    }

    public String getView() {
        return view;
    }

    public void setView(String view) {
        this.view = view;
    }

    public String getAmenities() {
        return amenities;
    }

    public void setAmenities(String amenities) {
        this.amenities = amenities;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    @Override
    public String toString() {
        return "<ul>"
                + "<li>Room Number: " + roomNumber + "</li>"
                + "<li>Name: " + name + "</li>"
                + "<li>Price: $" + price + "</li>"
                + "<li>Capacity: " + capacity + "</li>"
                + "<li>Upgradable: " + (upgradable ? "Yes" : "No") + "</li>"
                + "<li>Damages: " + (damages == null ? "None" : damages) + "</li>"
                + "<li>View: " + (view == null ? "N/A" : view) + "</li>"
                + "<li>Amenities: " + (amenities == null ? "N/A" : amenities) + "</li>"
                + "<li>Address: " + address + "</li>"
                + "</ul>";
    }
}