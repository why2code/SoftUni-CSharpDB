
--USE SoftUni

-- Problem 02
SELECT *
  FROM [Departments]

-- Problem 03
SELECT [Name] 
  FROM [Departments]
 
-- Problem 04
SELECT [FirstName], 
       [LastName], 
       [Salary] 
  FROM [Employees]
 
-- Problem 05
SELECT [FirstName],
       [MiddleName],
       [LastName]
  FROM [Employees]
 
-- Problem 06
SELECT CONCAT([FirstName], '.', [LastName], '@', 'softuni.bg')
    AS [Full Email Address]
  FROM [Employees]
 
-- Problem 06 with + operator
SELECT [FirstName] + '.' + [MiddleName] + '.' + [LastName] + '@' + 'softuni.bg'
    AS [Full Email Address],
       [MiddleName]
  FROM [Employees]
 
-- Problem 06 with removing .. 
SELECT CONCAT([FirstName], '.', [MiddleName] + '.', [LastName], '@', 'softuni.bg')
    AS [Full Email Address],
       [MiddleName]
  FROM [Employees]
 
-- Problem 07
SELECT DISTINCT [Salary]
           FROM [Employees]
 
-- Problem 08
SELECT *
  FROM Employees AS e
  WHERE e.JobTitle = 'Sales Representative'

-- Problem 09
SELECT [FirstName],
       [LastName],
       [JobTitle]
  FROM [Employees]
 WHERE [Salary] BETWEEN 20000 AND 30000
 
-- Problem 10
SELECT CONCAT([FirstName], ' ', [MiddleName], ' ', [LastName])
    AS [Full Name]
  FROM [Employees]
 WHERE [Salary] IN (25000, 14000, 12500, 23600)
 
-- Problem 10 with CONCAT_WS() FUNCTION
SELECT CONCAT_WS(' ', [FirstName], [MiddleName], [LastName])
    AS [Full name]
  FROM [Employees]
 WHERE [Salary] IN (25000, 14000, 12500, 23600)
 
-- Problem 11
SELECT [FirstName],
       [LastName]
  FROM [Employees]
 WHERE [ManagerID] IS NULL

-- Problem 12
SELECT e.FirstName, e.LastName, e.Salary
  FROM Employees AS e
  WHERE E.Salary > 50000
  ORDER BY e.Salary DESC
 
-- Problem 13
  SELECT 
 TOP (5) [FirstName],
         [LastName]
    FROM [Employees]
ORDER BY [Salary] DESC


-- Problem 14
SELECT e.FirstName,
	   e.LastName
  FROM Employees AS e
  WHERE e.DepartmentID <> 4
 
-- Problem 15
  SELECT *
    FROM [Employees]
ORDER BY [Salary]   DESC,
         [FirstName]    ,
         [LastName] DESC,
         [MiddleName]

-- Problem 16
GO
CREATE VIEW [V_EmployeesSalaries]
		AS (
				SELECT e.FirstName, 
					   e.LastName,
					   e.Salary
				  FROM Employees AS e
			)
GO
SELECT * FROM V_EmployeesSalaries
 
-- Problem 17
-- Views store temporaly the SELECT query, not the resultset!!!
 
GO
CREATE VIEW [V_EmployeeNameJobTitle]
         AS
            (
                SELECT CONCAT([FirstName], ' ', [MiddleName], ' ', [LastName])
                    AS [Full Name],
                       [JobTitle]
                  FROM [Employees] 
            )
 
GO
 
SELECT * FROM [V_EmployeeNameJobTitle]
 
GO
 
SELECT [FirstName] + ' ' + ISNULL([MiddleName], 'Replacement') + ' ' + [LastName]
                    AS [Full Name],
                       [JobTitle]
                  FROM [Employees] 
 

-- Problem 18
SELECT DISTINCT JobTitle
  FROM Employees



-- Problem 19
SELECT
TOP (10) *--, FORMAT([StartDate], 'dd/MM/yyyy')
    FROM [Projects]
ORDER BY [StartDate],
         [Name]


-- Problem 20
SELECT TOP(7) e.FirstName,
	   e.LastName,
	   e.HireDate
  FROM Employees AS e
  ORDER BY e.HireDate DESC

-- Problem 21
--Helper Queries
SELECT *
  FROM [Employees]
 
SELECT [DepartmentID]
  FROM [Departments]
 WHERE [Name] IN ('Engineering', 'Tool Design', 'Marketing', 'Information Services')
 
--Main Query Solution
UPDATE [Employees]
   SET [Salary] += 0.12 * [Salary]
 WHERE [DepartmentID] IN (1, 2, 4, 11)
 
SELECT [Salary]
  FROM [Employees]
 
--You can use Reverse Query if the changed value is const
RESTORE DATABASE [SoftUni] FROM DISK = 'BackUpPath.bak'
 
-- Advanced Solution (Subqueries)
UPDATE [Employees]
   SET [Salary] += 0.12 * [Salary]
 WHERE [DepartmentID] IN 
                         (
                            SELECT [DepartmentID]
                              FROM [Departments]
                             WHERE [Name] IN ('Engineering', 'Tool Design', 'Marketing', 'Information Services')
                         )

GO
 SELECT [Salary]
  FROM [Employees]


USE [Geography]
GO

-- Problem 22
SELECT PeakName 
  FROM Peaks
  ORDER BY PeakName ASC

-- Problem 23
SELECT TOP(30) 
	[CountryName],
	[Population]
  FROM Countries AS c
  WHERE c.ContinentCode = 'EU'
  ORDER BY [Population] DESC


-- Problem 24
--CASE WHEN -> If [CurrencyCode] = 'EUR' then display 'Euro'
--             else display 'Not Euro'
  SELECT [CountryName],
         [CountryCode],
         CASE [CurrencyCode]
              WHEN 'EUR' THEN 'Euro'
              ELSE 'Not Euro'
         END
      AS [Currency]
    FROM [Countries]
ORDER BY [CountryName]

-- Problem 25
USE Diablo

SELECT [Name] 
  FROM Characters
  ORDER BY [Name] ASC

