use ExaminationSystem

----->>> Instructor Functionality

--->>> Question

-- add new question : addQuestion takes parameters with instructor SSN and course code to check if the instructor teach this course
---------------------------------- and takes the question type and question and correct answer and four choices and if the type
----------------------------------- is not MCQ the four choice must enter four null values

-----------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------
--> add new question
create or alter procedure addQuestion @inst_SSN bigint,@question varchar(255),@qs_type varchar(20),@correct_answer varchar(100),
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
						insert into Question(qs_text,qs_type,correct_answer,crs_code)
						values(@question,@qs_type,@correct_answer,@crs_code)

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
addQuestion 45678901234567,'An object of a derived class cannot access private members of base class.','True&False','True','csh20'
	,null,null,null,null

addQuestion 45678901234567,'Choose “.NET class” name from which data type “UInt” is derived','MCQ','System.UInt32','csh20'
	,'System.Int16','System.UInt32','System.UInt64','System.UInt16'