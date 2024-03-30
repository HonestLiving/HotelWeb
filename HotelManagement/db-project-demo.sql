-- Table structure for Employees
DROP TABLE IF EXISTS Employees;
CREATE TABLE Employees (
  id serial PRIMARY KEY,
  name varchar(100) NOT NULL,
  sin varchar(100) NOT NULL,
  position varchar(100) NOT NULL,
  address varchar(200) NOT NULL
);

-- Records of Employees
INSERT INTO Employees VALUES (1, 'Cristiano Ronaldo', '123456789', 'Forward', 'Portugal');
INSERT INTO Employees VALUES (2, 'Lionel Messi', '987654321', 'Forward', 'Argentina');
INSERT INTO Employees VALUES (3, 'Pedro Wilkinson', '567890123', 'Midfielder', 'England');

-- Table structure for Rooms
DROP TABLE IF EXISTS Rooms;
CREATE TABLE Rooms (
  room_number serial PRIMARY KEY,
  name varchar(100) NOT NULL,
  price decimal(10,2) NOT NULL,
  capacity int NOT NULL,
  upgradable boolean NOT NULL,
  damages text,
  view varchar(100),
  amenities text,
  address varchar(200) NOT NULL  -- Add the address column here
);

-- Records of Rooms
INSERT INTO Rooms (name, price, capacity, upgradable, damages, view, amenities, address) VALUES ('Luxury Suite', 500.00, 2, true, 'None', 'City View', 'Mini Bar, Jacuzzi', 'Address 1');
INSERT INTO Rooms (name, price, capacity, upgradable, damages, view, amenities, address) VALUES ('Standard Room', 150.00, 1, false, 'Minor scratches on the wall', 'Courtyard View', 'TV, Wi-Fi', 'Address 2');
INSERT INTO Rooms (name, price, capacity, upgradable, damages, view, amenities, address) VALUES ('Family Suite', 350.00, 4, true, 'None', 'Ocean View', 'Kitchenette, Sofa Bed', 'Address 3');
