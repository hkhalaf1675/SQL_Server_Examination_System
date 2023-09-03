------------------------------------ Procedure For Instructor_Exam -------------------------------
------------------------------------   Crud  For Instructor_Exam  --------------------------------

-------------------------------------      Add Instructor_Exam    --------------------------------
---('exam','corrective'))---- check for examType

Go
create or alter proc InstructorFunctionality.Add_Exam(@ex_code nvarchar(5),@ex_type nvarchar(15)
,@start_time time,@end_time time,@Br_Dept_Tr_Intake_ID int
,@crs_code varchar(5),@inst_SSN char(14),@Ex_year date)as
	begin
	    declare @total_time int;
		set @total_time = CAST(DATEDIFF(MINUTE,@start_time, @end_time)as int);
		begin try
			IF not EXISTS (select 1 from  Exam where ex_code=@ex_code)
			and EXISTS(select 1 from  Instructor where inst_SSN=@inst_SSN)
			and EXISTS(select 1 from  Course where crs_code=@crs_code)
			and EXISTS(select 1 from  Course,Instructor where
			Instructor.inst_SSN=Course.inst_SSN)

				begin 
			      if (@Ex_year > getdate()) and (@start_time < @end_time )
						begin
						  if (@start_time > '08:00') and (@start_time < '19:00') and (@end_time < '20:00')
								begin
								   if (@start_time!=@end_time)
										 begin
										   if (@total_time > 60 and @total_time <300)
												begin
													insert into Exam(ex_code,ex_type,start_time
													,end_time,Br_Dept_Tr_Intake_ID,Ex_year
													,crs_code,inst_SSN)
													values(@ex_code,@ex_type,@start_time,@end_time
													,@Br_Dept_Tr_Intake_ID,@Ex_year,@crs_code
													,@inst_SSN)
													print 'This Exam added Successfully'
												end
									       else
											   begin
											      throw 50001,'The time of exame must between 1 to 5 hours.',16;
											   end
										 end
									else
										begin
										   throw 50001,'Start time must not the same of end time for exam.',16;
										end
								end
                          else
							  begin
                                 throw 50001,'The time of Exam must startTime from 8 Am and endTime less than 8:Pm am ',16;
							  end
						end
                  else 
					  begin
					       throw 50001,'The date of exam is less than the current date.',16;
					  end
				end
			else
				begin
					THROW 50006,'This instructor or Course name  or Intake Not Exists or Exam Already Exists',16;
				end
		end try

		begin catch
			--PRINT('Raise the caught error again');
			select ERROR_MESSAGE();
		end catch

	end
GO
-----------------------------------------------------------------------------------------------

-----------------------------------------------------------------------------------------------

-----------------------------------    Update    ----------------------------------------------

-------------------------------------      Add Instructor_Exam    --------------------------------
---('exam','corrective'))---- check for examType

Go
create or alter proc InstructorFunctionality.Update_Exam(@ex_code nvarchar(5)
,@start_time time,@end_time time,@Ex_year date)as
	begin
		begin try
		     IF EXISTS (select 1 from  Exam where ex_code=@ex_code)    
				 begin 
					  declare @total_time int;
					  set @total_time = CAST(DATEDIFF(MINUTE,@start_time, @end_time)as int);
					  if (@Ex_year > getdate()) and (@start_time < @end_time )
							begin
							  if (@start_time > '08:00') and (@start_time < '19:00') and (@end_time < '20:00')
									begin
									   if (@start_time!=@end_time)
											 begin
											   if (@total_time > 60 and @total_time <300)
													begin
														update Exam
														set start_time=@start_time,end_time=@end_time,Ex_year=@Ex_year
														where ex_code=@ex_code
														print 'This Exam Updated Successfully'
													end
											   else
												   begin
													  throw 50001,'The time of exame must between 1 to 5 hours.',16;
												   end
											 end
										else
											begin
											   throw 50001,'Start time must not the same of end time for exam.',16;
											end
									end
							  else
								  begin
									 throw 50001,'The time of Exam must startTime from 8 Am and endTime less than 8:Pm am ',16;
								  end
							end
					  else 
						  begin
							   throw 50001,'The date of exam is less than the current date.',16;
						  end
				end
			else
				begin
					THROW 50006,'This Exam is not Exists',16;
				end
		end try

			begin catch
				--PRINT('Raise the caught error again');
				select ERROR_MESSAGE();
			end catch
	end
GO
----------------------------------------------------------------------------------------------

-----------------------------    Delete Exam   -----------------------------------------------
----------------------------------------------------------------------------------------------

Go
create or alter proc InstructorFunctionality.Delete_Exam(@ex_code nvarchar(5),@instSNN char(14))as
	begin
		begin try
			IF EXISTS (select 1 from  Exam where ex_code=@ex_code and inst_SSN = @instSNN)
			and EXISTS (select 1 from  Instructor as inst join Course as cou on
			inst.inst_SSN=@instSNN and cou.inst_SSN=@instSNN)
				begin 
					delete from Inst_Course_Exam
					where ex_code = @ex_code
					delete from Exam
					where ex_code=@ex_code
					print 'This Exam Deleted Successfully'
				end
			else
				begin
					THROW 50006,'This Exam Not Exists or instructor not teach this course .',16;
				end
		end try

		begin catch
			select ERROR_MESSAGE();
		end catch

	end
GO
----------------------
-- show all exam for spacific instructor
create or alter proc InstructorFunctionality.ShowInstructorExams @inst_SSN char(14)
as
begin try
	if exists(select * from Exam where inst_SSN=@inst_SSN)
	begin
		select * from Exam where inst_SSN=@inst_SSN
	end
	else
		print 'That Instructor did not add any exam '
end try
begin catch
	print ERROR_MESSAGE()
end catch
------------------------------------------------------------------------

--drop proc Display_Exams_Specific_Inst 
------------------------------------------------------------------------
--(branch_no,dept_no,track_code,intake_round)values(10,2,'WD',52)
