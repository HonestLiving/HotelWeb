package com.demo;

/**
 * Hotel class to store hotel data
 */
public class Hotel {
    private String hotel_name;
    private String address;
    private String email;
    private String phoneNumber;
    private int rating;

    /**
     * Constructor to save hotel's data
     *
     * @param address     address of hotel
     * @param email       email of hotel
     * @param phoneNumber phone number of hotel
     * @param rating      rating of hotel
     */
    public Hotel(String hotel_name, String address, String email, String phoneNumber, int rating) {
        this.hotel_name = hotel_name;
        this.address = address;
        this.email = email;
        this.phoneNumber = phoneNumber;
        this.rating = rating;
    }

    //getters
    public String getHotel_name() {
        return hotel_name;
    }
    public String getAddress() {
        return address;
    }

    public String getEmail() {
        return email;
    }

    public String getPhoneNumber() {
        return phoneNumber;
    }

    public int getRating() {
        return rating;
    }

    //setters
    public void setAddress(String address) {
        this.address = address;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public void setPhoneNumber(String phoneNumber) {
        this.phoneNumber = phoneNumber;
    }

    public void setRating(int rating) {
        this.rating = rating;
    }

    @Override
    public String toString() {
        return "<ul>"
                + "<li>Address: " + address + "</li>"
                + "<li>Email: " + email + "</li>"
                + "<li>Phone Number: " + phoneNumber + "</li>"
                + "<li>Rating: " + rating + "</li>"
                + "</ul>";
    }
}
