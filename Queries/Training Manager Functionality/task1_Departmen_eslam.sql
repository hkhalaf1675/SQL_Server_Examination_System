use ExaminationSystem_2
	----------Add Department-----

create or ALTER PROCEDURE TrainingManagerFunctionality.[Add_Department]
@Dept_Name NVARCHAR (50)
AS
BEGIN TRY
		IF EXISTS (select[dept_name] from Department where [dept_name]=@Dept_Name  )
		begin
				--RAISERROR 'the Department Name aready exist'
				print 'the Department Name aready exist';
				raiserror ('you must chaning value of departmean name',16,1)
		end
		else
		begin
				INSERT  INTO [Department]
				VALUES (@Dept_Name);
		end
END TRY
BEGIN CATCH
    SELECT Error_Line() AS Num_Line,
           Error_Message() AS message,
           ERROR_NUMBER() AS E_Num;
END CATCH

TrainingManagerFunctionality.[Add_Department] 'Mobile'
-------------------------------------------------------------------------
--------------------------Updata 
create or ALTER PROCEDURE TrainingManagerFunctionality.[Update_Department]
@Deprt_Name VARCHAR (30), @New_Value VARCHAR (30)
AS
BEGIN TRY
	if exists(select * from Department where dept_name = @New_Value)
		print 'There is Department With That Name'
	else
	begin
        UPDATE [dbo].[Department]
        SET    dept_name = @New_Value
        WHERE  dept_name = @Deprt_Name
	end
END TRY
BEGIN CATCH
    SELECT ERROR_LINE(),
           ERROR_MESSAGE(),
           ERROR_NUMBER();
END CATCH

TrainingManagerFunctionality.[Update_Department] 'Mobile','Mobile App'
-------------------------------------Delate
---------------------------------------------------------------------------
create or ALTER PROCEDURE TrainingManagerFunctionality.[Delete_Department]
@Department_Name NVARCHAR (50)
AS
BEGIN TRY
	if exists(select * from Department where dept_name = @Department_Name)
	begin
		DELETE [dbo].[Department]
		WHERE  [dept_name] = @Department_Name;
	end
	else
		print 'there is no department with that name'
END TRY
BEGIN CATCH
    SELECT ERROR_LINE(),
           error_message(),
           ERROR_NUMBER();
END CATCH
