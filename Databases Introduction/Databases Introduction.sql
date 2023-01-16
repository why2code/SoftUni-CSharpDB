--USE master
--DROP DATABASE Minions

--1
CREATE DATABASE Minions
GO

--2
USE [Minions]
CREATE TABLE Minions(
	Id INT PRIMARY KEY,
	[Name] VARCHAR(100),
	Age INT
);

CREATE TABLE Towns(
	Id INT PRIMARY KEY,
	[Name] VARCHAR(100)
);


--Editing the primary key after column already in the table
--ALTER TABLE Minions
--ALTER COLUMN Id INT NOT NULL

--ALTER TABLE Minions
--ADD CONSTRAINT Pk_Id PRIMARY KEY (Id);


--3
ALTER TABLE Minions
ADD TownId INT FOREIGN KEY REFERENCES Towns(Id);


--4
INSERT INTO Towns
VALUES
(1, 'Sofia'),
(2, 'Plovdiv'),
(3, 'Varna')

INSERT INTO Minions
	(Id, [Name], Age, TownId)
VALUES 
	(1, 'Kevin ', 22, 1),
	(2, 'Bob', 15, 3),
	(3, 'Steward', NULL, 2)


--5
TRUNCATE TABLE Minions

--6
DROP TABLE Minions
DROP TABLE [dbo].[Towns]

--7
CREATE TABLE People(
[ID] INT PRIMARY KEY IDENTITY,
[Name] NVARCHAR(200) NOT NULL,
[Picture] VARBINARY (MAX),
CHECK (DATALENGTH([Picture]) <= 2000000),
[Height] DECIMAL (3, 2),
[Weight] DECIMAL (5, 2),
[Gender] CHAR(1) NOT NULL,
CHECK ([Gender] = 'm' OR [Gender] = 'f'),
[Birthdate] DATE NOT NULL,
[Biography] NVARCHAR(MAX))

INSERT INTO [People] ([Name], [Height], [Weight], [Gender], [Birthdate])
VALUES
('Peshe', 1.77, 75.2,'m', '1998-05-25'),
('Ivan', 1.97, 75.2,'m', '1998-05-25'),
('Toni', 1.87, 75.2,'f', '2003-05-25'),
('Koza', 1.57, 75.2,'f', '2005-05-25'),
('Pacha', 1.55, 75.2,'m', '2000-05-25')

-- 8
CREATE TABLE [dbo].[Users]
(
    [Id] BIGINT PRIMARY KEY IDENTITY,
    [Username] VARCHAR(30) NOT NULL,
    [Password] VARCHAR(26) NOT NULL,
    [ProfilePicture] VARBINARY(MAX),
    [LastLoginTime] DATETIME2,
    [IsDeleted] BIT
);

INSERT INTO Users (Username, [Password], ProfilePicture, LastLoginTime, IsDeleted)
VALUES 
('Ivan', '123456', 333131, '2005-10-10', 0),
('Gosho', '123456', 333131, '2005-10-10', 0),
('Pesho', '123456', 333131, '2005-10-10', 0),
('Koci', '123456', 333131, '2005-10-10', 0),
('Krasi', '123456', 333131, '2005-10-10', 0)

 
-- 9 
ALTER TABLE [dbo].[Users] 
DROP CONSTRAINT [PK__Users__3214EC074615D3D5]
 
ALTER TABLE [dbo].[Users] 
ADD CONSTRAINT PK_IdUsername 
PRIMARY KEY (Id, Username)
 
-- 10
ALTER TABLE [dbo].[Users]
ADD CONSTRAINT CH_Password CHECK((LEN([Password]) >= 5))
 
-- 11 
ALTER TABLE [dbo].[Users]
ADD CONSTRAINT DF_LastLoginTime DEFAULT GETDATE() FOR LastLoginTime;
 
-- 12 
ALTER TABLE [dbo].[Users]
DROP CONSTRAINT [PK_IdUsername]
 
ALTER TABLE [dbo].[Users]
ADD CONSTRAINT PK_ID PRIMARY KEY (Id)
 
ALTER TABLE [dbo].[Users]
ADD CONSTRAINT CHK_Username CHECK((LEN([Username]) >= 3))
 

-- 13
CREATE DATABASE Movies
GO
USE Movies

CREATE TABLE Directors (
Id INT PRIMARY KEY IDENTITY, 
DirectorName NVARCHAR(50), 
Notes NVARCHAR(MAX))

INSERT INTO Directors (DirectorName, Notes)
VALUES
('Ivan', 'gotin direktor'),
('gOSHO', 'gotin direktor'),
('Pesho', 'gotin direktor'),
('Ivan2', 'gotin direktor'),
('Iva3', 'gotin direktor')

CREATE TABLE Genres 
(Id INT PRIMARY KEY IDENTITY, 
GenreName NVARCHAR(50), 
Notes NVARCHAR(MAX))

INSERT INTO Genres (GenreName, Notes)
VALUES
('Horror', 'Very scary!'),
('Horror2', 'Very scary2!'),
('Horror3', 'Very scary3!'),
('Horror4', 'Very scary4!'),
('Horror5', 'Very scary5!')

CREATE TABLE Categories (
Id INT PRIMARY KEY IDENTITY, 
CategoryName NVARCHAR(50), 
Notes NVARCHAR(MAX))

INSERT INTO Categories (CategoryName, Notes)
VALUES
('Movie', 'Movie'),
('Story', 'Movie'),
('Musical', 'Movie'),
('Movie2', 'Movie'),
('Story2', 'Movie')

CREATE TABLE Movies (
Id INT PRIMARY KEY IDENTITY, 
Title NVARCHAR(100), 
DirectorId INT NOT NULL, 
CopyrightYear INT NOT NULL, 
[Length] INT, 
GenreId INT NOT NULL, 
CategoryId INT NOT NULL,
Rating INT, 
Notes NVARCHAR(MAX))

INSERT INTO Movies(Title, DirectorId, CopyrightYear, [Length], GenreId, CategoryId, Rating, Notes)
VALUES
('New movie bro', 1, 2003, 120, 1, 1, 5, 'Veery nice movie!'),
('New movie bro', 2, 2003, 120, 2, 2, 5, 'Veery nice movie!'),
('New movie bro', 3, 2005, 120, 3, 3, 5, 'Veery nice movie!'),
('New movie bro', 4, 2006, 120, 4, 4, 5, 'Veery nice movie!'),
('New movie bro', 5, 2007, 120, 5, 5, 5, 'Veery nice movie!')

--14
CREATE DATABASE CarRental
GO
USE CarRental

CREATE TABLE Categories (
Id INT PRIMARY KEY IDENTITY, 
CategoryName NVARCHAR(100) NOT NULL, 
DailyRate DECIMAL NOT NULL, 
WeeklyRate DECIMAL, 
MonthlyRate DECIMAL, 
WeekendRate DECIMAL)

INSERT INTO Categories (CategoryName, DailyRate, WeeklyRate, MonthlyRate, WeekendRate)
VALUES
('SUV', 20.50, 100, 380, 50),
('Car', 20.50, 100, 380, 50),
('Van', 20.50, 100, 380, 50)


CREATE TABLE Cars (
Id INT PRIMARY KEY IDENTITY, 
PlateNumber NVARCHAR(20) NOT NULL, 
Manufacturer NVARCHAR(50) NOT NULL, 
Model NVARCHAR(30) NOT NULL, 
CarYear INT NOT NULL, 
CategoryId INT NOT NULL, 
Doors INT, 
Picture NVARCHAR(MAX), 
Condition NVARCHAR(100), 
Available BIT NOT NULL)

INSERT INTO Cars (PlateNumber, Manufacturer, Model, CarYear, CategoryId, Doors, Picture, Condition, Available)
VALUES
('CB 1111 AA', 'Kia', 'Sportage', 2022, 1, 5, 'linkToPic', 'New', 1),
('CB 1112 AA', 'Kia', 'Ceed', 2021, 2, 5, 'linkToPic', 'New', 0),
('CB 1113 AA', 'Kia', 'Cadenza', 2020, 3, 5, 'linkToPic', 'New', 1)


CREATE TABLE Employees (
Id INT PRIMARY KEY IDENTITY, 
FirstName NVARCHAR(50) NOT NULL, 
LastName NVARCHAR(50) NOT NULL, 
Title NVARCHAR(100) NOT NULL, 
Notes NVARCHAR(MAX))

INSERT INTO Employees (FirstName, LastName, Title, Notes)
VALUES
('Ivan', 'Ivanov', 'Manager', 'Best manager of all!'),
('Ivan2', 'Ivanov2', 'Genator', 'Best Genator of all!'),
('Ivan3', 'Ivanov3', 'Owner', 'Best Owner of all!')


CREATE TABLE Customers (
Id INT PRIMARY KEY IDENTITY, 
DriverLicenceNumber INT NOT NULL, 
FullName NVARCHAR(100) NOT NULL, 
[Address] NVARCHAR(200) NOT NULL, 
City NVARCHAR(50) NOT NULL, 
ZIPCode NVARCHAR(20), 
Notes NVARCHAR(MAX))

INSERT INTO Customers (DriverLicenceNumber, FullName, [Address], City, ZIPCode, Notes)
VALUES
(1234555661, 'Vankata Ivanov', 'Gorno Nanadolnishte 5', 'Sofia', '1000CZ', 'Strashen pich!'),
(1234555662, 'Vankata Ivanov2', 'Gorno Nanadolnishte 5', 'Sofia2', '1000CZ', 'Strashen pich!'),
(1234555663, 'Vankata Ivanov3', 'Gorno Nanadolnishte 5', 'Sofia3', '1000CZ', 'Strashen pich!')


CREATE TABLE RentalOrders (
Id INT PRIMARY KEY IDENTITY, 
EmployeeId INT NOT NULL, 
CustomerId INT NOT NULL, 
CarId INT NOT NULL, 
TankLevel NVARCHAR(10) NOT NULL, 
KilometrageStart INT NOT NULL, 
KilometrageEnd INT NOT NULL, 
TotalKilometrage INT, 
StartDate DATETIME2 NOT NULL, 
EndDate DATETIME2 NOT NULL, 
TotalDays INT, 
RateApplied DECIMAL NOT NULL, 
TaxRate DECIMAL NOT NULL, 
OrderStatus NVARCHAR(20) NOT NULL, 
Notes NVARCHAR(MAX))


INSERT INTO RentalOrders (EmployeeId, CustomerId, CarId, TankLevel, KilometrageStart, KilometrageEnd, TotalKilometrage, StartDate, EndDate, TotalDays, RateApplied, TaxRate, OrderStatus, Notes)
VALUES
(1, 1, 1, '50%', 10100, 10500, 400, '2022-10-10', '2022-10-11', 1, 20.33, 20, 'Closed', 'Good customer'),
(2, 2, 2, '20%', 10102, 10502, 402, '2022-10-10', '2022-10-12', 2, 20.33, 20, 'Closed', 'Good customer2'),
(3, 3, 3, '40%', 10103, 10503, 403, '2022-10-10', '2022-10-13', 3, 20.33, 20, 'Closed', 'Good customer3')



--15
CREATE DATABASE Hotel
GO
USE Hotel
 
CREATE TABLE [dbo].[Employees]
(
    Id INT PRIMARY KEY IDENTITY,
    FirstName NVARCHAR(100) NOT NULL,
    LastName NVARCHAR(100) NOT NULL,
    Title NVARCHAR(100),
    Notes NVARCHAR(MAX)
)
INSERT INTO [dbo].[Employees]
    (FirstName,LastName,Title,Notes)
VALUES
('gosho', 'goshev', 'shef', 'abe gotin shef'),
('gosho2', 'goshev', 'shef', 'abe gotin shef2'),
('gosho3', 'goshev', 'shef', 'abe gotin shef3')
 

Create TABLE [dbo].[Customers]
(
    Id INT PRIMARY KEY IDENTITY,
	AccountNumber INT NOT NULL,
    FirstName NVARCHAR(100) NOT NULL,
    LastName NVARCHAR(100) NOT NULL,
    PhoneNumber CHAR(10) NOT NULL,
    EmergencyName NVARCHAR(100) NOT NULL,
    EmergencyNumber CHAR(10) NOT NULL,
    Notes NVARCHAR(MAX)
)

INSERT INTO [dbo].[Customers]
    (AccountNumber,FirstName,LastName,PhoneNumber,EmergencyName,EmergencyNumber, Notes)
VALUES
(1231313131, 'gosho', 'goshev', 33333444, 'g-ja goshevica', 4444444333, 'gotini pichove'),
(1231313132, 'gosho2', 'goshev', 33333444, 'g-ja goshevica2', 4444444333, 'gotini pichove2'),
(1231313133, 'gosho3', 'goshev', 33333444, 'g-ja goshevica3', 4444444333, 'gotini pichove3')
 

CREATE TABLE [dbo].[RoomStatus]
(
	Id INT PRIMARY KEY IDENTITY,
    RoomStatus BIT NOT NULL,
    Notes NVARCHAR(MAX)
)

INSERT INTO RoomStatus (RoomStatus, Notes)
VALUES
(0, 'Mnogo qka SVOBODNA staq'),
(1, 'Mnogo qka ZAAETA staq'),
(1, 'Mnogo qka SVOBODNA staq2')
 

CREATE TABLE [dbo].[RoomTypes]
(
	Id INT PRIMARY KEY IDENTITY,
    RoomType NVARCHAR(50) NOT NULL,
    Notes NVARCHAR(MAX)
)

INSERT INTO [dbo].[RoomTypes] (RoomType, Notes)
VALUES
('Suteren', 'Gotin suteren'),
('Suteren2', 'Gotin suteren2'),
('Suteren3', 'Gotin suteren3')
 

CREATE TABLE [dbo].[BedTypes]
(
	Id INT PRIMARY KEY IDENTITY,
    BedType NVARCHAR(50) NOT NULL,
    Notes NVARCHAR(MAX)
)

INSERT INTO [dbo].[BedTypes] (BedType, Notes)
VALUES
('King-size', 'Mega qkata staq!'),
('King-size2', 'Mega qkata staq!2'),
('King-size3', 'Mega qkata staq!3')
 

CREATE TABLE [dbo].[Rooms]
(
	RoomNumber INT PRIMARY KEY,
    RoomType NVARCHAR(50) NOT NULL,
    BedType NVARCHAR(50) NOT NULL,
    Rate SMALLINT,
    RoomStatus BIT NOT NULL,
    Notes NVARCHAR(MAX)
)

INSERT INTO [dbo].[Rooms]
    (RoomNumber, RoomType,BedType,Rate,RoomStatus,Notes)
VALUES
(1, 'Suteren', 'King-size', 5, 1, 'qKA STAQ'),
(2, 'Suteren2', 'King-size', 5, 0, 'qKA STAQ2'),
(3, 'Suteren3', 'King-size', 5, 1, 'qKA STAQ3')
 

CREATE TABLE [dbo].[Payments]
(
    Id INT PRIMARY KEY IDENTITY,
    EmployeeId INT NOT NULL,
    PaymentDate DATETIME2 NOT NULL,
    AccountNumber INT NOT NULL,
    FirstDateOccupied DATETIME2 NOT NULL,
    LastDateOccupied DATETIME2 NOT NULL,
    TotalDays INT,
    AmountCharged DECIMAL(15,2),
    TaxRate INT,
    TaxAmount DECIMAL,
    PaymentTotal DECIMAL(15,2),
    Notes NVARCHAR(MAX)
)

INSERT INTO [dbo].[Payments]
    (EmployeeId,PaymentDate,AccountNumber,FirstDateOccupied,LastDateOccupied,TotalDays,AmountCharged,TaxRate,TaxAmount,PaymentTotal, Notes)
VALUES
(1, '2022-10-10', 12344455, '2022-10-10', '2022-10-15', 5, 120.10, 20, 20.10, 140.20, 'Paid'),
(2, '2022-10-10', 12344452, '2022-10-10', '2022-10-12', 2, 120.10, 20, 20.10, 140.20, 'Paid2'),
(3, '2022-10-10', 12344453, '2022-10-10', '2022-10-13', 3, 120.10, 20, 20.10, 140.20, 'Paid3')
 

CREATE TABLE [dbo].[Occupancies]
(
    Id INT PRIMARY KEY IDENTITY,
    EmployeeId INT NOT NULL,
    DateOccupied DATETIME2 NOT NULL,
    AccountNumber INT NOT NULL,
    RoomNumber INT NOT NULL,
    RateApplied INT NOT NULL,
    PhoneCharge DECIMAL(15,2),
    Notes NVARCHAR(MAX)
)

INSERT INTO [dbo].[Occupancies]
    (EmployeeId, DateOccupied, AccountNumber, RoomNumber, RateApplied, PhoneCharge, Notes)
VALUES
(1, '2022-10-10', 1234544331, 22, 3, 12.33, 'ot SKYPOTO!'),
(2, '2022-10-12', 1234544331, 22, 3, 12.34, 'ot SKYPOTO2!'),
(3, '2022-10-13', 1234544331, 22, 3, 12.35, 'ot SKYPOTO3!')


--16 AND 18
CREATE DATABASE SoftUni2
GO
USE SoftUni2

CREATE TABLE Towns (
Id INT PRIMARY KEY IDENTITY, 
[Name] NVARCHAR(50) NOT NULL
);

INSERT INTO Towns ([Name])
VALUES
('Sofia'), ('Plovdiv'), ('Varna'), ('Burgas')

CREATE TABLE Addresses (
Id INT PRIMARY KEY IDENTITY, 
AddressText NVARCHAR(100) NOT NULL, 
TownId INT FOREIGN KEY REFERENCES Towns(Id)
)

CREATE TABLE Departments (
Id INT PRIMARY KEY IDENTITY, 
[Name] NVARCHAR(80) NOT NULL
)

INSERT INTO Departments ([Name])
VALUES
('Engineering'), 
('Sales'), 
('Marketing'), 
('Software Development'), 
('Quality Assurance')

CREATE TABLE Employees (
Id INT PRIMARY KEY IDENTITY, 
FirstName NVARCHAR(50) NOT NULL, 
MiddleName NVARCHAR(50), 
LastName NVARCHAR(50) NOT NULL, 
JobTitle NVARCHAR(30) NOT NULL, 
DepartmentId INT FOREIGN KEY REFERENCES Departments(Id), 
HireDate DATETIME2 NOT NULL, 
Salary DECIMAL NOT NULL, 
AddressId INT FOREIGN KEY REFERENCES Addresses(Id)
)

INSERT INTO Employees(FirstName, MiddleName, LastName, JobTitle, DepartmentId, HireDate, Salary)
VALUES
('Ivan', 'Ivanov', 'Ivanov', '.NET Developer', 4, '2013-02-01', 3500.00),
('Petar', 'Petrov', 'Petrov', 'Senior Engineer', 1, '2004-03-02', 4000.00),
('Maria', 'Petrova', 'Ivanova', 'Intern', 5, '2016-08-28', 525.25),
('Georgi', 'Teziev', 'Ivanov', 'CEO', 2, '2007-12-09', 3000.00),
('Peter', 'Pan', 'Pan', 'Intern', 3, '2016-08-28', 599.88)

--19
SELECT * FROM Towns
SELECT * FROM Departments
SELECT * FROM Employees

--20
SELECT * FROM Towns ORDER BY [Name]
SELECT * FROM Departments ORDER BY [Name]
SELECT * FROM Employees ORDER BY [Salary] DESC


--21
SELECT [Name] FROM Towns ORDER BY [Name]
SELECT [Name] FROM Departments ORDER BY [Name]
SELECT FirstName, LastName, JobTitle, Salary FROM Employees ORDER BY [Salary] DESC


--22
SELECT * FROM Employees
UPDATE Employees
SET [Salary] += [Salary] * 0.10

SELECT Salary FROM Employees


--23
USE Hotel
SELECT * FROM Payments
UPDATE Payments
SET [TaxRate] -= [TaxRate] * 0.03

SELECT TaxRate from Payments


--24
SELECT * FROM Occupancies
TRUNCATE TABLE Occupancies
