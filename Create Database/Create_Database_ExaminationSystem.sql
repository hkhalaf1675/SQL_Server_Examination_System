
-- --create the database on two filegroups and each group consists from two files
--create database ExaminationSystem_2
--on Primary
--(
--	Name = 'ExaminationSystem_2File1',
--	FileName = 'F:\Education\Databases\ExaminationSystem\ExaminationSystem_2File1.mdf'
--),
--(
--	Name = 'ExaminationFile2',
--	FileName = 'F:\Education\Databases\ExaminationSystem\ExaminationSystem_2File2.mdf'
--)
--Log ON
--(
--	Name = 'ExaminationLogFile',
--	FileName = 'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\DATA\Examination_2LogFile.ndf'
--)
------------------------------------------------------------------------------
--create the tables
use ExaminationSystem_2
go
-->>Branch Table
create table Branch
(
	branch_name nvarchar(50),--Branch_Unique_Name
	branch_address nvarchar(100) not null,
	manager_SSN char(14),--One_Manager_One_Branch
	constraint Branch_PK primary key(branch_name)
)
go
-->Department table 
create table Department
(
	dept_name nvarchar(50) not null unique,--Department_Unique_Name
	constraint Department_PK primary key(dept_name)
)
go
-->instructor table
create table Instructor
(
	inst_SSN char(14) not null,
	inst_fullname nvarchar(50) not null,
	inst_address nvarchar(100),
	inst_phone char(11),
	dept_name nvarchar(50),
	branch_name nvarchar(50),
	constraint Instructor_PK primary key(inst_SSN),
	constraint DepartMent_Instructor_FK foreign key (dept_name) references Department(dept_name)
		on delete set NULL on update cascade,
	constraint Branch_Instructor_FK foreign key (branch_name) references Branch(branch_name)
		on delete set null on update cascade,
	constraint One_Branch_Many_Instructors unique(inst_SSN,branch_name),
	constraint One_Department_Many_Instructors unique(inst_SSN,dept_name)
)

go
-->add the relation between branch and instructor(manager)
alter table Branch-----
	add constraint Manager_FK foreign key(manager_SSN) references Instructor(inst_SSN)
-----
go
--> track table
create table Track
(
	track_code varchar(5) not null,
	track_name nvarchar(50) not null,
	superVisior char(14),
	constraint Track_PK primary key(track_code),
	constraint SuperVisior_FK foreign key(superVisior) references Instructor(inst_SSN)
		on delete set null on update cascade
)
go
-->the relation between instructor and track
create table Track_Instructors
(
	track_code varchar(5) not null,
	inst_SSN char(14) not null,
	constraint Track_Instructors_PK primary key(track_code,inst_SSN),
	constraint Track_FK foreign key(track_code) references Track(track_code),
	constraint Instructor_FK foreign key(inst_SSN) references Instructor(inst_SSN)
)
go

-->Intake table

create table Intake
(
	intake_round int not null,
	intake_name nvarchar(50),
	constraint Intake_PK primary key(intake_round)
)
go
--> the relation between Branch , Department,Track , Intake
create table Br_Dept_Tr_Intake
(
	ID int identity(1,1) unique,
	branch_name nvarchar(50) not null,
	dept_name nvarchar(50) not null,
	track_code varchar(5) not null,
	intake_round int not null,
	constraint Br_Dept_Tr_Intake_PK primary key(branch_name,dept_name,track_code,intake_round),
	constraint Relation_Branch_FK foreign key(branch_name) references Branch(branch_name),
	constraint Relation_Department_FK foreign key(dept_name) references Department(dept_name),
	constraint Relation_Track_FK foreign key(track_code) references Track(track_code),
	constraint Intake_FK foreign key(intake_round) references Intake(intake_round)
)
---------------
----------------
go
--> student table
create table Student
(
	st_SSN char(14) not null,
	st_fullName nvarchar(50) not null,
	st_address nvarchar(100),
	st_phone char(14),
	intake_round int not null,
	constraint Student_PK primary key(st_SSN),
	constraint St_Intake_FK foreign key(intake_round) references Intake(intake_round)
)
go
-->Course table
create table Course
(
	crs_code varchar(5) not null,
	crs_name nvarchar(50) not null,
	crs_description nvarchar(255),
	crs_max_dgree int not null,
	crs_min_dgree int not null,
	inst_SSN char(14),
	constraint Course_PK primary key(crs_code),
	constraint CRS_Instructor_FK foreign key(inst_SSN) references Instructor(inst_SSN)
)
go
-->the relation between track and course
create table Track_Courses
(
	track_code varchar(5) not null,
	crs_code varchar(5) not null,
	constraint Track_Courses_PK primary key(track_code,crs_code),
	constraint Relation_TR_FK foreign key(track_code) references Track(track_code),
	constraint Relation_CRS_FK foreign key(crs_code) references Course(crs_code)
)
go
-->the relation between course and student
create table Student_Courses
(
	st_SSN char(14) not null,
	crs_code varchar(5) not null,
	constraint Student_Courses_PK primary key(st_SSN,crs_code),
	constraint St_Crs_Student_FK foreign key(st_SSN) references Student(st_SSN),
	constraint St_Crs_Course_FK foreign key(crs_code) references Course(crs_code)
)
go
-->question table
create table Question
(
	qs_Id int identity(1,1),
	qs_text nvarchar(255) not null,
	qs_type varchar(15) not null default('text'),
	correct_answer nvarchar(50),
	crs_code varchar(5) not null,
	inst_SSN char(14),
	constraint Question_PK primary key(qs_Id),
	constraint Quest_Crs_FK foreign key(crs_code) references Course(crs_code),
	constraint Instructor_Question_FK foreign key(inst_SSN) references Instructor(inst_SSN),
	constraint TypeCheck check (qs_type in ('text','True&False','MCQ'))
)
go
--> choice table for question that it's type Multiple Choices
create table Choice
(
	choice nvarchar(100) not null,
	qs_Id int not null,
	choice_num char(1),--a,b,c,d
	constraint Choice_PK primary key(choice,qs_Id),
	constraint Quest_Choice_FK foreign key(qs_Id) references Question(qs_Id)
)
go
-->Exam table
-----------------------year
create table Exam
(
	ex_code varchar(5) not null,
	ex_type varchar(15) not null default('exam'),
	start_time time,
	end_time time,
	total_time as cast(DateDiff(minute,start_time,end_time) as int),
	Ex_year date,
	allow_option varchar(20),
	Br_Dept_Tr_Intake_ID int,
	crs_code varchar(5) ,
	inst_SSN char(14),
	constraint Exam_PK primary key(ex_code),
	constraint Relation_table_FK foreign key(Br_Dept_Tr_Intake_ID) references Br_Dept_Tr_Intake(Id),
	constraint ExamTypeCheck check(ex_type in ('exam','corrective')),
	constraint Course_Exam_FK foreign key(crs_code) references Course(crs_code),
	constraint Instructor_Exam_FK foreign key(inst_SSN) references Instructor(inst_SSN)
)
go
-->exam page or the relation between exam and course
create table Inst_Course_Exam
(
	ex_Page_Id int identity(1,1),
	ex_code varchar(5) not null,
	inst_SSN char(14) not null,
	crs_code varchar(5) not null,
	qs_Id int not null,
	qs_dgree int not null,
	constraint Inst_Course_Exam_PK primary key(ex_Page_Id),
	constraint Exam_PageExam_FK foreign key(ex_code) references Exam(ex_code),
	constraint Instructor_PageExam_FK foreign key(inst_SSN) references Instructor(inst_SSN),
	constraint Course_PageExam_FK foreign key(crs_code) references Course(crs_code),
	constraint Quest_ExamPage_FK foreign key(qs_Id) references Question(qs_Id)
)
go
-->create the table that save the student answer
create table Student_Answers
(
	ex_Page_Id int not null,
	st_SSN char(14) not null,
	st_quest_answer nvarchar(255) not null,
	st_qs_dgree int not null,
	constraint Student_Answers_PK primary key(ex_Page_Id,st_SSN,st_quest_answer),
	constraint ExamPage_FK foreign key(ex_Page_Id) references Inst_Course_Exam(ex_Page_Id),
	constraint Student_Answer_FK foreign key(st_SSN) references Student(st_SSN)
)
alter table Student_Answers
add courseName varchar(50)
go
---->student course total results
--create table Student_Course_Result
--(
--	st_SSN char(14) not null,
--	crs_code varchar(5) not null,
--	ex_Page_Id int not null,
--	final_result float,
--	constraint Result_PK primary key(st_SSN,crs_code,ex_Page_Id),
--	constraint Student_Result_FK foreign key(st_SSN) references Student(st_SSN),
--	constraint Course_Result_FK foreign key(crs_code) references Course(crs_code),
--	constraint ExamPage_Result_FK foreign key(ex_Page_Id) references Inst_Course_Exam(ex_Page_Id)
--)

---->>> Table to student exams result
create table FinalResult_StudentExam(
	ex_code varchar(5),
	crs_code varchar(5),
	st_SSN char(14),
	finalDegree int,
	GPA char(1),
	constraint FinalResult_PK primary key(ex_code,crs_code,st_SSN),
	constraint Result_Exam_FK foreign key(ex_code) references Exam(ex_code)
		on delete cascade on update cascade,
	constraint Result_Course_FK foreign key(crs_code) references Course(crs_code)
		on delete cascade on update cascade,
	constraint Result_Student_FK foreign key(st_SSN) references Student(st_SSN)
		on delete cascade on update cascade
);
---------------------------------
--->insert data from csv files using bulk
--bulk insert Question
--from 'F:\Education\Databases\ExaminationSystem\C#_Questions - Sheet1.csv'
--with (format = 'csv')
