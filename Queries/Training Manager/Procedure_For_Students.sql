use ExaminationSystem_2
---------------------------------     Procedure for Student     --------------------
---------------------------------    Crud for Students   -----------------------

---------------------------------      Add Student   ---------------------------
-- to add new student must insert the ssn { be 14 num}  and the insert fullname , address,phone number {be 11 num} and the intake round num
Go 
create or alter proc TrainingManagerFunctionality.Add_Student(@st_SSN char(14),@st_fullName nvarchar(50),@st_address nvarchar(100)
,@st_phone char(14),@intake_round int)as
begin
	IF NOT EXISTS(select 1 from  Student where st_SSN=@st_SSN )
	and EXISTS(select 1 from  Intake where intake_round=@intake_round )
		begin
			if len(@st_SSN) = 14 and len(@st_phone) = 11
			begin
				insert into Student(st_SSN,st_fullName,st_address,st_phone,intake_round)
				values (@st_SSN,@st_fullName,@st_address,@st_phone,@intake_round)
				print 'This Student Inserted Successfully'
			end
			else
				print 'The Student SSN must be 14 num and Phone must 11 num'
		end
	else
	begin
		print 'This Student already Exists or Intake not found .'
	end
end
Go

TrainingManagerFunctionality.Add_Student @st_SSN='12345678912345',@st_fullName='Esslam Gamal'
,@st_address='Sohag',@st_phone='01234567891',@intake_round=8
Go


---------------------------------      Update Student   -------------------------------
-- update all data of student expect the studnt SSN
Go
create or alter proc TrainingManagerFunctionality.Update_Student(@st_SSN char(14)
,@New_st_fullName nvarchar(50),@New_st_address nvarchar(100)
,@New_st_phone char(11),@intake_round int)as
begin
	IF EXISTS(select 1 from  Student where st_SSN=@st_SSN and intake_round=@intake_round)
		begin
			update Student
			set st_fullName=@New_st_fullName,st_address=@New_st_address
			,st_phone=@New_st_phone,intake_round=@intake_round
			where st_SSN=@st_SSN
			print 'This Student Updated Successfully .'
		end
	else
	begin
		print 'This Student not Exists or Intake not found .'
	end
end

Go
 TrainingManagerFunctionality.Update_Student @st_SSN='12345678912345'
,@New_st_fullName='Ahmed El Guhny'
,@New_st_address='Assuit',@New_st_phone='12345678998',@intake_round=8
Go
---------------------------------      Delete Student   -------------------------------
--delete student using SSN
Go
create or alter proc TrainingManagerFunctionality.Delete_Student(@st_SSN char(14))as
begin
	IF EXISTS(select 1 from  Student where st_SSN=@st_SSN)
		begin
			delete from Student
			where  st_SSN=@st_SSN
			print 'This Student Deleted Successfully .'
		end
	else
	begin
		print 'This Student not Exists .'
	end
end
Go

Go
TrainingManagerFunctionality.Delete_Student @st_SSN='12345678912345'
Go

------------------------------ function for Diplay Students    -----------------------------

Go
CREATE FUNCTION Select_Student()
RETURNS TABLE
AS
RETURN
    SELECT  *
    FROM Student
Go

SELECT * FROM Select_Student()