------------------------------------ Procedure For Create_Actually_Exam --------------------------
----------------------------------------        Papper Exam    -----------------------------------
------------------------------------  Crud  For Create_Actually_Exam -----------------------
-----------------------------------------------  trigger Page -----------------------------
----------------------------------------------   Triger on Insert -------------------------------
Go
create or alter trigger Add_Quest_In_PaperExam
on Inst_Course_Exam instead of insert 
as begin
	declare @Amount int,@course_Degree int;
	declare @ex_code varchar(5),@inst_SSN bigint,@crs_code varchar(5),@qs_Id int,@qs_dgree int;
	--select * from inserted
	select @Amount=qs_dgree from inserted;
	select @ex_code=ex_code,@inst_SSN=inst_SSN,@crs_code=crs_code,@qs_Id=qs_Id,@qs_dgree=qs_dgree
	from inserted;
	begin
		declare @total int
		select @total = ISNULL(sum([qs_dgree]),0) from [Inst_Course_Exam] where ex_code = @crs_code;
		
		select @course_Degree=crs_max_dgree from Course where crs_code=@crs_code;
	
		if (@total + @Amount) < @course_Degree
			insert into [Inst_Course_Exam] Values(@ex_code, @inst_SSN,@crs_code,@qs_Id,@qs_dgree)

		else
			throw 51000,'Question Degree Exceeds the maximum degree for this course',16
	end
	--else
		--throw 51000,'Incorrect Data',16
end


-----------------------------------------------------------------------------------------
--------------------------   Update paper exam With Triger ---------------------------------------------
Go
create or alter trigger Update_Ques_In_paper_Exam on [Inst_Course_Exam]
instead of update as

begin 

	declare @Amount int,@course_Degree int , @Old_qs_id int,@New_qs_Id int,
	@old_Ques_Degree int;
	declare @ex_code varchar(5),@inst_SSN bigint,@crs_code varchar(5),@qs_Id int,@qs_dgree int;
	--select * from inserted
	select @Amount=qs_dgree from inserted;
	select @old_Ques_Degree=qs_dgree from deleted;
	select @Old_qs_id=qs_Id from deleted;
	select @New_qs_id=qs_Id from inserted;
	select @ex_code=ex_code,@inst_SSN=inst_SSN,@crs_code=crs_code,@qs_Id=qs_Id,@qs_dgree=qs_dgree
	from inserted;

			begin
				declare @total int,@deletedDegree int ;
		
				select @total = ISNULL(sum([qs_dgree]),0) from [Inst_Course_Exam] where ex_code=@crs_code;
				--@total = @total - @old_Ques_Degree;
				select @course_Degree=crs_max_dgree from Course where crs_code=@crs_code;
				select @deletedDegree=qs_dgree from Inst_Course_Exam where qs_id=@Old_qs_id
				set @total=@total-@deletedDegree
				if (@total + @Amount) < @course_Degree
					begin
						update Inst_Course_Exam
						set qs_Id=@New_qs_Id,qs_dgree=@qs_dgree
						where ex_code=@ex_code and qs_Id=@Old_qs_Id
						print'Question is updated successfully .';
					end	
				else
					  print'Question Degree Exceeds the maximum degree 
					  for this course or this question not found';
			end

end

exec GetDegree_Exam_paper