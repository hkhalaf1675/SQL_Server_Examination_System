use ExaminationSystem_2

----------------->>> Functions
--- create function to check if there is track with that code or not
create or alter function checkTrackExists(@track_code varchar(5))
returns bit
as
begin
	declare @f bit
	if exists(select * from Track where track_code = @track_code)
		set @f = 1
	else
		set @f = 0
	return @f
end
go

-------------------------------------------------------------------------------------------
-------------------------------------  Procedure for Track  -------------------------------
-------------------------------------   crud  For Track   ---------------------------------

--------------------------------------------------------------------------------------------
-------------------------------------       Add Track       --------------------------------
--------------------------------------------------------------------------------------------

Go
create or alter proc TrainingManagerFunctionality.Add_Track(@track_code nvarchar(5)
,@track_name nvarchar(50),@superVisior char(14))as
begin
		BEGIN TRY
				IF not EXISTS (select 1 from  Track where track_code=@track_code 
				and track_name=@track_name and superVisior=@superVisior)
				and EXISTS (select 1 from  Instructor where inst_SSN=@superVisior)
					begin 
						insert into Track(track_code,track_name,superVisior)
						values(@track_code,@track_name,@superVisior)
						print 'This Track Inserted Successfully'
					end
				else
					begin
						THROW 50006,'This Track already Exists or supervisor is not found in Instructors.',16;
					end
		END TRY
		BEGIN CATCH
               PRINT('Raise the caught error again');
               --select @@error;
			   select ERROR_MESSAGE(); --- thow the exception is throwed
			   --select ERROR_SEVERITY(); --- print 16
               --select ERROR_STATE();  ---- print 16
         End CATCH
end
Go
---29009876500003

exec TrainingManagerFunctionality.Add_Track @track_code='.NetD',@track_name='DotNetDevelopment_FullStack'
,@superVisior=29009876500003


--------------------------------------------------------------------------------------------
-------------------------------------       Update Track       --------------------------------
--------------------------------------------------------------------------------------------

Go
create or alter proc TrainingManagerFunctionality.Update_Track(@Old_track_code varchar(5),@New_track_code varchar(5)
,@old_track_name nvarchar(50),@New_track_name nvarchar(50))as
begin

		BEGIN TRY
				IF EXISTS (select 1 from  Track 
				where track_code=@Old_track_code and track_name=@old_track_name)
					begin 
						update  Track
						set track_code=@New_track_code,track_name=@New_track_name
						where track_code=@Old_track_code and track_name=@old_track_name
						print 'This Track Updated Successfully'
					end
				else
					begin
						THROW 50006,'This Track Not Exists.',16;
					end
		END TRY
		BEGIN CATCH
               PRINT('Raise the caught error again');
			   select ERROR_MESSAGE(); --- thow the exception is throwed
         End CATCH
end
Go
---29009876500003
--DotNetDevelopment_FullStack
exec TrainingManagerFunctionality.Update_Track @Old_track_code='.NetD', @New_track_code='Sofwr', 
@old_track_name='DotNetDevelopment_FullStack',@New_track_name='Software Development';


--------------------------------------------------------------------------------------------
-------------------------------------       Delete Track       --------------------------------
--------------------------------------------------------------------------------------------

Go
create or alter proc TrainingManagerFunctionality.Delete_Track(@Old_track_code varchar(5))as
begin

		BEGIN TRY
				IF EXISTS (select 1 from  Track 
				where track_code=@Old_track_code)
					begin 
						delete from  Track
						where track_code=@Old_track_code
						print 'This Track Deleted Successfully'
					end
				else
					begin
						THROW 50006,'This Track Not Exists.',16;
					end
		END TRY
		BEGIN CATCH
               PRINT('Raise the caught error again');
			   select ERROR_MESSAGE(); --- thow the exception is throwed
         End CATCH
end
Go
---29009876500003
--DotNetDevelopment_FullStack
exec TrainingManagerFunctionality.Delete_Track @Old_track_code='sofwr'





--------------------------------   Procedure for display track  ----------------
Go   
 Create or ALTER PROCEDURE Display_Track
    AS
    BEGIN
        SELECT * from Track;
    END;
Go

EXEC Display_Track;

---------------------------------  end  ------------------------------

--- add instructor to the track
create or alter procedure TrainingManagerFunctionality.addInstructorToTrack @inst_SSN char(14),@track_code varchar(5)
as
begin try
	if dbo.checkInstructorExists(@inst_SSN) = 1 and dbo.checkTrackExists(@track_code) = 1
	begin
		insert into Track_Instructors values(@track_code,@inst_SSN)
	end
	else
		print 'There is no instructor with that SSN or There is no Track with that Code'
end try
begin catch
	print CONCAT(Error_NUMBER(),':',ERROR_MESSAGE())
end catch

go
TrainingManagerFunctionality.addInstructorToTrack 29678901200007,'WD'
----------------------------

--- add course to the track
create or alter procedure TrainingManagerFunctionality.addCourseToTrack @crs_code varchar(5),@track_code varchar(5)
as
begin try
	if dbo.checkCourseExists(@crs_code) = 1 and dbo.checkTrackExists(@track_code) = 1
	begin
		insert into Track_Courses values(@track_code,@crs_code)
	end
	else
		print 'There is no instructor with that SSN or There is no Track with that Code'
end try
begin catch
	print CONCAT(Error_NUMBER(),':',ERROR_MESSAGE())
end catch

go
TrainingManagerFunctionality.addCourseToTrack 'sq405','WD'