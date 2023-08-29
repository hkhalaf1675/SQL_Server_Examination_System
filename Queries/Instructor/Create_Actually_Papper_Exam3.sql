------------------------------------------------------------------------------------------
-------------------------------    Display Acctually Exam    -----------------------------

-------------------------------------------------------------------------------------------
create or alter proc GetDegree_Exam_paper
as
begin
 select sum([qs_dgree]) from [Inst_Course_Exam]
end

------------------------------------------------------------------------------------------
------------------------------------  proc for Display Paper Exam for student  -----------
Go
create or alter proc Get_Exam_paper_For_Student(@ExamCode nvarchar(5))
as
begin
 declare @Exam_Degree int,@Course_Degree int;
 --------------
declare @dateExam date,@starttime time , @endtime time;
select @dateExam=Ex_year,@starttime=start_time ,@endtime=end_time from Exam where ex_code=@ExamCode
 ---------------------
 select @Exam_Degree=sum([qs_dgree]) from [Inst_Course_Exam]
 select @Course_Degree=crs_max_dgree from Course;
   BEGIN TRY
	 if(@Exam_Degree=@Course_Degree and cast(getdate() as date) = @dateExam 
	 and cast(sysdatetime() as time ) >= @starttime and cast(sysdatetime() as time ) <= @endtime)
	 begin
		select * from [Inst_Course_Exam]
	 end
	 else
	 begin
	  throw 51000,'This Exam Not Completed or Its time not now',16;
	 end
   END TRY

   BEGIN CATCH
		PRINT('Raise the caught error again');
		select ERROR_MESSAGE();
   END CATCH

end
-----------------------------------------
exec Get_Exam_paper_For_Student @ExamCode='Front';

exec GetDegree_Exam_paper;