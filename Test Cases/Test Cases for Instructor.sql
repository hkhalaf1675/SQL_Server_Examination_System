use ExaminationSystem_2

---========================>>> Instructor Functionality <<< -------------------------------

------------->>> Question

--show all questions belongs to course
-- takes course code as a parameter
InstructorFunctionality.showAllQuestionChoices csh20

--add new Question
-- takes parameters : 
---------------> instructor SSN
---------------> question
---------------> question type must be of {True&False,Text,MCQ}
---------------> Correct Answer
---------------> course code { the must instructor must be teaching that course}
---------------> four choices { if True&False or Text must enter four null}
InstructorFunctionality.addQuestion '29204372600011','An object of a derived class cannot access private members of base class.',
   'True&False','True','csh20',null,null,null,null

   --udate question choice
-- takes instructor ssn
---,question id , char of choice 
---and the new value
InstructorFunctionality.updateQuestionChoice '29204372600011',10,'a','--'

---update question text or correct answer
-- takes instructor ssn,
-------- column to updae{correct answer , Question} ,
-------- new value
InstructorFunctionality.updateQuestionOrCorrectAnswer '29204372600011',46,'correct answer','true'

---delete question
--- takes the instructor ssn and question id
InstructorFunctionality.deleteQuestion 29204372600011,46

------------->>> Show Instructor Courses
--- take one parameter : instrcutor ssn
InstructorFunctionality.showInstructorCourses 29204372600011

--------------------------------------------------------------------------------------------------

------------------->>> Exam 

-- show instructor exams 
-- takes one parameter : instructor ssn
InstructorFunctionality.ShowInstructorExams '29204372600011'

--add new exam
-- takes parameters : 
-------------------> exam code
-------------------> exam type {exam or corrective}
-------------------> start time 
-------------------> end time 
-------------------> the id of relation between intake and branch
-------------------> course code
-------------------> instructor ssn
-------------------> the year of exam
[InstructorFunctionality].[Add_Exam] 'xch20','exam','12:00','16:00',1,'csh20','29204372600011','2023/9/4'

--update exam
-- takes parameters : 
-------------------> exam code
-------------------> start time 
-------------------> end time 
-------------------> the year of exam
InstructorFunctionality.Update_Exam 'xmxh5','12:15','15:30','2023/9/4'

--delete exam
-- takes parameters : 
-------------------> exam code
-------------------> instructor ssn
InstructorFunctionality.Delete_Exam 'exm55','29204372600011'

-----------------------------

-- show exam questions:
-- take one parameter : exam code
InstructorFunctionality.showExamPage 'xch20'

-- add exam manaully
-- takes parameters : 
-------------------> exam code
-------------------> instructor ssn
-------------------> course code
-------------------> id of question
-------------------> the dgree of the question
[InstructorFunctionality].[Add_Quest_To_Papper_Exam_Manually] 'xmxh5','29204372600011','csh20',14,14

-- add auto exam
-- takes parameters : 
-------------------> number of questions
-------------------> course code
-------------------> exam code
-------------------> instructor ssn
-------------------> the dgree for each question
[InstructorFunctionality].[select_Question_Random] 10,'csh20','Front','29204372600011',10

-- update the exam questions
-- takes parameters : 
-------------------> exam code
-------------------> instructor ssn
-------------------> course code
-------------------> the question id need t update it
-------------------> the new question id
-------------------> the dgree of the question
[InstructorFunctionality].[Update_Ques_ExamPaper] 'exm21','29204372600011','csh20',14,13,14

--- delete question from exam
-- takes parameters : 
-------------------> exam code
-------------------> the question id need t delete it
-------------------> instructor ssn
-------------------> course code
exec InstructorFunctionality.Delete_Question_From_papper_Exam @examCode='exm21'
,@QuesId=13,@instSNN='29204372600011',@corseCode='csh20'

--------------------

-- show all student result on spacific exam
-- takes two parametes ,exam code and instructor code
InstructorFunctionality.showStudentResults 'exm21','29204372600011'






