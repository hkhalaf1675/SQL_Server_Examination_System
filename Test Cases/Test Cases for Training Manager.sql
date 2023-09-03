use ExaminationSystem_2

---========================>>> Training Manager Functionality <<< -------------------------------

--->>> Branch{add,update,delete}

--- show all branches
SELECT * FROM TrainingManagerFunctionality.Select_Branches()

--add new branch
--takes three parameters : the branch name{the primary key} , the branch address, 
------and the manager SSN {which is references from Instructor table}
-------the manager must be exists on database
exec TrainingManagerFunctionality.Add_Branch @branch_name='Assuit',@branch_address='Assuit, Egypt',
@manager_SSN='29901234500012'

---add new Branch with new Manager
--- takes parameters : 
----------------> branch name
----------------> branch address
----------------> new manager ssn { must consist from 14 number }
----------------> manager full name
----------------> manager address
----------------> manager phone number { must consists from 11 number}

TrainingManagerFunctionality.addNewBranchWithNewManager 'Minya','Minia, Egypt','29009876500013',
			'Ahmed Tawfik','Minya, Egypt','01098765431'

--- delete branch
--->>> takes one parameter : branch name
TrainingManagerFunctionality.Delete_Branch 'Minya'

--- update branch
--->> takes parameters :
------------------> branch name {the primary key}
------------------> New branch address
------------------> manager ssn
TrainingManagerFunctionality.Update_Branch @branch_name='Cairo',@New_branch_address='Smart Cairo, Egypt',@manager_SSN = '292043726000001'
Go
-----------------------------------------------------------------------------------------------------

---->>> Department {add,update,delete}

--add department
--> takes one parameter : department name
TrainingManagerFunctionality.add_Department 'Cyber Security'

-->upadte department
--> takes two parameters :
----------->> old department name
----------->> new department name

TrainingManagerFunctionality.Update_Department 'Security','MCA'

---> delete Department
---> takes one paramter : Department Name

TrainingManagerFunctionality.Delete_Department 'Cyber Security'

-----------------------------------------------------------------------------------------------------

------->>> Instructor { add,update,delete ,show Instrcutors}

----->> show Instrcutors : 
TrainingManagerFunctionality.showAllInstructors

---> check if instrcutor is exists or not
---> takes one parameter : SSN {the primay key}
TrainingManagerFunctionality.checkInstructor '29009876500005'

--->> add instructor
---> takes parameters : 
------------> instrcutor ssn {primary key} must be 14 number
------------> full name 
------------> address
-------------> phone number and must be 11 number
------------> department name { foreign references department table}
------------> branch name { foreign key refereneces branch table}
TrainingManagerFunctionality.addNewInstructor '295678901000012','Dailda Mohamed','Mansoura, Egypt','01187654321','Security','Luxor'

---> delete Instructor
--- take one parameter { SSN the primary key}
TrainingManagerFunctionality.deleteInstructor '295678901000012'

---> update Instructor
--- takes three parameter : 
-------------------> column name : {branch name , department name , full name , address , phone }
-------------------> primary key {SSN of the row }
-------------------> new value or updated value
TrainingManagerFunctionality.updateInstructor 'full name','29204372600011','Ryan Mohamed'

-------------------------------------------------------------------------------------------------------

------>>> Track

--> add track
-- takes parameters : 
------------>> track code { the primay key of table}
------------>> tarck name
----------->> supervisior ssn { references to instrcutor ssn}
TrainingManagerFunctionality.Add_Track 'SE','Software Engineering','29789012300008'

--> delete track
---- takes one parameter : the primary key : old track code
TrainingManagerFunctionality.Delete_Track 'SE'

--> Upadte Track
--- takes parameters : 
----------->> old track code
----------->> new track code
----------->> new track name
exec TrainingManagerFunctionality.Update_Track @Old_track_code='DS', @New_track_code='Sofwr', 
@old_track_name='DotNetDevelopment_FullStack',@New_track_name='Software Development';

-------------------------------------------------------------------------------------------------

------------>>> Course {show,add,delete,update}

---> show all courses
TrainingManagerFunctionality.Display_Courses;

--->> add new Course
--- takes parameters : 
-------------------> course code {primary key}
-------------------> course name
-------------------> course description
-------------------> course max dgree
-------------------> coures min dgree
-------------------> instructor ssn {foreign key} who teach the course
TrainingManagerFunctionality.Add_Course 'sftsk','Soft Skills',null,100,50,'29901234500010'

--->> update Course
--- takes parameters : 
-------------------> course code {primary key}
-------------------> course name
-------------------> course description
-------------------> course max dgree
-------------------> coures min dgree
-------------------> instructor ssn {foreign key} who teach the course
TrainingManagerFunctionality.Update_Course 'sftsk','Soft-Skills',null,100,50,'29901234500010'

-- delete course
----> takes one parameter : course code { primary key}
TrainingManagerFunctionality.Delete_Course 'sftsk'

-------------------------------------------------------------------

-------------- many to many tables 

---track courses
--- takes two parameters : course code , track code
TrainingManagerFunctionality.addCourseToTrack 'csh20','DS'

---Trak instructor
-- takes tow parameter : instructor course , track course
TrainingManagerFunctionality.addInstructorToTrack '29901234500010','DS'

--------------------------------------------------------------------------------

-------------->>> Intakes

--- show all inatkes
TrainingManagerFunctionality.showAllIntakes

----add new intake with initialize the department and track and one branch 
--- takes parameters : 
--------------------> round number { primay key}
--------------------> intake round name
--------------------> track code { foreign key referenece track tabel}
--------------------> department name { foreign key referenece department tabel}
--------------------> branch name { foreign key referenece branch tabel}
TrainingManagerFunctionality.addIntake 29,'Data Science Round 29','DS','Operations','Aswan'

---> add intake to branch
----> takes intake round num and branch name
TrainingManagerFunctionality.IntakeBranch 29,'Luxor'

-- show all branchs that the intake on it
-- takes intake round number
TrainingManagerFunctionality.showIntakeBranches 29

--- check intake exists
--- takes intake round number 
TrainingManagerFunctionality.checkIntake 7

--- delete intake from branch
--- takes intake round number and branch name
TrainingManagerFunctionality.deleteIntakeFromBranches 29,'Luxor'

-------------------------------------------------------------------------------------------

---------->>> Student

--- add new Student
------ takes parameters :
-------------------> student ssn must be 14 numnber { primary key}
-------------------> full name
-------------------> address
-------------------> phone number
-------------------> intake round number
[TrainingManagerFunctionality].[Add_Student] '30001234500000','Eslam Gamal','sohag','01234567899',28

--- delete student
--- takes one parameter : ssn
[TrainingManagerFunctionality].[Delete_Student] '30001234500000'

--- update studnet
------ takes parameters :
-------------------> student ssn must be 14 numnber { primary key}
-------------------> full name
-------------------> address
-------------------> phone number
-------------------> intake round number
[TrainingManagerFunctionality].[Update_Student] '30001234500000','Eslam Gamal','ELSaaeed','01234567899',28


select * from Student
