use ExaminationSystem_2
go
create schema TrainingManagerFunctionality
go
-----------------------------------------
---- traning manager user login
--name:TraningManager
--password:12345
------------------------
-- trainning manager instructor

------> instructor
-- to insert new instructor : addNewInstructor with parameters SSN,fullname,address,phone,dept name , branch name
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

-- there is procedure to add new intake : addIntake must determine the track code and department name and initial branch name
---------------------------
-----------> Intake to branches
-- add intake to branches : addIntakeToBranches take parameters intake round number,branch name,department name,track code

-- add intake to branch : IntakeBranch and take only the intake round and branch name

-- delete branch from intake : deleteIntakeFromBranches take with two parameters intake round num,branch name
-- show intake branches : showIntakeBranches take the intake round number

-----------------------------
------------>add Track Instructors and Course
-- add instructor to Track : addInstructorToTrack take two parameter the instructor SSN and the track code
-- add course to track : addCourseToTrack take two parameter the course code and the tack code

---------------------------------------------------------------------------------------------------------------------------------------


go
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
create or alter proc TrainingManagerFunctionality.updateIntake @round int,@newValue varchar(100)
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




----------------------------
----create schema and transfer all trainning manager procedures to it


--go
--alter schema TrainingManagerFunctionality transfer addNewInstructor
--go
--alter schema TrainingManagerFunctionality transfer deleteInstructor
--go
--alter schema TrainingManagerFunctionality transfer updateInstructor
--go
--alter schema TrainingManagerFunctionality transfer showAllInstructors
--go
--alter schema TrainingManagerFunctionality transfer checkInstructor
--go
--alter schema TrainingManagerFunctionality transfer addNewIntake
--go
--alter schema TrainingManagerFunctionality transfer deleteIntake
--go
--alter schema TrainingManagerFunctionality transfer updateIntake
--go
--alter schema TrainingManagerFunctionality transfer showAllIntakes
--go
--alter schema TrainingManagerFunctionality transfer checkIntake
--go
--alter schema TrainingManagerFunctionality transfer addIntake
--go
--alter schema TrainingManagerFunctionality transfer addIntakeToBranches
--go
--alter schema TrainingManagerFunctionality transfer IntakeBranch
--go
--alter schema TrainingManagerFunctionality transfer deleteIntakeFromBranches
--go
--alter schema TrainingManagerFunctionality transfer showIntakeBranches
--go
--alter schema TrainingManagerFunctionality transfer addInstructorToTrack
--go
--alter schema TrainingManagerFunctionality transfer addCourseToTrack
--go
