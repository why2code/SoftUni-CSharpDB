CREATE DATABASE NationalTouristSitesOfBulgaria
USE NationalTouristSitesOfBulgaria

-- Problem 01
CREATE TABLE Categories
(
	Id INT PRIMARY KEY IDENTITY,
	[Name] VARCHAR(50) NOT NULL
)

CREATE TABLE Locations
(
	Id INT PRIMARY KEY IDENTITY,
	[Name] VARCHAR(50) NOT NULL,
	Municipality VARCHAR(50),
	Province VARCHAR(50)
)

CREATE TABLE Sites
(
	Id INT PRIMARY KEY IDENTITY,
	[Name] VARCHAR(100) NOT NULL,
	LocationId INT FOREIGN KEY REFERENCES Locations(Id) NOT NULL,
	CategoryId INT FOREIGN KEY REFERENCES Categories(Id) NOT NULL,
	Establishment VARCHAR(15)
)

CREATE TABLE Tourists
(
	Id INT PRIMARY KEY IDENTITY,
	[Name] VARCHAR(50) NOT NULL,
	Age INT CHECK(Age >= 0 AND Age <=120) NOT NULL,
	PhoneNumber VARCHAR(20) NOT NULL,
	Nationality VARCHAR(30) NOT NULL,
	Reward VARCHAR(20)
)

CREATE TABLE SitesTourists
(
	TouristId INT FOREIGN KEY REFERENCES Tourists(Id) NOT NULL,
	SiteId INT FOREIGN KEY REFERENCES Sites(Id) NOT NULL,
	PRIMARY KEY(TouristId, SiteId)
)

CREATE TABLE BonusPrizes
(
	Id INT PRIMARY KEY IDENTITY,
	[Name] VARCHAR(50) NOT NULL
)

CREATE TABLE TouristsBonusPrizes
(
	TouristId INT FOREIGN KEY REFERENCES Tourists(Id) NOT NULL,
	BonusPrizeId INT FOREIGN KEY REFERENCES BonusPrizes(Id) NOT NULL,
	PRIMARY KEY(TouristId, BonusPrizeId)
)


-- Problem 02
INSERT INTO Tourists ([Name], Age, PhoneNumber, Nationality, Reward)
VALUES
	('Borislava Kazakova'	,52,	'+359896354244',	'Bulgaria',	NULL),
	('Peter Bosh'	,48,	'+447911844141',	'UK',	NULL),
	('Martin Smith'	,29,	'+353863818592',	'Ireland',	'Bronze badge'),
	('Svilen Dobrev'	,49,	'+359986584786',	'Bulgaria',	'Silver badge'),
	('Kremena Popova'	,38,	'+359893298604',	'Bulgaria',	NULL)

INSERT INTO Sites([Name], LocationId, CategoryId, Establishment)
VALUES
	('Ustra fortress',	90,	7, 'X'),
	('Karlanovo Pyramids',	65,	7, NULL),
	('The Tomb of Tsar Sevt',	63,	8, 'V BC'),
	('Sinite Kamani Natural Park',	17,	1, NULL),
	('St. Petka of Bulgaria – Rupite',	92,	6, '1994')


-- Problem 03
UPDATE Sites
SET Establishment = '(not defined)'
WHERE Establishment IS NULL

-- Problem 04
SELECT * FROM BonusPrizes
SELECT * FROM TouristsBonusPrizes
SELECT * FROM Tourists WHERE Reward = 'Sleeping bag';

DELETE FROM Tourists WHERE Reward = 'Sleeping bag';
DELETE FROM TouristsBonusPrizes WHERE BonusPrizeId = 5
DELETE FROM BonusPrizes WHERE Id = 5;

-- Problem 05
SELECT		[Name],
			Age,
			PhoneNumber,
			Nationality
FROM		Tourists
ORDER BY	Nationality,
			Age DESC,
			[Name]

-- Problem 06
SELECT		s.[Name] AS [Site],
			l.[Name] AS [Location],
			s.Establishment,
			c.[Name] AS [Category]
FROM		Sites AS s
LEFT JOIN	Locations AS l ON s.LocationId = l.Id
LEFT JOIN	Categories AS c ON s.CategoryId = c.Id
ORDER BY	c.[Name] DESC,
			l.[Name],
			s.[Name]


-- Problem 07
SELECT		l.Province AS [Province], 
			l.Municipality AS [Municipality],
			l.[Name] AS [Location],
			COUNT(s.[Name]) AS [CountOfSites]
FROM		Locations AS l
LEFT JOIN	Sites AS s ON l.Id = s.LocationId
WHERE		l.Province = 'Sofia'
GROUP BY	l.Province, l.Municipality, l.[Name]
ORDER BY	COUNT(s.[Name]) DESC,
			l.[Name]

-- Problem 08
SELECT		s.[Name] AS [Site],
			l.[Name] AS [Location],
			l.Municipality,
			l.Province,
			s.Establishment
FROM		Sites AS s
JOIN		Locations AS l
ON			s.LocationId = l.Id
WHERE		LEFT(l.[Name], 1) <> 'B'
AND			LEFT(l.[Name], 1) <> 'M'
AND			LEFT(l.[Name], 1) <> 'D'
AND			RIGHT(s.Establishment,2) = 'BC'
ORDER BY	s.[Name]


-- Problem 09
SELECT		t.[Name],
			t.Age,
			t.PhoneNumber,
			t.Nationality,
			CASE
			WHEN b.[Name] IS NULL THEN '(no bonus prize)' ELSE b.[Name]
			END
			AS Reward
FROM		Tourists AS t
LEFT JOIN	TouristsBonusPrizes AS tb
ON			t.Id = tb.TouristId
LEFT JOIN	BonusPrizes AS b
ON			tb.BonusPrizeId = b.Id
ORDER BY	t.[Name]


-- Problem 10
-- WTF THEY MULTIPLIED ?! NEVERMIND, ORDER BY TO SORT IT OUT, REVISIT TO FIGURE THIS OUT ANOTHER DAY
SELECT		RIGHT(t.[Name], LEN(t.[Name]) - CHARINDEX(' ', t.[Name])) AS [LastName],
			t.Nationality,
			t.Age,
			t.PhoneNumber
FROM		Tourists AS t
JOIN		SitesTourists AS st
ON			t.Id = st.TouristId
JOIN		Sites AS s
ON			st.SiteId = s.Id
JOIN		Categories AS c
ON			s.CategoryId = c.Id
WHERE		c.[Name] = 'History and archaeology'
GROUP BY	RIGHT(t.[Name], LEN(t.[Name]) - CHARINDEX(' ', t.[Name])),
			t.Nationality,
			t.Age,
			t.PhoneNumber
ORDER BY	RIGHT(t.[Name], LEN(t.[Name]) - CHARINDEX(' ', t.[Name])) ASC


-- Problem 11
GO;

CREATE FUNCTION udf_GetTouristsCountOnATouristSite (@Site VARCHAR(100))
RETURNS INT
AS
BEGIN
		DECLARE @RES INT;

		SET @RES =		(SELECT		COUNT(s.[Name]) AS [Count]
						 FROM		Tourists AS t
						 LEFT JOIN	SitesTourists AS st
					     ON			st.TouristId = t.Id 
						 LEFT JOIN	Sites AS s
						 ON			st.SiteId = s.Id
						 GROUP BY	s.[Name]
						 HAVING		s.[Name] = @Site)
		RETURN @RES
END

GO;
SELECT dbo.udf_GetTouristsCountOnATouristSite ('Regional History Museum – Vratsa')
SELECT dbo.udf_GetTouristsCountOnATouristSite ('Samuil’s Fortress')
SELECT dbo.udf_GetTouristsCountOnATouristSite ('Gorge of Erma River')


-- Problem 12
GO;

CREATE PROCEDURE usp_AnnualRewardLottery(@TouristName VARCHAR(50))
AS
BEGIN
		DECLARE @COUNT INT;
		SET @COUNT = (
						SELECT		COUNT(*) AS [SitesVisitedCount]
						FROM		Tourists AS t
						JOIN		SitesTourists AS st
						ON			t.Id = st.TouristId
						JOIN		Sites AS s
						ON			st.SiteId = s.Id
						GROUP BY	t.[Name]
						HAVING		t.[Name] = @TouristName
					)
		
		DECLARE @RewardEarned VARCHAR(20)
		SET @RewardEarned = (
								CASE 
								WHEN @COUNT >= 100 THEN 'Gold badge'
								WHEN @COUNT >= 50 AND @COUNT < 100 THEN 'Silver badge'
								WHEN @COUNT >= 25 AND @COUNT < 50 THEN 'Bronze badge'
								ELSE NULL
								END
							)

		UPDATE Tourists
		SET Reward = @RewardEarned
		WHERE [Name] = @TouristName
		
		SELECT [Name], Reward FROM Tourists
		WHERE [Name] = @TouristName
END

SELECT * FROM Tourists
EXEC usp_AnnualRewardLottery 'Gerhild Lutgard'

