USE [SoftUni]
 
GO
 
-- Problem 01
-- Judge does not like CREATE OR ALTER statement
CREATE PROCEDURE [usp_GetEmployeesSalaryAbove35000]
              AS
           BEGIN
                    SELECT [FirstName],
                           [LastName]
                      FROM [Employees]
                     WHERE [Salary] > 35000
             END
 
 
EXEC [dbo].[usp_GetEmployeesSalaryAbove35000]
 
GO
 
-- Problem 02
CREATE PROCEDURE [usp_GetEmployeesSalaryAboveNumber] @minSalary DECIMAL(18, 4)
              AS
           BEGIN
                    SELECT [FirstName],
                           [LastName]
                      FROM [Employees]
                     WHERE [Salary] >= @minSalary
             END
 
EXEC [dbo].[usp_GetEmployeesSalaryAboveNumber] 48100
 
GO

-- Problem 03
CREATE PROCEDURE usp_GetTownsStartingWith @townLetter VARCHAR(20)
			  AS
		   BEGIN
				SELECT	[Name] AS Town 
				FROM	Towns
				WHERE	SUBSTRING([Name],1, LEN(@townLetter)) LIKE @townLetter
		   END

EXEC dbo.usp_GetTownsStartingWith 'Bo';
EXEC dbo.usp_GetTownsStartingWith 'c';

GO

 
-- Problem 04
CREATE PROCEDURE [usp_GetEmployeesFromTown] @townName VARCHAR(50)
              AS
           BEGIN
                        SELECT [e].[FirstName],
                               [e].[LastName]
                          FROM [Employees]
                            AS [e]
                    INNER JOIN [Addresses]
                            AS [a]
                            ON [e].[AddressID] = [a].[AddressID]
                    INNER JOIN [Towns]
                            AS [t]
                            ON [a].[TownID] = [t].[TownID]
                         WHERE [t].[Name] = @townName
             END
 
EXEC [dbo].[usp_GetEmployeesFromTown] 'Monroe'
EXEC [dbo].[usp_GetEmployeesFromTown] 'Sofia'
EXEC [dbo].[usp_GetEmployeesFromTown] 'Bordeaux'
 
GO
 
-- Problem 05
-- Accepts Salary as a number and return salary level as a text
CREATE FUNCTION [ufn_GetSalaryLevel](@salary DECIMAL(18,4))
RETURNS VARCHAR(8)
AS
BEGIN
    DECLARE @salaryLevel VARCHAR(8)
 
    IF @salary < 30000
    BEGIN
        SET @salaryLevel = 'Low'
    END
    ELSE IF @salary BETWEEN 30000 AND 50000
    BEGIN
        SET @salaryLevel = 'Average'
    END
    ELSE IF @salary > 50000
    BEGIN
        SET @salaryLevel = 'High'
    END
 
    RETURN @salaryLevel
END
 
GO
 
-- Problem 06
CREATE PROCEDURE usp_EmployeesBySalaryLevel @salaryLevel VARCHAR(8)
              AS
           BEGIN
                    SELECT [FirstName],
                           [LastName]
                      FROM [Employees]
                     WHERE [dbo].[ufn_GetSalaryLevel]([Salary]) = @salaryLevel
             END
 
EXEC [dbo].[usp_EmployeesBySalaryLevel] 'High'
EXEC [dbo].[usp_EmployeesBySalaryLevel] 'Average'
 
GO
 
-- Problem 7
CREATE FUNCTION ufn_IsWordComprised(@setOfLetters VARCHAR(50), @word VARCHAR(50))
    RETURNS BIT
             AS
          BEGIN
                    DECLARE @wordIndex INT = 1;
                    WHILE (@wordIndex <= LEN(@word))
                    BEGIN
                            DECLARE @currentCharacter CHAR = SUBSTRING(@word, @wordIndex, 1);
 
                            IF CHARINDEX(@currentCharacter, @setOfLetters) = 0
                            BEGIN
                                RETURN 0;
                            END
 
                            SET @wordIndex += 1;
                    END
 
                    RETURN 1;
            END
 
GO
 
SELECT [dbo].[ufn_IsWordComprised]('oistmiahf', 'h!alves')
 
GO
 
-- Problem 08
CREATE PROCEDURE usp_DeleteEmployeesFromDepartment @departmentId INT
              AS
           BEGIN
                    -- We need to store all id's of the Employees that are going to be removed
                    DECLARE @employeesToDelete TABLE ([Id] INT);            
                    INSERT INTO @employeesToDelete
                                SELECT [EmployeeID] 
                                  FROM [Employees]
                                 WHERE [DepartmentID] = @departmentId
 
                    -- Employees which we are going to remove can be working on some
                    -- projects. So we need to remove them from working on this projects.
                    DELETE
                      FROM [EmployeesProjects]
                     WHERE [EmployeeID] IN (
                                                SELECT * 
                                                  FROM @employeesToDelete
                                           )
 
                    -- Employees which we are going to remove can be Managers of some Departments
                    -- So we need to set ManagerID to NULL of all Departments with futurely deleted Managers
                    -- First we need to alter column ManagerID
                     ALTER TABLE [Departments]
                    ALTER COLUMN [ManagerID] INT
                    
                    UPDATE [Departments]
                       SET [ManagerID] = NULL
                     WHERE [ManagerID] IN (
                                                SELECT *
                                                  FROM @employeesToDelete
                                          )
 
                    -- Employees which we are going to remove can be Managers of another Employees
                    -- So we need to set ManagerID to NULL of all Employees with futurely deleted Managers
                    UPDATE [Employees]
                       SET [ManagerID] = NULL
                     WHERE [ManagerID] IN (
                                                SELECT *
                                                  FROM @employeesToDelete
                                          )
 
                    -- Since we removed all references to the employees we want to remove
                    -- We can safely remove them
                    DELETE
                      FROM [Employees]
                     WHERE [DepartmentID] = @departmentId
 
                     DELETE 
                       FROM [Departments]
                      WHERE [DepartmentID] = @departmentId
 
                      SELECT COUNT(*)
                        FROM [Employees]
                       WHERE [DepartmentID] = @departmentId
             END
 
GO
 
EXEC [dbo].[usp_DeleteEmployeesFromDepartment] 7
 
SELECT *
  FROM [Employees]
 WHERE [DepartmentID] = 7
 
-- Restore DB
USE [master]
 
GO
 
USE [SoftUni]
 
SELECT *
  FROM [Employees]
 WHERE [DepartmentId] = 7
 

-- Problem 09
USE Bank
GO

CREATE PROCEDURE usp_GetHoldersFullName 
AS
BEGIN
		SELECT	CONCAT(FirstName, ' ', LastName) AS [Full Name]
		FROM	AccountHolders
END

GO


-- Problem 10
CREATE PROCEDURE usp_GetHoldersWithBalanceHigherThan @Number MONEY
AS
BEGIN
		 SELECT		ahe.FirstName,
					ahe.LastName
		   FROM 
			    (
					SELECT		
								a.AccountHolderId,
								SUM(a.Balance) AS [bal]
					 FROM		AccountHolders AS ah
				LEFT JOIN		Accounts AS a
					   ON		ah.Id = a.AccountHolderId
				 GROUP BY		a.AccountHolderId
				) 
			AS	[InnerQuery]
     LEFT JOIN	AccountHolders AS ahe
			ON	[InnerQuery].AccountHolderId = ahe.Id
		 WHERE	[InnerQuery].bal > @Number
	  ORDER BY	ahe.FirstName,
				ahe.LastName
								
END
GO

EXEC usp_GetHoldersWithBalanceHigherThan 10000;
GO


-- Problem 11
CREATE FUNCTION ufn_CalculateFutureValue (@sum DECIMAL(18,4), @yearlyInterestRate FLOAT, @numberOfYears INT)
RETURNS DECIMAL(18,4)
AS
BEGIN
		DECLARE @Result DECIMAL(18,4);
		SET @Result = @sum * POWER((1 + @yearlyInterestRate), @numberofYears)
		RETURN @Result
END;
GO

SELECT dbo.ufn_CalculateFutureValue(1000, 0.1, 5)
GO;

-- Problem 12
CREATE PROCEDURE usp_CalculateFutureValueForAccount(@AccountId INT, @InterestRate FLOAT)
AS
BEGIN

	DECLARE @Period INT = 5;
	
	SELECT	     ah.Id AS [Account Id],
				 ah.FirstName AS [First Name],
				 ah.LastName AS [Last Name],
				 a.Balance AS [Current Balance],
				 dbo.ufn_CalculateFutureValue(a.Balance, @InterestRate, @Period) AS [Balance in 5 years]
	FROM	     AccountHolders AS ah
	LEFT JOIN    Accounts a
	ON			 ah.Id = a.AccountHolderId
	WHERE		 a.Id = @AccountId
END

GO


USE [Diablo]
 
GO
 
-- Problem 13
CREATE FUNCTION ufn_CashInUsersGames(@gameName NVARCHAR(50))
  RETURNS TABLE
             AS
         RETURN
                (
                    SELECT SUM([Cash])
                        AS [SumCash]
                      FROM (
                                SELECT [g].[Name],
                                       [ug].[Cash],
                                       ROW_NUMBER() OVER(ORDER BY [ug].[Cash] DESC)
                                    AS [RowNumber]
                                  FROM [UsersGames]
                                    AS [ug]
                            INNER JOIN [Games]
                                    AS [g]
                                    ON [ug].[GameId] = [g].[Id]
                                 WHERE [g].[Name] = @gameName
                           ) 
                        AS [RankingSubQuery]
                     WHERE [RowNumber] % 2 <> 0
                )
 
GO
 
SELECT * FROM [dbo].[ufn_CashInUsersGames]('Love in a mist')

