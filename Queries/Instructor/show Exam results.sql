use ExaminationSystem_2

-- show all student result on spacific exam
-- takes two parametes ,exam code and instructor code
create or alter procedure InstructorFunctionality.showStudentResults @ex_code varchar(5),@inst_SSN char(14)
as
begin try
	if exists(select * from Exam 
		where ex_code=@ex_code and inst_SSN=@inst_SSN)
	begin
		select * from FinalResult_StudentExam
		where ex_code = @ex_code
	end
	else
		print 'There is no exam with that code or that instructor did not add that exam'
end try
begin catch
	print ERROR_MESSAGE()
end catch