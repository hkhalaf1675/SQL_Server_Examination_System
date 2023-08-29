use ExaminationSystem_2

------------------------------->>>


------------------------>>> Procedures

----->>> Question
--> add new question
create or alter procedure InstructorFunctionality.addQuestion @inst_SSN char(14),@question varchar(255),@qs_type varchar(20),@correct_answer varchar(100),
	@crs_code varchar(5),@choice_num1 varchar(100),@choice_num2 varchar(100),@choice_num3 varchar(100),@choice_num4 varchar(100)
as
	begin try
		if exists(select * from Course where crs_code = @crs_code)
		begin
			if exists(select * from Course where crs_code = @crs_code and inst_SSN = @inst_SSN)
			begin
				if @qs_type = 'MCQ'
				begin
					if @choice_num1 is not null and @choice_num2 is not null and @choice_num3 is not null and @choice_num4 is not null
					begin
						insert into Question(qs_text,qs_type,correct_answer,crs_code,inst_SSN)
						values(@question,@qs_type,@correct_answer,@crs_code,@inst_SSN)

						insert into Choice
						values(@choice_num1,@@IDENTITY,'a'),
								(@choice_num2,@@IDENTITY,'b'),
								(@choice_num3,@@IDENTITY,'c'),
								(@choice_num4,@@IDENTITY,'d')
					end
					else
						select 'You must enter the four choices and the correct answer must be one of them' MSG
				end
				else
				begin
					insert into Question(qs_text,qs_type,correct_answer,crs_code)
					values(@question,@qs_type,@correct_answer,@crs_code)
				end
			end
			else
				select 'there no instructor with that SSN or the instructor do not teach this course' MSG
		end
		else
			select 'There no course with that code' as MSG
	end try
	begin catch
		rollback
		select ERROR_NUMBER(),ERROR_MESSAGE()
	end catch
----------------------
InstructorFunctionality.addQuestion 29204372600000,'An object of a derived class cannot access private members of base class.',
   'True&False','True','csh20',null,null,null,null

InstructorFunctionality.addQuestion 45678901234567,'Choose “.NET class” name from which data type “UInt” is derived','MCQ','System.UInt32','csh20'
	,'System.Int16','System.UInt32','System.UInt64','System.UInt16'

---------------------------------
-->> delete question
create or alter procedure InstructorFunctionality.deleteQuestion @inst_SSN char(14),@question_id int
as
	begin try
		if exists(select * from Question where qs_Id = @question_id)
		begin
			if exists(select * from Question where inst_SSN = @inst_SSN)
			begin
				begin transaction
					delete from Choice
						where qs_Id = @question_id

					delete from Question
						where qs_Id = @question_id
				commit
			end
			else
				print 'there is no instructor with that SSN or the instructor did not add this question'
		end
		else
			select 'there no question with that id' MSG
	end try
	begin catch
		rollback
		select ERROR_NUMBER(),ERROR_MESSAGE()
	end catch
-----------
InstructorFunctionality.deleteQuestion 29204372600011,1013
--------------------------------------

--update for question text and the correct answer
create or alter procedure InstructorFunctionality.updateQuestionOrCorrectAnswer @inst_SSN char(14),@quest_Id int,@col varchar(15),@newValue varchar(255)
as
	begin try
		if exists (select * from Question where qs_Id = @quest_Id)
		begin
			if exists(select * from Question where inst_SSN = @inst_SSN)
			begin
				if @col = 'question'
				begin
					update Question
						set qs_text = @newValue
					where qs_Id = @quest_Id
				end
				else if @col = 'correct answer'
				begin
					update Question
						set correct_answer = @newValue
					where qs_Id = @quest_Id
				end
				else
					print 'please enter avalid column name one of { question or correct answer }'
			end
			else
				print 'there is no instructor with that SSN or the instructor did not add this question'
		end
		else
			print 'There is no question with that id number'
	end try
	begin catch
		select ERROR_NUMBER(),ERROR_MESSAGE()
	end catch
-----------------
InstructorFunctionality.updateQuestionOrCorrectAnswer 29204372600011,1013,'correct answer','a'

--------------------

-- update question options take instructor ssn and question and choice num
create or alter procedure InstructorFunctionality.updateQuestionChoice @inst_SSN char(14),@quest_Id int,@choice_num char(1),@newValue varchar(100)
as
	begin try
		declare @qs_type varchar(12) = 'MCQ'
		select @qs_type = qs_type from Question where qs_Id = @quest_Id
		if exists (select * from Question where qs_Id = @quest_Id)
		begin
			if exists(select * from Question where inst_SSN = @inst_SSN)
			begin
				if @qs_type = 'MCQ'
				begin
					if @choice_num in ('a','b','c','d')
					begin
						update Choice
							set choice = @newValue
						where qs_Id = @quest_Id and choice_num = @choice_num
					end
					else
						print 'please enter avlid choice number or char must be one of {a,b,c,d}'
				end
				else
					print 'please ensure that the question is one of MCQ questions'
			end
			else
				print 'there is no instructor with that SSN or the instructor did not add this question'
		end
		else
			print 'There is no question with that id number'
	end try
	begin catch
		select ERROR_NUMBER(),ERROR_MESSAGE()
	end catch
----------
InstructorFunctionality.updateQuestionChoice 45678901234567,1015,'f','Console.Int16'
-------------------------------------------------

-- question with choices 
create or alter procedure InstructorFunctionality.showAllQuestionChoices @crs_code varchar(5)
as
	begin try
		select *
		from
		(select CONCAT('ID:',Question.qs_Id,'-> Type : ',qs_type,' -> ',qs_text) quest,Choice.choice,Choice.choice_num
		from Question
		left join Choice
		on Question.qs_Id = Choice.qs_Id and Question.crs_code = @crs_code) as t
		PIVOT(max(choice) for choice_num in ([a],[b],[c],[d])) as PVT
	end try
	begin catch
		select ERROR_NUMBER(),ERROR_MESSAGE()
	end catch
--------------------------
InstructorFunctionality.showAllQuestionChoices csh20