use ExaminationSystem_2

begin try
	begin transaction
		insert into Question(qs_text,qs_type,correct_answer,crs_code)
			values('Which of these access specifiers must be used for main() method?','MCQ','private','csh20')

		insert into Choice 
			values('private',4,'a'),
					('public',4,'b'),
					('protected',4,'c'),
					('none of the mentioned',4,'d')
	commit
end try
begin catch
	rollback
	select ERROR_NUMBER(),ERROR_MESSAGE()
end catch

select * from Question
select * from Choice
select * from Course
where crs_code = 'csh20' and inst_SSN = 45678901234567
--c sharp csh20

select qs_text,choice,choice_num
from Question
join Choice
on Question.qs_Id = Choice.qs_Id and qs_type = 'MCQ'
order by Question.qs_Id,choice_num
-----------------------------------------------
-----------------------------------------------
begin try
	begin transaction
		delete from Choice
			where qs_Id = 5

		delete from Question
			where qs_Id = 5
	commit
end try
begin catch
	rollback
	select ERROR_NUMBER(),ERROR_MESSAGE()
end catch
-----------

select Question.*,choice,choice_num
from Question
join Choice
on Question.qs_Id = Choice.qs_Id
order by Question.qs_Id,choice_num

select *
from
	(select qs_text,Choice.choice,Choice.choice_num
	from Question
	left join Choice
	on Question.qs_Id = Choice.qs_Id) as t
PIVOT(max(choice) for choice_num in ([a],[b],[c],[d])) as PVT

-- can make the first query on table and use the pivot on the result table

-----------------
alter table Instructor
	drop constraint Instructor_PK
alter table Instructor
	alter column inst_SSN char(14)
alter table Instructor
	add constraint Instructor_PK primary key(inst_SSN)
---------------------------------------------------------------
---------------------------
alter table Track
	alter column superVisior char(14)
alter table Track----
	add constraint SuperVisior_FK foreign key(superVisior) references Instructor(inst_SSN)------
---------------------------
alter table Course
	alter column inst_SSN char(14)
alter table Course-----
	add constraint CRS_Instructor_FK foreign key (inst_SSN) references Instructor(inst_SSN)-----
----------------------
alter table Inst_Course_Exam
	drop constraint Instructor_PageExam_FK
alter table Inst_Course_Exam
	alter column inst_SSN char(14)
alter table Inst_Course_Exam-----
	add constraint Instructor_PageExam_FK foreign key (inst_SSN) references Instructor(inst_SSN)-----
--------------
alter table Track_Instructors
	drop constraint Instructor_FK
alter table Track_Instructors
	drop constraint Track_Instructors_PK
alter table Track_Instructors
	alter column inst_SSN char(14)
alter table Track_Instructors----
	add constraint Instructor_FK foreign key (inst_SSN) references Instructor(inst_SSN)
alter table Track_Instructors
	add constraint Track_Instructors_PK primary key(inst_SSN,track_code)-----
	---------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------
----> add c# mcq questions
InstructorFunctionality.addQuestion 29204372600011,'How many Bytes are stored by ‘Long’ Data type in C# .net?','MCQ','a','csh20',8,4,2,1
go
InstructorFunctionality.addQuestion 29204372600011,'“.NET class” name from which data type “UInt” is derived?','MCQ','b','csh20','System.Int16','System.UInt32','System.UInt64','System.UInt16'
go
InstructorFunctionality.addQuestion 29204372600011,'Correct Declaration of Values to variables ‘a’ and ‘b’?','MCQ','c','csh20','int a = 32, b = 40.6;','int a = 42; b = 40;','int a = 32; int b = 40;','int a = b = 42;'
go
InstructorFunctionality.addQuestion 29204372600011,'Which data type should be more preferred for storing a simple number ','MCQ','a','csh20','sbyte','short','int','long'
go
InstructorFunctionality.addQuestion 29204372600011,'Correct way to assign values to variable ‘c’ when int a=12, float b=3.5, int c;','MCQ','c','csh20','c = a + b;','c = a + int(float(b));','c = a + convert.ToInt32(b);','c = int(a + b);'
go
InstructorFunctionality.addQuestion 29204372600011,'Which of the following is used to define the member of a class externally?','MCQ','b','csh20',':','::','#','none of the mentioned'
go
InstructorFunctionality.addQuestion 29204372600011,'The operator used to access member function of a class?','MCQ','c','csh20',':','::','.','#'
go
InstructorFunctionality.addQuestion 29204372600011,'What is the most specified using class declaration?','MCQ','c','csh20','type','scope','type & scope','none of the mentioned'
go
InstructorFunctionality.addQuestion 29204372600011,'Which of the following statements about objects in “C#” is correct?','MCQ','d','csh20','Everything you use in C# is an object, including Windows Forms and controls','Objects have methods and events that allow them to perform actions','All objects created from a class will occupy equal number of bytes in memory','All of the mentioned'
go
InstructorFunctionality.addQuestion 29204372600011,'“A mechanism that binds together code and data in manipulates, and keeps both safe from outside interference and misuse. In short it isolates a particular code and data from all other codes and data. A well-defined interface controls access to that particular code and data.”','MCQ','d','csh20','Abstraction','Polymorphism','Inheritance','Encapsulation'
go
InstructorFunctionality.addQuestion 29204372600011,'The data members of a class by default are?','MCQ','c','csh20','protected, public','private, public','private','public'
go

---------------------------------
---> c# True&False questions

InstructorFunctionality.addQuestion 29204372600011,'Multiple inheritance is different from multiple levels of inheritance.','True&False','t','csh20',null,null,null,null
go
InstructorFunctionality.addQuestion 29204372600011,'An object of a derived class cannot access private members of base class.','True&False','t','csh20',null,null,null,null
go
InstructorFunctionality.addQuestion 29204372600011,'The way a derived class member function can access base class public members, the base class member functions can access public member functions of derived class.','True&False','f','csh20',null,null,null,null
go
InstructorFunctionality.addQuestion 29204372600011,'There is no private or protected inheritance in C#.NET.','True&False','t','csh20',null,null,null,null
go
InstructorFunctionality.addQuestion 29204372600011,'We can derive a class from a base class even if the base class s source code is not available.','True&False','t','csh20',null,null,null,null
go
InstructorFunctionality.addQuestion 29204372600011,'If a base class contains a member function func(), and a derived class does not contain a function with this name, an object of the derived class cannot access func().','True&False','f','csh20',null,null,null,null
go
InstructorFunctionality.addQuestion 29204372600011,'If a base class and a derived class each include a member function with the same name, the member function of the derived class will be called by an object of the derived class','True&False','t','csh20',null,null,null,null
go
InstructorFunctionality.addQuestion 29204372600011,'The size of a derived class object is equal to the sum of sizes of data members in base class and the derived class.','True&False','t','csh20',null,null,null,null
go
InstructorFunctionality.addQuestion 29204372600011,'Private members of base class cannot be accessed by derived class member functions or objects of derived class.','True&False','t','csh20',null,null,null,null
go
InstructorFunctionality.addQuestion 29204372600011,'A class D can be derived from a class C, which is derived from a class B, which is derived from a class A.','True&False','t','csh20',null,null,null,null
go

------------------------------

--------------------
