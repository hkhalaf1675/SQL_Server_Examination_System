use ExaminationSystem_2

create or alter procedure TrainingManagerFunctionality.addNewBranchWithNewManager @branch_name nvarchar(50),@branch_address nvarchar(100),
	@manager_SSN char(14),@fullNmae nvarchar(50),@manager_address nvarchar(100),@phone_num char(11)
as
begin try
	begin transaction
		insert into Branch(branch_name,branch_address)
			values(@branch_name,@branch_address)
		insert into Instructor
			values(@manager_SSN,@fullNmae,@manager_address,@phone_num,null,@branch_name)
		update Branch
			set manager_SSN = @manager_SSN
		where branch_name = @branch_name
	commit
end try
begin catch
	rollback
	print Error_MESSAGE()
end catch

