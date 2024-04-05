DROP TYPE IF EXISTS Booking_status CASCADE;
CREATE TYPE Booking_status AS ENUM ('Booked', 'Rented', 'Done');

--Table structure for Bookings
DROP TABLE IF EXISTS Bookings;
CREATE TABLE Bookings (
  room_number serial PRIMARY KEY,
  Cname varchar(100) NOT NULL,
  email varchar(100) NOT NULL,
  in_date DATE,
  out_date DATE,
  hotel varchar(100) NOT NULL,
  id varchar(100) NOT NULL,
  status Booking_status
);

INSERT INTO Bookings (room_number, Cname, email, in_date, out_date, hotel, id, status)
VALUES (100001, 'Rishi', 'Rishising', '2024-04-05', '2024-04-08', 'Meep Hotel', '1122334455667788', 'Booked');
INSERT INTO Bookings (room_number, Cname, email, in_date, out_date, hotel, id, status)
VALUES (1000, 'Rishi', 'Rishising', '2024-04-05', '2024-04-08', 'Meep Hotel', '1122334455667788', 'Rented');

UPDATE Bookings SET status = 'Done' WHERE room_number = 1000;
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
VALUES (100002, 'Standard Room', 150.00, 1, 'Toronto', 'Jac Hotels', false, 'Minor scratches on the wall', 'Courtyard View', 'TV, Wi-Fi', 'Address 2', TRUE, 'Minx Hotel');

INSERT INTO Rooms (room_number, name, price, capacity, area, hotel_chain, upgradable, damages, view, amenities, address, availability, hotel)
VALUES (100003, 'Family Suite', 350.00, 4, 'Markham', 'Bruh Hotels', true, 'None', 'Ocean View', 'Kitchenette, Sofa Bed', 'Address 3', TRUE, 'Lol Hotel');

SELECT * FROM Rooms;

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

-- Table Structure for Hotels
DROP TABLE IF EXISTS Hotels;
CREATE TABLE Hotels (
    hotel_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL,
    address VARCHAR(255) NOT NULL,
    phone_number VARCHAR(20) NOT NULL,
    rating INT
);
-- Inserting example data into Hotels table with a rating of 3 for each hotel
INSERT INTO hotels (hotel_name, email, address, phone_number, rating)
VALUES
    ('Qol Hotel', 'qolhotel@example.com', '123 Beach Ave, Markham', '+1234567890', 1),
    ('Pol Hotel', 'polhotel@example.com', '111 Hilltop Rd, Markham', '+1234567890', 3),
    ('Lol Hotel', 'lolhotel@example.com', '123 River Rd, Markham', '+1234567890',4),
    ('Dol Hotel', 'dolhotel@example.com', '111 Lakeshore Dr, Markham', '+1234567890', 3),
    ('Jol Hotel', 'jolhotel@example.com', '123 Riverside Dr, Markham', '+1234567890', 3),
    ('Kol Hotel', 'kolhotel@example.com', '111 Skyline Ave, Markham', '+1234567890', 5),
    ('Mol Hotel', 'molhotel@example.com', '123 Mountain Ave, Markham', '+1234567890', 3),
    ('Jax Hotel', 'jaxhotel@example.com', '65 Jax St', '+1234567890', 3),
    ('Lmao Hotel', 'lmaohotel@example.com', '55 Lmao St', '+1234567890', 2),
    ('Meep Hotel', 'meephotel@example.com', '65 Meep St', '+1234567890', 3),
    ('Troll Hotel', 'trollhotel@example.com', '65 Troll St', '+1234567890', 1),
    ('Bingus Hotel', 'bingushotel@example.com', '55 Bingus St', '+1234567890', 3),
    ('Deep Hotel', 'deephotel@example.com', '65 Deep St', '+1234567890', 2),
    ('Teep Hotel', 'teephotel@example.com', '55 Teep St', '+1234567890', 3),
    ('Ooga Hotel', 'oogahotel@example.com', '55 Ooga St', '+1234567890', 4),
    ('Toga Hotel', 'togahotel@example.com', '55 Toga St, Toronto', '+1234567890', 1),
    ('Mulu Hotel', 'muluhotel@example.com', '55 Mulu St, Toronto', '+1234567890', 1),
    ('Julu Hotel', 'juluhotel@example.com', '55 Julu St, Toronto', '+1234567890', 2),
    ('Hulu Hotel', 'huluhotel@example.com', '55 Hulu St, Toronto', '+1234567890', 5),
    ('Kulu Hotel', 'kuluhotel@example.com', '55 Kulu St, Toronto', '+1234567890', 3),
    ('Krollo Hotel', 'krollohotel@example.com', '55 Krollo St, Toronto', '+1234567890', 2),
    ('Olu Hotel', 'oluhotel@example.com', '55 Olu St, Toronto', '+1234567890', 1),
    ('Polu Hotel', 'poluhotel@example.com', '55 Polu St, Toronto', '+1234567890', 4),
    ('Chingus Hotel', 'chingushotel@example.com', '55 Chingus St, Toronto', '+1234567890', 4),
    ('Linugs Hotel', 'linugshotel@example.com', '55 Linugs St, Toronto', '+1234567890', 5),
    ('Minugs Hotel', 'minugshotel@example.com', '55 Minugs St, Toronto', '+1234567890', 5),
    ('Fringus Hotel', 'fringushotel@example.com', '55 Fringus St, Toronto', '+1234567890', 5),
    ('Yingus Hotel', 'yingushotel@example.com', '55 Yingus St, Toronto', '+1234567890', 1),
    ('Yongus Hotel', 'yongushotel@example.com', '55 Yongus St, Toronto', '+1234567890', 1),
    ('Kingus Hotel', 'kingushotel@example.com', '55 Kingus St, Toronto', '+1234567890', 1),
    ('Oogus Hotel', 'oogushotel@example.com', '55 Oogus St, Toronto', '+1234567890', 2),
    ('Ayaya Hotel', 'ayayahotel@example.com', '55 Ayaya St, Toronto', '+1234567890', 3),
    ('Dayaya Hotel', 'dayayahotel@example.com', '55 Dayaya St, Toronto', '+1234567890', 3),
    ('Gogogo Hotel', 'gogogohotel@example.com', '55 Gogogo St, Toronto', '+1234567890', 4),
    ('Dingdingding Hotel', 'dingdingdinghotel@example.com', '55 Dingdingding St, Toronto', '+1234567890', 3),
    ('Mingming Hotel', 'mingminghotel@example.com', '55 Mingming St, Toronto', '+1234567890', 3),
    ('Ringring Hotel', 'ringringhotel@example.com', '55 Ringring St, Toronto', '+1234567890', 5),
    ('Hohoho Hotel', 'hohohohotel@example.com', '55 Hohoho St, Toronto', '+1234567890', 3),
    ('Jojojo Hotel', 'jojojohotel@example.com', '55 Jojojo St, Toronto', '+1234567890', 3),
    ('Goo Hotel', 'goohotel@example.com', '55 Goo St, Toronto', '+1234567890', 1),
    ('More Goo Hotel', 'moregoohotel@example.com', '55 More Goo St, Toronto', '+1234567890', 2),
    ('Even More Goo Hotel', 'evenmoregoohotel@example.com', '55 Even More Goo St, Toronto', '+1234567890', 3),
    ('Still Goo Hotel', 'stillgoohotel@example.com', '55 Still Goo St, Toronto', '+1234567890', 3),
    ('Wow More Goo Hotel', 'wowmoregoohotel@example.com', '55 Wow More Goo St, Toronto', '+1234567890', 3),
    ('Dang Its Goo Hotel', 'dangitsgoohotel@example.com', '55 Dang Its Goo St, Toronto', '+1234567890', 3),
    ('Wow Goo Hotel', 'wowgoohotel@example.com', '55 Wow Goo St, Toronto', '+1234567890', 3),
    ('Welp Goo Hotel', 'welpgoohotel@example.com', '55 Welp Goo St, Toronto', '+1234567890', 4);


--Bruh Hotels
-- Qol Hotel
INSERT INTO Rooms (room_number, name, price, capacity, area, hotel_chain, upgradable, damages, view, amenities, address, availability, hotel)
VALUES
    (100004, 'Ocean View Suite', 400.00, 2, 'Markham', 'Bruh Hotels', true, 'None', 'Ocean View', 'Kitchenette, Jacuzzi', '123 Beach Ave, Markham', TRUE, 'Qol Hotel'),
    (100005, 'Luxury Room', 250.00, 1, 'Markham', 'Bruh Hotels', false, 'Minor scratches on furniture', 'City View', 'Mini Bar, Wi-Fi', '456 Palm St, Markham', TRUE, 'Qol Hotel'),
    (100006, 'Family Suite', 500.00, 4, 'Markham', 'Bruh Hotels', true, 'None', 'Ocean View', 'Kitchenette, Sofa Bed', '789 Shoreline Dr, Markham', TRUE, 'Qol Hotel'),
    (100007, 'City View Suite', 350.00, 3, 'Markham', 'Bruh Hotels', true, 'None', 'City View', 'Kitchenette, Gym', '101 Sunset Blvd, Markham', TRUE, 'Qol Hotel'),
    (100008, 'Standard Room', 150.00, 2, 'Markham', 'Bruh Hotels', false, 'None', 'Street View', 'TV, Wi-Fi', '202 Coastal Rd, Markham', TRUE, 'Qol Hotel');

-- Pol Hotel
INSERT INTO Rooms (room_number, name, price, capacity, area, hotel_chain, upgradable, damages, view, amenities, address, availability, hotel)
VALUES
    (100009, 'Deluxe Suite', 600.00, 3, 'Markham', 'Bruh Hotels', true, 'None', 'City View', 'Mini Bar, Jacuzzi', '111 Hilltop Rd, Markham', TRUE, 'Pol Hotel'),
    (100010, 'Executive Room', 300.00, 2, 'Markham', 'Bruh Hotels', false, 'None', 'City View', 'Mini Fridge, Wi-Fi', '222 Valley View Dr, Markham', TRUE, 'Pol Hotel'),
    (100011, 'Ocean View Suite', 450.00, 2, 'Markham', 'Bruh Hotels', true, 'None', 'Ocean View', 'Kitchenette, Sofa Bed', '333 Lakeside Ave, Markham', TRUE, 'Pol Hotel'),
    (100012, 'Family Suite', 400.00, 4, 'Markham', 'Bruh Hotels', true, 'None', 'City View', 'Kitchenette, Sofa Bed', '444 Riverside Dr, Markham', TRUE, 'Pol Hotel'),
    (100013, 'Standard Room', 200.00, 2, 'Markham', 'Bruh Hotels', false, 'None', 'Street View', 'TV, Wi-Fi', '555 Hillcrest Rd, Markham', TRUE, 'Pol Hotel');

-- Lol Hotel
INSERT INTO Rooms (room_number, name, price, capacity, area, hotel_chain, upgradable, damages, view, amenities, address, availability, hotel)
VALUES
    (100014, 'Deluxe Suite', 600.00, 3, 'Markham', 'Bruh Hotels', true, 'None', 'City View', 'Mini Bar, Jacuzzi', '123 River Rd, Markham', TRUE, 'Lol Hotel'),
    (100015, 'Executive Room', 300.00, 2, 'Markham', 'Bruh Hotels', false, 'None', 'City View', 'Mini Fridge, Wi-Fi', '456 Skyline Blvd, Markham', TRUE, 'Lol Hotel'),
    (100016, 'Ocean View Suite', 450.00, 2, 'Markham', 'Bruh Hotels', true, 'None', 'Ocean View', 'Kitchenette, Sofa Bed', '789 Sunset Blvd, Markham', TRUE, 'Lol Hotel'),
    (100017, 'Family Suite', 400.00, 4, 'Markham', 'Bruh Hotels', true, 'None', 'City View', 'Kitchenette, Sofa Bed', '101 Mountain View Dr, Markham', TRUE, 'Lol Hotel'),
    (100018, 'Standard Room', 200.00, 2, 'Markham', 'Bruh Hotels', false, 'None', 'Street View', 'TV, Wi-Fi', '202 Ocean Ave, Markham', TRUE, 'Lol Hotel');

-- Dol Hotel
INSERT INTO Rooms (room_number, name, price, capacity, area, hotel_chain, upgradable, damages, view, amenities, address, availability, hotel)
VALUES
    (100019, 'Ocean View Suite', 400.00, 2, 'Markham', 'Bruh Hotels', true, 'None', 'Ocean View', 'Kitchenette, Jacuzzi', '111 Lakeshore Dr, Markham', TRUE, 'Dol Hotel'),
    (100020, 'Luxury Room', 250.00, 1, 'Markham', 'Bruh Hotels', false, 'Minor scratches on furniture', 'City View', 'Mini Bar, Wi-Fi', '222 Beachside Ave, Markham', TRUE, 'Dol Hotel'),
    (100021, 'Family Suite', 500.00, 4, 'Markham', 'Bruh Hotels', true, 'None', 'Ocean View', 'Kitchenette, Sofa Bed', '333 Lakeside Dr, Markham', TRUE, 'Dol Hotel'),
    (100022, 'City View Suite', 350.00, 3, 'Markham', 'Bruh Hotels', true, 'None', 'City View', 'Kitchenette, Gym', '444 Parkside Blvd, Markham', TRUE, 'Dol Hotel'),
    (100023, 'Standard Room', 150.00, 2, 'Markham', 'Bruh Hotels', false, 'None', 'Street View', 'TV, Wi-Fi', '555 Lakeshore Rd, Markham', TRUE, 'Dol Hotel');

-- Ool Hotel
INSERT INTO Rooms (room_number, name, price, capacity, area, hotel_chain, upgradable, damages, view, amenities, address, availability, hotel)
VALUES
    (100024, 'Deluxe Suite', 600.00, 3, 'Markham', 'Bruh Hotels', true, 'None', 'City View', 'Mini Bar, Jacuzzi', '123 Riverside Dr, Markham', TRUE, 'Ool Hotel'),
    (100025, 'Executive Room', 300.00, 2, 'Markham', 'Bruh Hotels', false, 'None', 'City View', 'Mini Fridge, Wi-Fi', '456 Seaside Ave, Markham', TRUE, 'Ool Hotel'),
    (100026, 'Ocean View Suite', 450.00, 2, 'Markham', 'Bruh Hotels', true, 'None', 'Ocean View', 'Kitchenette, Sofa Bed', '789 Oceanview Dr, Markham', TRUE, 'Ool Hotel'),
    (100027, 'Family Suite', 400.00, 4, 'Markham', 'Bruh Hotels', true, 'None', 'City View', 'Kitchenette, Sofa Bed', '101 Hilltop Ave, Markham', TRUE, 'Ool Hotel'),
    (100028, 'Standard Room', 200.00, 2, 'Markham', 'Bruh Hotels', false, 'None', 'Street View', 'TV, Wi-Fi', '202 Beach Blvd, Markham', TRUE, 'Ool Hotel');

-- Jol Hotel
INSERT INTO Rooms (room_number, name, price, capacity, area, hotel_chain, upgradable, damages, view, amenities, address, availability, hotel)
VALUES
    (100029, 'Deluxe Suite', 600.00, 3, 'Markham', 'Bruh Hotels', true, 'None', 'City View', 'Mini Bar, Jacuzzi', '111 Skyline Ave, Markham', TRUE, 'Jol Hotel'),
    (100030, 'Executive Room', 300.00, 2, 'Markham', 'Bruh Hotels', false, 'None', 'City View', 'Mini Fridge, Wi-Fi', '222 Hillside Blvd, Markham', TRUE, 'Jol Hotel'),
    (100031, 'Ocean View Suite', 450.00, 2, 'Markham', 'Bruh Hotels', true, 'None', 'Ocean View', 'Kitchenette, Sofa Bed', '333 Riverbank Dr, Markham', TRUE, 'Jol Hotel'),
    (100032, 'Family Suite', 400.00, 4, 'Markham', 'Bruh Hotels', true, 'None', 'City View', 'Kitchenette, Sofa Bed', '444 Lakeside Rd, Markham', TRUE, 'Jol Hotel'),
    (100033, 'Standard Room', 200.00, 2, 'Markham', 'Bruh Hotels', false, 'None', 'Street View', 'TV, Wi-Fi', '202 Beach Blvd, Markham', TRUE, 'Jol Hotel');

-- Kol Hotel
INSERT INTO Rooms (room_number, name, price, capacity, area, hotel_chain, upgradable, damages, view, amenities, address, availability, hotel)
VALUES
    (100034, 'Deluxe Suite', 600.00, 3, 'Markham', 'Bruh Hotels', true, 'None', 'City View', 'Mini Bar, Jacuzzi', '123 Mountain Ave, Markham', TRUE, 'Kol Hotel'),
    (100035, 'Executive Room', 300.00, 2, 'Markham', 'Bruh Hotels', false, 'None', 'City View', 'Mini Fridge, Wi-Fi', '456 Hilltop Blvd, Markham', TRUE, 'Kol Hotel'),
    (100036, 'Ocean View Suite', 450.00, 2, 'Markham', 'Bruh Hotels', true, 'None', 'Ocean View', 'Kitchenette, Sofa Bed', '789 Seaside Ave, Markham', TRUE, 'Kol Hotel'),
    (100037, 'Family Suite', 400.00, 4, 'Markham', 'Bruh Hotels', true, 'None', 'City View', 'Kitchenette, Sofa Bed', '101 Riverside Dr, Markham', TRUE, 'Kol Hotel'),
    (100038, 'Standard Room', 200.00, 2, 'Markham', 'Bruh Hotels', false, 'None', 'Street View', 'TV, Wi-Fi', '202 Beachside Blvd, Markham', TRUE, 'Kol Hotel');

-- Mol Hotel
INSERT INTO Rooms (room_number, name, price, capacity, area, hotel_chain, upgradable, damages, view, amenities, address, availability, hotel)
VALUES
    (100039, 'Deluxe Suite', 600.00, 3, 'Markham', 'Bruh Hotels', true, 'None', 'City View', 'Mini Bar, Jacuzzi', '111 Lakeside Dr, Markham', TRUE, 'Mol Hotel'),
    (100040, 'Executive Room', 300.00, 2, 'Markham', 'Bruh Hotels', false, 'None', 'City View', 'Mini Fridge, Wi-Fi', '222 Mountainview Blvd, Markham', TRUE, 'Mol Hotel'),
    (100041, 'Ocean View Suite', 450.00, 2, 'Markham', 'Bruh Hotels', true, 'None', 'Ocean View', 'Kitchenette, Sofa Bed', '333 Beachside Ave, Markham', TRUE, 'Mol Hotel'),
    (100042, 'Family Suite', 400.00, 4, 'Markham', 'Bruh Hotels', true, 'None', 'City View', 'Kitchenette, Sofa Bed', '444 Hillside Dr, Markham', TRUE, 'Mol Hotel'),
    (100043, 'Standard Room', 200.00, 2, 'Markham', 'Bruh Hotels', false, 'None', 'Street View', 'TV, Wi-Fi', '555 Seaview Rd, Markham', TRUE, 'Mol Hotel');

--Jac Hotels
-- Jax Hotel
INSERT INTO Rooms (room_number, name, price, capacity, area, hotel_chain, upgradable, damages, view, amenities, address, availability, hotel)
VALUES
    (100044, 'Luxury Suite', 500.00, 2, 'Toronto', 'Jac Hotels', true, 'None', 'City View', 'Mini Bar, Jacuzzi', '65 Jax St', TRUE, 'Jax Hotel'),
    (100045, 'Luxury Suite', 450.00, 1, 'Toronto', 'Jac Hotels', true, 'Minor scratches on the wall', 'City View', 'Mini Bar, Jacuzzi', '65 Jax St', TRUE, 'Jax Hotel'),
    (100046, 'Deluxe Room', 300.00, 3, 'Toronto', 'Jac Hotels', true, 'None', 'City View', 'Mini Bar', '65 Jax St', TRUE, 'Jax Hotel'),
    (100047, 'Standard Room', 200.00, 2, 'Toronto', 'Jac Hotels', false, 'None', 'City View', 'TV, Wi-Fi', '65 Jax St', TRUE, 'Jax Hotel'),
    (100048, 'Family Suite', 600.00, 4, 'Toronto', 'Jac Hotels', true, 'None', 'City View', 'Kitchenette, Sofa Bed', '65 Jax St', TRUE, 'Jax Hotel');

-- Lmao Hotel
INSERT INTO Rooms (room_number, name, price, capacity, area, hotel_chain, upgradable, damages, view, amenities, address, availability, hotel)
VALUES
    (100049, 'Standard Room', 150.00, 1, 'Toronto', 'Jac Hotels', false, 'Minor scratches on the wall', 'Courtyard View', 'TV, Wi-Fi', '55 Lmao St', TRUE, 'Lmao Hotel'),
    (100050, 'Standard Room', 170.00, 2, 'Toronto', 'Jac Hotels', false, 'Minor scratches on the wall', 'Courtyard View', 'TV, Wi-Fi', '55 Lmao St', TRUE, 'Lmao Hotel'),
    (100051, 'Deluxe Room', 250.00, 3, 'Toronto', 'Jac Hotels', false, 'None', 'City View', 'Mini Bar', '55 Lmao St', TRUE, 'Lmao Hotel'),
    (100052, 'Luxury Suite', 400.00, 2, 'Toronto', 'Jac Hotels', true, 'None', 'City View', 'Mini Bar, Jacuzzi', '55 Lmao St', TRUE, 'Lmao Hotel'),
    (100053, 'Family Suite', 550.00, 5, 'Toronto', 'Jac Hotels', true, 'None', 'City View', 'Kitchenette, Sofa Bed', '55 Lmao St', TRUE, 'Lmao Hotel');

-- Urp Hotel
INSERT INTO Rooms (room_number, name, price, capacity, area, hotel_chain, upgradable, damages, view, amenities, address, availability, hotel)
VALUES
    (100054, 'Luxury Suite', 480.00, 2, 'Toronto', 'Jac Hotels', true, 'None', 'City View', 'Mini Bar, Jacuzzi', '65 Urp St', TRUE, 'Urp Hotel'),
    (100055, 'Luxury Suite', 520.00, 1, 'Toronto', 'Jac Hotels', true, 'None', 'City View', 'Mini Bar, Jacuzzi', '65 Urp St', TRUE, 'Urp Hotel'),
    (100056, 'Deluxe Room', 300.00, 3, 'Toronto', 'Jac Hotels', true, 'None', 'City View', 'Mini Bar', '65 Urp St', TRUE, 'Urp Hotel'),
    (100057, 'Standard Room', 190.00, 2, 'Toronto', 'Jac Hotels', false, 'None', 'City View', 'TV, Wi-Fi', '65 Urp St', TRUE, 'Urp Hotel'),
    (100058, 'Family Suite', 600.00, 4, 'Toronto', 'Jac Hotels', true, 'None', 'City View', 'Kitchenette, Sofa Bed', '65 Urp St', TRUE, 'Urp Hotel');

-- Meep Hotel
INSERT INTO Rooms (room_number, name, price, capacity, area, hotel_chain, upgradable, damages, view, amenities, address, availability, hotel)
VALUES
    (100059, 'Standard Room', 170.00, 1, 'Toronto', 'Jac Hotels', false, 'Minor scratches on the wall', 'Courtyard View', 'TV, Wi-Fi', '55 Meep St', TRUE, 'Meep Hotel'),
    (100060, 'Standard Room', 180.00, 2, 'Toronto', 'Jac Hotels', false, 'Minor scratches on the wall', 'Courtyard View', 'TV, Wi-Fi', '55 Meep St', TRUE, 'Meep Hotel'),
    (100061, 'Deluxe Room', 280.00, 3, 'Toronto', 'Jac Hotels', false, 'None', 'City View', 'Mini Bar', '55 Meep St', TRUE, 'Meep Hotel'),
    (100062, 'Luxury Suite', 420.00, 2, 'Toronto', 'Jac Hotels', true, 'None', 'City View', 'Mini Bar, Jacuzzi', '55 Meep St', TRUE, 'Meep Hotel'),
    (100063, 'Family Suite', 580.00, 5, 'Toronto', 'Jac Hotels', true, 'None', 'City View', 'Kitchenette, Sofa Bed', '55 Meep St', TRUE, 'Meep Hotel');

-- Troll Hotel
INSERT INTO Rooms (room_number, name, price, capacity, area, hotel_chain, upgradable, damages, view, amenities, address, availability, hotel)
VALUES
    (100064, 'Luxury Suite', 520.00, 2, 'Toronto', 'Jac Hotels', true, 'None', 'City View', 'Mini Bar, Jacuzzi', '65 Troll St', TRUE, 'Troll Hotel'),
    (100065, 'Luxury Suite', 540.00, 1, 'Toronto', 'Jac Hotels', true, 'None', 'City View', 'Mini Bar, Jacuzzi', '65 Troll St', TRUE, 'Troll Hotel'),
    (100066, 'Deluxe Room', 320.00, 3, 'Toronto', 'Jac Hotels', true, 'None', 'City View', 'Mini Bar', '65 Troll St', TRUE, 'Troll Hotel'),
    (100067, 'Standard Room', 210.00, 2, 'Toronto', 'Jac Hotels', false, 'None', 'City View', 'TV, Wi-Fi', '65 Troll St', TRUE, 'Troll Hotel'),
    (100068, 'Family Suite', 620.00, 4, 'Toronto', 'Jac Hotels', true, 'None', 'City View', 'Kitchenette, Sofa Bed', '65 Troll St', TRUE, 'Troll Hotel');

-- Bingus Hotel
INSERT INTO Rooms (room_number, name, price, capacity, area, hotel_chain, upgradable, damages, view, amenities, address, availability, hotel)
VALUES
    (100069, 'Standard Room', 160.00, 1, 'Toronto', 'Jac Hotels', false, 'Minor scratches on the wall', 'Courtyard View', 'TV, Wi-Fi', '55 Bingus St', TRUE, 'Bingus Hotel'),
    (100070, 'Standard Room', 190.00, 2, 'Toronto', 'Jac Hotels', false, 'Minor scratches on the wall', 'Courtyard View', 'TV, Wi-Fi', '55 Bingus St', TRUE, 'Bingus Hotel'),
    (100071, 'Deluxe Room', 290.00, 3, 'Toronto', 'Jac Hotels', false, 'None', 'City View', 'Mini Bar', '55 Bingus St', TRUE, 'Bingus Hotel'),
    (100072, 'Luxury Suite', 430.00, 2, 'Toronto', 'Jac Hotels', true, 'None', 'City View', 'Mini Bar, Jacuzzi', '55 Bingus St', TRUE, 'Bingus Hotel'),
    (100073, 'Family Suite', 590.00, 5, 'Toronto', 'Jac Hotels', true, 'None', 'City View', 'Kitchenette, Sofa Bed', '55 Bingus St', TRUE, 'Bingus Hotel');

-- Deep Hotel
INSERT INTO Rooms (room_number, name, price, capacity, area, hotel_chain, upgradable, damages, view, amenities, address, availability, hotel)
VALUES
    (100074, 'Luxury Suite', 540.00, 2, 'Toronto', 'Jac Hotels', true, 'None', 'City View', 'Mini Bar, Jacuzzi', '65 Deep St', TRUE, 'Deep Hotel'),
    (100075, 'Luxury Suite', 560.00, 1, 'Toronto', 'Jac Hotels', true, 'None', 'City View', 'Mini Bar, Jacuzzi', '65 Deep St', TRUE, 'Deep Hotel'),
    (100076, 'Deluxe Room', 330.00, 3, 'Toronto', 'Jac Hotels', true, 'None', 'City View', 'Mini Bar', '65 Deep St', TRUE, 'Deep Hotel'),
    (100077, 'Standard Room', 220.00, 2, 'Toronto', 'Jac Hotels', false, 'None', 'City View', 'TV, Wi-Fi', '65 Deep St', TRUE, 'Deep Hotel'),
    (100078, 'Family Suite', 640.00, 4, 'Toronto', 'Jac Hotels', true, 'None', 'City View', 'Kitchenette, Sofa Bed', '65 Deep St', TRUE, 'Deep Hotel');

-- Teep Hotel
INSERT INTO Rooms (room_number, name, price, capacity, area, hotel_chain, upgradable, damages, view, amenities, address, availability, hotel)
VALUES
    (100079, 'Standard Room', 180.00, 1, 'Toronto', 'Jac Hotels', false, 'Minor scratches on the wall', 'Courtyard View', 'TV, Wi-Fi', '55 Teep St', TRUE, 'Teep Hotel'),
    (100080, 'Standard Room', 200.00, 2, 'Toronto', 'Jac Hotels', false, 'Minor scratches on the wall', 'Courtyard View', 'TV, Wi-Fi', '55 Teep St', TRUE, 'Teep Hotel'),
    (100081, 'Deluxe Room', 310.00, 3, 'Toronto', 'Jac Hotels', false, 'None', 'City View', 'Mini Bar', '55 Teep St', TRUE, 'Teep Hotel'),
    (100082, 'Luxury Suite', 450.00, 2, 'Toronto', 'Jac Hotels', true, 'None', 'City View', 'Mini Bar, Jacuzzi', '55 Teep St', TRUE, 'Teep Hotel'),
    (100083, 'Family Suite', 610.00, 5, 'Toronto', 'Jac Hotels', true, 'None', 'City View', 'Kitchenette, Sofa Bed', '55 Teep St', TRUE, 'Teep Hotel');

--Foll Hotels
-- Ooga Hotel
INSERT INTO Rooms (room_number, name, price, capacity, area, hotel_chain, upgradable, damages, view, amenities, address, availability, hotel)
VALUES
    (100084, 'Standard Room', 180.00, 1, 'Toronto', 'Foll Hotels', false, 'Minor scratches on the wall', 'Courtyard View', 'TV, Wi-Fi', '55 Ooga St', TRUE, 'Ooga Hotel'),
    (100085, 'Standard Room', 200.00, 2, 'Toronto', 'Foll Hotels', false, 'Minor scratches on the wall', 'Courtyard View', 'TV, Wi-Fi', '55 Ooga St', TRUE, 'Ooga Hotel'),
    (100086, 'Deluxe Room', 310.00, 3, 'Toronto', 'Foll Hotels', false, 'None', 'City View', 'Mini Bar', '55 Ooga St', TRUE, 'Ooga Hotel'),
    (100087, 'Luxury Suite', 450.00, 2, 'Toronto', 'Foll Hotels', true, 'None', 'City View', 'Mini Bar, Jacuzzi', '55 Ooga St', TRUE, 'Ooga Hotel'),
    (100088, 'Family Suite', 610.00, 5, 'Toronto', 'Foll Hotels', true, 'None', 'City View', 'Kitchenette, Sofa Bed', '55 Ooga St', TRUE, 'Ooga Hotel');

-- Doga Hotel
INSERT INTO Rooms (room_number, name, price, capacity, area, hotel_chain, upgradable, damages, view, amenities, address, availability, hotel)
VALUES
    (100089, 'Standard Room', 190.00, 1, 'Toronto', 'Foll Hotels', false, 'Minor scratches on the wall', 'Courtyard View', 'TV, Wi-Fi', '55 Doga St', TRUE, 'Doga Hotel'),
    (100090, 'Standard Room', 210.00, 2, 'Toronto', 'Foll Hotels', false, 'Minor scratches on the wall', 'Courtyard View', 'TV, Wi-Fi', '55 Doga St', TRUE, 'Doga Hotel'),
    (100091, 'Deluxe Room', 320.00, 3, 'Toronto', 'Foll Hotels', false, 'None', 'City View', 'Mini Bar', '55 Doga St', TRUE, 'Doga Hotel'),
    (100092, 'Luxury Suite', 460.00, 2, 'Toronto', 'Foll Hotels', true, 'None', 'City View', 'Mini Bar, Jacuzzi', '55 Doga St', TRUE, 'Doga Hotel'),
    (100093, 'Family Suite', 620.00, 5, 'Toronto', 'Foll Hotels', true, 'None', 'City View', 'Kitchenette, Sofa Bed', '55 Doga St', TRUE, 'Doga Hotel');

-- Toga Hotel
INSERT INTO Rooms (room_number, name, price, capacity, area, hotel_chain, upgradable, damages, view, amenities, address, availability, hotel)
VALUES
    (100094, 'Standard Room', 200.00, 1, 'Toronto', 'Foll Hotels', false, 'Minor scratches on the wall', 'Courtyard View', 'TV, Wi-Fi', '55 Toga St', TRUE, 'Toga Hotel'),
    (100095, 'Standard Room', 220.00, 2, 'Toronto', 'Foll Hotels', false, 'Minor scratches on the wall', 'Courtyard View', 'TV, Wi-Fi', '55 Toga St', TRUE, 'Toga Hotel'),
    (100096, 'Deluxe Room', 330.00, 3, 'Toronto', 'Foll Hotels', false, 'None', 'City View', 'Mini Bar', '55 Toga St', TRUE, 'Toga Hotel'),
    (100097, 'Luxury Suite', 470.00, 2, 'Toronto', 'Foll Hotels', true, 'None', 'City View', 'Mini Bar, Jacuzzi', '55 Toga St', TRUE, 'Toga Hotel'),
    (100098, 'Family Suite', 630.00, 5, 'Toronto', 'Foll Hotels', true, 'None', 'City View', 'Kitchenette, Sofa Bed', '55 Toga St', TRUE, 'Toga Hotel');

-- Moga Hotel
INSERT INTO Rooms (room_number, name, price, capacity, area, hotel_chain, upgradable, damages, view, amenities, address, availability, hotel)
VALUES
    (100099, 'Standard Room', 210.00, 1, 'Toronto', 'Foll Hotels', false, 'Minor scratches on the wall', 'Courtyard View', 'TV, Wi-Fi', '55 Moga St', TRUE, 'Moga Hotel'),
    (100100, 'Standard Room', 230.00, 2, 'Toronto', 'Foll Hotels', false, 'Minor scratches on the wall', 'Courtyard View', 'TV, Wi-Fi', '55 Moga St', TRUE, 'Moga Hotel'),
    (100101, 'Deluxe Room', 340.00, 3, 'Toronto', 'Foll Hotels', false, 'None', 'City View', 'Mini Bar', '55 Moga St', TRUE, 'Moga Hotel'),
    (100102, 'Luxury Suite', 480.00, 2, 'Toronto', 'Foll Hotels', true, 'None', 'City View', 'Mini Bar, Jacuzzi', '55 Moga St', TRUE, 'Moga Hotel'),
    (100103, 'Family Suite', 650.00, 5, 'Toronto', 'Foll Hotels', true, 'None', 'City View', 'Kitchenette, Sofa Bed', '55 Moga St', TRUE, 'Moga Hotel');

-- Joga Hotel
INSERT INTO Rooms (room_number, name, price, capacity, area, hotel_chain, upgradable, damages, view, amenities, address, availability, hotel)
VALUES
    (100104, 'Standard Room', 220.00, 1, 'Toronto', 'Foll Hotels', false, 'Minor scratches on the wall', 'Courtyard View', 'TV, Wi-Fi', '55 Joga St', TRUE, 'Joga Hotel'),
    (100105, 'Standard Room', 240.00, 2, 'Toronto', 'Foll Hotels', false, 'Minor scratches on the wall', 'Courtyard View', 'TV, Wi-Fi', '55 Joga St', TRUE, 'Joga Hotel'),
    (100106, 'Deluxe Room', 350.00, 3, 'Toronto', 'Foll Hotels', false, 'None', 'City View', 'Mini Bar', '55 Joga St', TRUE, 'Joga Hotel'),
    (100107, 'Luxury Suite', 490.00, 2, 'Toronto', 'Foll Hotels', true, 'None', 'City View', 'Mini Bar, Jacuzzi', '55 Joga St', TRUE, 'Joga Hotel'),
    (100108, 'Family Suite', 670.00, 5, 'Toronto', 'Foll Hotels', true, 'None', 'City View', 'Kitchenette, Sofa Bed', '55 Joga St', TRUE, 'Joga Hotel');

-- Loga Hotel
INSERT INTO Rooms (room_number, name, price, capacity, area, hotel_chain, upgradable, damages, view, amenities, address, availability, hotel)
VALUES
    (100109, 'Standard Room', 230.00, 1, 'Toronto', 'Foll Hotels', false, 'Minor scratches on the wall', 'Courtyard View', 'TV, Wi-Fi', '55 Loga St', TRUE, 'Loga Hotel'),
    (100110, 'Standard Room', 250.00, 2, 'Toronto', 'Foll Hotels', false, 'Minor scratches on the wall', 'Courtyard View', 'TV, Wi-Fi', '55 Loga St', TRUE, 'Loga Hotel'),
    (100111, 'Deluxe Room', 360.00, 3, 'Toronto', 'Foll Hotels', false, 'None', 'City View', 'Mini Bar', '55 Loga St', TRUE, 'Loga Hotel'),
    (100112, 'Luxury Suite', 510.00, 2, 'Toronto', 'Foll Hotels', true, 'None', 'City View', 'Mini Bar, Jacuzzi', '55 Loga St', TRUE, 'Loga Hotel'),
    (100113, 'Family Suite', 690.00, 5, 'Toronto', 'Foll Hotels', true, 'None', 'City View', 'Kitchenette, Sofa Bed', '55 Loga St', TRUE, 'Loga Hotel');

-- Kola Hotel
INSERT INTO Rooms (room_number, name, price, capacity, area, hotel_chain, upgradable, damages, view, amenities, address, availability, hotel)
VALUES
    (100114, 'Standard Room', 240.00, 1, 'Toronto', 'Foll Hotels', false, 'Minor scratches on the wall', 'Courtyard View', 'TV, Wi-Fi', '55 Kola St', TRUE, 'Kola Hotel'),
    (100115, 'Standard Room', 260.00, 2, 'Toronto', 'Foll Hotels', false, 'Minor scratches on the wall', 'Courtyard View', 'TV, Wi-Fi', '55 Kola St', TRUE, 'Kola Hotel'),
    (100116, 'Deluxe Room', 370.00, 3, 'Toronto', 'Foll Hotels', false, 'None', 'City View', 'Mini Bar', '55 Kola St', TRUE, 'Kola Hotel'),
    (100117, 'Luxury Suite', 530.00, 2, 'Toronto', 'Foll Hotels', true, 'None', 'City View', 'Mini Bar, Jacuzzi', '55 Kola St', TRUE, 'Kola Hotel'),
    (100118, 'Family Suite', 710.00, 5, 'Toronto', 'Foll Hotels', true, 'None', 'City View', 'Kitchenette, Sofa Bed', '55 Kola St', TRUE, 'Kola Hotel');

-- Yola Hotel
INSERT INTO Rooms (room_number, name, price, capacity, area, hotel_chain, upgradable, damages, view, amenities, address, availability, hotel)
VALUES
    (100119, 'Standard Room', 250.00, 1, 'Toronto', 'Foll Hotels', false, 'Minor scratches on the wall', 'Courtyard View', 'TV, Wi-Fi', '55 Yola St', TRUE, 'Yola Hotel'),
    (100120, 'Standard Room', 270.00, 2, 'Toronto', 'Foll Hotels', false, 'Minor scratches on the wall', 'Courtyard View', 'TV, Wi-Fi', '55 Yola St', TRUE, 'Yola Hotel'),
    (100121, 'Deluxe Room', 380.00, 3, 'Toronto', 'Foll Hotels', false, 'None', 'City View', 'Mini Bar', '55 Yola St', TRUE, 'Yola Hotel'),
    (100122, 'Luxury Suite', 550.00, 2, 'Toronto', 'Foll Hotels', true, 'None', 'City View', 'Mini Bar, Jacuzzi', '55 Yola St', TRUE, 'Yola Hotel'),
    (100123, 'Family Suite', 730.00, 5, 'Toronto', 'Foll Hotels', true, 'None', 'City View', 'Kitchenette, Sofa Bed', '55 Yola St', TRUE, 'Yola Hotel');

--Lala hotels
-- Yulu Hotel
INSERT INTO Rooms (room_number, name, price, capacity, area, hotel_chain, upgradable, damages, view, amenities, address, availability, hotel)
VALUES
    (100124, 'Standard Room', 260.00, 1, 'Toronto', 'Lala Hotels', false, 'Minor scratches on the wall', 'Courtyard View', 'TV, Wi-Fi', '55 Yulu St', TRUE, 'Yulu Hotel'),
    (100125, 'Standard Room', 280.00, 2, 'Toronto', 'Lala Hotels', false, 'Minor scratches on the wall', 'Courtyard View', 'TV, Wi-Fi', '55 Yulu St', TRUE, 'Yulu Hotel'),
    (100126, 'Deluxe Room', 390.00, 3, 'Toronto', 'Lala Hotels', false, 'None', 'City View', 'Mini Bar', '55 Yulu St', TRUE, 'Yulu Hotel'),
    (100127, 'Luxury Suite', 560.00, 2, 'Toronto', 'Lala Hotels', true, 'None', 'City View', 'Mini Bar, Jacuzzi', '55 Yulu St', TRUE, 'Yulu Hotel'),
    (100128, 'Family Suite', 740.00, 5, 'Toronto', 'Lala Hotels', true, 'None', 'City View', 'Kitchenette, Sofa Bed', '55 Yulu St', TRUE, 'Yulu Hotel');

-- Mulu Hotel
INSERT INTO Rooms (room_number, name, price, capacity, area, hotel_chain, upgradable, damages, view, amenities, address, availability, hotel)
VALUES
    (100129, 'Standard Room', 270.00, 1, 'Toronto', 'Lala Hotels', false, 'Minor scratches on the wall', 'Courtyard View', 'TV, Wi-Fi', '55 Mulu St', TRUE, 'Mulu Hotel'),
    (100130, 'Standard Room', 290.00, 2, 'Toronto', 'Lala Hotels', false, 'Minor scratches on the wall', 'Courtyard View', 'TV, Wi-Fi', '55 Mulu St', TRUE, 'Mulu Hotel'),
    (100131, 'Deluxe Room', 400.00, 3, 'Toronto', 'Lala Hotels', false, 'None', 'City View', 'Mini Bar', '55 Mulu St', TRUE, 'Mulu Hotel'),
    (100132, 'Luxury Suite', 570.00, 2, 'Toronto', 'Lala Hotels', true, 'None', 'City View', 'Mini Bar, Jacuzzi', '55 Mulu St', TRUE, 'Mulu Hotel'),
    (100133, 'Family Suite', 750.00, 5, 'Toronto', 'Lala Hotels', true, 'None', 'City View', 'Kitchenette, Sofa Bed', '55 Mulu St', TRUE, 'Mulu Hotel');

-- Julu Hotel
INSERT INTO Rooms (room_number, name, price, capacity, area, hotel_chain, upgradable, damages, view, amenities, address, availability, hotel)
VALUES
    (100134, 'Standard Room', 280.00, 1, 'Toronto', 'Lala Hotels', false, 'Minor scratches on the wall', 'Courtyard View', 'TV, Wi-Fi', '55 Julu St', TRUE, 'Julu Hotel'),
    (100135, 'Standard Room', 300.00, 2, 'Toronto', 'Lala Hotels', false, 'Minor scratches on the wall', 'Courtyard View', 'TV, Wi-Fi', '55 Julu St', TRUE, 'Julu Hotel'),
    (100136, 'Deluxe Room', 410.00, 3, 'Toronto', 'Lala Hotels', false, 'None', 'City View', 'Mini Bar', '55 Julu St', TRUE, 'Julu Hotel'),
    (100137, 'Luxury Suite', 580.00, 2, 'Toronto', 'Lala Hotels', true, 'None', 'City View', 'Mini Bar, Jacuzzi', '55 Julu St', TRUE, 'Julu Hotel'),
    (100138, 'Family Suite', 760.00, 5, 'Toronto', 'Lala Hotels', true, 'None', 'City View', 'Kitchenette, Sofa Bed', '55 Julu St', TRUE, 'Julu Hotel');

-- Hulu Hotel
INSERT INTO Rooms (room_number, name, price, capacity, area, hotel_chain, upgradable, damages, view, amenities, address, availability, hotel)
VALUES
    (100139, 'Standard Room', 290.00, 1, 'Toronto', 'Lala Hotels', false, 'Minor scratches on the wall', 'Courtyard View', 'TV, Wi-Fi', '55 Hulu St', TRUE, 'Hulu Hotel'),
    (100140, 'Standard Room', 310.00, 2, 'Toronto', 'Lala Hotels', false, 'Minor scratches on the wall', 'Courtyard View', 'TV, Wi-Fi', '55 Hulu St', TRUE, 'Hulu Hotel'),
    (100141, 'Deluxe Room', 420.00, 3, 'Toronto', 'Lala Hotels', false, 'None', 'City View', 'Mini Bar', '55 Hulu St', TRUE, 'Hulu Hotel'),
    (100142, 'Luxury Suite', 590.00, 2, 'Toronto', 'Lala Hotels', true, 'None', 'City View', 'Mini Bar, Jacuzzi', '55 Hulu St', TRUE, 'Hulu Hotel'),
    (100143, 'Family Suite', 770.00, 5, 'Toronto', 'Lala Hotels', true, 'None', 'City View', 'Kitchenette, Sofa Bed', '55 Hulu St', TRUE, 'Hulu Hotel');

-- Kulu Hotel
INSERT INTO Rooms (room_number, name, price, capacity, area, hotel_chain, upgradable, damages, view, amenities, address, availability, hotel)
VALUES
    (100144, 'Standard Room', 300.00, 1, 'Toronto', 'Lala Hotels', false, 'Minor scratches on the wall', 'Courtyard View', 'TV, Wi-Fi', '55 Kulu St', TRUE, 'Kulu Hotel'),
    (100145, 'Standard Room', 320.00, 2, 'Toronto', 'Lala Hotels', false, 'Minor scratches on the wall', 'Courtyard View', 'TV, Wi-Fi', '55 Kulu St', TRUE, 'Kulu Hotel'),
    (100146, 'Deluxe Room', 430.00, 3, 'Toronto', 'Lala Hotels', false, 'None', 'City View', 'Mini Bar', '55 Kulu St', TRUE, 'Kulu Hotel'),
    (100147, 'Luxury Suite', 600.00, 2, 'Toronto', 'Lala Hotels', true, 'None', 'City View', 'Mini Bar, Jacuzzi', '55 Kulu St', TRUE, 'Kulu Hotel'),
    (100148, 'Family Suite', 780.00, 5, 'Toronto', 'Lala Hotels', true, 'None', 'City View', 'Kitchenette, Sofa Bed', '55 Kulu St', TRUE, 'Kulu Hotel');

-- Krollo Hotel
INSERT INTO Rooms (room_number, name, price, capacity, area, hotel_chain, upgradable, damages, view, amenities, address, availability, hotel)
VALUES
    (100149, 'Standard Room', 310.00, 1, 'Toronto', 'Lala Hotels', false, 'Minor scratches on the wall', 'Courtyard View', 'TV, Wi-Fi', '55 Krollo St', TRUE, 'Krollo Hotel'),
    (100150, 'Standard Room', 330.00, 2, 'Toronto', 'Lala Hotels', false, 'Minor scratches on the wall', 'Courtyard View', 'TV, Wi-Fi', '55 Krollo St', TRUE, 'Krollo Hotel'),
    (100151, 'Deluxe Room', 440.00, 3, 'Toronto', 'Lala Hotels', false, 'None', 'City View', 'Mini Bar', '55 Krollo St', TRUE, 'Krollo Hotel'),
    (100152, 'Luxury Suite', 610.00, 2, 'Toronto', 'Lala Hotels', true, 'None', 'City View', 'Mini Bar, Jacuzzi', '55 Krollo St', TRUE, 'Krollo Hotel'),
    (100153, 'Family Suite', 790.00, 5, 'Toronto', 'Lala Hotels', true, 'None', 'City View', 'Kitchenette, Sofa Bed', '55 Krollo St', TRUE, 'Krollo Hotel');

-- Olu Hotel
INSERT INTO Rooms (room_number, name, price, capacity, area, hotel_chain, upgradable, damages, view, amenities, address, availability, hotel)
VALUES
    (100154, 'Standard Room', 320.00, 1, 'Toronto', 'Lala Hotels', false, 'Minor scratches on the wall', 'Courtyard View', 'TV, Wi-Fi', '55 Olu St', TRUE, 'Olu Hotel'),
    (100155, 'Standard Room', 340.00, 2, 'Toronto', 'Lala Hotels', false, 'Minor scratches on the wall', 'Courtyard View', 'TV, Wi-Fi', '55 Olu St', TRUE, 'Olu Hotel'),
    (100156, 'Deluxe Room', 450.00, 3, 'Toronto', 'Lala Hotels', false, 'None', 'City View', 'Mini Bar', '55 Olu St', TRUE, 'Olu Hotel'),
    (100157, 'Luxury Suite', 620.00, 2, 'Toronto', 'Lala Hotels', true, 'None', 'City View', 'Mini Bar, Jacuzzi', '55 Olu St', TRUE, 'Olu Hotel'),
    (100158, 'Family Suite', 800.00, 5, 'Toronto', 'Lala Hotels', true, 'None', 'City View', 'Kitchenette, Sofa Bed', '55 Olu St', TRUE, 'Olu Hotel');

-- Polu Hotel
INSERT INTO Rooms (room_number, name, price, capacity, area, hotel_chain, upgradable, damages, view, amenities, address, availability, hotel)
VALUES
    (100159, 'Standard Room', 330.00, 1, 'Toronto', 'Lala Hotels', false, 'Minor scratches on the wall', 'Courtyard View', 'TV, Wi-Fi', '55 Polu St', TRUE, 'Polu Hotel'),
    (100160, 'Standard Room', 350.00, 2, 'Toronto', 'Lala Hotels', false, 'Minor scratches on the wall', 'Courtyard View', 'TV, Wi-Fi', '55 Polu St', TRUE, 'Polu Hotel'),
    (100161, 'Deluxe Room', 460.00, 3, 'Toronto', 'Lala Hotels', false, 'None', 'City View', 'Mini Bar', '55 Polu St', TRUE, 'Polu Hotel'),
    (100162, 'Luxury Suite', 630.00, 2, 'Toronto', 'Lala Hotels', true, 'None', 'City View', 'Mini Bar, Jacuzzi', '55 Polu St', TRUE, 'Polu Hotel'),
    (100163, 'Family Suite', 810.00, 5, 'Toronto', 'Lala Hotels', true, 'None', 'City View', 'Kitchenette, Sofa Bed', '55 Polu St', TRUE, 'Polu Hotel');

--Molley Hotels
-- Chingus Hotel
INSERT INTO Rooms (room_number, name, price, capacity, area, hotel_chain, upgradable, damages, view, amenities, address, availability, hotel)
VALUES
    (100164, 'Standard Room', 300.00, 1, 'Toronto', 'Molly Hotels', false, 'Minor scratches on the wall', 'City View', 'TV, Wi-Fi', '55 Chingus St', TRUE, 'Chingus Hotel'),
    (100165, 'Standard Room', 320.00, 2, 'Toronto', 'Molly Hotels', false, 'Minor scratches on the wall', 'City View', 'TV, Wi-Fi', '55 Chingus St', TRUE, 'Chingus Hotel'),
    (100166, 'Deluxe Room', 430.00, 3, 'Toronto', 'Molly Hotels', false, 'None', 'City View', 'Mini Bar', '55 Chingus St', TRUE, 'Chingus Hotel'),
    (100167, 'Luxury Suite', 600.00, 2, 'Toronto', 'Molly Hotels', true, 'None', 'City View', 'Mini Bar, Jacuzzi', '55 Chingus St', TRUE, 'Chingus Hotel'),
    (100168, 'Family Suite', 780.00, 5, 'Toronto', 'Molly Hotels', true, 'None', 'City View', 'Kitchenette, Sofa Bed', '55 Chingus St', TRUE, 'Chingus Hotel');

-- Linugs Hotel
INSERT INTO Rooms (room_number, name, price, capacity, area, hotel_chain, upgradable, damages, view, amenities, address, availability, hotel)
VALUES
    (100169, 'Standard Room', 310.00, 1, 'Toronto', 'Molly Hotels', false, 'Minor scratches on the wall', 'City View', 'TV, Wi-Fi', '55 Linugs St', TRUE, 'Linugs Hotel'),
    (100170, 'Standard Room', 330.00, 2, 'Toronto', 'Molly Hotels', false, 'Minor scratches on the wall', 'City View', 'TV, Wi-Fi', '55 Linugs St', TRUE, 'Linugs Hotel'),
    (100171, 'Deluxe Room', 440.00, 3, 'Toronto', 'Molly Hotels', false, 'None', 'City View', 'Mini Bar', '55 Linugs St', TRUE, 'Linugs Hotel'),
    (100172, 'Luxury Suite', 610.00, 2, 'Toronto', 'Molly Hotels', true, 'None', 'City View', 'Mini Bar, Jacuzzi', '55 Linugs St', TRUE, 'Linugs Hotel'),
    (100173, 'Family Suite', 790.00, 5, 'Toronto', 'Molly Hotels', true, 'None', 'City View', 'Kitchenette, Sofa Bed', '55 Linugs St', TRUE, 'Linugs Hotel');

-- Minugs Hotel
INSERT INTO Rooms (room_number, name, price, capacity, area, hotel_chain, upgradable, damages, view, amenities, address, availability, hotel)
VALUES
    (100174, 'Standard Room', 320.00, 1, 'Toronto', 'Molly Hotels', false, 'Minor scratches on the wall', 'City View', 'TV, Wi-Fi', '55 Minugs St', TRUE, 'Minugs Hotel'),
    (100175, 'Standard Room', 340.00, 2, 'Toronto', 'Molly Hotels', false, 'Minor scratches on the wall', 'City View', 'TV, Wi-Fi', '55 Minugs St', TRUE, 'Minugs Hotel'),
    (100176, 'Deluxe Room', 450.00, 3, 'Toronto', 'Molly Hotels', false, 'None', 'City View', 'Mini Bar', '55 Minugs St', TRUE, 'Minugs Hotel'),
    (100177, 'Luxury Suite', 620.00, 2, 'Toronto', 'Molly Hotels', true, 'None', 'City View', 'Mini Bar, Jacuzzi', '55 Minugs St', TRUE, 'Minugs Hotel'),
    (100178, 'Family Suite', 800.00, 5, 'Toronto', 'Molly Hotels', true, 'None', 'City View', 'Kitchenette, Sofa Bed', '55 Minugs St', TRUE, 'Minugs Hotel');

-- Fringus Hotel
INSERT INTO Rooms (room_number, name, price, capacity, area, hotel_chain, upgradable, damages, view, amenities, address, availability, hotel)
VALUES
    (100179, 'Standard Room', 330.00, 1, 'Toronto', 'Molly Hotels', false, 'Minor scratches on the wall', 'City View', 'TV, Wi-Fi', '55 Fringus St', TRUE, 'Fringus Hotel'),
    (100180, 'Standard Room', 350.00, 2, 'Toronto', 'Molly Hotels', false, 'Minor scratches on the wall', 'City View', 'TV, Wi-Fi', '55 Fringus St', TRUE, 'Fringus Hotel'),
    (100181, 'Deluxe Room', 460.00, 3, 'Toronto', 'Molly Hotels', false, 'None', 'City View', 'Mini Bar', '55 Fringus St', TRUE, 'Fringus Hotel'),
    (100182, 'Luxury Suite', 630.00, 2, 'Toronto', 'Molly Hotels', true, 'None', 'City View', 'Mini Bar, Jacuzzi', '55 Fringus St', TRUE, 'Fringus Hotel'),
    (100183, 'Family Suite', 810.00, 5, 'Toronto', 'Molly Hotels', true, 'None', 'City View', 'Kitchenette, Sofa Bed', '55 Fringus St', TRUE, 'Fringus Hotel');

-- Yingus Hotel
INSERT INTO Rooms (room_number, name, price, capacity, area, hotel_chain, upgradable, damages, view, amenities, address, availability, hotel)
VALUES
    (100184, 'Standard Room', 340.00, 1, 'Toronto', 'Molly Hotels', false, 'Minor scratches on the wall', 'City View', 'TV, Wi-Fi', '55 Yingus St', TRUE, 'Yingus Hotel'),
    (100185, 'Standard Room', 360.00, 2, 'Toronto', 'Molly Hotels', false, 'Minor scratches on the wall', 'City View', 'TV, Wi-Fi', '55 Yingus St', TRUE, 'Yingus Hotel'),
    (100186, 'Deluxe Room', 470.00, 3, 'Toronto', 'Molly Hotels', false, 'None', 'City View', 'Mini Bar', '55 Yingus St', TRUE, 'Yingus Hotel'),
    (100187, 'Luxury Suite', 640.00, 2, 'Toronto', 'Molly Hotels', true, 'None', 'City View', 'Mini Bar, Jacuzzi', '55 Yingus St', TRUE, 'Yingus Hotel'),
    (100188, 'Family Suite', 820.00, 5, 'Toronto', 'Molly Hotels', true, 'None', 'City View', 'Kitchenette, Sofa Bed', '55 Yingus St', TRUE, 'Yingus Hotel');

-- Yongus Hotel
INSERT INTO Rooms (room_number, name, price, capacity, area, hotel_chain, upgradable, damages, view, amenities, address, availability, hotel)
VALUES
    (100189, 'Standard Room', 350.00, 1, 'Toronto', 'Molly Hotels', false, 'Minor scratches on the wall', 'City View', 'TV, Wi-Fi', '55 Yongus St', TRUE, 'Yongus Hotel'),
    (100190, 'Standard Room', 370.00, 2, 'Toronto', 'Molly Hotels', false, 'Minor scratches on the wall', 'City View', 'TV, Wi-Fi', '55 Yongus St', TRUE, 'Yongus Hotel'),
    (100191, 'Deluxe Room', 480.00, 3, 'Toronto', 'Molly Hotels', false, 'None', 'City View', 'Mini Bar', '55 Yongus St', TRUE, 'Yongus Hotel'),
    (100192, 'Luxury Suite', 650.00, 2, 'Toronto', 'Molly Hotels', true, 'None', 'City View', 'Mini Bar, Jacuzzi', '55 Yongus St', TRUE, 'Yongus Hotel'),
    (100193, 'Family Suite', 830.00, 5, 'Toronto', 'Molly Hotels', true, 'None', 'City View', 'Kitchenette, Sofa Bed', '55 Yongus St', TRUE, 'Yongus Hotel');

-- Kingus Hotel
INSERT INTO Rooms (room_number, name, price, capacity, area, hotel_chain, upgradable, damages, view, amenities, address, availability, hotel)
VALUES
    (100194, 'Standard Room', 360.00, 1, 'Toronto', 'Molly Hotels', false, 'Minor scratches on the wall', 'City View', 'TV, Wi-Fi', '55 Kingus St', TRUE, 'Kingus Hotel'),
    (100195, 'Standard Room', 380.00, 2, 'Toronto', 'Molly Hotels', false, 'Minor scratches on the wall', 'City View', 'TV, Wi-Fi', '55 Kingus St', TRUE, 'Kingus Hotel'),
    (100196, 'Deluxe Room', 490.00, 3, 'Toronto', 'Molly Hotels', false, 'None', 'City View', 'Mini Bar', '55 Kingus St', TRUE, 'Kingus Hotel'),
    (100197, 'Luxury Suite', 660.00, 2, 'Toronto', 'Molly Hotels', true, 'None', 'City View', 'Mini Bar, Jacuzzi', '55 Kingus St', TRUE, 'Kingus Hotel'),
    (100198, 'Family Suite', 840.00, 5, 'Toronto', 'Molly Hotels', true, 'None', 'City View', 'Kitchenette, Sofa Bed', '55 Kingus St', TRUE, 'Kingus Hotel');

-- Oogus Hotel
INSERT INTO Rooms (room_number, name, price, capacity, area, hotel_chain, upgradable, damages, view, amenities, address, availability, hotel)
VALUES
    (100199, 'Standard Room', 370.00, 1, 'Toronto', 'Molly Hotels', false, 'Minor scratches on the wall', 'City View', 'TV, Wi-Fi', '55 Oogus St', TRUE, 'Oogus Hotel'),
    (100200, 'Standard Room', 390.00, 2, 'Toronto', 'Molly Hotels', false, 'Minor scratches on the wall', 'City View', 'TV, Wi-Fi', '55 Oogus St', TRUE, 'Oogus Hotel'),
    (100201, 'Deluxe Room', 500.00, 3, 'Toronto', 'Molly Hotels', false, 'None', 'City View', 'Mini Bar', '55 Oogus St', TRUE, 'Oogus Hotel'),
    (100202, 'Luxury Suite', 670.00, 2, 'Toronto', 'Molly Hotels', true, 'None', 'City View', 'Mini Bar, Jacuzzi', '55 Oogus St', TRUE, 'Oogus Hotel'),
    (100203, 'Family Suite', 850.00, 5, 'Toronto', 'Molly Hotels', true, 'None', 'City View', 'Kitchenette, Sofa Bed', '55 Oogus St', TRUE, 'Oogus Hotel');

--Kakaka hotels
-- Ayaya Hotel
INSERT INTO Rooms (room_number, name, price, capacity, area, hotel_chain, upgradable, damages, view, amenities, address, availability, hotel)
VALUES
    (100204, 'Standard Room', 200.00, 1, 'Toronto', 'Kakaka Hotels', false, 'None', 'City View', 'TV, Wi-Fi', '55 Ayaya St', TRUE, 'Ayaya Hotel'),
    (100205, 'Standard Room', 220.00, 2, 'Toronto', 'Kakaka Hotels', false, 'None', 'City View', 'TV, Wi-Fi', '55 Ayaya St', TRUE, 'Ayaya Hotel'),
    (100206, 'Deluxe Room', 330.00, 3, 'Toronto', 'Kakaka Hotels', false, 'None', 'City View', 'Mini Bar', '55 Ayaya St', TRUE, 'Ayaya Hotel'),
    (100207, 'Luxury Suite', 500.00, 2, 'Toronto', 'Kakaka Hotels', true, 'None', 'City View', 'Mini Bar, Jacuzzi', '55 Ayaya St', TRUE, 'Ayaya Hotel'),
    (100208, 'Family Suite', 700.00, 5, 'Toronto', 'Kakaka Hotels', true, 'None', 'City View', 'Kitchenette, Sofa Bed', '55 Ayaya St', TRUE, 'Ayaya Hotel');

-- Dayaya Hotel
INSERT INTO Rooms (room_number, name, price, capacity, area, hotel_chain, upgradable, damages, view, amenities, address, availability, hotel)
VALUES
    (100209, 'Standard Room', 210.00, 1, 'Toronto', 'Kakaka Hotels', false, 'None', 'City View', 'TV, Wi-Fi', '55 Dayaya St', TRUE, 'Dayaya Hotel'),
    (100210, 'Standard Room', 230.00, 2, 'Toronto', 'Kakaka Hotels', false, 'None', 'City View', 'TV, Wi-Fi', '55 Dayaya St', TRUE, 'Dayaya Hotel'),
    (100211, 'Deluxe Room', 340.00, 3, 'Toronto', 'Kakaka Hotels', false, 'None', 'City View', 'Mini Bar', '55 Dayaya St', TRUE, 'Dayaya Hotel'),
    (100212, 'Luxury Suite', 510.00, 2, 'Toronto', 'Kakaka Hotels', true, 'None', 'City View', 'Mini Bar, Jacuzzi', '55 Dayaya St', TRUE, 'Dayaya Hotel'),
    (100213, 'Family Suite', 710.00, 5, 'Toronto', 'Kakaka Hotels', true, 'None', 'City View', 'Kitchenette, Sofa Bed', '55 Dayaya St', TRUE, 'Dayaya Hotel');

-- Gogogo Hotel
INSERT INTO Rooms (room_number, name, price, capacity, area, hotel_chain, upgradable, damages, view, amenities, address, availability, hotel)
VALUES
    (100214, 'Standard Room', 220.00, 1, 'Toronto', 'Kakaka Hotels', false, 'None', 'City View', 'TV, Wi-Fi', '55 Gogogo St', TRUE, 'Gogogo Hotel'),
    (100215, 'Standard Room', 240.00, 2, 'Toronto', 'Kakaka Hotels', false, 'None', 'City View', 'TV, Wi-Fi', '55 Gogogo St', TRUE, 'Gogogo Hotel'),
    (100216, 'Deluxe Room', 350.00, 3, 'Toronto', 'Kakaka Hotels', false, 'None', 'City View', 'Mini Bar', '55 Gogogo St', TRUE, 'Gogogo Hotel'),
    (100217, 'Luxury Suite', 520.00, 2, 'Toronto', 'Kakaka Hotels', true, 'None', 'City View', 'Mini Bar, Jacuzzi', '55 Gogogo St', TRUE, 'Gogogo Hotel'),
    (100218, 'Family Suite', 720.00, 5, 'Toronto', 'Kakaka Hotels', true, 'None', 'City View', 'Kitchenette, Sofa Bed', '55 Gogogo St', TRUE, 'Gogogo Hotel');

-- Dingdingding Hotel
INSERT INTO Rooms (room_number, name, price, capacity, area, hotel_chain, upgradable, damages, view, amenities, address, availability, hotel)
VALUES
    (100219, 'Standard Room', 230.00, 1, 'Toronto', 'Kakaka Hotels', false, 'None', 'City View', 'TV, Wi-Fi', '55 Dingdingding St', TRUE, 'Dingdingding Hotel'),
    (100220, 'Standard Room', 250.00, 2, 'Toronto', 'Kakaka Hotels', false, 'None', 'City View', 'TV, Wi-Fi', '55 Dingdingding St', TRUE, 'Dingdingding Hotel'),
    (100221, 'Deluxe Room', 360.00, 3, 'Toronto', 'Kakaka Hotels', false, 'None', 'City View', 'Mini Bar', '55 Dingdingding St', TRUE, 'Dingdingding Hotel'),
    (100222, 'Luxury Suite', 530.00, 2, 'Toronto', 'Kakaka Hotels', true, 'None', 'City View', 'Mini Bar, Jacuzzi', '55 Dingdingding St', TRUE, 'Dingdingding Hotel'),
    (100223, 'Family Suite', 730.00, 5, 'Toronto', 'Kakaka Hotels', true, 'None', 'City View', 'Kitchenette, Sofa Bed', '55 Dingdingding St', TRUE, 'Dingdingding Hotel');

-- Mingming Hotel
INSERT INTO Rooms (room_number, name, price, capacity, area, hotel_chain, upgradable, damages, view, amenities, address, availability, hotel)
VALUES
    (100224, 'Standard Room', 240.00, 1, 'Toronto', 'Kakaka Hotels', false, 'None', 'City View', 'TV, Wi-Fi', '55 Mingming St', TRUE, 'Mingming Hotel'),
    (100225, 'Standard Room', 260.00, 2, 'Toronto', 'Kakaka Hotels', false, 'None', 'City View', 'TV, Wi-Fi', '55 Mingming St', TRUE, 'Mingming Hotel'),
    (100226, 'Deluxe Room', 370.00, 3, 'Toronto', 'Kakaka Hotels', false, 'None', 'City View', 'Mini Bar', '55 Mingming St', TRUE, 'Mingming Hotel'),
    (100227, 'Luxury Suite', 540.00, 2, 'Toronto', 'Kakaka Hotels', true, 'None', 'City View', 'Mini Bar, Jacuzzi', '55 Mingming St', TRUE, 'Mingming Hotel'),
    (100228, 'Family Suite', 740.00, 5, 'Toronto', 'Kakaka Hotels', true, 'None', 'City View', 'Kitchenette, Sofa Bed', '55 Mingming St', TRUE, 'Mingming Hotel');

-- Ringring Hotel
INSERT INTO Rooms (room_number, name, price, capacity, area, hotel_chain, upgradable, damages, view, amenities, address, availability, hotel)
VALUES
    (100229, 'Standard Room', 250.00, 1, 'Toronto', 'Kakaka Hotels', false, 'None', 'City View', 'TV, Wi-Fi', '55 Ringring St', TRUE, 'Ringring Hotel'),
    (100230, 'Standard Room', 270.00, 2, 'Toronto', 'Kakaka Hotels', false, 'None', 'City View', 'TV, Wi-Fi', '55 Ringring St', TRUE, 'Ringring Hotel'),
    (100231, 'Deluxe Room', 380.00, 3, 'Toronto', 'Kakaka Hotels', false, 'None', 'City View', 'Mini Bar', '55 Ringring St', TRUE, 'Ringring Hotel'),
    (100232, 'Luxury Suite', 550.00, 2, 'Toronto', 'Kakaka Hotels', true, 'None', 'City View', 'Mini Bar, Jacuzzi', '55 Ringring St', TRUE, 'Ringring Hotel'),
    (100233, 'Family Suite', 750.00, 5, 'Toronto', 'Kakaka Hotels', true, 'None', 'City View', 'Kitchenette, Sofa Bed', '55 Ringring St', TRUE, 'Ringring Hotel');

-- Hohoho Hotel
INSERT INTO Rooms (room_number, name, price, capacity, area, hotel_chain, upgradable, damages, view, amenities, address, availability, hotel)
VALUES
    (100234, 'Standard Room', 260.00, 1, 'Toronto', 'Kakaka Hotels', false, 'None', 'City View', 'TV, Wi-Fi', '55 Hohoho St', TRUE, 'Hohoho Hotel'),
    (100235, 'Standard Room', 280.00, 2, 'Toronto', 'Kakaka Hotels', false, 'None', 'City View', 'TV, Wi-Fi', '55 Hohoho St', TRUE, 'Hohoho Hotel'),
    (100236, 'Deluxe Room', 390.00, 3, 'Toronto', 'Kakaka Hotels', false, 'None', 'City View', 'Mini Bar', '55 Hohoho St', TRUE, 'Hohoho Hotel'),
    (100237, 'Luxury Suite', 560.00, 2, 'Toronto', 'Kakaka Hotels', true, 'None', 'City View', 'Mini Bar, Jacuzzi', '55 Hohoho St', TRUE, 'Hohoho Hotel'),
    (100238, 'Family Suite', 760.00, 5, 'Toronto', 'Kakaka Hotels', true, 'None', 'City View', 'Kitchenette, Sofa Bed', '55 Hohoho St', TRUE, 'Hohoho Hotel');

-- Jojojo Hotel
INSERT INTO Rooms (room_number, name, price, capacity, area, hotel_chain, upgradable, damages, view, amenities, address, availability, hotel)
VALUES
    (100239, 'Standard Room', 270.00, 1, 'Toronto', 'Kakaka Hotels', false, 'None', 'City View', 'TV, Wi-Fi', '55 Jojojo St', TRUE, 'Jojojo Hotel'),
    (100240, 'Standard Room', 290.00, 2, 'Toronto', 'Kakaka Hotels', false, 'None', 'City View', 'TV, Wi-Fi', '55 Jojojo St', TRUE, 'Jojojo Hotel'),
    (100241, 'Deluxe Room', 400.00, 3, 'Toronto', 'Kakaka Hotels', false, 'None', 'City View', 'Mini Bar', '55 Jojojo St', TRUE, 'Jojojo Hotel'),
    (100242, 'Luxury Suite', 570.00, 2, 'Toronto', 'Kakaka Hotels', true, 'None', 'City View', 'Mini Bar, Jacuzzi', '55 Jojojo St', TRUE, 'Jojojo Hotel'),
    (100243, 'Family Suite', 770.00, 5, 'Toronto', 'Kakaka Hotels', true, 'None', 'City View', 'Kitchenette, Sofa Bed', '55 Jojojo St', TRUE, 'Jojojo Hotel');

--Snail Hotels
-- Goo Hotel
INSERT INTO Rooms (room_number, name, price, capacity, area, hotel_chain, upgradable, damages, view, amenities, address, availability, hotel)
VALUES
    (100244, 'Standard Room', 200.00, 1, 'Toronto', 'Snail Hotels', false, 'None', 'City View', 'TV, Wi-Fi', '55 Goo St', TRUE, 'Goo Hotel'),
    (100245, 'Standard Room', 220.00, 2, 'Toronto', 'Snail Hotels', false, 'None', 'City View', 'TV, Wi-Fi', '55 Goo St', TRUE, 'Goo Hotel'),
    (100246, 'Deluxe Room', 330.00, 3, 'Toronto', 'Snail Hotels', false, 'None', 'City View', 'Mini Bar', '55 Goo St', TRUE, 'Goo Hotel'),
    (100247, 'Luxury Suite', 500.00, 2, 'Toronto', 'Snail Hotels', true, 'None', 'City View', 'Mini Bar, Jacuzzi', '55 Goo St', TRUE, 'Goo Hotel'),
    (100248, 'Family Suite', 700.00, 5, 'Toronto', 'Snail Hotels', true, 'None', 'City View', 'Kitchenette, Sofa Bed', '55 Goo St', TRUE, 'Goo Hotel');

-- More Goo Hotel
INSERT INTO Rooms (room_number, name, price, capacity, area, hotel_chain, upgradable, damages, view, amenities, address, availability, hotel)
VALUES
    (100249, 'Standard Room', 210.00, 1, 'Toronto', 'Snail Hotels', false, 'None', 'City View', 'TV, Wi-Fi', '55 More Goo St', TRUE, 'More Goo Hotel'),
    (100250, 'Standard Room', 230.00, 2, 'Toronto', 'Snail Hotels', false, 'None', 'City View', 'TV, Wi-Fi', '55 More Goo St', TRUE, 'More Goo Hotel'),
    (100251, 'Deluxe Room', 340.00, 3, 'Toronto', 'Snail Hotels', false, 'None', 'City View', 'Mini Bar', '55 More Goo St', TRUE, 'More Goo Hotel'),
    (100252, 'Luxury Suite', 510.00, 2, 'Toronto', 'Snail Hotels', true, 'None', 'City View', 'Mini Bar, Jacuzzi', '55 More Goo St', TRUE, 'More Goo Hotel'),
    (100253, 'Family Suite', 710.00, 5, 'Toronto', 'Snail Hotels', true, 'None', 'City View', 'Kitchenette, Sofa Bed', '55 More Goo St', TRUE, 'More Goo Hotel');

-- Even More Goo Hotel
INSERT INTO Rooms (room_number, name, price, capacity, area, hotel_chain, upgradable, damages, view, amenities, address, availability, hotel)
VALUES
    (100254, 'Standard Room', 220.00, 1, 'Toronto', 'Snail Hotels', false, 'None', 'City View', 'TV, Wi-Fi', '55 Even More Goo St', TRUE, 'Even More Goo Hotel'),
    (100255, 'Standard Room', 240.00, 2, 'Toronto', 'Snail Hotels', false, 'None', 'City View', 'TV, Wi-Fi', '55 Even More Goo St', TRUE, 'Even More Goo Hotel'),
    (100256, 'Deluxe Room', 350.00, 3, 'Toronto', 'Snail Hotels', false, 'None', 'City View', 'Mini Bar', '55 Even More Goo St', TRUE, 'Even More Goo Hotel'),
    (100257, 'Luxury Suite', 520.00, 2, 'Toronto', 'Snail Hotels', true, 'None', 'City View', 'Mini Bar, Jacuzzi', '55 Even More Goo St', TRUE, 'Even More Goo Hotel'),
    (100258, 'Family Suite', 720.00, 5, 'Toronto', 'Snail Hotels', true, 'None', 'City View', 'Kitchenette, Sofa Bed', '55 Even More Goo St', TRUE, 'Even More Goo Hotel');

-- Still Goo Hotel
INSERT INTO Rooms (room_number, name, price, capacity, area, hotel_chain, upgradable, damages, view, amenities, address, availability, hotel)
VALUES
    (100259, 'Standard Room', 230.00, 1, 'Toronto', 'Snail Hotels', false, 'None', 'City View', 'TV, Wi-Fi', '55 Still Goo St', TRUE, 'Still Goo Hotel'),
    (100260, 'Standard Room', 250.00, 2, 'Toronto', 'Snail Hotels', false, 'None', 'City View', 'TV, Wi-Fi', '55 Still Goo St', TRUE, 'Still Goo Hotel'),
    (100261, 'Deluxe Room', 360.00, 3, 'Toronto', 'Snail Hotels', false, 'None', 'City View', 'Mini Bar', '55 Still Goo St', TRUE, 'Still Goo Hotel'),
    (100262, 'Luxury Suite', 530.00, 2, 'Toronto', 'Snail Hotels', true, 'None', 'City View', 'Mini Bar, Jacuzzi', '55 Still Goo St', TRUE, 'Still Goo Hotel'),
    (100263, 'Family Suite', 730.00, 5, 'Toronto', 'Snail Hotels', true, 'None', 'City View', 'Kitchenette, Sofa Bed', '55 Still Goo St', TRUE, 'Still Goo Hotel');

-- Wow More Goo Hotel
INSERT INTO Rooms (room_number, name, price, capacity, area, hotel_chain, upgradable, damages, view, amenities, address, availability, hotel)
VALUES
    (100264, 'Standard Room', 240.00, 1, 'Toronto', 'Snail Hotels', false, 'None', 'City View', 'TV, Wi-Fi', '55 Wow More Goo St', TRUE, 'Wow More Goo Hotel'),
    (100265, 'Standard Room', 260.00, 2, 'Toronto', 'Snail Hotels', false, 'None', 'City View', 'TV, Wi-Fi', '55 Wow More Goo St', TRUE, 'Wow More Goo Hotel'),
    (100266, 'Deluxe Room', 370.00, 3, 'Toronto', 'Snail Hotels', false, 'None', 'City View', 'Mini Bar', '55 Wow More Goo St', TRUE, 'Wow More Goo Hotel'),
    (100267, 'Luxury Suite', 540.00, 2, 'Toronto', 'Snail Hotels', true, 'None', 'City View', 'Mini Bar, Jacuzzi', '55 Wow More Goo St', TRUE, 'Wow More Goo Hotel'),
    (100268, 'Family Suite', 740.00, 5, 'Toronto', 'Snail Hotels', true, 'None', 'City View', 'Kitchenette, Sofa Bed', '55 Wow More Goo St', TRUE, 'Wow More Goo Hotel');

-- Dang Its Goo Hotel
INSERT INTO Rooms (room_number, name, price, capacity, area, hotel_chain, upgradable, damages, view, amenities, address, availability, hotel)
VALUES
    (100269, 'Standard Room', 250.00, 1, 'Toronto', 'Snail Hotels', false, 'None', 'City View', 'TV, Wi-Fi', '55 Dang Its Goo St', TRUE, 'Dang Its Goo Hotel'),
    (100270, 'Standard Room', 270.00, 2, 'Toronto', 'Snail Hotels', false, 'None', 'City View', 'TV, Wi-Fi', '55 Dang Its Goo St', TRUE, 'Dang Its Goo Hotel'),
    (100271, 'Deluxe Room', 380.00, 3, 'Toronto', 'Snail Hotels', false, 'None', 'City View', 'Mini Bar', '55 Dang Its Goo St', TRUE, 'Dang Its Goo Hotel'),
    (100272, 'Luxury Suite', 550.00, 2, 'Toronto', 'Snail Hotels', true, 'None', 'City View', 'Mini Bar, Jacuzzi', '55 Dang Its Goo St', TRUE, 'Dang Its Goo Hotel'),
    (100273, 'Family Suite', 750.00, 5, 'Toronto', 'Snail Hotels', true, 'None', 'City View', 'Kitchenette, Sofa Bed', '55 Dang Its Goo St', TRUE, 'Dang Its Goo Hotel');

-- Wow Goo Hotel
INSERT INTO Rooms (room_number, name, price, capacity, area, hotel_chain, upgradable, damages, view, amenities, address, availability, hotel)
VALUES
    (100274, 'Standard Room', 260.00, 1, 'Toronto', 'Snail Hotels', false, 'None', 'City View', 'TV, Wi-Fi', '55 Wow Goo St', TRUE, 'Wow Goo Hotel'),
    (100275, 'Standard Room', 280.00, 2, 'Toronto', 'Snail Hotels', false, 'None', 'City View', 'TV, Wi-Fi', '55 Wow Goo St', TRUE, 'Wow Goo Hotel'),
    (100276, 'Deluxe Room', 390.00, 3, 'Toronto', 'Snail Hotels', false, 'None', 'City View', 'Mini Bar', '55 Wow Goo St', TRUE, 'Wow Goo Hotel'),
    (100277, 'Luxury Suite', 560.00, 2, 'Toronto', 'Snail Hotels', true, 'None', 'City View', 'Mini Bar, Jacuzzi', '55 Wow Goo St', TRUE, 'Wow Goo Hotel'),
    (100278, 'Family Suite', 760.00, 5, 'Toronto', 'Snail Hotels', true, 'None', 'City View', 'Kitchenette, Sofa Bed', '55 Wow Goo St', TRUE, 'Wow Goo Hotel');

-- Welp Goo Hotel
INSERT INTO Rooms (room_number, name, price, capacity, area, hotel_chain, upgradable, damages, view, amenities, address, availability, hotel)
VALUES
    (100279, 'Standard Room', 270.00, 1, 'Toronto', 'Snail Hotels', false, 'None', 'City View', 'TV, Wi-Fi', '55 Welp Goo St', TRUE, 'Welp Goo Hotel'),
    (100280, 'Standard Room', 290.00, 2, 'Toronto', 'Snail Hotels', false, 'None', 'City View', 'TV, Wi-Fi', '55 Welp Goo St', TRUE, 'Welp Goo Hotel'),
    (100281, 'Deluxe Room', 400.00, 3, 'Toronto', 'Snail Hotels', false, 'None', 'City View', 'Mini Bar', '55 Welp Goo St', TRUE, 'Welp Goo Hotel'),
    (100282, 'Luxury Suite', 570.00, 2, 'Toronto', 'Snail Hotels', true, 'None', 'City View', 'Mini Bar, Jacuzzi', '55 Welp Goo St', TRUE, 'Welp Goo Hotel'),
    (100283, 'Family Suite', 770.00, 5, 'Toronto', 'Snail Hotels', true, 'None', 'City View', 'Kitchenette, Sofa Bed', '55 Welp Goo St', TRUE, 'Welp Goo Hotel');

