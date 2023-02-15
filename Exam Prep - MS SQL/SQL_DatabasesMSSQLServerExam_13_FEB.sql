CREATE DATABASE Bitbucket
USE Bitbucket

-- --------------------------------

-- Problem 01

CREATE TABLE Users
(
	Id INT PRIMARY KEY IDENTITY,
	Username VARCHAR(30) NOT NULL,
	[Password] VARCHAR(30) NOT NULL,
	Email VARCHAR(50) NOT NULL,
)

CREATE TABLE Repositories
(
	Id INT PRIMARY KEY IDENTITY,
	Name VARCHAR(50) NOT NULL,
)

CREATE TABLE RepositoriesContributors
(
	RepositoryId INT FOREIGN KEY REFERENCES Repositories(Id) NOT NULL,
	ContributorId INT FOREIGN KEY REFERENCES Users(Id) NOT NULL,
	PRIMARY KEY (RepositoryId, ContributorId)
)

CREATE TABLE Issues
(
	Id INT PRIMARY KEY IDENTITY,
	Title VARCHAR(255) NOT NULL,
	IssueStatus VARCHAR(6) NOT NULL CHECK(LEN(IssueStatus) <= 6),
	RepositoryId INT FOREIGN KEY REFERENCES Repositories(Id) NOT NULL,
	AssigneeId INT FOREIGN KEY REFERENCES Users(Id) NOT NULL

)

CREATE TABLE Commits
(
	Id INT PRIMARY KEY IDENTITY,
	[Message] VARCHAR(255) NOT NULL,
	IssueId INT FOREIGN KEY REFERENCES Issues(Id),
	RepositoryId INT FOREIGN KEY REFERENCES Repositories(Id) NOT NULL,
	ContributorId INT FOREIGN KEY REFERENCES Users(Id) NOT NULL
)


CREATE TABLE Files
(
	Id INT PRIMARY KEY IDENTITY,
	[Name] VARCHAR(100) NOT NULL,
	Size DECIMAL(18,2) NOT NULL,
	ParentId INT FOREIGN KEY REFERENCES Files(Id),
	CommitId INT FOREIGN KEY REFERENCES Commits(Id) NOT NULL
)

-- Problem 02
INSERT INTO Files([Name], Size, ParentId, CommitId)
VALUES 
		('Trade.idk', 2598.0, 1,1),
		('menu.net', 9238.31, 2, 2),
		('Administrate.soshy', 1246.93,	3, 3),
		('Controller.php',	7353.15, 4,	4),
		('Find.java', 9957.86, 5, 5),
		('Controller.json', 14034.87, 3, 6),
		('Operate.xix',	7662.92, 7, 7)

INSERT INTO Issues(Title, IssueStatus, RepositoryId, AssigneeId)
VALUES
		('Critical Problem with HomeController.cs file', 'open'	,1,	4),
		('Typo fix in Judge.html', 'open', 4, 3),
		('Implement documentation for UsersService.cs', 'closed', 8, 2),
		('Unreachable code in Index.cs', 'open', 9, 8)


-- Problem 03
UPDATE Issues
SET IssueStatus = 'closed'
WHERE AssigneeId = 6


-- Problem 04
DELETE FROM Files WHERE Id = 36
DELETE FROM Commits WHERE RepositoryId = 3
DELETE FROM Issues WHERE RepositoryId = 3
DELETE FROM RepositoriesContributors WHERE RepositoryId = 3
DELETE FROM Repositories WHERE [Name] = 'Softuni-Teamwork'


-- Problem 05
SELECT		Id,
			[Message],
			RepositoryId,
			ContributorId
FROM		Commits
ORDER BY	Id,
			[Message],
			RepositoryId,
			ContributorId



-- Problem 06
SELECT		Id,
			[Name],
			Size
FROM		Files
WHERE		Size > 1000 AND
			CHARINDEX('.html', [Name]) >= 1
ORDER BY	Size DESC,
			Id,
			[Name]


-- Problem 07
SELECT		i.Id,
			CONCAT(u.Username, ' : ', i.Title) AS IssueAssignee
FROM		Issues AS i
LEFT JOIN	Users AS u ON i.AssigneeId = u.Id
ORDER BY	i.Id DESC,
			IssueAssignee


-- Problem 08
SELECT
			[F2].[Id],
			[F2].[Name],
			CONCAT([F2].[Size], 'KB') AS [Size]
FROM		[Files] AS [F]
RIGHT JOIN	[Files] AS [F2]
ON			[F].[ParentId] = [F2].[Id]
WHERE		[F].[Id] IS NULL
ORDER BY	[F2].[Id] ASC, [F2].[Name] ASC, [F2].[Size] DESC


-- Problem 09
SELECT TOP(5)  r.Id ,
			   r.[Name], 
			   COUNT (r.[Name]) AS Commits
FROM		   Repositories as r
LEFT JOIN	   Commits as c ON r.Id = c.RepositoryId
JOIN		   RepositoriesContributors AS RC ON RC.RepositoryId = R.Id
GROUP BY	   r.Id ,r.[Name]
ORDER BY	   Commits DESC , r.Id , r.[Name]


-- Problem 10
--potentially remove those with NULL file size
SELECT		u.Username, 
			AVG(f.Size) AS Size 
FROM		Commits AS c
LEFT JOIN	Users AS u ON c.ContributorId = u.Id
LEFT JOIN	Files AS f ON c.Id = f.CommitId
WHERE		f.Size IS NOT NULL -- THIS REMOVES NULL SIZES (THEREFORE 2 USERS WHICH STILL HAVE COMMITS BUT DID NOT UPLOAD FILES... UNCLEAR ASSIGNMENT)
GROUP BY	u.Username
ORDER BY	AVG(f.Size) DESC,
			u.Username


-- Problem 11
GO;

CREATE FUNCTION udf_AllUserCommits(@username VARCHAR(30)) 
RETURNS INT
AS
BEGIN
		DECLARE @RES INT;
		SET @RES = (
					SELECT COUNT(*)
						FROM	(
									SELECT		COUNT(u.Id) AS z
									FROM		Commits AS c
									LEFT JOIN	Users AS u ON c.ContributorId = u.Id
									LEFT JOIN	Files AS f ON c.Id = f.CommitId
									where U.Username = @username
									GROUP BY	u.Username, c.[Message]
								) 
					AS [Z]
					)
		IF @RES IS NULL
		SET @RES = 0;

		RETURN @RES
					
END;
GO;

select * FROM Users WHERE Username = 'WhatTerrorBel'
SELECT dbo.udf_AllUserCommits('UnderSinduxrein');
SELECT dbo.udf_AllUserCommits('WhatTerrorBel');


-- Problem 12
GO;
CREATE PROCEDURE usp_SearchForFiles(@fileExtension VARCHAR(50))
AS
BEGIN
		SELECT		Id,
					[Name],
					CONCAT(Files.Size, 'KB') AS Size
		FROM		Files
		WHERE		[Name] LIKE CONCAT('%', @fileExtension, '%')
		ORDER BY	Id,
					[Name],
					Files.Size DESC
END;

EXEC usp_SearchForFiles 'html'

GO;



