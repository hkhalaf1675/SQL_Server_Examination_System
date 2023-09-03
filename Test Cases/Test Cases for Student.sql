use ExaminationSystem_2

---------------------------------->>> Student Functionality <<<----------------

--- show exam page
--- takes one parameter : exam code

[StudentFunctionality].[showExamPage] 'Front'

[StudentFunctionality].[showExamPage] 'xch20'

-- student answer for spacific question on exam
-- takes parameters :
---------------------> the question id on exam page
---------------------> exam code
---------------------> student ssn
---------------------> the answer of the question
[StudentFunctionality].[Student_Answer_Quest] 1478,'xch20','12345678912323','d','C#'



-- student answer for spacific question on exam
-- takes parameters :
---------------------> the question id on exam page
---------------------> exam code
---------------------> student ssn
---------------------> the new answer of the question
[StudentFunctionality].[Student_Answer_Update_Quest] 1478,'xch20','12345678912323','d'

------------------
--- show exam result for spacific exam
-- takes parameters : student ssn,and cexam code
[StudentFunctionality].[GetFinalresult_forPaper_toResultFinal] '12345678912323','xch20'

select * delete from FinalResult_StudentExam

declare @s decimal(5,2)
select @s = (8.00/10) * 100
select @s