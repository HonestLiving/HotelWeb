package com.demo;
import java.sql.Date;

public class Booking {
    private int room_Number;
    private String cName;
    private String email;
    private Date in_Date;
    private Date out_Date;
    private String hotel;
    private String id;
    private String status;

    public Booking (int room_Number, String cName, String email, Date in_Date, Date out_Date, String hotel, String id, String status) {
        this.room_Number = room_Number;
        this.cName = cName;
        this.email = email;
        this.in_Date = in_Date;
        this.out_Date = out_Date;
        this.hotel = hotel;
        this.id = id;
        this.status = status;
    }

    public Booking () {      
    }

    public Integer getRoomNumber() {
        return room_Number;
    }

    public void setRoomNumber(Integer roomNumber) {
        this.room_Number = roomNumber;
    }

    public String getCustomerName() {
        return cName;
    }

    public void setCustomerName(String customerName) {
        this.cName = customerName;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public Date getCheckInDate() {
        return in_Date;
    }

    public void setCheckInDate(Date checkInDate) {
        this.in_Date = checkInDate;
    }

    public Date getCheckOutDate() {
        return out_Date;
    }

    public void setCheckOutDate(Date checkOutDate) {
        this.out_Date = checkOutDate;
    }

    public String getHotel() {
        return hotel;
    }

    public void setHotel(String hotel) { this.hotel = hotel; }
    public String getId () { return id; }
    public void setId(String id) {this.id = id; }
    public String getStatus () { return status; }
    public void setStatus(String status) {this.status = status; }

       
}
