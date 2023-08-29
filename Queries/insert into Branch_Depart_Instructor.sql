use ExaminationSystem_2

begin try
	begin transaction
		insert into Branch(branch_name,branch_address)
			values('Cairo','cairo ,Egypt')
		insert into Department(dept_name)
			values('Web')
		insert into Instructor
			values('29009876500000','Hassan Tawfik','Egypt Giza','01023456789','Web','Cairo')
		update Branch
			set manager_SSN = '29009876500000'
		where branch_name = 'Cairo'
	commit
end try
begin catch
	rollback
	print Error_MESSAGE()
end catch


