use ExaminationSystem_2

create or alter procedure TrainingManagerFunctionality.addNewBranchWithNewManager @branch_name nvarchar(50),@branch_address nvarchar(100),
	@manager_SSN char(14),@fullNmae nvarchar(50),@manager_address nvarchar(100),@phone_num char(11)
as
begin try
	begin transaction
		if exists(select * from Branch where branch_name = @branch_name)
			print 'There is Branch With That Name'
		else
		begin
			if exists(select * from Instructor where inst_SSN = @manager_SSN)
			begin
				if exists(select * from Branch where manager_SSN = @manager_SSN)
					print 'There is Manager already exists with that SSN'
				else
					begin
						insert into Branch(branch_name,branch_address)
							values(@branch_name,@branch_address)
						update Branch
							set manager_SSN = @manager_SSN
						where branch_name = @branch_name
						print CONCAT('update the instructor to be manager to branch ',@branch_name)
					end
			end
			else
			begin
				insert into Branch(branch_name,branch_address)
					values(@branch_name,@branch_address)
				insert into Instructor
					values(@manager_SSN,@fullNmae,@manager_address,@phone_num,null,@branch_name)
				update Branch
					set manager_SSN = @manager_SSN
				where branch_name = @branch_name
			end
		end
	commit
end try
begin catch
	rollback
	print Error_MESSAGE()
end catch
-----------------------------------

TrainingManagerFunctionality.addNewBranchWithNewManager