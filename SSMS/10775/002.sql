EXEC sys.sp_configure N'show advanced options', N'0'  

RECONFIGURE WITH OVERRIDE

ALTER SERVER CONFIGURATION 
SET PROCESS AFFINITY CPU = 0 TO 3

EXEC sys.sp_configure N'show advanced options', N'1'  

RECONFIGURE WITH OVERRIDE

EXEC sys.sp_configure N'priority boost', N'1'

EXEC sys.sp_configure N'min memory per query (KB)', N'512'

EXEC sys.sp_configure N'affinity I/O mask', N'240'

RECONFIGURE

EXEC sys.sp_configure N'show advanced options', N'0'  

RECONFIGURE WITH OVERRIDE

