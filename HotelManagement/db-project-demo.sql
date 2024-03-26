-- ----------------------------
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

