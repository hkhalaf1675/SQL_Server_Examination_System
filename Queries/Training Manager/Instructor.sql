use ExaminationSystem_2

-->>> Functions 

--- create function to check if there is instructor with that SSN or not
create or alter function checkInstructorExists(@inst_SSN char(14))
returns bit
as
begin
	declare @f bit
	if exists(select * from Instructor where inst_SSN = @inst_SSN)
		set @f = 1
	else
		set @f = 0
	return @f
end
go
-------------------

---->>>> Procedures 

--->>> Instructor
-->> add Instructor

create or alter procedure TrainingManagerFunctionality.addNewInstructor @SSN char(14),@fullName varchar(50),
										@inst_address varchar(50),@phone char(11),@dept_name nvarchar(50),@branch_name nvarchar(50)
as
	begin try
		if len(@SSN) = 14
		begin
			if len(@phone) = 11
			begin
				insert into Instructor
					values(@SSN,@fullName,@inst_address,@phone,@dept_name,@branch_name)
			end
			else
				print ' the phone must be 11 number'
		end
		else
			print 'The Instructor SSN Must be 14 number'
	end try
	begin catch
		print Error_MESSAGE()
	end catch
go
-------
TrainingManagerFunctionality.addNewInstructor '29204372600011','Hassan khalaf','egypt giza','01234567890','Web Development','Sohag'

insert into Department values('Web Development')
---------
--- to delete instructor 
create or alter procedure TrainingManagerFunctionality.deleteInstructor @SSN char(14)
as
	begin try
		if dbo.checkInstructorExists(@SSN) = 1
		begin
			begin try
				begin transaction
					delete from Track_Instructors
						where inst_SSN=@SSN
					delete from Inst_Course_Exam
						where inst_SSN = @SSN
					delete from Course
						where inst_SSN = @SSN
					update Branch
						set manager_SSN = null
						where manager_SSN = @SSN
					update Track
						set superVisior = null
						where superVisior = @SSN
					update Question
						set inst_SSN = null
						where inst_SSN = @SSN
					delete from Instructor
						where inst_SSN = @SSN
				commit
			end try
			begin catch
				rollback
				print ERROR_MESSAGE()
			end catch
		end
		else
			print 'There is no Instructor with that SSN'
	end try
	begin catch
		print ERROR_MESSAGE()
	end catch
-----
TrainingManagerFunctionality.deleteInstructor '29009876500000'
---------
---------
--- to upadte instructor
create or alter procedure TrainingManagerFunctionality.updateInstructor @col varchar(20),@SSN char(14),@newValue varchar(50)
as
	begin try
		if LEN(@SSN) = 14
		begin
			if @col = 'full name'
				begin
					update Instructor
						set inst_fullname = @newValue
					where inst_SSN = @SSN
				end
			else if @col = 'address'
				begin
					update Instructor
						set inst_address = @newValue
					where inst_SSN = @SSN
				end
			else if @col = 'phone'
				begin
					if LEN(@newValue) = 11
					begin
						update Instructor
							set inst_phone = @newValue
						where inst_SSN = @SSN
					end
					else
						print 'The Phone Number Must Be 11 number'
				end
			else if @col = 'department name'
				begin
					if exists(select * from Branch where manager_SSN = @SSN)
						print 'Can not update the value of branch no of that instructor because he is the branch manager'
					else
					begin
						update Instructor
							set dept_name = @newValue 
						where inst_SSN = @SSN
					end
				end
			else if @col = 'branch name'
				begin
					if exists(select * from Branch where manager_SSN = @SSN)
						print 'Can not update the value of department no of that instructor because he is the branch manager'
					else
					begin
						update Instructor
							set branch_name = @newValue
						where inst_SSN = @SSN
					end
				end
			else
				print 'the value of col is to determine which column will upadte the value of it and must be one of 
						(full name,address,phone,department name,branch name)'
		end
		else
			print 'The SSN must Be 14 numbers'
	end try
	begin catch
		print ERROR_MESSAGE()
	end catch

-----
TrainingManagerFunctionality.updateInstructor 'department name',29009876500001,'Web Development'
-----

---  show all instructors
create or alter procedure TrainingManagerFunctionality.showAllInstructors
as
	select * from Instructor

TrainingManagerFunctionality.showAllInstructors
-----------------
------------
---show if the instructor is added by ssn
create or alter procedure TrainingManagerFunctionality.checkInstructor @SSN char(14)
as
	begin try
		if LEN(@SSN) = 14
			select * from Instructor where inst_SSN = @SSN
		else
			print 'the instructor ssn must be 14 number'
	end try
	begin catch
		print ERROR_MESSAGE()
	end catch

TrainingManagerFunctionality.checkInstructor 29204372600000