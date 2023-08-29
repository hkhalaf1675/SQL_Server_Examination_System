use ExaminationSystem
go
create schema TrainingManagerFunctionality
go
-- trainning manager instructor

------> instructor
-- to insert new instructor : addNewInstructor with parameters SSN,fullname,address,phone,dept no , branch no
-- to delete instructor : deleteInstructor with one parameter SSN
-- to update instructor : updateInstructor with parameter the column name of updated data and the primary key value of the row and the new value
-- show all instructors : showAllInstructors
-- to check if instructor is exists : checkInstructor take one parameter SSN
---------------------------
--------> Intake
-- to insert new Intake : addNewIntake with two parameters round num and intake name
-- to delete intake : deleteIntake with one parameter the round number
-- to update intake : updateIntake with two parameters the round number and the new intake name value
-- show all intakes data : showAllIntakes
-- check if the intake is exists : checkIntake take intake round number

-- there is procedure to add new intake : addIntake must determine the track code and department no and initial branch no
---------------------------
-----------> Intake to branches
-- add intake to branches : addIntakeToBranches take parameters intake round number,branch no,department no,track code

-- add intake to branch : IntakeBranch and take only the intake round and branch no

-- delete branch from intake : deleteIntakeFromBranches take with two parameters intake round num,branch no
-- show intake branches : showIntakeBranches take the intake round number

-----------------------------
------------>add Track Instructors and Course
-- add instructor to Track : addInstructorToTrack take two parameter the instructor SSN and the track code
-- add course to track : addCourseToTrack take twp parameter the course code and the tack code

---------------------------------------------------------------------------------------------------------------------------------------

--create function to check if the intake round is exists or not
create function checkIntakeRound (@round int)
returns bit
begin
	declare @f bit
	if exists(select * from Intake where intake_round = @round)
		set @f = 1
	else
		set @f = 0
	return @f
end
go
------------
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
------------------
--- create function to check if there is track with that code or not
create or alter function checkTrackExists(@track_code varchar(5))
returns bit
as
begin
	declare @f bit
	if exists(select * from Track where track_code = @track_code)
		set @f = 1
	else
		set @f = 0
	return @f
end
go
---------------------
--- create function to check if there is course with that code or not
create or alter function checkCourseExists(@crs_code varchar(5))
returns bit
as
begin
	declare @f bit
	if exists(select * from Course where crs_code = @crs_code)
		set @f = 1
	else
		set @f = 0
	return @f
end
go
-------------------------------------------------------------------------------------------------------------------------------------

create or alter procedure TrainingManagerFunctionality.addNewInstructor @SSN char(14),@fullName varchar(50),@inst_address varchar(50),@phone char(11),@dept_no int,@branch_no int
as
	begin try
		if len(@SSN) = 14
		begin
			if len(@phone) = 11
			begin
				insert into Instructor
					values(@SSN,@fullName,@inst_address,@phone,@dept_no,@branch_no)
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
--if Error_number() = 2627
			--print 'There is already instructor with that SSN';
--else if Error_number() = 547
			--print 'There is no branch or department with that id number';
--TrainingManagerFunctionality.addNewInstructor 29204372600000,'Hassan Tawfik','egypt giza','01234567890',3,3

----------
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
TrainingManagerFunctionality.deleteInstructor 29101234500012
---------
--- to upadte instructor
create or alter procedure updateInstructor @col varchar(20),@SSN char(14),@newValue varchar(50)
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
					update Instructor
						set inst_phone = CAST(@newValue as bigint)
					where inst_SSN = @SSN
				end
			else if @col = 'department no'
				begin
					if exists(select * from Branch where manager_SSN = @SSN)
						print 'Can not update the value of branch no of that instructor because he is the branch manager'
					else
					begin
						update Instructor
							set dept_no = CAST(@newValue as int)
						where inst_SSN = @SSN
					end
				end
			else if @col = 'branch no'
				begin
					if exists(select * from Branch where manager_SSN = @SSN)
						print 'Can not update the value of department no of that instructor because he is the branch manager'
					else
					begin
						update Instructor
							set branch_no = CAST(@newValue as int)
						where inst_SSN = @SSN
					end
				end
			else
				print 'the value of col is to determine which column will upadte the value of it and must be one of 
						(full name,address,phone,department no,branch no)'
		end
		else
			print 'The SSN must Be 14 numbers'
	end try
	begin catch
		print ERROR_MESSAGE()
	end catch

-----
updateInstructor 'department no',29204372600000,5
-----
---  show all instructors
create or alter procedure showAllInstructors
as
	select * from Instructor

showAllInstructors
------------
---show if the instructor is added by ssn
create or alter procedure checkInstructor @SSN char(14)
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

checkInstructor 29204372600000

-------------------------------------------------------------
-->>>> to add new intake must determine what branchs and tracks after adding the new intake
-->add the new intake
create or alter proc addNewIntake @round int,@intake_name varchar(50)
as
	begin try
		insert into Intake values(@round,@intake_name)
	end try
	begin catch
		print CONCAT(ERROR_NUMBER(),' : ',ERROR_LINE(),' :- ',ERROR_MESSAGE())
	end catch

-----
TrainingManagerFunctionality.addNewIntake 8 ,'Software Testing'
-------------------------------------


-->delete row from intake by round number
create or alter proc TrainingManagerFunctionality.deleteIntake @round int
as
	begin try
		if dbo.checkIntakeRound(@round) = 1
		begin
			delete from Br_Dept_Tr_Intake
				where intake_round = @round
			delete from Student
				where intake_round = @round
			delete from Intake where intake_round = @round
		end
		else
			print 'There is no Intake round with this number'
	end try
	begin catch
		select ERROR_NUMBER(),ERROR_LINE(),ERROR_MESSAGE()
	end catch
---------------
TrainingManagerFunctionality.deleteIntake 8

------
---> update Intake name
create or alter proc updateIntake @round int,@newValue varchar(100)
as
	begin try
		if dbo.checkIntakeRound(@round) = 1
		begin
			update Intake
				set intake_name = @newValue
			where intake_round = @round
		end
		else
			print 'There is no Intake round with this number'
	end try
	begin catch
		select ERROR_NUMBER(),ERROR_LINE(),ERROR_MESSAGE()
	end catch

----------
TrainingManagerFunctionality.updateIntake 8 ,'Flutter 14'

----> show all intakes
create procedure showAllIntakes
as
	select * from Intake
------------
TrainingManagerFunctionality.showAllIntakes

---> check if intake is exists or not
create or alter procedure checkIntake @intake_round int
as
	begin try
		select * from Intake
			where intake_round = @intake_round
	end try
	begin catch
		select ERROR_NUMBER(),ERROR_LINE(),ERROR_MESSAGE()
	end catch
--------------
TrainingManagerFunctionality.checkIntake 7

--------------------------
---> the relation between intake and branches
create or alter procedure addIntakeToBranches @intake_round int,@branch_no int,@dept_no int,@track_code varchar(5)
as
	begin try
		if dbo.checkIntakeRound(@intake_round) = 1
			begin
				if exists(select * from Branch where branch_no = @branch_no)
					begin
						if exists(select * from Department where dept_no = @dept_no)
							begin
								if exists(select * from Track where track_code = @track_code)
									begin
										insert into Br_Dept_Tr_Intake(intake_round,branch_no,dept_no,track_code)
										values(@intake_round,@branch_no,@dept_no,@track_code)
									end
								else
									select 'That track code is not exists' as MSG
							end
						else
							select 'That department number is not exists' as MSG
					end
				else
					select 'That branch number is not exists' as MSG 
			end
		else
			select 'That round number is not exists' as MSG 
	end try
	begin catch
		select ERROR_NUMBER(),ERROR_LINE(),ERROR_MESSAGE()
	end catch
-----------
TrainingManagerFunctionality.addIntakeToBranches 7 , 5 , 2 , 'AI'
----------------------------------------
--> delete round from branch by intake round number and branch no
create or alter procedure deleteIntakeFromBranches @intake_round int,@branch_no int
as
	begin try
		delete from Br_Dept_Tr_Intake
			where intake_round = @intake_round and branch_no = @branch_no
	end try
	begin catch
		select ERROR_NUMBER(),ERROR_LINE(),ERROR_MESSAGE()
	end catch
---
TrainingManagerFunctionality.deleteIntakeFromBranches 7,5
-------
--> show branches that intake on it
create or alter procedure showIntakeBranches @intake_round int
as
	begin try
		select Intake.intake_round,Branch.branch_name
		from Br_Dept_Tr_Intake as Intake
		join Branch
		on Branch.branch_no = Intake.branch_no
	end try
	begin catch
		select ERROR_NUMBER(),ERROR_LINE(),ERROR_MESSAGE()
	end catch
---------
TrainingManagerFunctionality.showIntakeBranches 7

------------------------------------------
--create new intake but must sent the track code and department no and inital branch no
create or alter procedure addIntake @intake_round int,@intake_name varchar(50),@track_code varchar(5), @dept_no int,@branch_no int
as
	begin try
		begin transaction
			if exists(select * from Track where track_code = @track_code)
			begin 
				if exists (select * from Department where dept_no = @dept_no)
				begin
					if exists(select * from Branch where branch_no = @branch_no)
					begin
						insert into Intake values(@intake_round,@intake_name)
						insert into Br_Dept_Tr_Intake(intake_round,branch_no,dept_no,track_code)
							values(@intake_round,@branch_no,@dept_no,@track_code)
					end
					else
						select 'There is no branch with this num ' as MSG
				end
				else
					select 'There is no department with this number' as MSG
			end
			else
				select 'there is no track with this code' as MSG
		commit
	end try
	begin catch
		rollback
		select ERROR_NUMBER(),ERROR_MESSAGE()
	end catch
-------------------
TrainingManagerFunctionality.addIntake 8,'Software Engineering 8','SE',3,5
----------------------------------------------
---> add intake to branchs
create or alter procedure IntakeBranch @intake_round int,@branch_no int
as
	begin try
		if dbo.checkIntakeRound(@intake_round) = 1
		begin
			if exists(select * from Branch where branch_no = @branch_no)
			begin
				declare @dept_no int ,@track_code varchar(5)
				select @dept_no = dept_no,@track_code = track_code from Br_Dept_Tr_Intake where intake_round = @intake_round
				begin transaction
					insert into Br_Dept_Tr_Intake(intake_round,track_code,dept_no,branch_no)
						values(@intake_round,@track_code,@dept_no,@branch_no)
				commit
			end
			else
				select 'There is no Branch with this number' as MSG
		end
		else
			select 'There is no Intake with this round' as MSG
	end try
	begin catch
		rollback
		select ERROR_NUMBER(),ERROR_MESSAGE()
	end catch
------------------
TrainingManagerFunctionality.IntakeBranch 7,3
----------------------------------------------------

--- add instructor to the track
create or alter procedure addInstructorToTrack @inst_SSN char(14),@track_code varchar(5)
as
begin try
	if dbo.checkInstructorExists(@inst_SSN) = 1 and dbo.checkTrackExists(@track_code) = 1
	begin
		insert into Track_Instructors values(@track_code,@inst_SSN)
	end
	else
		print 'There is no instructor with that SSN or There is no Track with that Code'
end try
begin catch
	print CONCAT(Error_NUMBER(),':',ERROR_MESSAGE())
end catch

TrainingManagerFunctionality.addInstructorToTrack 29678901200007,'WD'
------------------------------------------------------
--- add course to the track
create or alter procedure addCourseToTrack @crs_code varchar(5),@track_code varchar(5)
as
begin try
	if dbo.checkCourseExists(@crs_code) = 1 and dbo.checkTrackExists(@track_code) = 1
	begin
		insert into Track_Courses values(@track_code,@crs_code)
	end
	else
		print 'There is no instructor with that SSN or There is no Track with that Code'
end try
begin catch
	print CONCAT(Error_NUMBER(),':',ERROR_MESSAGE())
end catch

TrainingManagerFunctionality.addCourseToTrack 'sq405','WD'

----------------------------
----create schema and transfer all trainning manager procedures to it


go
alter schema TrainingManagerFunctionality transfer addNewInstructor
go
alter schema TrainingManagerFunctionality transfer deleteInstructor
go
alter schema TrainingManagerFunctionality transfer updateInstructor
go
alter schema TrainingManagerFunctionality transfer showAllInstructors
go
alter schema TrainingManagerFunctionality transfer checkInstructor
go
alter schema TrainingManagerFunctionality transfer addNewIntake
go
alter schema TrainingManagerFunctionality transfer deleteIntake
go
alter schema TrainingManagerFunctionality transfer updateIntake
go
alter schema TrainingManagerFunctionality transfer showAllIntakes
go
alter schema TrainingManagerFunctionality transfer checkIntake
go
alter schema TrainingManagerFunctionality transfer addIntake
go
alter schema TrainingManagerFunctionality transfer addIntakeToBranches
go
alter schema TrainingManagerFunctionality transfer IntakeBranch
go
alter schema TrainingManagerFunctionality transfer deleteIntakeFromBranches
go
alter schema TrainingManagerFunctionality transfer showIntakeBranches
go
alter schema TrainingManagerFunctionality transfer addInstructorToTrack
go
alter schema TrainingManagerFunctionality transfer addCourseToTrack
go

-----------------------------------------
---- traning manager user login
--name:TraningManager
--password:12345