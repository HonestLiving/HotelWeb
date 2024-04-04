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

-- Trigger to prevent booking an unavailable room
CREATE OR REPLACE FUNCTION preventDoubleBooking()
RETURNS TRIGGER AS $$
DECLARE
    roomAvailable BOOLEAN;
BEGIN
    SELECT availability INTO roomAvailable
    FROM Rooms
    WHERE room_number = NEW.room_number;

    IF NOT roomAvailable THEN
        RAISE EXCEPTION 'Cannot book an unavailable room.';
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER preventDoubleBooking
BEFORE INSERT ON Bookings
FOR EACH ROW
EXECUTE FUNCTION preventDoubleBooking();

-- Trigger to automatically change availability
CREATE OR REPLACE FUNCTION updateAvailability()
RETURNS TRIGGER AS $$
BEGIN
    UPDATE Rooms
    SET availability = FALSE
    WHERE room_number = NEW.room_number;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER updateAvailability
AFTER INSERT ON Bookings
FOR EACH ROW
EXECUTE FUNCTION updateAvailability();

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

--Table Structure for Archive
DROP TABLE IF EXISTS BookingsArchive;
CREATE TABLE BookingsArchive (
    room_number INT NOT NULL,
    Cname VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL,
    in_date DATE NOT NULL,
    out_date DATE NOT NULL
);

-- Insert expired booking into the archive table
CREATE OR REPLACE FUNCTION archiveBookings()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO BookingsArchive (room_number, Cname, email, in_date, out_date)
    VALUES (OLD.room_number, OLD.Cname, OLD.email, OLD.in_date, OLD.out_date);

    RETURN OLD;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER archiveBookings
BEFORE DELETE ON Bookings
FOR EACH ROW
WHEN (OLD.out_date < CURRENT_DATE)
EXECUTE PROCEDURE archiveBookings();

SELECT * FROM BookingsArchive;

INSERT INTO BookingsArchive (room_number, Cname, email, in_date, out_date)
VALUES (100001, 'Rishi', 'Rishising', '2024-03-10', '2024-03-11');
INSERT INTO BookingsArchive (room_number, Cname, email, in_date, out_date)
VALUES (100001, 'Kevin', 'bruh@gmail.com', '2024-03-11', '2024-03-12');
INSERT INTO BookingsArchive (room_number, Cname, email, in_date, out_date)
VALUES (100001, 'Matthew', 'bruh1@gmail.com', '2024-03-12', '2024-03-13');

--Indexes
CREATE INDEX RoomsRoomNum ON Rooms(room_number);
CREATE INDEX BookingsRoomNum ON Bookings(room_number);
CREATE INDEX BookingsDateRange ON Bookings(in_date, out_date);