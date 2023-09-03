

-------------->>>> Backup and Auto

---->>> On SQL Server Agent
----right click and start it
-----> then on Jobs
----> right click and select New Job
----> On General Eneter the the name of Job
----> on Steps create New :
-------------->>>Enter the step name and the code to action :

BACKUP LOG ExaminationSystem_2
TO DISK = 'F:\Education\Databases\SQL Server Project\SQL_Server_Examination_System\ExaminationSystem_2_Trans_Log.trn';

----->>>onSchedules create New
------------>>>and enter the name of scheduale nad determine the Frequency of Occurs