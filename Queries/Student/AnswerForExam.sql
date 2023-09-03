------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------
----------------------------------   Answer For Exam  ------------------------------------------------
--takes exam page question id,exam code,student ssn, and student question answer
Go
create or alter proc StudentFunctionality.Student_Answer_Quest(@ex_Page_Id int
,@ex_code varchar(5),@st_SSN char(14)
,@st_quest_answer nvarchar(255)
,@courseName varchar(50))

as
	begin
		   declare @degreeQuest int=0,@qs_id int,@crs_code varchar(5);
		   declare @Exam_Degree int,@Course_Degree int;
			--------------
		   declare @dateExam date,@starttime time , @endtime time;
		   select @dateExam=Ex_year,@starttime=start_time ,@endtime=end_time 
		   from Exam where ex_code=@ex_code
			---------------------

			select @crs_code=crs_code from exam where ex_code=@ex_code

		   select @Exam_Degree=isnull(sum([qs_dgree]),0) from [Inst_Course_Exam] where ex_code=@ex_code;
		   select @Course_Degree=crs_max_dgree from Course where crs_code=@crs_code;
		   begin try
				   if(@Exam_Degree=@Course_Degree and cast(getdate() as date) = @dateExam 
				   and cast(sysdatetime() as time ) >= @starttime 
				   and cast(sysdatetime() as time ) <= @endtime)
				   begin

				   if exists(select 1 from Exam join Inst_Course_Exam on 
				   Exam.ex_code=@ex_code and Inst_Course_Exam.ex_code=@ex_code)
				   and exists(select 1 from Student where st_SSN=@st_SSN)
				   and exists (select 1 from Inst_Course_Exam where ex_Page_Id=@ex_Page_Id)
				   and not exists(select 1 from Student_Answers where 
				   ex_Page_Id=@ex_Page_Id)
						   begin
							  --if student answer match to correct answer ..
							      select @qs_id=qs_Id from Inst_Course_Exam where
								  ex_Page_Id=@ex_Page_Id
								  if exists(select 1 from Question 
								  where correct_answer=@st_quest_answer and qs_Id=@qs_Id)
									  begin
										select @degreeQuest=Inst_Course_Exam.qs_dgree,@qs_id=qs_Id from Inst_Course_Exam where
										ex_Page_Id=@ex_Page_Id 
										insert into Student_Answers(ex_Page_Id,st_SSN,st_quest_answer,st_qs_dgree,courseName)
										values(@ex_Page_Id,@st_SSN,@st_quest_answer,@degreeQuest,@courseName);
									  end
								  else
									  begin
										insert into Student_Answers(ex_Page_Id,st_SSN,st_quest_answer,st_qs_dgree,courseName)
										values(@ex_Page_Id,@st_SSN,@st_quest_answer,@degreeQuest,@courseName);
									  end
						   end
						else
							begin
							   throw 50001,'paper exam not put yet or this ques not found 
							   in exam or question aleardy found in answer page',16;
							end


				   end

				   -----
				   else
						begin
						    throw 50001,'This course not completed to answer or this not time or exceeded time',16
						end
		   end try

		   begin catch
			   select ERROR_MESSAGE();
		   end catch

	end


----------------------------------------------------------------------------------------------
-------------------- update in questions answer from student  --------------------------------

Go
create or alter proc StudentFunctionality.Student_Answer_Update_Quest(@ex_Page_Id int
,@ex_code varchar(5),@st_SSN char(14)
,@st_quest_New_answer nvarchar(255))as
	begin
			 declare @degreeQuest int=0,@qs_id int,@crs_code varchar(5);
			 declare @Exam_Degree int,@Course_Degree int;
			 --------------
			 declare @dateExam date,@starttime time , @endtime time;
			 select @dateExam=Ex_year,@starttime=start_time 
			 ,@endtime=end_time from Exam where ex_code=@ex_code
			 ---------------------
           select @crs_code=crs_code from exam where ex_code=@ex_code
		   select @Exam_Degree=isnull(sum([qs_dgree]),0) from [Inst_Course_Exam] where ex_code=@ex_code;
		   select @Course_Degree=crs_max_dgree from Course where crs_code=@crs_code;
			 
			 begin try
			   if(@Exam_Degree=@Course_Degree and cast(getdate() as date) = @dateExam 
			   and cast(sysdatetime() as time ) >= @starttime and cast(sysdatetime() as time ) <= @endtime)
			       begin

						   if exists(select 1 from Exam join Inst_Course_Exam on 
						   Exam.ex_code=@ex_code and Inst_Course_Exam.ex_code=@ex_code)
						   and exists (select 1 from Inst_Course_Exam where ex_Page_Id=@ex_Page_Id)
						   and exists(select 1 from Student where st_SSN=@st_SSN)
						   and exists(select 1 from Student_Answers where 
						   ex_Page_Id=@ex_Page_Id)
						    begin
								  --if student answer match to correct answer ..
								  select @qs_id=qs_Id from Inst_Course_Exam where
								  ex_Page_Id=@ex_Page_Id
								  if exists(select 1 from Question 
								  where correct_answer=@st_quest_New_answer and qs_Id=@qs_Id)
									  begin
										select @degreeQuest=Inst_Course_Exam.qs_dgree from Inst_Course_Exam where
										ex_Page_Id=@ex_Page_Id
										update Student_Answers
										set st_quest_answer=@st_quest_New_answer,st_qs_dgree=@degreeQuest
										where ex_Page_Id=@ex_Page_Id 
									  end
								  else
									  begin
										update Student_Answers
										set st_quest_answer=@st_quest_New_answer,st_qs_dgree=@degreeQuest
										where ex_Page_Id=@ex_Page_Id
										print' your question updated successfully';
									  end
						       end
						     else
							   begin
							       throw 50001,'paper exam not put yet or this ques not found 
							       in exam or question not found in answer page',16;
							   end


				   end
        
			   -----
			   else
				   begin
				       throw 50001,'This course not completed to answer or this not time or exceeded time',16
				   end


			  end try

			  begin catch
				  select ERROR_MESSAGE();
			  end catch

	end



