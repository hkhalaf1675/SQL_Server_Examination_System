------------------------------------------------------------------------
------------------------- proc for final result ------------------------
--Hassn we need to add column 
select * from Student_Answers
select * from Inst_Course_Exam
select * from exam
select * from exam where ex_code='front'
select Ex_year from exam where ex_code='front'
select Course_Name from exam where ex_code='front'
select * from course

-- this proc for student to show his /her GPA or degree
go
create or alter proc GetFinalresult_forPaper_toResultFinal(@St_SNN bigint
,@ex_code varchar(5))
as 
  begin
      declare @finalDegree int,@dateExam date,@maxDegreeForCourse int,
	  @coursename varchar(50),@exam_type varchar(15)
	  ,@number_of_corrective_specific_student int;
		declare @crs_code varchar(5)


	  select @dateExam=ex_year from exam where ex_code=@ex_code
	  select @crs_code=crs_code from exam where ex_code=@ex_code
	  select @coursename=crs_name from Course where crs_code=@crs_code
	  select @maxDegreeForCourse=crs_max_dgree from course 
	  where crs_name=@coursename
	  select @exam_type=ex_type from exam where ex_code=@ex_code;

      begin try
	  --select 1 from exam where ex_type='exam' and ex_code='dsapp' 
	  --select * from course
	        	if exists (select 1  from exam where ex_code=@ex_code)
	  begin
	     	   if exists(select 1 from Student where st_SSN=@St_SNN)
	      begin
		     if(cast(getdate() as date) = @dateExam)
				BEGIN
				     --select * from FinalResult_StudentExam
					 --select * from Student_Answers
					 select @finalDegree=isnull(sum(st_qs_dgree),0) from Student_Answers 
					 where st_SSN=@St_SNN ;
					   begin 
					        --delete from FinalResult_StudentExam
					   		select * from FinalResult_StudentExam
							select @number_of_corrective_specific_student=count(gpa) from FinalResult_StudentExam where 
							gpa='f' and st_SNN=212534785647389 and course='c#'
							and ex_code='dsapp'
							if(@number_of_corrective_specific_student>=2)
							      begin
								       throw 50001,'you can not do exam more than two time',16;
								  end
							else
							      begin
								       if(@exam_type != 'corrective') ---not corrective
							    begin

									if(@finalDegree >= (@maxDegreeForCourse*9/10))
										begin  
											insert into FinalResult_StudentExam
											(ex_code,course,st_SNN,finalDegree,GPA)
											 values
											(@ex_code,@coursename,@St_SNN,@finalDegree,'A')
											print'You passed in exam in GPA A';
										end
									else if(@finalDegree >= (@maxDegreeForCourse*8/10))
										begin
											insert into FinalResult_StudentExam
											(ex_code,course,st_SNN,finalDegree,GPA)
											values
											(@ex_code,@coursename,@St_SNN,@finalDegree,'B')
											print'You passed in exam in GPA B';
										end
									else if(@finalDegree >= (@maxDegreeForCourse*7/10))
										begin
											insert into FinalResult_StudentExam
											(ex_code,course,st_SNN,finalDegree,GPA)
											values
											(@ex_code,@coursename,@St_SNN,@finalDegree,'B-')
											print'You passed in exam in GPA B-';
										end
									else if(@finalDegree >= (@maxDegreeForCourse*6/10))
										begin
											insert into FinalResult_StudentExam
											(ex_code,course,st_SNN,finalDegree,GPA)
											values
											(@ex_code,@coursename,@St_SNN,@finalDegree,'C+')
											print'You passed in exam in GPA C+';
										end
									else if(@finalDegree >=(@maxDegreeForCourse*5/10))
										begin
											insert into FinalResult_StudentExam
											(ex_code,course,st_SNN,finalDegree,GPA)
											values
											(@ex_code,@coursename,@St_SNN,@finalDegree,'C')
											print'You passed in exam in GPA C';
										end
									else
										begin
											insert into FinalResult_StudentExam
											(ex_code,course,st_SNN,finalDegree,GPA)
											values
											(@ex_code,@coursename,@St_SNN,@finalDegree,'F')
											print'You faild in exam in GPA D';
										end
										end

                            else   ---is corrective
							--@maxDegreeForCourse = @maxDegreeForCourse*3/4;
							    begin
								     if(@number_of_corrective_specific_student=1)
									     begin
										     
								     if(@finalDegree >= (@maxDegreeForCourse*9/10)*4/5)
										begin  
											insert into FinalResult_StudentExam
											(ex_code,course,st_SNN,finalDegree,GPA)
											values
											(@ex_code,@coursename,@St_SNN,@finalDegree,'B')
											print'You passed in exam in GPA B';
										end
									else if(@finalDegree >= (@maxDegreeForCourse*8/10)*4/5)
										begin
											insert into FinalResult_StudentExam
											(ex_code,course,st_SNN,finalDegree,GPA)
											values
											(@ex_code,@coursename,@St_SNN,@finalDegree,'B-')
											print'You will passed in exam in GPA B-';
										end
									else if(@finalDegree >= (@maxDegreeForCourse*7/10)*4/5)
										begin
											insert into FinalResult_StudentExam
											(ex_code,course,st_SNN,finalDegree,GPA)
											values
											(@ex_code,@coursename,@St_SNN,@finalDegree,'C+')
											print'You will passed in exam in GPA C+';
										end
									else if(@finalDegree >= (@maxDegreeForCourse*6/10)*4/5)
										begin
											insert into FinalResult_StudentExam
											(ex_code,course,st_SNN,finalDegree,GPA)
											values
											(@ex_code,@coursename,@St_SNN,@finalDegree,'C')
											print'You will passed in exam in GPA C';
										end
									else if(@finalDegree >=(@maxDegreeForCourse*5/10)*4/5)
										begin
											insert into FinalResult_StudentExam
											(ex_code,course,st_SNN,finalDegree,GPA)
											values
											(@ex_code,@coursename,@St_SNN,@finalDegree,'D+')
											print'You will passed in exam in GPA D+';
										end
									else
										begin
											insert into FinalResult_StudentExam
											(ex_code,course,st_SNN,finalDegree,GPA)
											values
											(@ex_code,@coursename,@St_SNN,@finalDegree,'F')
											print'You will faild in exam in GPA F';
										end

										 end
								     else
									     begin
										     print 'This student dot have corrective before you must 
											 change the type of exam for this student';
										     throw 50001,'This student dot have corrective before you must 
											 change the type of exam for this student',16;
										 end
										end
								  end
					        
								end

				 end
			  else
				begin
				throw 50001,'Its not time for the exam .',16;
				end
		  end
        else
		   begin
		      throw 50001,'Student is not Exists in system',16;
		   end
	  end
	else
	  begin
	    throw 50001,'This exam code not found',16;
	  end
	  end try

	  begin catch
	        select ERROR_MESSAGE();
	  end catch

	  
   end


   use examsystem
select * from Student_Answers
select * from student


create table FinalResult_StudentExam(
 ex_code varchar(5),
 course varchar(50),
 st_SNN bigint,
 finalDegree int,
 GPA char(1)
);


select * from student_answers
alter table student_answers
add ex_code varchar(5)


