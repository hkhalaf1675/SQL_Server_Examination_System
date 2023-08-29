use ExaminationSystem_2
------------------------------------ Procedure For Branch -------------------------------
------------------------------------   Crud  For Branch  --------------------------------


-------------------------------------      Add Branch    --------------------------------
-- to add new Branch and take 3 parameters : branch name , address , manager ssn and must be instructor
Go
create or alter proc Add_Branch(@branch_name nvarchar(100),@branch_address nvarchar(100)
,@manager_SSN char(14))as
begin
	IF not EXISTS (select 1 from  Branch where manager_SSN=@manager_SSN)
	and not EXISTS(select 1 from  Branch where branch_name=@branch_name)
	and not EXISTS(select 1 from  Branch where branch_address=@branch_address)
	and EXISTS(select 1 from  Instructor where inst_SSN=@manager_SSN)
	begin 
		insert into Branch(branch_name,branch_address,manager_SSN)
		values(@branch_name,@branch_address,@manager_SSN)

		update Instructor
			set dept_name = null,branch_name=@branch_name
			where inst_SSN = @manager_SSN
		print 'This branch added Successfully'
	end
	else
	begin
		print 'This instructor is not exists or he is already manager or branch name already Exists'
	end
end

exec Add_Branch @branch_name='Sohag',@branch_address='Sohag, Egypt',@manager_SSN='292043726000001'
exec Add_Branch @branch_name='Qina',@branch_address='Qina, Egypt',@manager_SSN='292043726000001'

Go

select * from Branch

---------------------------     Update on branch address   --------------------------------
-- update the branch take three parameter : branch name and take new address and the new manager ssn
Go
create or alter proc Update_Branch(@branch_name nvarchar(100),@New_branch_address nvarchar(100),@manager_SSN char(14))
as
begin
	IF EXISTS (select 1 from  Branch where branch_name=@branch_name)
	begin 
		if exists(select * from Branch where manager_SSN = @manager_SSN and branch_name != @branch_name)
		begin
			print 'This Instructor is Manager to Another Branch'
		end
		else
		begin
			update Branch
				set branch_address=@New_branch_address,
					manager_SSN = @manager_SSN
				where branch_name=@branch_name
			update Instructor
				set dept_name = null,branch_name = @branch_name
				where inst_SSN = @manager_SSN
			print 'This Branch address and Manager SSN is updated  Successfully'
		end
	end
	else
	begin
		print 'This Branch is not Exists'
	end
end
Go
Update_Branch @branch_name='Cairo',@New_branch_address='Smart Cairo, Egypt',@manager_SSN = '292043726000001'
Go
select * from Branch

-------------------------      delete Branch  by its name  ----------------------------------
Go
create or alter proc Delete_Branch(@branch_name nvarchar(100))as
begin
	IF EXISTS (select 1 from  Branch where branch_name=@branch_name)
	begin 
		delete from Br_Dept_Tr_Intake
			where branch_name = @branch_name
		delete from Branch
			where branch_name=@branch_name
			print 'This Branch is deleted Successfully'
	end
	else
	begin
		print 'This Branch is not Exists'
	end
end
Go
exec Delete_Branch @branch_name='Giza';
Go


-----------------------------------  Function for Diplay Branches  ---------------
Go
CREATE FUNCTION Select_Branches()
RETURNS TABLE
AS
RETURN
    SELECT  *
    FROM Branch
Go

SELECT * FROM Select_Branches()

select * from Instructor;
