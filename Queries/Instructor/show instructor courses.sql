use ExaminationSystem_2

------------->>>create to procedure to show course that aspacific instructor teach

create or alter procedure InstructorFunctionality.showInstructorCourses @inst_SSN char(14)
as
begin try
	if dbo.checkInstructorExists(@inst_SSN) = 1
	begin
		select crs_code , crs_name from Course
		where inst_SSN = @inst_SSN
	end
	else
		print CONCAT('There is no Instrcutor with "',@inst_SSN,'" SSN')
end try
begin catch
	print ERROR_MESSAGE()
end catch

alter schema TrainingManagerFunctionality transfer showInstructorCourses