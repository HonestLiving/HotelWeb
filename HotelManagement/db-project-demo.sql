--Table structure for Bookings
DROP TABLE IF EXISTS Bookings;
CREATE TABLE Bookings (
  room_number serial PRIMARY KEY,
  Cname varchar(100) NOT NULL,
  email varchar(100) NOT NULL,
  in_date DATE,
  out_date DATE,
  hotel varchar(100) NOT NULL,
  id varchar(100) NOT NULL
);

INSERT INTO Bookings (room_number, Cname, email, in_date, out_date, hotel, id)
VALUES (100001, 'Rishi', 'Rishising', '2024-04-05', '2024-04-08', 'Meep Hotel', '1122334455667788');

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
DROP TABLE IF EXISTS Rooms CASCADE;
CREATE TABLE Rooms (
  room_number int PRIMARY KEY,
  name varchar(100) NOT NULL,
  price decimal(10,2) NOT NULL,
  capacity int NOT NULL,
  area varchar(100) NOT NULL,
  hotel_chain varchar(100) NOT NULL,
  upgradable boolean NOT NULL,
  damages text,
  view varchar(100),
  amenities text,
  address varchar(200) NOT NULL,
  availability BOOLEAN,
  hotel varchar(100) NOT NULL
);

-- Records of Rooms
INSERT INTO Rooms (room_number, name, price, capacity, area, hotel_chain, upgradable, damages, view, amenities, address, availability, hotel)
VALUES (100001, 'Luxury Suite', 500.00, 2, 'Toronto', 'Jac Hotels', true, 'None', 'City View', 'Mini Bar, Jacuzzi', 'Address 1', TRUE, 'Meep Hotel');

INSERT INTO Rooms (room_number, name, price, capacity, area, hotel_chain, upgradable, damages, view, amenities, address, availability, hotel)
VALUES (100002, 'Standard Room', 150.00, 1, 'Toronto', 'Jac Hotels', false, 'Minor scratches on the wall', 'Courtyard View', 'TV, Wi-Fi', 'Address 2', FALSE, 'Minx Hotel');

INSERT INTO Rooms (room_number, name, price, capacity, area, hotel_chain, upgradable, damages, view, amenities, address, availability, hotel)
VALUES (100003, 'Family Suite', 350.00, 4, 'Markham', 'Bruh Hotels', true, 'None', 'Ocean View', 'Kitchenette, Sofa Bed', 'Address 3', TRUE, 'Lol Hotel');

--Table Structure for Archive
DROP TABLE IF EXISTS BookingsArchive;
CREATE TABLE BookingsArchive (
    room_number INT NOT NULL,
    Cname VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL,
    in_date DATE NOT NULL,
    out_date DATE NOT NULL,
    hotel varchar(100) NOT NULL,
    id varchar(100) NOT NULL
);

-- Insert expired booking into the archive table
CREATE OR REPLACE FUNCTION archiveBookings()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO BookingsArchive (room_number, Cname, email, in_date, out_date, hotel, id)
    VALUES (OLD.room_number, OLD.Cname, OLD.email, OLD.in_date, OLD.out_date, OLD.hotel, OLD.id);

    RETURN OLD;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER archiveBookings
BEFORE DELETE ON Bookings
FOR EACH ROW
WHEN (OLD.out_date < CURRENT_DATE)
EXECUTE PROCEDURE archiveBookings();

SELECT * FROM BookingsArchive;

INSERT INTO BookingsArchive (room_number, Cname, email, in_date, out_date, hotel, id)
VALUES (100001, 'Rishi', 'Rishising', '2024-03-10', '2024-03-11', 'Meep Hotel', '123456789');
INSERT INTO BookingsArchive (room_number, Cname, email, in_date, out_date, hotel, id)
VALUES (100001, 'Kevin', 'bruh@gmail.com', '2024-03-11', '2024-03-12', 'Minx Hotel', '221133554466');
INSERT INTO BookingsArchive (room_number, Cname, email, in_date, out_date, hotel, id)
VALUES (100001, 'Matthew', 'bruh1@gmail.com', '2024-03-12', '2024-03-13', 'Lol Hotel', '331122667744');

--Indexes
CREATE INDEX RoomsRoomNum ON Rooms(room_number);
CREATE INDEX BookingsRoomNum ON Bookings(room_number);
CREATE INDEX BookingsDateRange ON Bookings(in_date, out_date);

--Views
CREATE VIEW AvailableRoomsPerArea AS
SELECT area, COUNT(*) AS num_available_rooms
FROM Rooms
WHERE availability = TRUE
GROUP BY area;

CREATE VIEW AvailableRoomsPerHotel AS
SELECT hotel, SUM(capacity) AS total_capacity
FROM Rooms
GROUP BY hotel;