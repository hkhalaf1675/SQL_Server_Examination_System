use ExaminationSystem_2

go
create schema InstructorFunctionality
go

----------------

----->>> Instructor Functionality

--->>> Question

-->>>> add new question : addQuestion takes parameters with instructor SSN and course code to check if the instructor teach this course
---------------------------------- and takes the question type and question and correct answer and four choices and if the type
----------------------------------- is not MCQ the four choice must enter four null values

-->>>> delete question : deleteQuestion takes two parameters the first is instructor SSN to ensure that instructor is exist on database
------------------------------- or he teaches the course that question belong to it,the second parameter is question id

-->>>> update table Question {question text or correct answer} : updateQuestionOrCorrectAnswer take parameters:
-------------- instructor ssn : to check that instructor exists or he is the instructor who teach the course that qs belong to it
-------------- question id number 
-------------- column that you need to update the value on it and it one of {question,correct answer}
-------------- the new value 

-->>>> update question mcq option : updateQuestionChoice takes parameters :
--- instructor ssn
--- question id to ensure that the type of it is MCQ
--- choice or char must be of {a,b,c,d}
--- new value

-->>>> show all Questions with there choices : showAllQuestionChoices take crs_code is the course code 

-----------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------
----->> Procedure that enable instrcutor create new Exam
--->>> takes instructor SSN , course code,new exam code,exam type,starting time,ending time,exam year
------------>>> allow option if there,and intake Branch code

create or alter procedure InstructorFunctionality.addNewExam @inst_SSN char(14),@crs_code varchar(5),@exam_code char(5),
	@exam_type varchar(15),@start_time time,@end_time time,@exam_year date,@allow_option varchar(100),@inatek_branch_id int
as
begin try
	if dbo.checkInstructorExists(@inst_SSN) = 1 and dbo.checkCourseExists(@crs_code) = 1
		and exists(select * from Br_Dept_Tr_Intake where ID = @inatek_branch_id)
		and exists(select * from Course where crs_code = @crs_code and inst_SSN = @inst_SSN)
	begin
		if @exam_code is not null and @exam_type is not null and @start_time  is not null and @end_time  is not null
			and @exam_year is not null
		begin
			if @exam_type in ('corrective','exam')
			begin
				insert into Exam(ex_code,ex_type,Ex_year,allow_option,Br_Dept_Tr_Intake_ID,crs_code
					,inst_SSN,start_time,end_time)
					values(@exam_code,@exam_type,@exam_year,@allow_option
							,@inatek_branch_id,@crs_code,@inst_SSN,@start_time,@end_time)
			end
			else
				print CONCAT(@exam_type,' is invalid the exam type must be one of {corrective , exam}')
		end
		else
			print ' You must enter the exam code , type , exam staring type and ending type  , and the year'
	end
	else
		print CONCAT('There is no Instructor with "',@inst_SSN,'" or there is no course code with 
			"',@crs_code,'" or IntakeBransh with that id or That instructor do not teach that course')
end try
begin catch
	print ERROR_MESSAGE()
end catch
----------------
select * from Exam

InstructorFunctionality.addNewExam '29204372600011','csh20','exm22','exam','10:00','12:00','10/9/2023',null,1



--------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------
----->>> Function that calculate the dgree of each type of question
--->>> takes Number of each type of Question and course max dgree

create or alter function specifyQuestionDgree(@num_of_MCQ int,@num_of_TrueFalse int,@num_of_Text int,
	@crs_max_dgree int)
returns @t table (MCQ_dgree int,TrueFalse_dgree int ,Text_dgree int)
as
begin
	declare @degree int = @crs_max_dgree / (@num_of_MCQ+(@num_of_Text)+@num_of_TrueFalse)
	
	declare @rest_dgree int = @crs_max_dgree - ((@num_of_MCQ+@num_of_Text+@num_of_TrueFalse) * @degree)
	
	if @rest_dgree = 0
	begin
		insert into @t values(@degree,@degree,@degree)
	end
	else if @num_of_Text > 0
	begin
		insert into @t values(@degree,@degree,((@degree) + @rest_dgree / @num_of_Text))
	end
	else if @num_of_MCQ > 0
	begin
		insert into @t values((@degree + @rest_dgree / @num_of_MCQ),@degree,@degree)
	end
	else
		insert into @t values((@degree + @rest_dgree / @num_of_Text),@degree,@degree)
	return
end

----------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------
---->>> Procedure that select random question 
--->> takes type of question , number of question,course code , question dgree , instructor SSN and the code of exam

create or alter procedure selectRandomQuestionBasedOnType @quest_type varchar(10), @num_of_Questions int , 
		@crs_code varchar(5),@qs_dgree int , @inst_SSN char(14),@exam_code varchar(5)
as
begin try
	print @num_of_Questions
	insert into Inst_Course_Exam(ex_code,inst_SSN,crs_code,qs_Id,qs_dgree)
	select top (@num_of_Questions) @exam_code,@inst_SSN,@crs_code,qs_Id,@qs_dgree
	from Question
	where crs_code = @crs_code and qs_type = @quest_type
	order by NEWID()
end try
begin catch
	print ERROR_MESSAGE()
end catch
-------------
selectRandomQuestionBasedOnType 'True&False' ,5 , 'csh20',5,'29901234500010','exm22'

-------------------------------------
-------------------------------------

---- Add new Automated Exam Questions
---- 
create or alter procedure InstructorFunctionality.automateExam  @inst_SSN char(14),
			@exam_code varchar(5),@num_of_MCQ int,@num_of_TrueFalse int,@num_of_Text int
as
begin try
	if exists(select * from Exam where ex_code = @exam_code and inst_SSN = @inst_SSN)
	begin
		declare @crs_code varchar(5)
		select @crs_code=crs_code from Exam where ex_code = @exam_code
		------
		declare @crs_max_dgree int
		select @crs_max_dgree = crs_max_dgree from Course where crs_code = @crs_code
		------
		-------
		declare @MCQ_dgree int,@Text_dgree int,@TrueFalse_dgree int
		select top 1 @MCQ_dgree = MCQ_dgree,@Text_dgree = Text_dgree ,@TrueFalse_dgree = TrueFalse_dgree
		from specifyQuestionDgree(@num_of_MCQ,@num_of_TrueFalse,@num_of_Text,@crs_max_dgree)
		--------
		EXEC selectRandomQuestionBasedOnType 'MCQ' ,@num_of_MCQ ,@crs_code,@MCQ_dgree,@inst_SSN,@exam_code
		---
		exec selectRandomQuestionBasedOnType 'True&False',@num_of_TrueFalse,@crs_code,@TrueFalse_dgree,@inst_SSN,@exam_code
		---
		exec selectRandomQuestionBasedOnType 'Text',@num_of_Text,@crs_code,@Text_dgree,@inst_SSN,@exam_code
	end
	else
		print CONCAT('There is no instructor with "',@inst_SSN,'" or no Exam with "',@exam_code,'" code 
		or that instructor did not put that exam') 
end try
begin catch
	print ERROR_MESSAGE()
end catch
--------------
InstructorFunctionality.automateExam '29204372600011','exm22',10,1,1

select * from Inst_Course_Exam

select ex_code,sum(qs_dgree) from Inst_Course_Exam
group by ex_code