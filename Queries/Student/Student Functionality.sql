use ExaminationSystem_2

---------------------->>>> Student Functionality <<<<-----------------------

create schema StudentFunctionality
--------------------------------------------

----->>> create procedure to show exam page to student
--->> take exam code
create or alter procedure StudentFunctionality.showExamPage @exam_code varchar(5)
as
begin try
	declare @Exam_Degree int,@Course_Degree int,@crs_code varchar(5)
	select @crs_code=crs_code from exam where ex_code=@exam_code

	declare @dateExam date,@starttime time , @endtime time;
	select @dateExam=Ex_year,@starttime=start_time ,@endtime=end_time 
	from Exam where ex_code=@exam_code

	select @Exam_Degree=isnull(sum([qs_dgree]),0) from [Inst_Course_Exam] where ex_code=@exam_code;
	select @Course_Degree=crs_max_dgree from Course where crs_code=@crs_code;

	if(@Exam_Degree=@Course_Degree and cast(getdate() as date) = @dateExam 
	and cast(sysdatetime() as time ) >= @starttime 
	and cast(sysdatetime() as time ) <= @endtime)
	begin
		select *
		from
		(select CONCAT('ID:',Inst_Course_Exam.ex_Page_Id,'-> Type : ',qs_type,' -> ',qs_text) quest,Choice.choice,Choice.choice_num
		from Question
		join Inst_Course_Exam
		on Question.qs_Id = Inst_Course_Exam.qs_Id and Inst_Course_Exam.ex_code = @exam_code
		left join Choice
		on Question.qs_Id = Choice.qs_Id) as t
		PIVOT(max(choice) for choice_num in ([a],[b],[c],[d])) as PVT
	end
	else
		print 'paper exam not put yet or this ques not found 
				in exam or question aleardy found in answer page'
end try
begin catch
	print ERROR_MESSAGE()
end catch

StudentFunctionality.showExamPage 'exm21'

select * from Inst_Course_Exam