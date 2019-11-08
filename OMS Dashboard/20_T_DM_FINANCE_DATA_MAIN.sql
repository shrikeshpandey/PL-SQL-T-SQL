USE [Clerk]
GO
/****** Object:  StoredProcedure [dbo].[T_DM_FINANCE_DATA_MAIN]    Script Date: 10/10/2018 10:36:12 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/***********************************************************************************
||   QUERY INFORMATION
||
||   Department:     Data Warehouse
||   Programmer:     Luis Fuentes
||   Date:           6/27/2018
||   Category:       Table
||
||   Description:    	<This sp loads data into [dbo].[DASHBOARD_FINANCE_DATA]>
||
||   Parameters:     None
||
||   Historic Info:
||    Name:           Date:        Brief Description:
||   -----------------------------------------------------------------------------
||   Luis Fuentes     7/10/2018    Initial Creation
||   -----------------------------------------------------------------------------
||
||   CURRENT REVISION STANDARD:  v1.50
||
***********************************************************************************/

ALTER PROCEDURE [dbo].[T_DM_FINANCE_DATA_MAIN]
	-- Add the parameters for the stored procedure here
AS

SET NOCOUNT ON
BEGIN
---- SET NOCOUNT ON added to prevent extra result sets from
---- interfering with SELECT statements.
---- SET NOCOUNT ON;
SET XACT_ABORT ON;
BEGIN TRY
  BEGIN TRAN
	EXEC [dbo].[T_DM_FINANCE_DATA_PART_1];
	EXEC [dbo].[T_DM_FINANCE_DATA_PART_2];
   COMMIT TRAN

END TRY
BEGIN CATCH

	INSERT INTO [dbo].[PS_LOAD_VERIFY] (
	  	[error_number],
		[error_severity],
		[error_state],
		[error_procedure],
		[error_line],
		[error_message],
		[source_type]
	)
    SELECT ERROR_NUMBER()	 AS ErrorNumber
		  ,ERROR_SEVERITY()  AS ErrorSeverity
		  ,ERROR_STATE()	 AS ErrorState
          ,ERROR_PROCEDURE() AS ErrorProcedure
          ,ERROR_LINE()      AS ErrorLine
          ,ERROR_MESSAGE()   AS ErrorMessage
		  ,'T_DM_FINANCE_DATA_MAIN' AS source_type;




END CATCH;

END
