use ExaminationSystem_2
------------------------------------ Procedure For Instructor_Exam -------------------------------
------------------------------------   Crud  For Instructor_Exam  --------------------------------

-------------------------------------      Add Instructor_Exam    --------------------------------
---('exam','corrective'))---- check for examType

Go
create or alter proc InstructorFunctionality.Add_Exam(@ex_code nvarchar(5),@ex_type nvarchar(15)
,@start_time date,@end_time date,@Br_Dept_Tr_Intake_ID int
,@crs_code varchar(5),@inst_SSN char(14),@Ex_year date)as
begin
    begin try
	IF not EXISTS (select 1 from  Exam where ex_code=@ex_code)
	and dbo.checkInstructorExists(@inst_SSN) = 1
	and dbo.checkCourseExists(@crs_code) = 1
	and EXISTS(select 1 from  Course,Instructor where Instructor.inst_SSN=Course.inst_SSN)
	begin 
		insert into Exam(ex_code,ex_type,start_time,end_time,Br_Dept_Tr_Intake_ID,Ex_year,crs_code,inst_SSN)
		values(@ex_code,@ex_type,@start_time,@end_time,@Br_Dept_Tr_Intake_ID,@Ex_year,@crs_code,@inst_SSN)
		print 'This Exam added Successfully'
	end
	else
	begin
		THROW 50006,'This instructor or Course name  or Intake Not Exists or Exam Already Exists .',16;
	end
	end try

	begin catch
		PRINT('Raise the caught error again');
		select ERROR_MESSAGE();
	end catch

end
GO
exec InstructorFunctionality.Add_Exam @ex_code='Front',@ex_type='exam',@start_time='10:00',@end_time='12:30',@Br_Dept_Tr_Intake_ID=1
,@Ex_year='2023/9/11',@crs_code='csh20',@inst_SSN ='29204372600011'
-----------------------------------------------------------------------------------------------

-----------------------------------------------------------------------------------------------

-----------------------------------    Update    ----------------------------------------------

-------------------------------------      Add Instructor_Exam    --------------------------------
---('exam','corrective'))---- check for examType

Go
create or alter proc InstructorFunctionality.Update_Exam(@ex_code nvarchar(5)
,@start_time date,@end_time date,@Ex_year date)as
begin
    begin try
	IF EXISTS (select 1 from  Exam where ex_code=@ex_code)
	begin 
		update Exam
		set start_time=@start_time,end_time=@end_time,Ex_year=@Ex_year
		where ex_code=@ex_code
		print 'This Exam Updated Successfully'
	end
	else
	begin
		THROW 50006,'This Exam Not Exists .',16;
	end
	end try

	begin catch
		select ERROR_MESSAGE();
	end catch

end
GO
exec InstructorFunctionality.Update_Exam @ex_code='Front',@start_time='10:00',@end_time='12:00',@Ex_year='2023/9/13'

----------------------------------------------------------------------------------------------

-----------------------------    Delete Exam   -----------------------------------------------
----------------------------------------------------------------------------------------------

Go
create or alter proc InstructorFunctionality.Delete_Exam(@ex_code nvarchar(5))as
begin
    begin try
	IF EXISTS (select 1 from  Exam where ex_code=@ex_code)
	begin 
		delete from Exam
		where ex_code=@ex_code
		print 'This Exam Deleted Successfully'
	end
	else
	begin
		THROW 50006,'This Exam Not Exists .',16;
	end
	end try

	begin catch
		select ERROR_MESSAGE();
	end catch

end
GO
exec InstructorFunctionality.Delete_Exam @ex_code='Front'


----------------------------------------------------------------------------------------------

-----------------------------   Procedure for Get Exams  -------------------------------

Go
 Create or ALTER PROCEDURE InstructorFunctionality.Display_Exams
    AS
    BEGIN
        SELECT * from Exam;
    END;
Go
EXEC InstructorFunctionality.Display_Exams;
------------------------------------------------------------------------
-----------  Select Exams for specific Instructor    -------------------
Go
 Create or ALTER PROCEDURE InstructorFunctionality.Display_Exams_Specific_Inst(@Specific_inst_SSN bigint)
    AS
    BEGIN
        SELECT * from Exam where inst_SSN=@Specific_inst_SSN;
    END;


exec InstructorFunctionality.Display_Exams_Specific_Inst @Specific_inst_SSN=29101234500012

--drop proc Display_Exams_Specific_Inst 
------------------------------------------------------------------------


select * from [dbo].[Br_Dept_Tr_Intake];
--(branch_no,dept_no,track_code,intake_round)values(10,2,'WD',52)
select * From Instructor;
select * From Course;
select * From Instructor;
select * From Exam;

delete From Exam;