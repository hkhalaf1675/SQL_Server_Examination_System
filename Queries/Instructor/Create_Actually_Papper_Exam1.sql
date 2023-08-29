use ExaminationSystem_2

------------------------------------ Procedure For Create_Actually_Exam --------------------------
----------------------------------------        Papper Exam    -----------------------------------
------------------------------------  Crud  For Create_Actually_Exam -----------------------------

-------------------------------------     Add Create_Actually_Exam    ---------------------------
-----------------------  With Its Questions    ---------------------------------------------------
Go
create or alter proc InstructorFunctionality.Add_Quest_To_Papper_Exam_Manually(@ex_code varchar(5),@inst_SSN char(14)
,@crs_code varchar(5),@qs_Id int,@qs_dgree int)as
begin
--declare @course_Degree int;
--declare @Calculated_Degree int;

    		BEGIN TRY
				IF not EXISTS (select 1 from  Inst_Course_Exam where ex_code=@ex_code 
				and inst_SSN=@inst_SSN and crs_code=@crs_code and qs_Id=@qs_Id)
				and EXISTS (select 1 from  Question where qs_Id=@qs_Id)
				and EXISTS (select 1 from  Course where crs_code=@crs_code)
				and EXISTS (select 1 from  Exam where ex_code=@ex_code)
				and EXISTS (select 1 from  Instructor as inst join Course as cou on
				 inst.inst_SSN=@inst_SSN and cou.inst_SSN=@inst_SSN)
				and @qs_dgree>0
					begin 
					    --select @course_Degree=crs_max_dgree from Course;
						--@Calculated_Degree=Count_Degree_Quest_2(@qs_dgree)
						--if(@course_Degree>@Calculated_Degree)
						insert into Inst_Course_Exam(ex_code,inst_SSN,crs_code,qs_Id,qs_dgree)
						values(@ex_code,@inst_SSN,@crs_code,@qs_Id,@qs_dgree)
						print 'This Question Inserted Successfully'
					end
				else
					begin
						THROW 50006,'This Question already Exists An Error in data input.',16;
					end
		END TRY
		BEGIN CATCH
               PRINT('Raise the caught error again');
			   select ERROR_MESSAGE(); --- thow the exception is throwed
         End CATCH
end

------------------------------------------------------------------------------------------
------------------------------------------ insert Questions MAnually  -----------------
exec InstructorFunctionality.Add_Quest_To_Papper_Exam_Manually @ex_code='Front',@inst_SSN=29009876500003
,@crs_code='gd123',@qs_Id=76,@qs_dgree=2;

------------------------------------------------------------------------------------------


---------------------------------------   add question Rundomly --------------------------
-------------------          Select Question Rundomly ------------------------------

Go
create or alter procedure InstructorFunctionality.select_Question_Random(
@number_Quest int ,@crs_Id varchar(5),@Exam_Id varchar(5),@inst_id char(14),@degree_Ques int)
as 
begin
declare @last_Q int,@i int=1,@rundom_Quest_Id int,@Count_Course_Q int;
SELECT @last_Q= max(qs_Id) FROM Question;    -- get max or last number of quesion pool
SELECT  @Count_Course_Q=count(crs_code) 
FROM Question where crs_code=@crs_Id; --number of question in specific cours

select * from Exam;
if exists (select 1 from Exam 
	where inst_SSN=@inst_Id  and ex_code=@exam_id)
	and exists (select 1 from Course where crs_code=@crs_Id)
	and EXISTS (select 1 from  Instructor as inst join Course as cou on
	inst.inst_SSN=@inst_id and cou.inst_SSN=@inst_id)

	begin
	print 'success'

	begin try
	if (@number_Quest <= @Count_Course_Q )
		begin

		print 'success 2'
		while (@i <= @number_Quest) 
			begin
			    -- select rondum number success and not found before in papaper exam ..
				set @rundom_Quest_Id=CEILING(RAND() * @last_Q)
				if exists(select 1 from Question  where Crs_code=@crs_Id and qs_Id=@rundom_Quest_Id)
				and not exists(select 1 from [Inst_Course_Exam] where Crs_code=@crs_Id and Qs_ID=@rundom_Quest_Id)
					begin
		             print 'success 3'
					 set @i=@i+1;
					 insert INTO [Inst_Course_Exam] (ex_code,inst_SSN,crs_code,qs_Id,qs_dgree)
					 values(@Exam_Id,@inst_Id,@crs_Id,@rundom_Quest_Id,@degree_Ques);
				    end
		   end
	     end
	else
		begin
		     print 'The number of questions you requested is greater than the available number of questions.
			         Please ask for a smaller number or Exam Is Not Exam';
			   THROW 50005, N'Exam Not Exists', 16;
		
		end

end try
begin catch
	     --SELECT  ERROR_LINE() AS ErrorLine ,
         --ERROR_MESSAGE() AS ErrorMessage; 
		 select ERROR_MESSAGE();
end catch
end
--select * from Inst_Course_Exam;
end
----------------------------------------------------------------------------------
exec InstructorFunctionality.select_Question_Random
@number_Quest=1,@crs_Id='gd123',@Exam_Id='Front',@inst_id=29101234500012,@degree_Ques=1





------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------
-----------------------------------   procedure for update     -------------------------------
----------------------------------------------------------------------------------------------


Go
create or alter proc Update_Ques_ExamPaper(@ex_code varchar(5),@inst_SSN bigint
,@crs_code varchar(5),@Old_qs_Id int,@New_qs_Id int,@qs_dgree int)
as
begin
    BEGIN TRY
		if EXISTS (select 1 from  Question where qs_Id=@New_qs_Id)

		and EXISTS (select 1 from  Inst_Course_Exam where ex_code=@ex_code 
		and inst_SSN=@inst_SSN and crs_code=@crs_code and qs_Id=@Old_qs_Id)

		and EXISTS (select 1 from  Inst_Course_Exam where qs_Id=@Old_qs_Id)
		and not EXISTS (select 1 from  Inst_Course_Exam where qs_Id=@New_qs_Id)
		and EXISTS (select 1 from  Course where crs_code=@crs_code)
		and EXISTS (select 1 from  Exam where ex_code=@ex_code)
		and EXISTS (select 1 from  Instructor as inst join Course as cou on
		inst.inst_SSN=@inst_SSN and cou.inst_SSN=@inst_SSN)
		and @qs_dgree>0
			begin 
				update Inst_Course_Exam
				set qs_Id=@New_qs_Id,qs_dgree=@qs_dgree
				where ex_code=@ex_code and qs_Id=@Old_qs_Id
				print 'This Question Updated Successfully'
			end
		else
			begin
				THROW 50006,'This Question This course Not Exists or instructor 
				has not this course or this Ques repeated and exists before, or this ques not 
				found in question pool.',16;
			end
    END TRY
    BEGIN CATCH
		PRINT('Raise the caught error again');
		select ERROR_MESSAGE(); --- thow the exception is throwed
	End CATCH

end

exec GetDegree_Exam_paper
----------------------------------------------------------------------------------------------
exec Update_Ques_ExamPaper @ex_code='Front',@inst_SSN=29101234500012
,@crs_code='gd123',@Old_qs_Id=56,@New_qs_Id=60,@qs_dgree=7
-----------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------

-------------------------  delete Question From Actually_Papper_Exam    --------------------
GO
create or alter proc Delete_Question_From_papper_Exam(@examCode nvarchar(5)
,@QuesId int,@instSNN bigint,@corseCode nvarchar(5))
as
begin
    declare @total int ;
    begin try
			IF EXISTS (select 1 from  Inst_Course_Exam where ex_code=@examCode 
			and inst_SSN=@instSNN and crs_code=@corseCode and qs_Id=@QuesId)
			and EXISTS (select 1 from  Instructor as inst join Course as cou on
	        inst.inst_SSN=@instSNN and cou.inst_SSN=@instSNN)
			begin
			delete from Inst_Course_Exam where qs_Id=@QuesId;
			print 'This Question Deleted Successfully and you must add 
			alternative question instead of deleted to apperar your exam to stuents';
			select @total = ISNULL(sum([qs_dgree]),0) from [Inst_Course_Exam];
					if(@total=0)
					begin
					print'No longer any questions in your papper exam your exam paper degree is : ' ;
					print @total;
					end
					else
					begin
					print'You must get to maximum degree for course in 
					questions exam your paper exam degree is : ' ;
					print @total;
					end
			end
			else
			begin
			throw 51000,'This Question or Exam or Instructor Not Found in this Exam',16;
			end
	end try

	begin catch
	        select ERROR_MESSAGE();
	end catch

end
exec GetDegree_Exam_paper
select * from exam
select * from Inst_Course_Exam
exec  Delete_Question_From_papper_Exam @examCode='Front',@QuesId=72,@instSNN=29101234500012,@corseCode='gd123'
------------------------------------------------------------------------------------------------



















-----------------------------------------------------------------------------------------------
------------------------------------------   with cursor --------------------------------------
Go
CREATE or alter FUNCTION Count_Degree_Quest(@NewDegree int)
RETURNS INT
AS
BEGIN
    DECLARE @degree INT;
    DECLARE @column1 INT;
	set @degree=@NewDegree;
    DECLARE cursor_for_degrees CURSOR FOR
    SELECT [qs_dgree]
    FROM [dbo].[Inst_Course_Exam]; -- Replace with your table name

    OPEN cursor_for_degrees;

    FETCH NEXT FROM cursor_for_degrees INTO @column1;

    WHILE @@FETCH_STATUS = 0
    BEGIN
        -- Calculate the degree based on your logic
        SET @degree = @degree+ @column1;

        -- Store the degree or perform any other actions

        FETCH NEXT FROM cursor_for_degrees INTO @column1;
    END;

    CLOSE cursor_for_degrees;
    DEALLOCATE cursor_for_degrees;

    RETURN @degree;
END;

drop function Count_Degree_Quest;
declare @degree_Questions int;
select @degree_Questions=Count_Degree_Quest(12);

select sum([qs_dgree]) from [Inst_Course_Exam]; --if not any thing then return null

