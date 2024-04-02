-- Table structure for Rooms
DROP TABLE IF EXISTS Rooms;
CREATE TABLE Rooms (
  room_number serial PRIMARY KEY,
  name varchar(100) NOT NULL,
  price decimal(10,2) NOT NULL,
  capacity int NOT NULL,
  area decimal(10,2) NOT NULL, -- Adding room area column
  hotel_chain varchar(100) NOT NULL, -- Adding hotel chain column
  upgradable boolean NOT NULL,
  damages text,
  view varchar(100),
  amenities text,
  address varchar(200) NOT NULL
);

-- Records of Rooms
INSERT INTO Rooms (name, price, capacity, area, hotel_chain, upgradable, damages, view, amenities, address)
VALUES ('Luxury Suite', 500.00, 2, 80.00, 'Example Hotels', true, 'None', 'City View', 'Mini Bar, Jacuzzi', 'Address 1');
INSERT INTO Rooms (name, price, capacity, area, hotel_chain, upgradable, damages, view, amenities, address)
VALUES ('Standard Room', 150.00, 1, 30.00, 'Example Hotels', false, 'Minor scratches on the wall', 'Courtyard View', 'TV, Wi-Fi', 'Address 2');
INSERT INTO Rooms (name, price, capacity, area, hotel_chain, upgradable, damages, view, amenities, address)
VALUES ('Family Suite', 350.00, 4, 100.00, 'Example Hotels', true, 'None', 'Ocean View', 'Kitchenette, Sofa Bed', 'Address 3');
