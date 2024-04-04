-- Trigger to prevent booking an unavailable room
CREATE OR REPLACE FUNCTION prevent_unavailable_room_booking()
RETURNS TRIGGER AS $$
DECLARE
    room_available BOOLEAN;
BEGIN
    SELECT availability INTO room_available
    FROM Rooms
    WHERE room_number = NEW.room_number;

    IF NOT room_available THEN
        RAISE EXCEPTION 'Cannot book an unavailable room.';
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER prevent_unavailable_room_booking
BEFORE INSERT ON Bookings
FOR EACH ROW
EXECUTE FUNCTION prevent_unavailable_room_booking();

-- Trigger to automatically change availability
CREATE OR REPLACE FUNCTION update_room_availability()
RETURNS TRIGGER AS $$
BEGIN
    UPDATE Rooms
    SET availability = FALSE
    WHERE room_number = NEW.room_number;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER update_room_availability
AFTER INSERT ON Bookings
FOR EACH ROW
EXECUTE FUNCTION update_room_availability();

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
INSERT INTO Rooms (room_number, name, price, capacity, area, hotel_chain, upgradable, damages, view, amenities, address, availability)
VALUES (100001, 'Luxury Suite', 500.00, 2, 'Toronto', 'Jac Hotels', true, 'None', 'City View', 'Mini Bar, Jacuzzi', 'Address 1', TRUE);

INSERT INTO Rooms (room_number, name, price, capacity, area, hotel_chain, upgradable, damages, view, amenities, address, availability)
VALUES (100002, 'Standard Room', 150.00, 1, 'Toronto', 'Jac Hotels', false, 'Minor scratches on the wall', 'Courtyard View', 'TV, Wi-Fi', 'Address 2', TRUE);

INSERT INTO Rooms (room_number, name, price, capacity, area, hotel_chain, upgradable, damages, view, amenities, address, availability)
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

INSERT INTO Bookings (room_number, Cname, email, in_date, out_date)
VALUES (100001, 'Rishi', 'Rishising', '2024-04-05', '2024-04-08');

SELECT * FROM Bookings;

--Indexes
CREATE INDEX RoomsRoomNum ON Rooms(room_number);
CREATE INDEX BookingsRoomNum ON Bookings(room_number);
CREATE INDEX BookingsDateRange ON Bookings(in_date, out_date);