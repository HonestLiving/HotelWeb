-- Table structure for Rooms
DROP TABLE IF EXISTS Rooms;
CREATE TABLE Rooms (
  room_number int PRIMARY KEY,
  name varchar(100) NOT NULL,
  price decimal(10,2) NOT NULL,
  capacity int NOT NULL,
  area varchar(100) NOT NULL, -- Adding room area column
  hotel_chain varchar(100) NOT NULL, -- Adding hotel chain column
  upgradable boolean NOT NULL,
  damages text,
  view varchar(100),
  amenities text,
  address varchar(200) NOT NULL,
  availability BOOLEAN
);

-- Records of Rooms
INSERT INTO Rooms (room_number, name, price, capacity, area, hotel_chain, upgradable, damages, view, amenities, address)
VALUES (100001, 'Luxury Suite', 500.00, 2, 'Toronto', 'Jac Hotels', true, 'None', 'City View', 'Mini Bar, Jacuzzi', 'Address 1', TRUE);

INSERT INTO Rooms (room_number, name, price, capacity, area, hotel_chain, upgradable, damages, view, amenities, address)
VALUES (100002, 'Standard Room', 150.00, 1, 'Toronto', 'Jac Hotels', false, 'Minor scratches on the wall', 'Courtyard View', 'TV, Wi-Fi', 'Address 2', TRUE);

INSERT INTO Rooms (room_number, name, price, capacity, area, hotel_chain, upgradable, damages, view, amenities, address)
VALUES (100003, 'Family Suite', 350.00, 4, 'Markham', 'Bruh Hotels', true, 'None', 'Ocean View', 'Kitchenette, Sofa Bed', 'Address 3', TRUE);

--Table structure for Bookings
DROP TABLE IF EXISTS Bookings;
CREATE TABLE Bookings (
  room_number serial PRIMARY KEY,
  Cname varchar(100) NOT NULL,
  email varchar(100) NOT NULL,
  in_date DATE,
  out_date DATE
);


