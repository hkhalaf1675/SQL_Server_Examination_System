use ExaminationSystem_2

--------------->>>> Intake
----->>> Functions
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

-------------------------------------------------------
-------------------------------------------------------

-------->>> Procedure

--create new intake but must sent the track code and department no and inital branch no
create or alter procedure TrainingManagerFunctionality.addIntake @intake_round int,@intake_name varchar(50),@track_code varchar(5), 
			@dept_name nvarchar(50),@branch_name nvarchar(50)
as
	begin try
		begin transaction
			if exists(select * from Track where track_code = @track_code)
			begin 
				if exists (select * from Department where dept_name = @dept_name)
				begin
					if exists(select * from Branch where branch_name = @branch_name)
					begin
						insert into Intake values(@intake_round,@intake_name)
						insert into Br_Dept_Tr_Intake(intake_round,branch_name,dept_name,track_code)
							values(@intake_round,@branch_name,@dept_name,@track_code)
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
TrainingManagerFunctionality.addIntake 8,'Software Engineering 8','SE','Web Development','Sohag'

----------------------------------
---> add intake to branchs
create or alter procedure TrainingManagerFunctionality.IntakeBranch @intake_round int,@branch_name nvarchar(50)
as
	begin try
		if dbo.checkIntakeRound(@intake_round) = 1
		begin
			if exists(select * from Branch where branch_name = @branch_name)
			begin
				declare @dept_name int ,@track_code varchar(5)
				select @dept_name = dept_name,@track_code = track_code from Br_Dept_Tr_Intake where intake_round = @intake_round
				begin transaction
					insert into Br_Dept_Tr_Intake(intake_round,track_code,dept_name,branch_name)
						values(@intake_round,@track_code,@dept_name,@branch_name)
				commit
			end
			else
				select 'There is no Branch with this name' as MSG
		end
		else
			select 'There is no Intake with this round' as MSG
	end try
	begin catch
		rollback
		select ERROR_NUMBER(),ERROR_MESSAGE()
	end catch
------------------
TrainingManagerFunctionality.IntakeBranch 7,'Giza'
------------------------
--> show branches that intake on it
create or alter procedure TrainingManagerFunctionality.showIntakeBranches @intake_round int
as
	begin try
		if dbo.checkIntakeRound(@intake_round) = 1
		begin
			select Intake.intake_round,Branch.branch_name
			from Br_Dept_Tr_Intake as Intake
			join Branch
			on Branch.branch_name = Intake.branch_name and Intake.intake_round = @intake_round
		end
		else
			print 'There is no Intake With That Number'
	end try
	begin catch
		select ERROR_NUMBER(),ERROR_LINE(),ERROR_MESSAGE()
	end catch
---------
TrainingManagerFunctionality.showIntakeBranches 7
------------------------------------
--> delete round from branch by intake round number and branch no
create or alter procedure TrainingManagerFunctionality.deleteIntakeFromBranches @intake_round int,@branch_name nvarchar(50)
as
	begin try
		if dbo.checkIntakeRound(@intake_round) = 1
		begin
			delete from Br_Dept_Tr_Intake
				where intake_round = @intake_round and branch_name = @branch_name
		end
		else
			print 'There is no Intake With That Number'
	end try
	begin catch
		select ERROR_NUMBER(),ERROR_LINE(),ERROR_MESSAGE()
	end catch
---
TrainingManagerFunctionality.deleteIntakeFromBranches 7,'Cairo'
-----------------------
---> check if intake is exists or not
create or alter procedure TrainingManagerFunctionality.checkIntake @intake_round int
as
	begin try
		if dbo.checkIntakeRound(@intake_round) = 1
		begin
			select * from Intake
				where intake_round = @intake_round
		end
		else
			print 'There is no Intake With That Number'
	end try
	begin catch
		select ERROR_NUMBER(),ERROR_LINE(),ERROR_MESSAGE()
	end catch
--------------
TrainingManagerFunctionality.checkIntake 7
-----------------------
----> show all intakes
create procedure TrainingManagerFunctionality.showAllIntakes
as
	select * from Intake
------------
TrainingManagerFunctionality.showAllIntakes
---------------------------------------------
----------------------------------------------
----->>> Another Way To Add New Intake
-->>>> to add new intake must determine what branchs and tracks after adding the new intake
-->add the new intake
create or alter proc TrainingManagerFunctionality.addNewIntake @round int,@intake_name varchar(50)
as
	begin try
		if dbo.checkIntakeRound(@round) = 0
			insert into Intake values(@round,@intake_name)
		else
			print 'There is Intake Round With That Round Number'
	end try
	begin catch
		print CONCAT(ERROR_NUMBER(),' : ',ERROR_LINE(),' :- ',ERROR_MESSAGE())
	end catch

-----
TrainingManagerFunctionality.addNewIntake 8 ,'Software Testing'
-------------------------------------
---> the relation between intake and branches
create or alter procedure TrainingManagerFunctionality.addIntakeToBranches @intake_round int,
			@branch_name nvarchar(50),@dept_name nvarchar(50),@track_code varchar(5)
as
	begin try
		if dbo.checkIntakeRound(@intake_round) = 1
			begin
				if exists(select * from Branch where branch_name = @branch_name)
					begin
						if exists(select * from Department where dept_name = @dept_name)
							begin
								if exists(select * from Track where track_code = @track_code)
									begin
										insert into Br_Dept_Tr_Intake(intake_round,branch_name,dept_name,track_code)
										values(@intake_round,@branch_name,@dept_name,@track_code)
									end
								else
									print 'That track code is not exists' 
							end
						else
							print 'That department name is not exists'
					end
				else
					print 'That branch name is not exists'
			end
		else
			print 'That round number is not exists'
	end try
	begin catch
		select ERROR_NUMBER(),ERROR_LINE(),ERROR_MESSAGE()
	end catch
-----------
TrainingManagerFunctionality.addIntakeToBranches 8 , 'Cairo' , 'Web Development' , 'AI'
----------------------------------------