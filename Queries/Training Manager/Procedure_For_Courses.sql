use ExaminationSystem_2

------->>> Functions
--- create function to check if there is course with that code or not
create or alter function checkCourseExists(@crs_code varchar(5))
returns bit
as
begin
	declare @f bit
	if exists(select * from Course where crs_code = @crs_code)
		set @f = 1
	else
		set @f = 0
	return @f
end
go
-----------------------------------------------------------------------------------------
-------------------------------------  Procedure for Course  -------------------------------
-------------------------------------   crud  For Courses   --------------------------------

--------------------------------------------------------------------------------------------
-------------------------------------       Add Course       -------------------------------
--------------------------------------------------------------------------------------------
create or alter proc TrainingManagerFunctionality.Add_Course(@crs_code varchar(5)
,@crs_name nvarchar(50),@crs_description nvarchar(255),@crs_max_dgree int
,@crs_min_dgree int,@inst_SSN char(14))as
begin
	IF dbo.checkCourseExists(@crs_code) = 0
		begin
            insert into Course(crs_code,crs_name,crs_description,crs_max_dgree,crs_min_dgree,inst_SSN)
			values(@crs_code,@crs_name,@crs_description,@crs_max_dgree,@crs_min_dgree,@inst_SSN)
			print 'This Course  Inserted Successfully .'
		end
	else
		begin
			print 'This Course already Exists .'
		end
end

exec TrainingManagerFunctionality.Add_Course @crs_code='csh20',@crs_name='C#',@crs_description='programming language'
,@crs_max_dgree=100,@crs_min_dgree=50,@inst_SSN = '29204372600011'

select * from Instructor;
------------------------------------  Update Course  --------------------------------
Go
create or alter proc TrainingManagerFunctionality.Update_Course(@crs_code varchar(5),@crs_name nvarchar(50)
,@crs_description nvarchar(255),@crs_max_dgree int,@crs_min_dgree int,@inst_SSN char(14))as
begin
	IF dbo.checkCourseExists(@crs_code) = 1 and dbo.checkInstructorExists(@inst_SSN) = 1
		begin
            update Course
				set crs_name=@crs_name,crs_description=@crs_description,crs_max_dgree=@crs_max_dgree
				,crs_min_dgree=@crs_min_dgree,inst_SSN = @inst_SSN
				where crs_code=@crs_code
				print 'This Course  Updated Successfully .'
		end
	else
		begin
			print 'This Course Not Exists or the Instructor Not Exists .'
		end
end
Go

exec TrainingManagerFunctionality.Update_Course @crs_code='gd123',@crs_name='C#'
,@crs_description='Course DeskTop Apps and For backend-Development'
,@crs_max_dgree=100,@crs_min_dgree=50,@inst_SSN = '292043726000'


------------------------------------     Delete Course    -----------------------
Go
create or alter proc TrainingManagerFunctionality.Delete_Course(@crs_code varchar(5))as
begin
	IF dbo.checkCourseExists(@crs_code) = 1
		begin
		begin try
			declare @qs_Id int
			select @qs_Id = qs_Id from Question where crs_code = @crs_code
			begin transaction
				delete from Choice
					where qs_Id = @qs_Id
				delete from  Question
					where crs_code = @crs_code
				delete from Course
					where crs_code=@crs_code
				print 'This Course  Deleted Successfully .'
			commit
		end try
		begin catch
			rollback
			print ERROR_MESSAGE()
		end catch
		end
	else
		begin
			print 'This Course Not Exists .'
		end
end

Go
exec TrainingManagerFunctionality.Delete_Course @crs_code='csh20'
------------------------------------------------------------
Go
create or alter proc Deltet_Course_Try_Catch(@crs_code varchar(5))as
begin
	
		BEGIN TRY
		  if dbo.checkCourseExists(@crs_code) = 1
				begin
					delete from Course
						where crs_code=@crs_code
						print 'This Course  Deleted Successfully .'
				end
		  else
				begin
					THROW 50006,'This Course Not Exists .',16;
				end
		END TRY
		BEGIN CATCH
               PRINT('Raise the caught error again');
               --select @@error;
			   select ERROR_MESSAGE(); --- thow the exception is throwed
			   --select ERROR_SEVERITY(); --- print 16
               --select ERROR_STATE();  ---- print 16
         End CATCH

end
Go 
exec Deltet_Course_Try_Catch @crs_code='nd123';

DROP PROCEDURE Delete_Course;

Go


------------------------------   function To Display Courses   ------------------

Go
CREATE or alter FUNCTION Select_Courses()
RETURNS TABLE
AS
RETURN
    SELECT  *
    FROM Course
Go

SELECT * FROM Select_Courses()

-------------------------  procedure to display courses --------------------
Go
 Create or ALTER PROCEDURE Display_Courses
    AS
    BEGIN
        SELECT * from Course;
    END;
Go
EXEC Display_Courses;

------------------------------------------------------------------------------




----------------------      insert data from csv files using bulk    --------------------------------
bulk insert Intake
from 'F:\Iti_Track\SQlServer\Project_SQL_Examination_System\Exam_System_Project\ExcelSheets\intake data - Sheet1.csv'
with (format = 'csv')

bulk insert Instructor
from 'F:\Iti_Track\SQlServer\Project_SQL_Examination_System\Exam_System_Project\ExcelSheets\instructor data - Sheet1.csv'
with (format = 'csv')

delete from Student;

select * from Student;

select * from Intake;

select * from Instructor;




begin try
	select 1/0
end try
begin catch
	select @@ERROR
end catch