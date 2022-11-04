USE Company

GO
---Creating EmpCount function
CREATE FUNCTION UDT_EmpCount(@DNumber INT)
RETURNS INT
AS
BEGIN 
   RETURN (SELECT COUNT(*) FROM Employee where Dno = @DNumber)
END 
GO
---Adding EmpCount column
ALTER TABLE Department ADD EmpCount AS dbo.UDT_EmpCount(DNumber);


GO
---CRUD: Create
Create OR ALTER PROCEDURE usp_CreateDepartment 
@DName nvarchar(50),
@MgrSSN int,
@DNumber INT OUTPUT

AS 
BEGIN
SET NOCOUNT ON
---statement
IF EXISTS (SELECT D.DName FROM Department as D WHERE DName = @DName)
 BEGIN
	RAISERROR('Department name already in use',16, 1)
	RETURN
 END

IF EXISTS (SELECT D.MgrSSN FROM Department as D WHERE MgrSSN = @MgrSSN)
 BEGIN
 	RAISERROR('Department manager name already in use',16, 1)
	RETURN
 END

 BEGIN
	 INSERT INTO [dbo].Department (DName, MgrSSN, MgrStartDate)
	 VALUES (@DName, @MgrSSN, GETDATE());
	  SELECT SCOPE_IDENTITY() AS [@DNumber];
	  RETURN;
  END
END


GO
---CRUD: Update Department Name
Create OR ALTER PROCEDURE usp_UpdateDepartmentName 
@DName nvarchar(50),
@DNumber INT 

AS 
BEGIN
---Statement
IF EXISTS (SELECT D.DName FROM Department as D WHERE DName = @DName)
 BEGIN
	RAISERROR('Department name already in use',16, 1)
	RETURN
 END

 BEGIN
	UPDATE Department
	Set Dname = @DName
	WHERE DNumber = @DNumber
	PRINT('Department name updated')
	RETURN
 END
END


GO
---CRUD: Update Department manager
Create OR ALTER PROCEDURE usp_UpdateDepartmentManager
@DNumber INT,
@MgrSSN int

AS 
BEGIN
SET NOCOUNT ON

---Statement
IF EXISTS (SELECT D.MgrSSN FROM Department AS D WHERE DNumber = @DNumber AND MgrSSN = @MgrSSN )
 BEGIN
	RAISERROR('Already department manager for this department',16, 1)
	RETURN
 END

 BEGIN
	UPDATE Department
	SET MgrSSN = @MgrSSN, MgrStartDate = GETDATE()
	WHERE DNumber = @DNumber
	PRINT('Department Manager updated')
	RETURN
 END
 END


GO
--- CRUD: Get a Department information
CREATE or alter PROCEDURE usp_GetDepartment
(
@DNumber int OUTPUT
--@EmpCount INT OUTPUT
)
AS
BEGIN
		SELECT D.DName, D.DNumber, D.MgrSSN, D.MgrStartDate, COUNT(*) AS EmpCount
		FROM Department as D 
		inner JOIN Employee e on e.Dno = @DNumber
		where DNumber = @DNumber
			GROUP BY  DName, DNumber, MgrSSN, MgrStartDate
			RETURN

			IF not EXISTS (SELECT DNumber FROM Department WHERE DNumber = @DNUmber)
			BEGIN
			RAISERROR('Department dont exist',16,1)
			PRINT('There is no department')
			RETURN
			END
END


GO
DROP PROCEDURE IF EXISTS usp_DeleteDepartment 
GO
--- CRUD: Delete a specific department
CREATE or ALTER PROCEDURE usp_DeleteDepartment(
@DNumber INT 
)
AS BEGIN
		IF EXISTS (SELECT DNumber FROM Department WHERE DNumber = @DNUmber)
		BEGIN
			DELETE FROM Works_on where Works_on.Pno = @DNumber (select PNumber from Project where DNum = @DNumber )
			DELETE FROM Project WHERE Project.DNum = @DNumber
			DELETE FROM Dept_Locations WHERE DNUmber = @DNumber
			UPDATE Employee SET Dno = NULL WHERE Employee.Dno = @DNumber
			DELETE FROM Department WHERE DNumber = @DNumber 

			PRINT('This is deleted')
			RETURN
		END
		BEGIN 
			RAISERROR('Department dont exist',16,1)
			PRINT('This WAS NOT deleted')
			RETURN
		END	
END


GO
--- CRUD: Delete a specific department
CREATE or ALTER PROCEDURE usp_DeleteDepartment(
@DNumber INT 
)
AS BEGIN
		IF EXISTS (SELECT DNumber FROM Department WHERE DNumber = @DNUmber)
		BEGIN
			DELETE FROM Works_on where Works_on.Pno = @DNumber (select PNumber from Project where DNum = @DNumber )
			DELETE FROM Project WHERE Project.DNum = @DNumber
			DELETE FROM Dept_Locations WHERE DNUmber = @DNumber
			UPDATE Employee SET Dno = NULL WHERE Employee.Dno = @DNumber
			DELETE FROM Department WHERE DNumber = @DNumber 

			PRINT('This is deleted')
			RETURN
		END
		BEGIN 
			RAISERROR('Department dont exist',16,1)
			PRINT('This WAS NOT deleted')
			RETURN
		END	
END


GO
--- CRUD: Get a Department information
CREATE or alter PROCEDURE usp_GetDepartment
(
@DNumber int OUTPUT
--@EmpCount INT OUTPUT
)
AS
BEGIN
		SELECT D.DName, D.DNumber, D.MgrSSN, D.MgrStartDate, COUNT(*) AS EmpCount
		FROM Department as D 
		inner JOIN Employee e on e.Dno = @DNumber
		where DNumber = @DNumber
			GROUP BY  DName, DNumber, MgrSSN, MgrStartDate
			RETURN

			IF not EXISTS (SELECT DNumber FROM Department WHERE DNumber = @DNUmber)
			BEGIN
			RAISERROR('Department dont exist',16,1)
			PRINT('There is no department')
			RETURN
			END
END


GO
--- CRUD: Get info on all Departments
CREATE OR ALTER PROCEDURE usp_GetAllDepartment
AS
BEGIN	
		SELECT D.DName, COUNT(Emp.Dno) AS EmpCount
		FROM Department AS D
			inner join Employee AS Emp on Emp.Dno = D.DNumber
			GROUP BY D.DName
			RETURN
END 
