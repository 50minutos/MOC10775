--MOSTRAR CONFIGURAÇÃO DO SQL SERVER AGENT
--SERVICES.MSC
--SQL SERVER CONFIGURATION MANAGER

--CONFIGURAR DATABASE MAIL NO DATABASE 

--CONFIGURAR O ALERT SYSTEM NO SQL SERVER AGENT PARA USAR DATABASE MAIL

EXEC MSDB..SP_SEND_DBMAIL 
	@RECIPIENTS = 'AGNALDO@50MINUTOS.COM.BR', 
	@SUBJECT = 'OPA... SEM ASSUNTO', 
	@BODY = 'CORPO DO ZEMAIL', 
	@PROFILE_NAME = 'DEFAULT'

--CRIAR UM JOB

--GERAR SCRIPT DO JOB (CÓDIGO GERADO ABAIXO!!!)

USE [msdb]
GO

/****** Object:  Job [JOB]    Script Date: 01/08/2013 15:50:53 ******/
BEGIN TRANSACTION
DECLARE @ReturnCode INT
SELECT @ReturnCode = 0
/****** Object:  JobCategory [[Uncategorized (Local)]]]    Script Date: 01/08/2013 15:50:53 ******/
IF NOT EXISTS (SELECT name FROM msdb.dbo.syscategories WHERE name=N'[Uncategorized (Local)]' AND category_class=1)
BEGIN
EXEC @ReturnCode = msdb.dbo.sp_add_category @class=N'JOB', @type=N'LOCAL', @name=N'[Uncategorized (Local)]'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

END

DECLARE @jobId BINARY(16)
EXEC @ReturnCode =  msdb.dbo.sp_add_job @job_name=N'JOB', 
		@enabled=1, 
		@notify_level_eventlog=0, 
		@notify_level_email=0, 
		@notify_level_netsend=0, 
		@notify_level_page=0, 
		@delete_level=0, 
		@description=N'No description available.', 
		@category_name=N'[Uncategorized (Local)]', 
		@owner_login_name=N'JOKER\agnaldo', @job_id = @jobId OUTPUT
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [STEP]    Script Date: 01/08/2013 15:50:54 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'STEP', 
		@step_id=1, 
		@cmdexec_success_code=0, 
		@on_success_action=1, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'EXEC XP_CREATE_SUBDIR ''C:\A\B\C\D''', 
		@database_name=N'master', 
		@flags=4
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_update_job @job_id = @jobId, @start_step_id = 1
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobschedule @job_id=@jobId, @name=N'DE HORA EM HORA', 
		@enabled=1, 
		@freq_type=4, 
		@freq_interval=1, 
		@freq_subday_type=8, 
		@freq_subday_interval=1, 
		@freq_relative_interval=0, 
		@freq_recurrence_factor=0, 
		@active_start_date=20130801, 
		@active_end_date=99991231, 
		@active_start_time=0, 
		@active_end_time=235959, 
		@schedule_uid=N'bff985b5-5288-464b-85e0-ad9c32e71a87'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobserver @job_id = @jobId, @server_name = N'(local)'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
COMMIT TRANSACTION
GOTO EndSave
QuitWithRollback:
    IF (@@TRANCOUNT > 0) ROLLBACK TRANSACTION
EndSave:

GO

SELECT GETDATE()

--MOSTRAR HISTÓRICO DA EXECUÇÃO DOS JOBS

SELECT SJ.NAME, 
	SJH.MESSAGE
FROM MSDB..SYSJOBS SJ
JOIN MSDB..SYSJOBHISTORY SJH
	ON SJ.JOB_ID = SJH.JOB_ID
WHERE SJ.NAME = 'JOB'
