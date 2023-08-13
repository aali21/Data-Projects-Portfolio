-- Procedure that resets the gameplay to initial state - this is to make it easier to troubleshoot and modify rules/gamesteps as I'm creating them
DELIMITER /
CREATE PROCEDURE initial_tables()
BEGIN
 SET FOREIGN_KEY_CHECKS = 0;
 DROP TABLE IF EXISTS `Audit`, `Bonus`,`Location`,`Players`,`Property`,`Gameplay`;
 SET FOREIGN_KEY_CHECKS = 1;

CREATE TABLE `Location` (
  `Location_ID` INT NOT NULL AUTO_INCREMENT,
  `Location_name` VARCHAR(45) NOT NULL, 
  `Type` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`Location_ID`)
);

CREATE TABLE `Bonus` (
  `Bonus_ID` INT NOT NULL AUTO_INCREMENT,
  `Bonus_name` VARCHAR(45) NOT NULL DEFAULT 'none',
  `Description` tinytext NOT NULL,
  `Location_ID` INT NOT NULL,
  PRIMARY KEY (`Bonus_ID`),
  FOREIGN KEY (`Location_ID`) REFERENCES `Location`(`Location_ID`)
);

CREATE TABLE `Players` (
  `Player_ID` INT NOT NULL AUTO_INCREMENT,
  `Player_name` VARCHAR(45) NOT NULL DEFAULT 'none',
  `Bank_balance` INT NULL DEFAULT 200,
  `Chosen_token` VARCHAR(20) NOT NULL DEFAULT 'none',
  `Bonus` INT NULL DEFAULT NULL,
  `Current_location` INT NOT NULL,
  PRIMARY KEY (`Player_ID`),
  FOREIGN KEY (`Current_location`) REFERENCES `Location`(`Location_ID`),
  FOREIGN KEY (`Bonus`) REFERENCES `Bonus`(`Bonus_ID`),
  FOREIGN KEY (`Chosen_token`) REFERENCES `Token`(`Token_name`)
);

CREATE TABLE `Property` (
  `Property_ID` INT NOT NULL AUTO_INCREMENT,
  `Property_name` VARCHAR(45) NOT NULL,
  `Purchase_cost` INT NOT NULL,
  `Property_owner` VARCHAR(45) NULL,
  `Colour` VARCHAR(45) NOT NULL,
  `Location_ID` INT NOT NULL,
  UNIQUE(`Property_name`),
  PRIMARY KEY (`Property_ID`),
  FOREIGN KEY (`Location_ID`) REFERENCES `Location`(`Location_ID`)
);

-- Turn_taken acts as a unique identifier for each instance of a gameplay
CREATE TABLE `Audit` (
  `Turn_taken` INT NOT NULL AUTO_INCREMENT,
  `Player_ID` INT NOT NULL,
  `Location_landed_on` INT NULL,
  `Current_bank_balance` INT NULL,
  `Game_round_number` VARCHAR(4) NULL,
  PRIMARY KEY (`Turn_taken`),
  FOREIGN KEY (`Location_landed_on`) REFERENCES `Location`(`Location_ID`),
  FOREIGN KEY (`Player_ID`) REFERENCES `Players`(`Player_ID`)
);
-- Gameplay table that stores the gameplay number and player ID with their respective roll
CREATE TABLE `Gameplay` (
  `Gameplay_ID` INT NOT NULL AUTO_INCREMENT,
  `Round_number` INT NOT NULL,
  `Player_ID` INT NOT NULL,
  `Dice_roll` INT NOT NULL,
  PRIMARY KEY (`Gameplay_ID`),
  FOREIGN KEY (`Player_ID`) REFERENCES `Players`(`Player_ID`)
);

-- Inserting the current values into the tables
INSERT INTO property (`Property_name`, `Purchase_cost`, `Colour`,`Property_owner`)
VALUES ('Oak house', 100, 'Orange','Norman'),
('Owens Park',30,'Orange','Norman'),
('AMBS',400,'Blue',DEFAULT),
('Co-Op',30,'Blue','Jane'),
('Kilburn',120,'Yellow',DEFAULT),
('Uni Place',100,'Yellow','Mary'),
('Victoria',75,'Green','Bill'),
('Piccadilly',35,'Green',DEFAULT);

INSERT INTO location (`Location_name`,`Type`)
VALUES ('GO','Corner'),
('Kilburn','Property'),
('CHANCE 1','Chance'),
('Uni Place','Property'),
('IN JAIL','Corner'),
('Victoria','Property'),
('COMMUNITY CHEST 1','Community chest'),
('Piccadilly','Property'),
('FREE PARKING','Corner'),
('Oak House','Property'),
('CHANCE 2','Chance'),
('Owens Park','Property'),
('GO TO JAIL','Corner'),
('AMBS','Property'),
('COMMUNITY CHEST 2','Community chest'),
('Co-op','Property');

INSERT INTO bonus (`Bonus_name`, `Description`,`Location_ID`)
VALUES ('Chance 1', 'Pay each of the other players £50',3),
('Chance 2','Move forward 3 spaces',11),
('Community Chest 1','For winning a Beauty Contest, you win £100',7),
('Community Chest 2','Your library books are overdue. Play a fine of £30',15),
('Free Parking','No action',9),
('Go to Jail','Go to Jail, do not pass GO, do not collect £200',13),
('GO','Collect £200',1);

INSERT INTO players (`Player_name`, `Chosen_token`,`Current_location`,`Bank_balance`)
VALUES ('Mary', 'Battleship',9,190),
('Bill','Dog',12,500),
('Jane','Car',14,150),
('Norman','Thimble',2,250);

INSERT INTO Gameplay (`Round_number`,`Player_ID`,`Dice_roll`)
VALUES (1,3,3),
(1,4,1),
(1,1,4),
(1,2,2),
(2,3,5),
(2,4,4),
(2,1,6),
(2,1,5),
(2,2,6),
(2,2,3);

-- Updating bonus column in players table by checking the location and assigning a bonus based off that.
SET SQL_SAFE_UPDATES = 0;
UPDATE players
INNER JOIN bonus AS b ON b.Location_ID = players.Current_location
SET players.Bonus = b.Bonus_ID;

-- Updating property table so it has a location ID
UPDATE property
INNER JOIN location AS l ON l.Location_name = property.Property_name
SET property.Location_ID = l.Location_ID;
SET SQL_SAFE_UPDATES = 1;
END /
DELIMITER ; -- Stored procedure initial_tables() ends here
-- Calling the procedure to create and populate the initial tables
CALL initial_tables();


-- Defining a stored procedure which takes the player ID, dice roll and the game round and inserts values from the players and gameplay table based of which player rolled what
DELIMITER /
CREATE PROCEDURE audit_insert(IN player_id INT, IN dice_roll INT, IN game_round INT)
BEGIN
INSERT INTO audit (`Player_ID`,`Location_landed_on`,`Current_bank_balance`,`Game_round_number`)
SELECT g.Player_ID, p.Current_location, p.Bank_balance, g.Round_number FROM players AS p
INNER JOIN gameplay AS g ON p.Player_ID = g.Player_ID
WHERE g.Player_ID = player_id AND g.Round_number= game_round AND g.Dice_roll = dice_roll;
END /
DELIMITER ;

-- Procedure that updates the player location and the bonus held at that location
DELIMITER /
CREATE PROCEDURE updating_location_bonus(IN player_id INT, IN dice_roll INT)
BEGIN
UPDATE players p
SET p.Current_location = IF(p.Current_location+ dice_roll = 13 , 5,
IF(MOD(p.Current_location + dice_roll ,16)= 0, 16, MOD(p.Current_location+ dice_roll, 16)))
WHERE p.Player_ID= player_id;
-- (used the Modulus as if I update a current location of say 14, and add 3 to it, I end -- up with 17. The MOD operator ensures that the Current_location is set to 1 instead of -- 17 (which doesn't exist). Also if the location landed on is 'GO TO JAIL'
-- (location 13) then the current location is set to 5 ('IN JAIL')

-- Updating bonus column 
UPDATE players p
LEFT JOIN bonus AS b ON b.Location_ID = p.Current_location
SET p.Bonus = IF(b.Location_ID != 3 OR b.Location_ID != 11 OR b.Location_ID != 7 OR b.Location_ID != 15
OR b.Location_ID != 9 OR b.Location_ID != 13 OR b.Location_ID != 1, b.Bonus_ID, NULL)
WHERE p.Player_ID = player_id;
-- Updating the bonus column based on the location landed

END /
DELIMITER ;

-- Stored procedure for updating the property owner
DELIMITER /
CREATE PROCEDURE property_update(IN player_id INT)
BEGIN
-- Updating property owner using players and location table
UPDATE property pr
LEFT JOIN players AS p ON p.Current_location = pr.Location_ID
LEFT JOIN location AS l ON p.Current_location = l.Location_ID
SET pr.Property_owner = p.Player_name
WHERE p.Player_ID = player_id;
END /
DELIMITER ;

-- Procedure for reducing the bank balance by how much the 
-- property cost (using the property table)
DELIMITER /
CREATE PROCEDURE balance_update(IN player_id INT)
BEGIN
UPDATE players p
INNER JOIN property AS pr ON pr.Location_ID = p.Current_location
SET p.Bank_balance = p.Bank_balance - pr.Purchase_cost
WHERE p.Player_ID = player_id;
END /
DELIMITER ;

-- G1: Jane rolls a 3
-- Updating location and bonus for Jane
CALL updating_location_bonus(3,3);

-- Jane landed on GO so she gets £200 (R4)
UPDATE players p
SET p.Bank_balance = p.Bank_balance + 200
WHERE Player_ID = 3;

-- Inserting the first turn
CALL audit_insert(3,3,1);

-- G2: Norman (Player_ID 4) rolls a 1
CALL updating_location_bonus(4,1);

-- Norman landed on Chance 1 bonus so has to pay each of the other players £50. His balance reduces by £150
UPDATE players p
SET p.Bank_balance = p.Bank_balance - 150
WHERE Player_ID = 4;

-- Adding £50 to the balance of all players other than Norman
UPDATE players p
SET p.Bank_balance = p.Bank_balance + 50
WHERE Player_ID <> 4;

CALL audit_insert(4,1,1);

-- G3 Mary (Player_ID 1) rolls a 4, she goes to jail
CALL updating_location_bonus(1,4);
CALL audit_insert(1,4,1);

-- G4 Bill (Player_ID 2) rolls a 2
-- Bill lands on AMBS and needs to purchase it (as it's NULL), reducing his balance by 400
CALL updating_location_bonus(2,2);

-- Using balance_update procedure to update Bills balance and also updating the property table
CALL balance_update(2);
CALL property_update(2);
CALL audit_insert(2,2,1);

-- Creating the gameview for the first round
CREATE VIEW gameView1 AS SELECT a.Game_round_number AS `Round number` , p.Player_name AS `Player name` ,p.Chosen_token AS `Token`,
p.Bank_balance AS `Bank balance`, l.Location_name AS `Current location`	
FROM players AS p
LEFT JOIN audit AS a ON p.Player_ID = a.Player_ID
LEFT JOIN location AS l ON p.Current_location = l.Location_ID
WHERE a.Player_ID = p.Player_ID AND a.Game_round_number = 1;
SELECT * FROM gameView1;

