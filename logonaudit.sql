select is_user_process, original_login_name, *
from sys.dm_exec_sessions
order by login_time desc

USE master
DROP TABLE LogonAudit
GO

CREATE TABLE LogonAudit
(
		ID INT PRIMARY KEY IDENTITY(1,1),
		UserName NVARCHAR(255),
		LogonTime DATETIME,
		HostName NVARCHAR(255),
		ProgramName NVARCHAR(255),
		spid INT
);
GO

CREATE TRIGGER [LogonTrigger_For_Audit2] 
ON ALL SERVER 
FOR LOGON
AS
BEGIN

	INSERT INTO master.dbo.LogonAudit (UserName,LogonTime,HostName,ProgramName,spid)
			VALUES (ORIGINAL_LOGIN(),GETDATE(),HOST_NAME(),PROGRAM_NAME(),@@SPID);

END;
