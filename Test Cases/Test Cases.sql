use ExaminationSystem_2

-------->>>> Test Cases <<<-------------

---->>> ADD New Branchs With It's Managers

TrainingManagerFunctionality.addNewBranchWithNewManager 'Alexandria','Alexandria, Egypt','29009876500003',
			'Mohamed Ahmed','Alexandria, Egypt','01098765431'

go

TrainingManagerFunctionality.addNewBranchWithNewManager 'Luxor','Luxor, Egypt','29345678900004',
			'Aya Mahmoud','Luxor, Egypt','01567894321'

go


TrainingManagerFunctionality.addNewBranchWithNewManager 'Aswan','Aswan, Egypt','29456789000005',
			'Sara Khalid','Aswan, Egypt','01012345671'

-----------
------------

----------------->>> Add New Department

TrainingManagerFunctionality.add_Department 'Security'
go
TrainingManagerFunctionality.add_Department 'Operations'
go
TrainingManagerFunctionality.add_Department 'Artificial intelligence'

--------------

-------------------->>> ADD new Instructor

TrainingManagerFunctionality.addNewInstructor '29567890100006','Mahmoud Ahmed','Mansoura, Egypt       ','01187654321','Security','Luxor'
go
TrainingManagerFunctionality.addNewInstructor '29678901200007','Yara Ali     ','Port Said, Egypt      ','01234567891','Security','Alexandria'
go
TrainingManagerFunctionality.addNewInstructor '29789012300008','Ahmed Mohamed','Sharm El Sheikh, Egypt','01098765431','Operations','Alexandria'
go
TrainingManagerFunctionality.addNewInstructor '29890123400009','Nour Ibrahim ','Tanta, Egypt          ','01123456781','Operations','Luxor'
go
TrainingManagerFunctionality.addNewInstructor '29901234500010','Ali Hassan   ','Hurghada, Egypt       ','01234567891','Artificial intelligence','Luxor'
go
TrainingManagerFunctionality.addNewInstructor '29101234500012','Mohamed Ali  ','Alexandria, Egypt     ','01123456781','Artificial intelligence','Aswan'
go
TrainingManagerFunctionality.addNewInstructor '29009876500013','Salma Ahmed  ','Cairo, Egypt          ','01234567891','Operations','Aswan'
go

TrainingManagerFunctionality.showAllInstructors

---delete Instructor
TrainingManagerFunctionality.deleteInstructor '29009876500003'

---update Instructor
TrainingManagerFunctionality.updateInstructor 'branch name','29009876500003','Giza'

-----------

------------------------->>> Add New Course
TrainingManagerFunctionality.Display_Courses;

---add

TrainingManagerFunctionality.Add_Course 'sq405','SQL server',null,100,50,'29901234500010'
go
TrainingManagerFunctionality.Add_Course 'NT145','Network',null,100,50,'29567890100006'
go
TrainingManagerFunctionality.Add_Course 'MT202','Calculus II',null,100,50,'29101234500012'
go
TrainingManagerFunctionality.Add_Course 'CS101','Introduction to Computer Science',null,100,50,'29789012300008'
go
TrainingManagerFunctionality.Add_Course 'op123','Object oriented programming',null,100,50,'29204372600011'
go
------------------

------------------>>> Add Tracks

TrainingManagerFunctionality.Add_Track 'SE','Software Engineering','29789012300008'
go
TrainingManagerFunctionality.Add_Track 'DS','Data Science','29901234500010'
go
TrainingManagerFunctionality.Add_Track 'CC','Cloud Computing','29567890100006'
go

--->>> add courses to  track

TrainingManagerFunctionality.addCourseToTrack 'CS101','SE'
go
TrainingManagerFunctionality.addCourseToTrack 'csh20','SE'
go
TrainingManagerFunctionality.addCourseToTrack 'sq405','DS'
go
TrainingManagerFunctionality.addCourseToTrack 'op123','DS'
go
TrainingManagerFunctionality.addCourseToTrack 'NT145','CC'
go

----------------------

-------------->>> ADD Intakes
TrainingManagerFunctionality.showAllIntakes

TrainingManagerFunctionality.showIntakeBranches 8

----add
TrainingManagerFunctionality.addIntake 28,'Data Science Round 28','DS','Operations','Aswan'
go
TrainingManagerFunctionality.IntakeBranch 28,'Luxor'
go
TrainingManagerFunctionality.IntakeBranch 28,'Alexandria'

--
TrainingManagerFunctionality.showIntakeBranches 28

---
TrainingManagerFunctionality.checkIntake 7

---
TrainingManagerFunctionality.deleteIntakeFromBranches 7,'Cairo'

--------
-------------->>> Question

InstructorFunctionality.showAllQuestionChoices csh20

--add new Question
-- takes parameters : 
---------------> instructor SSN
---------------> question
---------------> question type must be of {True&False,Text,MCQ}
---------------> Correct Answer
---------------> course code { the must instructor must be teaching that course}
---------------> four choices { if True&False or Text must enter four null}
InstructorFunctionality.addQuestion '29789012300008','An object of a derived class cannot access private members of base class.',
   'True&False','True','CS101',null,null,null,null

--add c# text questions
InstructorFunctionality.addQuestion '29204372600011','What is C#?','Text',null,'csh20',null,null,null,null
go
InstructorFunctionality.addQuestion '29204372600011','What are the features of C#?','Text',null,'csh20',null,null,null,null
go
InstructorFunctionality.addQuestion '29204372600011','What is the difference between value types and reference types in C#?','Text',null,'csh20',null,null,null,null
go
InstructorFunctionality.addQuestion '29204372600011','What is the difference between a class and an object in C#?','Text',null,'csh20',null,null,null,null
go
InstructorFunctionality.addQuestion '29204372600011','How do you declare a variable in C#?','Text',null,'csh20',null,null,null,null
go
InstructorFunctionality.addQuestion '29204372600011','What are the different access modifiers in C#?','Text',null,'csh20',null,null,null,null
go
InstructorFunctionality.addQuestion '29204372600011','What is the purpose of the "using" statement in C#?','Text',null,'csh20',null,null,null,null
go
InstructorFunctionality.addQuestion '29204372600011','What is the difference between "const" and "readonly" in C#?','Text',null,'csh20',null,null,null,null
go
InstructorFunctionality.addQuestion '29204372600011','How do you handle exceptions in C#?','Text',null,'csh20',null,null,null,null
go
InstructorFunctionality.addQuestion '29204372600011','What is the difference between "==" and "equals()" in C#?','Text',null,'csh20',null,null,null,null
go

--udate question choice
-- takes instructor ssn
---,question id , char of choice 
---and the new value
InstructorFunctionality.updateQuestionChoice 45678901234567,1015,'f','Console.Int16'

---update question text or correct answer
-- takes instructor ssn,
-------- column to updae{correct answer , Question} ,
-------- new value
InstructorFunctionality.updateQuestionOrCorrectAnswer 29204372600011,1013,'correct answer','a'

---delete question
--- takes the instructor ssn and question id
InstructorFunctionality.deleteQuestion 29204372600011,1013

--

-----------------------------------------------------------------------------------------------
----============================================================================================

----->>>> To add new Exam <<< -------

---make Instructor know his courses and the codes 

InstructorFunctionality.showInstructorCourses '29204372600011'

--- make the instructor create new exam

[InstructorFunctionality].[Add_Exam] 'exm57','exam','09:00','12:00',1,'csh20','29204372600011','2023/9/2'

--update exam
InstructorFunctionality.Update_Exam 'exm57','10:00','12:00','2023/9/2'

--delete exam
InstructorFunctionality.Delete_Exam 'exm57','29204372600011'


---- make the instructor select the exam {manual or automate}

[InstructorFunctionality].[Display_Exams]

[InstructorFunctionality].[Display_Exams_Specific_Inst] '29204372600011'

----select exam manaulay question by question
InstructorFunctionality.Add_Quest_To_Papper_Exam_Manually 'exm21','29204372600011','csh20'
,21,1

---select exam auto
InstructorFunctionality.select_Question_Random 5 ,'csh20','exm21','29204372600011',20

---update exam question
InstructorFunctionality.Update_Ques_ExamPaper 'exm21','29204372600011','csh20',15,18,49

---delete question from exam
 InstructorFunctionality.Delete_Question_From_papper_Exam 'exm21',18,'29204372600011','csh20'

select ex_code , SUM(qs_dgree) from Inst_Course_Exam
group by ex_code

--------------------------------------------------
--- show exam to student
StudentFunctionality.showExamPage  'exm21'

---answer for question
exec StudentFunctionality.Student_Answer_Quest 1393,'exm21','12345678912345','t'

exec StudentFunctionality.Student_Answer_Quest 1394,'exm21','12345678912345','f'

---
StudentFunctionality.Student_Answer_Update_Quest 1393
,'exm21','12345678912345'
,'False'
----------------------------------