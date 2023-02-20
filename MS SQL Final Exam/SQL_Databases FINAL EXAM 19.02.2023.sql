CREATE DATABASE Boardgames
USE Boardgames

-- Problem 01
CREATE TABLE Categories
(
	Id INT PRIMARY KEY IDENTITY,
	[Name] VARCHAR(50) NOT NULL
)

CREATE TABLE Addresses
(
	Id INT PRIMARY KEY IDENTITY,
	StreetName VARCHAR(100) NOT NULL,
	StreetNumber INT NOT NULL,
	Town VARCHAR(30) NOT NULL,
	Country VARCHAR(50) NOT NULL,
	ZIP INT NOT NULL
)

CREATE TABLE Publishers
(
	Id INT PRIMARY KEY IDENTITY,
	[Name] VARCHAR(30) UNIQUE NOT NULL,
	AddressId INT FOREIGN KEY REFERENCES Addresses(Id) NOT NULL,
	Website VARCHAR(40),
	Phone VARCHAR(20)
)

CREATE TABLE PlayersRanges
(
	Id INT PRIMARY KEY IDENTITY,
	PlayersMin INT NOT NULL,
	PlayersMax INT NOT NULL
)

CREATE TABLE Boardgames
(
	Id INT PRIMARY KEY IDENTITY,
	[Name] VARCHAR(30) NOT NULL,
	YearPublished INT NOT NULL,
	Rating DECIMAL(20,2) NOT NULL,
	CategoryId INT FOREIGN KEY REFERENCES Categories(Id) NOT NULL,
	PublisherId INT FOREIGN KEY REFERENCES Publishers(Id) NOT NULL,
	PlayersRangeId INT FOREIGN KEY REFERENCES PlayersRanges(Id) NOT NULL,
)

CREATE TABLE Creators
(
	Id INT PRIMARY KEY IDENTITY,
	FirstName VARCHAR(30) NOT NULL,
	LastName VARCHAR(30) NOT NULL,
	Email VARCHAR(30) NOT NULL	
)

CREATE TABLE CreatorsBoardgames
(
	CreatorId INT FOREIGN KEY REFERENCES Creators(Id) NOT NULL,
	BoardgameId INT FOREIGN KEY REFERENCES Boardgames(Id) NOT NULL,
	PRIMARY KEY (CreatorId, BoardgameId)
)

-- Problem 02
INSERT INTO Publishers([Name], AddressId, Website, Phone)
VALUES 
('Agman Games', 5, 'www.agmangames.com', '+16546135542'),
('Amethyst Games', 7, 'www.amethystgames.com' , '+15558889992'),
('BattleBooks', 13, 'www.battlebooks.com', '+12345678907')


INSERT INTO Boardgames([Name], YearPublished, Rating, CategoryId, PublisherId, PlayersRangeId)
VALUES
('Deep Blue', 2019, 5.67, 1, 15, 7),
('Paris', 2016, 9.78, 7, 1, 5),
('Catan: Starfarers', 2021, 9.87, 7, 13, 6),
('Bleeding Kansas', 2020, 3.25, 3, 7, 4),
('One Small Step', 2019, 5.75, 5, 9, 2)


-- Problem 03
SELECT * FROM PlayersRanges
WHERE PlayersMin >=2 OR PlayersMax <= 2

UPDATE PlayersRanges
SET PlayersMax = 3
WHERE PlayersMin = 2 AND PlayersMax = 2


UPDATE Boardgames
SET [Name] = CONCAT([Name], 'V2')
WHERE YearPublished >= 2020



-- Problem 04
SELECT * FROM Addresses
WHERE LEFT(Town,1) = 'L'

SELECT * FROM Publishers
WHERE AddressId = 5

SELECT * FROM Boardgames
WHERE PublisherId IN (1, 16)

SELECT * FROM CreatorsBoardgames
WHERE BoardgameId IN (1, 16, 31, 47)

SELECT * FROM Creators
WHERE Id IN (1, 2, 3, 4, 6)


DELETE FROM Creators
WHERE Id IN (1, 2, 3, 4, 6)

DELETE FROM CreatorsBoardgames
WHERE BoardgameId IN (1, 16, 31, 47)

DELETE FROM Boardgames
WHERE PublisherId IN (1, 16)

DELETE FROM Publishers
WHERE AddressId = 5

DELETE FROM Addresses
WHERE LEFT(Town,1) = 'L'


-- Problem 05
SELECT		[Name],
			Rating
FROM		Boardgames
ORDER BY	YearPublished ASC,
			[Name] DESC

-- Problem 06
SELECT		b.Id,
			b.[Name],
			b.YearPublished,
			c.[Name] AS [CategoryName]
FROM		Boardgames AS b
JOIN		Categories AS c
ON			b.CategoryId = c.Id
WHERE		c.[Name] = 'Strategy Games' OR c.[Name] = 'Wargames'
ORDER BY	YearPublished DESC

-- Problem 07
SELECT		c.Id,
			CONCAT(c.FirstName, ' ', c.LastName) AS [CreatorName],
			c.Email
FROM		Creators AS c
LEFT JOIN	CreatorsBoardgames AS cb
ON			c.Id = cb.CreatorId
WHERE		cb.CreatorId IS NULL
ORDER BY	c.FirstName


-- Problem 08
SELECT		TOP(5)
			b.[Name],
			b.Rating,
			c.[Name]
FROM		Boardgames AS b
LEFT JOIN	PlayersRanges AS p
ON			b.PlayersRangeId = p.Id
LEFT JOIN	Categories AS c
ON			b.CategoryId = c.Id
WHERE		(Rating > 7 AND CHARINDEX('a', b.[Name]) > 0)  OR (Rating > 7.50 AND (p.PlayersMin >= 2 AND p.PlayersMax <= 5))
ORDER BY	b.[Name],
			b.Rating DESC

-- Problem 09
SELECT		CONCAT(c.FirstName, ' ', c.LastName) AS [FullName],
			c.Email,
			MAX(b.Rating) AS [Rating]
FROM		Creators AS c
LEFT JOIN	CreatorsBoardgames AS cb
ON			c.Id = cb.CreatorId
LEFT JOIN	Boardgames AS b
ON			cb.BoardgameId = b.Id
WHERE		RIGHT(c.Email, 4) = '.com'
GROUP BY	c.FirstName, c.LastName, c.Email
HAVING		MAX(b.Rating) > 0

-- Problem 10
SELECT		c.LastName,
			CEILING(AVG(b.Rating)) AS [AverageRating],
			p.[Name] AS [PublisherName]
FROM		Creators AS c
LEFT JOIN	CreatorsBoardgames AS cb
ON			c.Id = cb.CreatorId
LEFT JOIN	Boardgames AS b
ON			cb.BoardgameId = b.Id
LEFT JOIN	Publishers AS p
ON			b.PublisherId = p.Id
WHERE		p.[Name] = 'Stonemaier Games'
GROUP BY	c.FirstName, c.LastName, p.[Name]
ORDER BY	(AVG(b.Rating)) DESC

-- Problem 11
GO;

CREATE FUNCTION udf_CreatorWithBoardgames(@name VARCHAR(30))
RETURNS INT
AS
BEGIN
		DECLARE @RES INT;
		SET @RES = (
		SELECT		COUNT(*) AS [Count]
		FROM		Creators AS c
		JOIN	CreatorsBoardgames AS cb
		ON			c.Id = cb.CreatorId
		LEFT JOIN	Boardgames AS b
		ON			cb.BoardgameId = b.Id
		WHERE		c.FirstName = @name)

		RETURN @RES;
END;
GO;

SELECT dbo.udf_CreatorWithBoardgames('Corey')

-- Problem 12
GO;

CREATE PROCEDURE usp_SearchByCategory(@category VARCHAR(50))
AS
BEGIN
		SELECT		b.[Name],
					b.YearPublished,
					b.Rating,
					c.[Name] AS [CategoryName],
					p.[Name] AS [PublisherName],
					CONCAT(pr.PlayersMin, ' people') AS MinPlayers,
					CONCAT(pr.PlayersMax, ' people') AS MaxPlayers
		FROM		Categories AS c
		JOIN	Boardgames AS b
		ON			c.Id = b.CategoryId
		LEFT JOIN	Publishers AS p
		ON			p.Id = b.PublisherId
		LEFT JOIN	PlayersRanges AS pr
		ON			b.PlayersRangeId = pr.Id
		WHERE		c.[Name] = @category
		ORDER BY	p.[Name],
					b.YearPublished DESC
END;


