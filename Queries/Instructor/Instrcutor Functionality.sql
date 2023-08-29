use ExaminationSystem_2

go
create schema InstructorFunctionality
go
-----------------
--- Instructor user Login
--Instructor
--123456

----------------

----->>> Instructor Functionality

--->>> Question

-->>>> add new question : addQuestion takes parameters with instructor SSN and course code to check if the instructor teach this course
---------------------------------- and takes the question type and question and correct answer and four choices and if the type
----------------------------------- is not MCQ the four choice must enter four null values

-->>>> delete question : deleteQuestion takes two parameters the first is instructor SSN to ensure that instructor is exist on database
------------------------------- or he teaches the course that question belong to it,the second parameter is question id

-->>>> update table Question {question text or correct answer} : updateQuestionOrCorrectAnswer take parameters:
-------------- instructor ssn : to check that instructor exists or he is the instructor who teach the course that qs belong to it
-------------- question id number 
-------------- column that you need to update the value on it and it one of {question,correct answer}
-------------- the new value 

-->>>> update question mcq option : updateQuestionChoice takes parameters :
--- instructor ssn
--- question id to ensure that the type of it is MCQ
--- choice or char must be of {a,b,c,d}
--- new value

-->>>> show all Questions with there choices : showAllQuestionChoices take crs_code is the course code 

-----------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------
select * from Course
select * from Instructor
insert into Course
values('csh20','C Sharp','programming language',100,50,'29204372600000')
--------------------------------------------------------
--------------------------------------------------------

