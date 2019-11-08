/***********************************************************************************
||   QUERY INFORMATION
||
||   Department:     Data Warehouse
||   Programmer:     Luis Fuentes
||   Date:           6/27/2018
||   Category:       Table
||
||   Description:    	<This sp loads data into [dbo].[DASHBOARD_OMS]>
||
||   Parameters:     None
||
||   Historic Info:
||    Name:           Date:        Brief Description:
||   -----------------------------------------------------------------------------
||   Luis Fuentes     6/27/2018    Initial Creation
||   Luis Fuentes     9/13/2018    Adding OT_COSTS
||   Luis Fuentes     10/5/2018    Changing gg.Group_Name AS Account and adding BILLED_OT
||   -----------------------------------------------------------------------------
||
||   CURRENT REVISION STANDARD:  v1.50
||
***********************************************************************************/
USE [Clerk]
GO
/****** Object:  StoredProcedure [dbo].[T_DM_FINANCE_DATA_PART_1]    Script Date: 10/10/2018 10:34:47 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
ALTER PROCEDURE [dbo].[T_DM_FINANCE_DATA_PART_1]
	-- Add the parameters for the stored procedure here
AS
BEGIN
---- SET NOCOUNT ON added to prevent extra result sets from
---- interfering with SELECT statements.
---- SET NOCOUNT ON;
SET XACT_ABORT ON;


BEGIN TRY
BEGIN TRAN
	--Get last day loaded
	--DECLARE @lastDate AS DATETIME = CONVERT(VARCHAR,CAST((SELECT MAX([PERIOD]) FROM [Clerk].[dbo].[DASHBOARD_FINANCE_DATA] WHERE [SOURCE_TYPE] = 'FINANCE_DATA_PART_1') AS DATE));
	DECLARE @lastDate AS DATETIME = DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE())-1, 0)

	--Delete from table
	DELETE [Clerk].[dbo].[DASHBOARD_FINANCE_DATA]
	WHERE [PERIOD] = @lastDate AND [SOURCE_TYPE] = 'FINANCE_DATA_PART_1';

	INSERT INTO [Clerk].[dbo].[DASHBOARD_FINANCE_DATA] (
		[SOURCE_TYPE],
		[DASHBOARD],
		[DIVISION],
		[DIRECTOR],
		[ACCOUNT],
		[PERIOD],
		[TOTAL_REVENUE],
		[MS_REVENUE],
		[SA_REVENUE],
		[TOTAL_COGS],
		[MS_COGS],
		[MS_COGS_ADJ],
		[MS_COGS_LABOR],
		[SA_COGS],
		[SA_COGS_ADJ],
		[TOTAL_GM],
		[SUBCONTRACTOR_EXP],
		[SUBCONTRACTOR_EXP_ADJ],
		[MS_SUBCONTRACTOR_EXP],
		[SA_SUBCONTRACTOR_EXP],
		[SA_SUBCONTRACTOR_EXP_ADJ],
		[NET_ALLOCATIONS_EXP],
		[TEMPORARY_EXP],
		[DIRECT_LABOR_COMPENSATION],
		[DIRECT_LABOR_TRAVEL_ENTER],
		[MS_DIRECT_LABOR_TRAVEL_ENTER],
		[SA_DIRECT_LABOR_TRAVEL_ENTER],
		[ANNUITY_REV],
		[PROJ_REV],
		[PART_SALES_REV],
		[FREIGHT_REV],
		[ANNUITY_EXP],
		[ANNUITY_TEMP_EXP],
		[PARTS_EXP],
		[FREIGHT_EXP],
		[MS_PARTS_FREIGHT_COSTS],
		[MS_PARTS_FREIGHT_COSTS_ADJ],
		[SA_PARTS_FREIGHT_COSTS],
		[DISPATCH_COSTS],
		[DISPATCH_COSTS_ADJ],
		[MS_DISPATCH_COSTS],
		[MS_DISPATCH_COSTS_ADJ],
		[SA_DISPATCH_COSTS],
		[ONSITE_LABOR_COSTS],
		[MS_ONSITE_LABOR_COSTS],
		[SA_ONSITE_LABOR_COSTS],
		[OTHER_COSTS],
		[MS_OTHER_COSTS],
		[SA_OTHER_COSTS],
		[ITO_COSTS],
		[OPEX_EXP],
		[PL_HC],
		[WD_MS_DAYS],
		[WD_SA_DAYS],
		[WD_FIN_DAYS],
		[FG_MS_DAYS],
		[FG_SA_DAYS],
		[FG_FIN_DAYS],
		[PAID],
		[OT],
		[FIELD_ANNUITY_CASES],
		[FIELD_ANNUITY_HOURS],
		[FIELD_PROJ_CASES],
		[FIELD_PROJ_HOURS],
		[FIELD_IMAC_CASES],
		[FIELD_IMAC_HOURS],
		[HC_MS_SDM],
		[HC_SA_SDM],
		[HC_MS_Tech],
		[HC_SA_Tech],
		[HC_MS_1_5_Desk],
		[HC_SA_1_5_Desk],
		[HC_MS_Solution_Cafe],
		[HC_SA_Solution_Cafe],
		[HC_MS_Temps],
		[HC_MS_Annuity_Temps],
		[HC_MS_Proj_Temps],
		[HC_SA_Temps],
		[HC_SA_Annuity_Temps],
		[HC_SA_Proj_Temps],
		[HC_MS_Other],
		[HC_SA_Other],
		[Laptops],
		[Desktops],
		[Mobile_Devices_Phones],
		[Mobile_Devices_Tablets],
		[Thin_clients],
		[Printers],
		[Managed_Printers],
		[Tk_MS_Annuity],
		[Tk_SA_Annuity],
		[Tk_MS_IMAC],
		[Tk_SA_IMAC],
		[Tk_MS_Project],
		[Tk_SA_Project],
		[Tk_MS_Solution_Cafe],
		[Tk_SA_Solution_Cafe],
		[Tk_Laptops],
		[Tk_Desktops],
		[Tk_Mobile_Device_Phones],
		[Tk_Mobile_Devices_Tablets],
		[Tk_Thin_Clients],
		[TK_Printers_Mgd_Printers],
		[TK_Monitors],
		[Tk_Misc_HW],
		[TS_HC_TECH],
		[TS_MS_TECH],
		[TS_SA_TECH],
		[TS_NO_TYPE_TECH],
		[TS_MS_1_5],
		[TS_SA_1_5],
		[TS_NO_TYPE_1_5],
		[TS_MS_CAFE],
		[TS_SA_CAFE],
		[TS_NO_TYPE_CAFE],
		[TS_MS_NO_ROLE],
		[TS_SA_NO_ROLE],
		[TS_NO_TYPE_NO_ROLE],
		[TS_Activities],
		[TS_Resumes],
		[TS_Days],
		[TS_TechDays],
		[TS_WD_FG_Days],
		--BEGING 9/13/2018
		[OT_COSTS],
		--END 9/13/2018
		--BEGING 10/5/2018
		[BILLED_OT]
		--END 10/5/2018
	)


SELECT  T.SOURCE_TYPE AS SOURCE_TYPE,
				T.DASHBOARD AS DASHBOARD,
				T.DIVISION AS DIVISION,
				T.DIRECTOR AS DIRECTOR,
				T.ACCOUNT AS ACCOUNT,
				T.PERIOD AS PERIOD,
				SUM(T.TOTAL_REVENUE) AS TOTAL_REVENUE,
				SUM(T.MS_REVENUE) AS MS_REVENUE,
				SUM(T.SA_REVENUE) AS SA_REVENUE,
				SUM(T.TOTAL_COGS) AS TOTAL_COGS,
				SUM(T.MS_COGS) AS MS_COGS,
				SUM(T.MS_COGS_ADJ) AS MS_COGS_ADJ,
				SUM(T.MS_COGS_LABOR) AS MS_COGS_LABOR,
				SUM(T.SA_COGS) AS SA_COGS,
				SUM(T.SA_COGS_ADJ) AS SA_COGS_ADJ,
				SUM(T.TOTAL_GM) AS TOTAL_GM,
				SUM(T.SUBCONTRACTOR_EXP) AS SUBCONTRACTOR_EXP,
				SUM(T.SUBCONTRACTOR_EXP_ADJ) AS SUBCONTRACTOR_EXP_ADJ,
				SUM(T.MS_SUBCONTRACTOR_EXP) AS MS_SUBCONTRACTOR_EXP,
				SUM(T.SA_SUBCONTRACTOR_EXP) AS SA_SUBCONTRACTOR_EXP,
				SUM(T.SA_SUBCONTRACTOR_EXP_ADJ) AS SA_SUBCONTRACTOR_EXP_ADJ,
				SUM(T.NET_ALLOCATIONS_EXP) AS NET_ALLOCATIONS_EXP,
				SUM(T.TEMPORARY_EXP) AS TEMPORARY_EXP,
				SUM(T.DIRECT_LABOR_COMPENSATION) AS DIRECT_LABOR_COMPENSATION,
				SUM(T.DIRECT_LABOR_TRAVEL_ENTER) AS DIRECT_LABOR_TRAVEL_ENTER,
				SUM(T.MS_DIRECT_LABOR_TRAVEL_ENTER) AS MS_DIRECT_LABOR_TRAVEL_ENTER,
				SUM(T.SA_DIRECT_LABOR_TRAVEL_ENTER) AS SA_DIRECT_LABOR_TRAVEL_ENTER,
				SUM(T.ANNUITY_REV) AS ANNUITY_REV,
				SUM(T.PROJ_REV) AS PROJ_REV,
				SUM(T.PART_SALES_REV) AS PART_SALES_REV,
				SUM(T.FREIGHT_REV) AS FREIGHT_REV,
				SUM(T.ANNUITY_EXP) AS ANNUITY_EXP,
				SUM(T.ANNUITY_TEMP_EXP) AS ANNUITY_TEMP_EXP,
				SUM(T.PARTS_EXP) AS PARTS_EXP,
				SUM(T.FREIGHT_EXP) AS FREIGHT_EXP,
				SUM(T.MS_PARTS_FREIGHT_COSTS) AS MS_PARTS_FREIGHT_COSTS,
				SUM(T.MS_PARTS_FREIGHT_COSTS_ADJ) AS MS_PARTS_FREIGHT_COSTS_ADJ,
				SUM(T.SA_PARTS_FREIGHT_COSTS) AS SA_PARTS_FREIGHT_COSTS,
				SUM(T.DISPATCH_COSTS) AS DISPATCH_COSTS,
				SUM(T.DISPATCH_COSTS_ADJ) AS DISPATCH_COSTS_ADJ,
				SUM(T.MS_DISPATCH_COSTS) AS MS_DISPATCH_COSTS,
				SUM(T.MS_DISPATCH_COSTS_ADJ) AS MS_DISPATCH_COSTS_ADJ,
				SUM(T.SA_DISPATCH_COSTS) AS SA_DISPATCH_COSTS,
				SUM(T.ONSITE_LABOR_COSTS) AS ONSITE_LABOR_COSTS,
				SUM(T.MS_ONSITE_LABOR_COSTS) AS MS_ONSITE_LABOR_COSTS,
				SUM(T.SA_ONSITE_LABOR_COSTS) AS SA_ONSITE_LABOR_COSTS,
				SUM(T.OTHER_COSTS) AS OTHER_COSTS,
				SUM(T.MS_OTHER_COSTS) AS MS_OTHER_COSTS,
				SUM(T.SA_OTHER_COSTS) AS SA_OTHER_COSTS,
				SUM(T.ITO_COSTS) AS ITO_COSTS,
				SUM(T.OPEX_EXP) AS OPEX_EXP,
				SUM(T.PL_HC) AS PL_HC,
				SUM(T.WD_MS_DAYS) AS WD_MS_DAYS,
				SUM(T.WD_SA_DAYS) AS WD_SA_DAYS,
				SUM(T.WD_FIN_DAYS) AS WD_FIN_DAYS,
				SUM(T.FG_MS_DAYS) AS FG_MS_DAYS,
				SUM(T.FG_SA_DAYS) AS FG_SA_DAYS,
				SUM(T.FG_FIN_DAYS) AS FG_FIN_DAYS,
				SUM(T.PAID) AS PAID,
				SUM(T.OT) AS OT,
				SUM(T.FIELD_ANNUITY_CASES) AS FIELD_ANNUITY_CASES,
				SUM(T.FIELD_ANNUITY_HOURS) AS FIELD_ANNUITY_HOURS,
				SUM(T.FIELD_PROJ_CASES) AS FIELD_PROJ_CASES,
				SUM(T.FIELD_PROJ_HOURS) AS FIELD_PROJ_HOURS,
				SUM(T.FIELD_IMAC_CASES) AS FIELD_IMAC_CASES,
				SUM(T.FIELD_IMAC_HOURS) AS FIELD_IMAC_HOURS,
				SUM(T.HC_MS_SDM) AS HC_MS_SDM,
				SUM(T.HC_SA_SDM) AS HC_SA_SDM,
				SUM(T.HC_MS_Tech) AS HC_MS_Tech,
				SUM(T.HC_SA_Tech) AS HC_SA_Tech,
				SUM(T.HC_MS_1_5_Desk) AS HC_MS_1_5_Desk,
				SUM(T.HC_SA_1_5_Desk) AS HC_SA_1_5_Desk,
				SUM(T.HC_MS_Solution_Cafe) AS HC_MS_Solution_Cafe,
				SUM(T.HC_SA_Solution_Cafe) AS HC_SA_Solution_Cafe,
				SUM(T.HC_MS_Temps) AS HC_MS_Temps,
				SUM(T.HC_MS_Annuity_Temps) AS HC_MS_Annuity_Temps,
				SUM(T.HC_MS_Proj_Temps) AS HC_MS_Proj_Temps,
				SUM(T.HC_SA_Temps) AS HC_SA_Temps,
				SUM(T.HC_SA_Annuity_Temps) AS HC_SA_Annuity_Temps,
				SUM(T.HC_SA_Proj_Temps) AS HC_SA_Proj_Temps,
				SUM(T.HC_MS_Other) AS HC_MS_Other,
				SUM(T.HC_SA_Other) AS HC_SA_Other,
				SUM(T.Laptops) AS Laptops,
				SUM(T.Desktops) AS Desktops,
				SUM(T.Mobile_Devices_Phones) AS Mobile_Devices_Phones,
				SUM(T.Mobile_Devices_Tablets) AS Mobile_Devices_Tablets,
				SUM(T.Thin_clients) AS Thin_clients,
				SUM(T.Printers) AS Printers,
				SUM(T.Managed_Printers) AS Managed_Printers,
				SUM(T.Tk_MS_Annuity) AS Tk_MS_Annuity,
				SUM(T.Tk_SA_Annuity) AS Tk_SA_Annuity,
				SUM(T.Tk_MS_IMAC) AS Tk_MS_IMAC,
				SUM(T.Tk_SA_IMAC) AS Tk_SA_IMAC,
				SUM(T.Tk_MS_Project) AS Tk_MS_Project,
				SUM(T.Tk_SA_Project) AS Tk_SA_Project,
				SUM(T.Tk_MS_Solution_Cafe) AS Tk_MS_Solution_Cafe,
				SUM(T.Tk_SA_Solution_Cafe) AS Tk_SA_Solution_Cafe,
				SUM(T.Tk_Laptops) AS Tk_Laptops,
				SUM(T.Tk_Desktops) AS Tk_Desktops,
				SUM(T.Tk_Mobile_Device_Phones) AS Tk_Mobile_Device_Phones,
				SUM(T.Tk_Mobile_Devices_Tablets) AS Tk_Mobile_Devices_Tablets,
				SUM(T.Tk_Thin_Clients) AS Tk_Thin_Clients,
				SUM(T.TK_Printers_Mgd_Printers) AS TK_Printers_Mgd_Printers,
				SUM(T.TK_Monitors) AS TK_Monitors,
				SUM(T.Tk_Misc_HW) AS Tk_Misc_HW,
				SUM(T.TS_HC_TECH) AS TS_HC_TECH,
				SUM(T.TS_MS_TECH) AS TS_MS_TECH,
				SUM(T.TS_SA_TECH) AS TS_SA_TECH,
				SUM(T.TS_NO_TYPE_TECH) AS TS_NO_TYPE_TECH,
				SUM(T.TS_MS_1_5) AS TS_MS_1_5,
				SUM(T.TS_SA_1_5) AS TS_SA_1_5,
				SUM(T.TS_NO_TYPE_1_5) AS TS_NO_TYPE_1_5,
				SUM(T.TS_MS_CAFE) AS TS_MS_CAFE,
				SUM(T.TS_SA_CAFE) AS TS_SA_CAFE,
				SUM(T.TS_NO_TYPE_CAFE) AS TS_NO_TYPE_CAFE,
				SUM(T.TS_MS_NO_ROLE) AS TS_MS_NO_ROLE,
				SUM(T.TS_SA_NO_ROLE) AS TS_SA_NO_ROLE,
				SUM(T.TS_NO_TYPE_NO_ROLE) AS TS_NO_TYPE_NO_ROLE,
				SUM(T.TS_Activities) AS TS_Activities,
				SUM(T.TS_Resumes) AS TS_Resumes,
				SUM(T.TS_Days) AS TS_Days,
				SUM(T.TS_TechDays) AS TS_TechDays,
				SUM(T.TS_WD_FG_Days) AS TS_WD_FG_Days,
				SUM(T.OT_COSTS) AS OT_COSTS,
				SUM(T.BILLED_OT) AS BILLED_OT
FROM (
	SELECT 'FINANCE_DATA_PART_1' AS  SOURCE_TYPE,
				CASE WHEN DW.DASHBOARD IS NULL THEN 'OTHER' ELSE DW.DASHBOARD END AS DASHBOARD,
				CASE WHEN DW.DIVISION IS NULL THEN 'OTHER' ELSE DW.DIVISION END AS DIVISION,
				CASE WHEN DW.DIRECTOR IS NULL THEN 'OTHER' ELSE DW.DIRECTOR END AS DIRECTOR,
				CASE WHEN DW.ACCOUNT IS NULL THEN 'OTHER' ELSE DW.ACCOUNT END AS ACCOUNT,
			  CASE WHEN DW.PERIOD IS NULL THEN CONVERT(DATETIME, CONVERT(DATE, GETDATE())) ELSE DW.PERIOD END AS PERIOD,
				TOTAL_REVENUE,
				MS_REVENUE,
				SA_REVENUE,
				TOTAL_COGS,
				MS_COGS,
				MS_COGS_ADJ,
				MS_COGS_LABOR,
				SA_COGS,
				SA_COGS_ADJ,
				TOTAL_GM,
				SUBCONTRACTOR_EXP,
				SUBCONTRACTOR_EXP_ADJ,
				MS_SUBCONTRACTOR_EXP,
				SA_SUBCONTRACTOR_EXP,
				SA_SUBCONTRACTOR_EXP_ADJ,
				NET_ALLOCATIONS_EXP,
				TEMPORARY_EXP,
				DIRECT_LABOR_COMPENSATION,
				DIRECT_LABOR_TRAVEL_ENTER,
				MS_DIRECT_LABOR_TRAVEL_ENTER,
				SA_DIRECT_LABOR_TRAVEL_ENTER,
				ANNUITY_REV,
				PROJ_REV,
				PART_SALES_REV,
				FREIGHT_REV,
				ANNUITY_EXP,
				ANNUITY_TEMP_EXP,
				PARTS_EXP,
				FREIGHT_EXP,
				MS_PARTS_FREIGHT_COSTS,
				MS_PARTS_FREIGHT_COSTS_ADJ,
				SA_PARTS_FREIGHT_COSTS,
				DISPATCH_COSTS,
				DISPATCH_COSTS_ADJ,
				MS_DISPATCH_COSTS,
				MS_DISPATCH_COSTS_ADJ,
				SA_DISPATCH_COSTS,
				ONSITE_LABOR_COSTS,
				MS_ONSITE_LABOR_COSTS,
				SA_ONSITE_LABOR_COSTS,
				OTHER_COSTS,
				MS_OTHER_COSTS,
				SA_OTHER_COSTS,
				ITO_COSTS,
				OPEX_EXP,
				PL_HC,
				WD_MS_DAYS,
				WD_SA_DAYS,
				WD_FIN_DAYS,
				FG_MS_DAYS,
				FG_SA_DAYS,
				FG_FIN_DAYS,
				PAID,
				OT,
				FIELD_ANNUITY_CASES,
				FIELD_ANNUITY_HOURS,
				FIELD_PROJ_CASES,
				FIELD_PROJ_HOURS,
				FIELD_IMAC_CASES,
				FIELD_IMAC_HOURS,
				HC_MS_SDM,
				HC_SA_SDM,
				HC_MS_Tech,
				HC_SA_Tech,
				HC_MS_1_5_Desk,
				HC_SA_1_5_Desk,
				HC_MS_Solution_Cafe,
				HC_SA_Solution_Cafe,
				HC_MS_Temps,
				HC_MS_Annuity_Temps,
				HC_MS_Proj_Temps,
				HC_SA_Temps,
				HC_SA_Annuity_Temps,
				HC_SA_Proj_Temps,
				HC_MS_Other,
				HC_SA_Other,
				Laptops,
				Desktops,
				Mobile_Devices_Phones,
				Mobile_Devices_Tablets,
				Thin_clients,
				Printers,
				Managed_Printers,
				Tk_MS_Annuity,
				Tk_SA_Annuity,
				Tk_MS_IMAC,
				Tk_SA_IMAC,
				Tk_MS_Project,
				Tk_SA_Project,
				Tk_MS_Solution_Cafe,
				Tk_SA_Solution_Cafe,
				Tk_Laptops,
				Tk_Desktops,
				Tk_Mobile_Device_Phones,
				Tk_Mobile_Devices_Tablets,
				Tk_Thin_Clients,
				TK_Printers_Mgd_Printers,
				TK_Monitors,
				Tk_Misc_HW,
				TS_HC_TECH,
				TS_MS_TECH,
				TS_SA_TECH,
				TS_NO_TYPE_TECH,
				TS_MS_1_5,
				TS_SA_1_5,
				TS_NO_TYPE_1_5,
				TS_MS_CAFE,
				TS_SA_CAFE,
				TS_NO_TYPE_CAFE,
				TS_MS_NO_ROLE,
				TS_SA_NO_ROLE,
				TS_NO_TYPE_NO_ROLE,
				TS_Activities,
				TS_Resumes,
				TS_Days,
				TS_TechDays,
				TS_WD_FG_Days,
				--BEGING 9/13/2018
				OT_COSTS,
				--END 9/13/2018
				--BEGING 10/5/2018
				BILLED_OT
				--END 10/5/2018

	FROM
	(
		SELECT  --BEGING 10/5/2018
						gg.Group_Name AS Account,
						--END 10/5/2018
						DASHBOARD,
						-- Canada exclude accounts
						CASE
						 WHEN DIVISION = 'Canada OMS' AND gg.group_name NOT IN
						(
							SELECT g.group_name
							FROM service_areas a
						  INNER JOIN geo_groups g
							 ON a.id = g.service_area_id
							where a.SERVICE_AREA = 'Canada OMS'
						) THEN 'Other'
						 WHEN gg.group_name = 'SC-USA' THEN 'Managed Services'
						 ELSE DIVISION
						END AS DIVISION,
						DIRECTOR,
						PERIOD,
						sum("Total Revenue") as  Total_Revenue,
						sum("MS Revenue") as  MS_Revenue,
						sum("SA Revenue") as  SA_Revenue,
						sum("Total COGS") as  Total_COGS,
						sum("MS COGS") as  MS_COGS,
						sum("MS COGS Adj") as  MS_COGS_Adj,
						sum("MS COGS LABOR") as  MS_COGS_LABOR,
						sum("SA COGS") as  SA_COGS,
						sum("SA COGS Adj") as  SA_COGS_Adj,
						sum("Total GM") as  Total_GM,
						sum("Subcontractor Exp") as  Subcontractor_Exp,
						sum("Subcontractor Exp Adj") as  Subcontractor_Exp_Adj,
						sum("MS Subcontractor Exp") as  MS_Subcontractor_Exp,
						sum("SA Subcontractor Exp") as  SA_Subcontractor_Exp,
						sum("SA Subcontractor Exp Adj") as  SA_Subcontractor_Exp_Adj,
						sum("Net Allocations Exp") as  Net_Allocations_Exp,
						sum("Temporary Exp") as  Temporary_Exp,
						sum("Direct Labor-Compensation") as  Direct_Labor_Compensation,
						sum("Direct Labor-Travel/Enter") as  Direct_Labor_Travel_Enter,
						sum("MS Direct Labor-Travel/Enter") as  MS_Direct_Labor_Travel_Enter,
						sum("SA Direct Labor-Travel/Enter") as  SA_Direct_Labor_Travel_Enter,
						sum("Annuity Rev") as  Annuity_Rev,
						sum("Proj Rev") as  Proj_Rev,
						sum("Part Sales Rev") as  Part_Sales_Rev,
						sum("Freight Rev") as  Freight_Rev,
						sum("Annuity Exp") as  Annuity_Exp,
						sum("Annuity Temp Exp") as  Annuity_Temp_Exp,
						sum("Parts Exp") as  Parts_Exp,
						sum("Freight Exp") as  Freight_Exp,
						sum("MS Parts & Freight Costs") as  MS_Parts_Freight_Costs,
						sum("MS Parts & Freight Costs Adj") as  MS_Parts_Freight_Costs_Adj,
						sum("SA Parts & Freight Costs") as  SA_Parts_Freight_Costs,
						sum("Dispatch Costs") as  Dispatch_Costs,
						sum("Dispatch Costs Adj") as  Dispatch_Costs_Adj,
						sum("MS Dispatch Costs") as  MS_Dispatch_Costs,
						sum("MS Dispatch Costs Adj") as  MS_Dispatch_Costs_Adj,
						sum("SA Dispatch Costs") as  SA_Dispatch_Costs,
						sum("Onsite Labor Costs") as  Onsite_Labor_Costs,
						sum("MS Onsite Labor Costs") as  MS_Onsite_Labor_Costs,
						sum("SA Onsite Labor Costs") as  SA_Onsite_Labor_Costs,
						sum("Other Costs") as  Other_Costs,
						sum("MS Other Costs") as  MS_Other_Costs,
						sum("SA Other Costs") as  SA_Other_Costs,
						sum("ITO Costs") as  ITO_Costs,
						sum("OPEX Exp") as  OPEX_Exp,
						sum(PL_HC) as  PL_HC,
						sum(WD_MS_DAYS) as  WD_MS_DAYS,
						sum(WD_SA_DAYS) as  WD_SA_DAYS,
						sum(WD_FIN_DAYS) as  WD_FIN_DAYS,
						sum(FG_MS_DAYS) as  FG_MS_DAYS,
						sum(FG_SA_DAYS) as  FG_SA_DAYS,
						sum(FG_FIN_DAYS) as  FG_FIN_DAYS,
						sum(PAID) as PAID,
						sum(OT) as OT,
						SUM(isnull(FIELD_ANNUITY_CASES,0)) as FIELD_ANNUITY_CASES,
						SUM(isnull(FIELD_ANNUITY_HOURS,0)) as FIELD_ANNUITY_HOURS,
						SUM(isnull(FIELD_PROJ_CASES,0)) as FIELD_PROJ_CASES,
						SUM(isnull(FIELD_PROJ_HOURS,0)) as FIELD_PROJ_HOURS,
						SUM(isnull(FIELD_IMAC_CASES,0)) as FIELD_IMAC_CASES,
						SUM(isnull(FIELD_IMAC_HOURS,0)) as FIELD_IMAC_HOURS,
						--BEGING 9/13/2018
						SUM(isnull(OT_COSTS,0)) as OT_COSTS,
						--END 9/13/2018
						--BEGING 10/5/2018
					  SUM(isnull(BILLED_OT,0)) as BILLED_OT
					  --END 10/5/2018
		FROM
		(
			SELECT g.group_name, geos.geo
			FROM dbo.geo_groups g
		  INNER JOIN dbo.geos
			 ON geos.geo_group_id = g.id
		) gg
		--BEGING 10/5/2018
		INNER JOIN
		--END 10/5/2018
		(
			SELECT PL.*, WD_MS_DAYS, WD_SA_DAYS, WD_FIN_DAYS, FG_MS_DAYS, FG_SA_DAYS, FG_FIN_DAYS, PAID, OT, FIELD_ANNUITY_CASES, FIELD_ANNUITY_HOURS, FIELD_PROJ_CASES, FIELD_PROJ_HOURS, FIELD_IMAC_CASES, FIELD_IMAC_HOURS
			--BEGING 10/5/2018
			,BILLED_OT
			--END 10/5/2018
			FROM (
						 SELECT Period,
			 	 	 					CASE
										 WHEN Region LIKE '%Faustini%' THEN 'OMS'
										 WHEN Region = 'Kelly Kelly' THEN 'DFS' ELSE 'ERROR'
										END AS Dashboard,
										Division,
										Geo,
										"Geo Desc",
										Director,
										-sum(f_je_l_Income) as "Total Revenue",
										-sum(case when F_GLCC_CC = '5364' then f_je_l_Income else 0 end ) as "MS Revenue",
										-sum(case when F_GLCC_CC = '5363'   then f_je_l_Income else 0 end ) as "SA Revenue",
										sum(f_je_l_Expense) as "Total COGS",
										sum(case when  F_GLCC_CC = '5364' then f_je_l_Expense else 0 end) as "MS COGS",
										sum (case when Division = 'Canada OMS' and F_GLCC_CC = '5364' and f_glcc_acct in (
											'625002001132', /* Field Service Allocation */
											'622002001820', /* COS Parts Consumble */
											'622002002070', /* COS Parts Replacement */
											'622002001320' /* COS-Parts Freight */
										) then f_je_l_Expense else 0 end) as "MS COGS Adj",

										/* added 2018-06-12 as requested by Eric Dush */
										sum(case when  F_GLCC_CC = '5364' then  f_je_l_Expense else 0 end)
								 		-sum( case when f_glcc_acct in (
										  '622002001820', /*COS-Parts Consumable*/
											'622002002080', /*COS-Parts Exchange*/
											'622002001320', /*COS-Parts Freight*/
											'622002001824', /*COS-Parts Freight (SIMSg/Metrix)*/
											'622002002200', /*COS-Parts Gain/Loss*/
											'622002001720', /*COS-Parts Repair*/
											'622002001823', /*COS-Parts Repair (SIMSg/Metrix)*/
											'622002001822', /*COS-Parts Repairable (SIMSg/Metrix)*/
											'622002002070', /*COS-Parts Replacement*/
											'630002001550', /*Direct COS Airfare*/
											'630002001577', /*Direct COS Auto-Parking Tolls*/
											'630002001575', /*Direct COS Auto-Rental*/
											'630002001540', /*Direct COS Hotel*/
											'630002001580', /*Direct COS Meals & Entertainment-Revenue related*/
											'630002001570', /*Direct COS Mileage*/
											'630002001555', /*Direct COS Other Transportation*/
											'625002001132', /*Field Services Allocation*/
											'850080001400', /*Hotel*/
											'850080001620'  /*Other Transportation*/
											) then f_je_l_netaccounted else 0 end) as "MS COGS LABOR",
										sum(case when  F_GLCC_CC = '5363'   then  f_je_l_Expense else 0 end) as "SA COGS",
										sum(case when  Geo = '69C' and F_GLCC_CC = '5363'   and f_glcc_acct = '622002001180' /* Direct COS Subcontractors */
											then  f_je_l_Expense else 0 end) as "SA COGS Adj",
										-sum(f_je_l_Income) - sum(f_je_l_Expense) as "Total GM",
										sum( case when f_glcc_acct in (
											  '622002001180', /* Direct COS Subcontractors */
											  '622002002270' /* Agency, Contract Fees */)  then f_je_l_netaccounted else 0 end) as "Subcontractor Exp",
										sum( case when Geo = '69C' and F_GLCC_CC = '5363'   and f_glcc_acct = '622002001180' /* Direct COS Subcontractors */
											   then f_je_l_netaccounted else 0 end) as "Subcontractor Exp Adj",
										sum( case when F_GLCC_CC = '5364' and f_glcc_acct in (
											  '622002001180', /* Direct COS Subcontractors */
											  '622002002270' /* Agency, Contract Fees */)  then f_je_l_netaccounted else 0 end) as "MS Subcontractor Exp",
										sum( case when F_GLCC_CC = '5363'   and f_glcc_acct in (
											  '622002001180', /* Direct COS Subcontractors */
											  '622002002270' /* Agency, Contract Fees */)  then f_je_l_netaccounted else 0 end) as "SA Subcontractor Exp",
										sum( case when Geo = '69C' and F_GLCC_CC = '5363'   and f_glcc_acct = '622002001180' /* Direct COS Subcontractors */
											   then f_je_l_netaccounted else 0 end) as "SA Subcontractor Exp Adj",
										sum( case when f_glcc_acct in (
											'625002001350',
											'625002001137',
											'625002001130',
											'625002001132',  /* Field Services Allocation */
											'625002001133',
											'622002001140')  then f_je_l_netaccounted else 0 end) as "Net Allocations Exp",
										sum( case when f_glcc_acct in (
											'630002001565', /* Direct COS Temp. Labor Travel Exp. */
											'625002001120' /* Direct COS Temporary Help */
											)  then f_je_l_netaccounted else 0 end) as "Temporary Exp",
										sum (case when lvl4_descr = 'Direct Labor Compensation' then f_je_l_netaccounted else 0 end) as "Direct Labor-Compensation",
										sum (case when lvl4_descr = 'Direct Labor Travel/Entertainment' then f_je_l_netaccounted else 0 end) as "Direct Labor-Travel/Enter",
										sum (case when F_GLCC_CC = '5364' and lvl4_descr = 'Direct Labor Travel/Entertainment' then f_je_l_netaccounted else 0 end) as "MS Direct Labor-Travel/Enter",
										sum (case when F_GLCC_CC = '5363'   and lvl4_descr = 'Direct Labor Travel/Entertainment' then f_je_l_netaccounted else 0 end) as "SA Direct Labor-Travel/Enter",
										-- Aunnity Revenue
										-sum( case when f_glcc_acct in (
											'522001001350', /* Annuity Revenue */
											'522001001530', /* Warranty Revenue */
											'522001001240', /* Discounts & Allowances ITO */
											'522001001380', /* AT&T Telecom Revenue */
											'522001001360', /* SLA Penalty Revenue */
											'522001001470', /* Service Maintenance Contract Revenue */
											'522001001540', /* Co-Branded Warranty Revenue */
											'522001001365' /* Contra Revenue - Annuity */) then f_je_l_netaccounted else 0 end) as "Annuity Rev",
										-- Project Revenue
										-sum( case when f_glcc_acct in (
											 '522001001000',	/* Utility Remarketing Revenue */
											 '522001001390',	/* Project Revenue - ITO */
											 '522001001550',	/*Hardware Installations */
											 '522001001560',	/* ITO Time and Materials */
											 '525001001360'	/* Customer Charges and Discounts */)  then f_je_l_netaccounted else 0 end) as "Proj Rev",
										-sum (case when  f_glcc_acct in (
										-- Parts Revenue
										'522001001570') then f_je_l_netaccounted else 0 end) as "Part Sales Rev",
										-sum (case when  f_glcc_acct in (
										-- Freight Revenue
										'522001001720') then f_je_l_netaccounted else 0 end) as "Freight Rev",
										-- Annuity Cost
										sum( case when f_glcc_acct in (
										'622002002270', /* Agency, Contract Fees */
										'622002001380', /* AT&T Telecom Cost */
										'625002001031', /* Bonus EBITDA - COGS */
										'623002002035', /* COS-3rd Party Consulting */
										'622002001640', /* COS-Depreciation Expense */
										'622002002001', /* COS-ITO Rental Equipment */
										'624002002000', /* COS-Rental Equipment */
										'622002002090', /* COS-Software WPO */
										'622002002160', /* COS-Training */
										'622002002290', /* Deferred Service Costs - Amortization */
										'622002001160', /* Direct COS - ITO */
										'625002001160', /* Direct COS - On-Call Labor */
										'625002001030', /* Direct COS Bonus */
										'625002001130', /* Direct COS Employee Transfer Expense (Cost Relief) */
										'625002001060', /* Direct COS Health Insurance */
										'630002001570', /* Direct COS Mileage */
										'625002001010', /* Direct COS Overtime */
										'625002001040', /* Direct COS Payroll Tax */
										'625002001050', /* Direct COS Pension & 401K */
										'625002001005', /* Direct COS PTO */
										'625002001000', /* Direct COS Salary & Wages */
										'630002001565', /* Direct COS Temp. Labor Travel Exp. */
										'625002001120', /* Direct COS Temporary Help */
										'630002001080', /* Direct COS Vehicles */
										'622002001200', /* Direct Material */
										'622002001590', /* Direct Telecom Costs-Revenue related */
										'625002001132', /* Field Services Allocation */
										'625002001133', /* Implementation Allocation */
										'622002001740', /* ITO COS-Misc Billable Costs */
										'622002001800', /* Maintenance Costs */
										'622002001840', /* OEM Support Costs */
										'625002001500', /* Other Employee Benefits */
										'623002002120', /* Other Professional Services Cost */
										'622002001860', /* Pass Through Costs */
										'622002001957', /* Services - Other Facility Expenses */
										'622002001780', /* Support Tools */
										'620001001420', /* VCS-COS-Misc Billable Costs */
										'622001001962' /* Vendor Contracts Costs */
										) then
										f_je_l_netaccounted else 0 end) as "Annuity Exp",

										Sum( case when f_glcc_acct in (
										'630002001565', /* Direct COS Temp. Labor Travel Exp. */
										'625002001120' /* Direct COS Temporary Help */
										) then
										f_je_l_netaccounted else 0 end) as "Annuity Temp Exp",

										 sum( case when f_glcc_acct in (
											  -- Parts Expense
											  '622002002080',
											  '622002001820', /* COS-Parts Consumable */
											  '622002002200',
											  '622002001720',
											  '622002001823',
											  '622002002070',
											  '622002002260'
											   ) then
										f_je_l_netaccounted else 0 end) as "Parts Exp",

										 sum( case when f_glcc_acct in (
											  -- Freight Expense
											  '622002001320', /* COS-Parts Freight */
											  '622002001824', /* COS-Parts Freight (SIMSg/Metrix)*/
											  '622002002230' /* Inbound Freight Parts*/
											  ) then
										f_je_l_netaccounted else 0 end) as "Freight Exp",

										 sum(case when F_GLCC_CC = '5364' and f_glcc_acct in (
											  '620001001320', /* COS - Freight Out */
											  '622002001230', /* Disposal Services */
											  '622002001320', /* COS-Parts Freight */
											  '622002001720', /* COS-Parts Repair */
											  '622002001820', /* COS-Parts Consumable */
											  '622002001823', /* COS-Parts Repair (SIMSg/Metrix) */
											  '622002001824', /* COS-Parts Freight (SIMSg/Metrix) */
											  '622002001825', /* COS-Customer Part Sales */
											  '622002001826', /* COS-Freight Expedite */
											  '622002002070', /* COS-Parts Replacement */
											  '622002002080', /* COS-Parts Exchange */
											  '622002002200', /* COS-Parts Gain/Loss */
											  '622002002220', /* COS-Handling Charges Parts */
											  '622002002230', /* Inbound Freight Parts */
											  '622002002260' /* COS-Restocking Fees Parts */
											  ) then f_je_l_netaccounted else 0 end) as "MS Parts & Freight Costs",
										sum(case when Division = 'Canada OMS' and F_GLCC_CC = '5364' and f_glcc_acct  in (
											  '622002001320', /* COS-Parts Freight */
											 '622002001820', /* COS-Parts Consumable */
											 '622002002070' /* COS-Parts Replacement */
											) then f_je_l_netaccounted else 0 end) as "MS Parts & Freight Costs Adj",
										sum(case when F_GLCC_CC = '5363'   and f_glcc_acct in (
											  '620001001320', /* COS - Freight Out */
											  '622002001230', /* Disposal Services */
											  '622002001320', /* COS-Parts Freight */
											  '622002001720', /* COS-Parts Repair */
											  '622002001820', /* COS-Parts Consumable */
											  '622002001823', /* COS-Parts Repair (SIMSg/Metrix) */
											  '622002001824', /* COS-Parts Freight (SIMSg/Metrix) */
											  '622002001825', /* COS-Customer Part Sales */
											  '622002001826', /* COS-Freight Expedite */
											  '622002002070', /* COS-Parts Replacement */
											  '622002002080', /* COS-Parts Exchange */
											  '622002002200', /* COS-Parts Gain/Loss */
											  '622002002220', /* COS-Handling Charges Parts */
											  '622002002230', /* Inbound Freight Parts */
											  '622002002260' /* COS-Restocking Fees Parts */
											  ) then f_je_l_netaccounted else 0 end) as "SA Parts & Freight Costs",
										sum( case when f_glcc_acct in (
											  '625002001132' /* Field Services Allocation */
											  ) then
										f_je_l_netaccounted else 0 end) as "Dispatch Costs",
										sum( case when Division = 'Canada OMS' and F_GLCC_CC = '5364' and f_glcc_acct in (
											  '625002001132' /* Field Services Allocation */
											  ) then
										f_je_l_netaccounted else 0 end) as "Dispatch Costs Adj",
										sum( case when F_GLCC_CC = '5364' and f_glcc_acct in (
											  '625002001132' /* Field Services Allocation */
											  ) then
										f_je_l_netaccounted else 0 end) as "MS Dispatch Costs",
										sum( case when Division = 'Canada OMS' and F_GLCC_CC = '5364' and f_glcc_acct in (
											  '625002001132' /* Field Services Allocation */
											  ) then
										f_je_l_netaccounted else 0 end) as "MS Dispatch Costs Adj",
										sum( case when F_GLCC_CC = '5363'   and f_glcc_acct in (
											  '625002001132' /* Field Services Allocation */
											  ) then
										f_je_l_netaccounted else 0 end) as "SA Dispatch Costs",

										sum( case when f_glcc_acct in (
											  '622002002161', /* COS-Excell Transfer Elimination */
											  '625002001000', /* Direct COS Salary & Wages */
											  '625002001005', /* Direct COS PTO */
											  '625002001010', /* Direct COS Overtime */
											  '625002001030', /* Direct COS Bonus */
											  '625002001031', /* Bonus EBITDA - COGS */
											  '625002001050', /* Direct COS Pension & 401K */
											  '625002001060', /* Direct COS Health Insurance */
											  '625002001120', /* Direct COS Temporary Help */
											  '625002001130', /* Direct COS Employee Transfer Expense (Cost Relief) */
											  '625002001133', /* Implementation Allocation */
											  '625002001040', /*  Direct COS Payroll Tax */
											  '625002001160', /* Direct COS - On-Call Labor */
											  '625002001500', /* Other Employee Benefits */
											  '630002001570' /* Direct COS Mileage */
											  ) then
										f_je_l_netaccounted else 0 end) as "Onsite Labor Costs",

										sum( case when F_GLCC_CC = '5364' and f_glcc_acct in (
											  '622002002161', /* COS-Excell Transfer Elimination */
											  '625002001000', /* Direct COS Salary & Wages */
											  '625002001005', /* Direct COS PTO */
											  '625002001010', /* Direct COS Overtime */
											  '625002001030', /* Direct COS Bonus */
											  '625002001031', /* Bonus EBITDA - COGS */
											  '625002001050', /* Direct COS Pension & 401K */
											  '625002001060', /* Direct COS Health Insurance */
											  '625002001120', /* Direct COS Temporary Help */
											  '625002001130', /* Direct COS Employee Transfer Expense (Cost Relief) */
											  '625002001133', /* Implementation Allocation */
											  '625002001040', /*  Direct COS Payroll Tax */
											  '625002001160', /* Direct COS - On-Call Labor */
											  '625002001500', /* Other Employee Benefits */
											  '630002001570' /* Direct COS Mileage */
											  ) then
										f_je_l_netaccounted else 0 end) as "MS Onsite Labor Costs",

										sum( case when F_GLCC_CC = '5363'   and f_glcc_acct in (
											  '622002002161', /* COS-Excell Transfer Elimination */
											  '625002001000', /* Direct COS Salary & Wages */
											  '625002001005', /* Direct COS PTO */
											  '625002001010', /* Direct COS Overtime */
											  '625002001030', /* Direct COS Bonus */
											  '625002001031', /* Bonus EBITDA - COGS */
											  '625002001050', /* Direct COS Pension & 401K */
											  '625002001060', /* Direct COS Health Insurance */
											  '625002001120', /* Direct COS Temporary Help */
											  '625002001130', /* Direct COS Employee Transfer Expense (Cost Relief) */
											  '625002001133', /* Implementation Allocation */
											  '625002001040', /*  Direct COS Payroll Tax */
											  '625002001160', /* Direct COS - On-Call Labor */
											  '625002001500', /* Other Employee Benefits */
											  '630002001570' /* Direct COS Mileage */
											  ) then
										f_je_l_netaccounted else 0 end) as "SA Onsite Labor Costs",

										 sum( case when f_glcc_acct in (
											  '622001001962', /* Vendor Contracts Costs */
											  '622002001200', /* Direct Material */
											  '622002001590', /* Direct Telecom Costs-Revenue related */
											  '622002001740', /* ITO COS-Misc Billable Costs */
											  '622002001780', /* Support Tools */
											  '622002001800', /* Maintenance Costs */
											  '622002001840', /* OEM Support Costs */
											  '622002001860', /* Pass Through Costs */
											  '622002001956', /* COS - CoBranded Warranty */
											  '622002001957', /* Services - Other Facility Expenses */
											  '622002002090', /* COS-Software WPO */
											  '622002002160', /* COS-Training */
											  '622002002290', /* Deferred Service Costs - Amortization */
											  '625002001134', /* Direct COS Config Allocation */
											  '630002001080', /* Direct COS Vehicles */
											  '630002001540', /* Direct COS Hotel */
											  '630002001550', /* Direct COS Airfare */
											  '630002001555', /* Direct COS Other Transportation */
											  '630002001565', /* Direct COS Temp. Labor Travel Exp. */
											  '630002001571', /* Direct COS Auto Liability */
											  '630002001575', /* Direct COS Auto-Rental */
											  '630002001577', /* Direct COS Auto-Parking Tolls */
											  '630002001580' /* Direct COS Meals & Entertainment-Revenue related */
											  ) then
										f_je_l_netaccounted else 0 end) as "Other Costs",


										 sum( case when F_GLCC_CC = '5364' and f_glcc_acct in (
											  '622001001962', /* Vendor Contracts Costs */
											  '622002001200', /* Direct Material */
											  '622002001590', /* Direct Telecom Costs-Revenue related */
											  '622002001740', /* ITO COS-Misc Billable Costs */
											  '622002001780', /* Support Tools */
											  '622002001800', /* Maintenance Costs */
											  '622002001840', /* OEM Support Costs */
											  '622002001860', /* Pass Through Costs */
											  '622002001956', /* COS - CoBranded Warranty */
											  '622002001957', /* Services - Other Facility Expenses */
											  '622002002090', /* COS-Software WPO */
											  '622002002160', /* COS-Training */
											  '622002002290', /* Deferred Service Costs - Amortization */
											  '625002001134', /* Direct COS Config Allocation */
											  '630002001080', /* Direct COS Vehicles */
											  '630002001540', /* Direct COS Hotel */
											  '630002001550', /* Direct COS Airfare */
											  '630002001555', /* Direct COS Other Transportation */
											  '630002001565', /* Direct COS Temp. Labor Travel Exp. */
											  '630002001571', /* Direct COS Auto Liability */
											  '630002001575', /* Direct COS Auto-Rental */
											  '630002001577', /* Direct COS Auto-Parking Tolls */
											  '630002001580' /* Direct COS Meals & Entertainment-Revenue related */
											  ) then
										f_je_l_netaccounted else 0 end) as "MS Other Costs",

										sum( case when F_GLCC_CC = '5363'   and f_glcc_acct in (
											  '622001001962', /* Vendor Contracts Costs */
											  '622002001200', /* Direct Material */
											  '622002001590', /* Direct Telecom Costs-Revenue related */
											  '622002001740', /* ITO COS-Misc Billable Costs */
											  '622002001780', /* Support Tools */
											  '622002001800', /* Maintenance Costs */
											  '622002001840', /* OEM Support Costs */
											  '622002001860', /* Pass Through Costs */
											  '622002001956', /* COS - CoBranded Warranty */
											  '622002001957', /* Services - Other Facility Expenses */
											  '622002002090', /* COS-Software WPO */
											  '622002002160', /* COS-Training */
											  '622002002290', /* Deferred Service Costs - Amortization */
											  '625002001134', /* Direct COS Config Allocation */
											  '630002001080', /* Direct COS Vehicles */
											  '630002001540', /* Direct COS Hotel */
											  '630002001550', /* Direct COS Airfare */
											  '630002001555', /* Direct COS Other Transportation */
											  '630002001565', /* Direct COS Temp. Labor Travel Exp. */
											  '630002001571', /* Direct COS Auto Liability */
											  '630002001575', /* Direct COS Auto-Rental */
											  '630002001577', /* Direct COS Auto-Parking Tolls */
											  '630002001580' /* Direct COS Meals & Entertainment-Revenue related */
											  ) then
										f_je_l_netaccounted else 0 end) as "SA Other Costs",

									sum (case when lvl4_descr = 'ITO Cost of Revenue' then f_je_l_netaccounted else 0 end) as "ITO Costs",
									sum (case when lvl2_descr = 'Operating Expenses' then f_je_l_netaccounted else 0 end) as "OPEX Exp",
									sum( case when f_glcc_acct in (
									  -- billable personnel
									  '999100001000', /* Billable Regular */
									  '999100002000' /* Billable Temp */
									 ) then
									  f_je_l_netaccounted else 0 end) as "PL_HC",
										--BEGING  9/13/2018  Adding OT_COSTS
										sum( case when f_glcc_acct  =  '625002001010' /* Direct COS Overtime */
															then f_je_l_netaccounted else 0 end) as "OT_COSTS"
										--END  9/13/2018  Adding OT_COSTS
	FROM
	(select * from openquery([DW],
	'select to_date(''01-''||gl.f_acctperiod, ''dd-mon-yy'') as Period,
  				case when pa.description = ''SC-USA'' then ''Managed Services'' else pa2.Service_region end as "Region",
					case when PA.SERVICE_AREA is null then ''Other''
     					 when pa2.Service_region like ''%Faustini%'' and PA.SERVICE_AREA not in (''Canada OMS'', ''GE'', ''Hybrid Delivery'' , ''Managed Services'' ,''Managed Staffing'') then ''Other''
	 				 		 when pa2.Service_region = ''Kelly Kelly'' and gl.f_glcc_geo = ''330'' then ''Finance Vertical Delivery'' /* Citizens First Bank changed divisions */
	 					   else PA.SERVICE_AREA
					 end as DIVISION,
  		 		 gl.f_GLCC_GEO as Geo,
 			 		 PA.Description as "Geo Desc",
 			 		 case
					  when pa2.Service_region = ''Kelly Kelly'' and gl.f_glcc_geo = ''330'' then ''Penzler''  /* Citizens First Bank changed divisions */
	  				else PA.Service_Area_Owner
					 end as "Director",
					 gl.f_glcc_acct,
					 gl.F_GLCC_CC,
					 acct.lvl2_descr,
					 acct.lvl4_descr,
					 gl.f_je_l_Income,
					 gl.f_je_l_Expense,
					 gl.f_je_l_netaccounted
		from DW.V_ODS_FIN_SVC gl
	  inner join DW.T_PFIN_CMPC_PA_REPORTING PA on gl.F_GLCC_GEO = PA.GEOGRAPHY
	  inner join DW.T_PFIN_CMPC_PA_REPORTING PA2 on gl.F_GLCC_CC = PA2.GEOGRAPHY
	  left join DW.T_DIM_COST_CENTER cc on gl.f_glcc_cc = cc.id
	  left join DW.T_DIM_ACCOUNT acct on gl.f_glcc_acct = acct.id
	where
	 pa2.SERVICE_AREA =''EUE''
	and ( (pa2.Service_region like ''%Faustini%''
	and F_GLCC_CC not in (
			''5205'', /* Centralized Service-Non Billable */
			''5276'', /* Printer Excellence */
			''5297'', /* Productivity & Automation */
			''5430'', /* Service Quality */
			''5431''  /* Service Quality Billable */
			)
	)
	or
	(pa2.Service_region = ''Kelly Kelly'' and (PA.SERVICE_AREA = ''Finance Vertical Delivery'' or gl.f_glcc_geo = ''330'' ))) /* Citizens First Bank changed divisions */
	and  f_je_l_eff_Dt >= (select trunc(last_day(add_months(sysdate,-2))+1) FROM dual) --to_date(''01/01/2017'', ''mm/dd/yyyy'')
	and f_je_l_eff_Dt < (select trunc(last_day(add_months(sysdate,-1))+1) FROM dual)
	and (gl.F_GLCC_ACCT Like ''5%'' Or gl.F_GLCC_ACCT Like ''6%'' or  gl.F_GLCC_ACCT Like ''8%''  or gl.f_glcc_acct like ''99910000%'' )
	and gl.F_GLCC_ACCT_DESCR Not Like ''%Netting%''
	' )
	) DW_PL

	Group by Period,
					case when Region like '%Faustini%' then 'OMS' when Region = 'Kelly Kelly' then 'DFS' else 'ERROR' end,
	Division,
	Geo,
	"Geo Desc",
	Director) PL
	-- Clearvision Case Counts and Hours
	left join
	(
	select * from openquery([DW],
	  'select O.F_CASE_GEO_CODE, trunc(A.F_TXN_DT, ''MM'') as Period,
			sum (case when a.f_call_category = ''Annuity'' then 1 else 0 end) as Field_Annuity_Cases,
			sum (case when a.f_call_category = ''Projects'' then 1 else 0 end) as Field_Proj_Cases,
			sum (case when a.f_call_category = ''IMAC'' then 1 else 0 end) as Field_IMAC_Cases,
			sum(case when a.f_call_category = ''Annuity'' then A.F_CLOSE_TOTAL_HRS else 0 end) as Field_Annuity_Hours,
			Sum(case when a.f_call_category = ''Projects'' then A.F_CLOSE_TOTAL_HRS else 0 end) as Field_Proj_Hours,
			Sum(case when a.f_call_category = ''IMAC'' then A.F_CLOSE_TOTAL_HRS else 0 end) as Field_IMAC_Hours

		  from
		  DW.T_DM_SVC_FS_DETAIL A
		  inner join dw.t_clar_ods_case O                 on A.F_CASE_KEY = O.f_case_key
		  where
		  F_SOURCE_TYPE in ''CLOSED_CALLS''
		  and a.f_txn_dt >= (select trunc(last_day(add_months(sysdate,-2))+1) FROM dual) --to_date(''01/01/2017'', ''mm/dd/yyyy'')
		  and a.f_txn_dt < (select trunc(last_day(add_months(sysdate,-1))+1) FROM dual)
		  and a.f_tech_org = ''Dispatch Tech''
		  group by  O.F_CASE_GEO_CODE, trunc(A.F_TXN_DT, ''MM'')'
	  )) CV on CV.F_CASE_GEO_CODE = PL.GEO and CV.Period =  PL.Period
	left join
	(
	/* Workday Days */
	select * from openquery([DW],
	'Select
		HR.F_RESOURCE_DISTRICT_ID as Geo,
		DT.CLNDR_MO_START_DT  as Period,
		(Sum(case when PT.f_hr_Dept_id = ''5364'' then PT.F_CCSI_WORK_HRS + PT.F_OT_HRS else 0 end))/8 as WD_MS_Days,
		(Sum(case when PT.f_hr_Dept_id = ''5363'' then PT.F_CCSI_WORK_HRS + PT.F_OT_HRS else 0 end))/8 as WD_SA_Days,
		(Sum(case when PT.f_hr_Dept_id = ''5300'' then PT.F_CCSI_WORK_HRS + PT.F_OT_HRS else 0 end))/8 as WD_FIN_Days
	From
		DW.T_DM_LABOR_PAYTIME PT
		inner join DW.T_DIM_DATE                     DT on PT.F_DUR = DT.DAY_DT
		inner join dw.t_dm_human_resources_wkly_hist HR on PT.F_RESOURCE_NET_ID = HR.F_RESOURCE_NET_ID and DT.FRI_WEEKEND_DATE = HR.F_WEEK_ENDING
	Where PT.F_DUR >= (select trunc(last_day(add_months(sysdate,-2))+1) FROM dual) --to_date(''01/01/2017'', ''mm/dd/yyyy'')
	    and PT.F_DUR < (select trunc(last_day(add_months(sysdate,-1))+1) FROM dual)
		and hr.f_resource_comp_class in ''Hourly''
		and PT.f_hr_Dept_id in ( ''5364'', ''5363'', ''5300'')
	group by
		HR.F_RESOURCE_DISTRICT_ID,
		DT.CLNDR_MO_START_DT'
	 ) ) WD  on PL.Geo = WD.Geo and PL.Period = WD.Period

	left join
	 --Fieldglass Days
	(select * from openquery([DW],
	'Select
		 HR.F_RESOURCE_DISTRICT_ID as Geo,
		 DT.CLNDR_MO_START_DT as Period,
		 sum( case when WT.department_code = ''5364'' then WT.Billable_Hours else 0 end)/8 as FG_MS_Days,
		 sum( case when WT.department_code = ''5363'' then WT.Billable_Hours else 0 end)/8 as FG_SA_Days,
		 sum( case when WT.department_code = ''5300'' then WT.Billable_Hours else 0 end)/8 as FG_FIN_Days
	FROM
	   DW.T_FG_WORKER  W
	   inner join T_FG_WORKER_TIMESHEET            WT on W.Worker_Id = WT.Worker_Id
	   inner join DW.T_DIM_DATE                     DT on WT.Time_entry_dt = DT.DAY_DT
	   inner join dw.t_dm_human_resources_wkly_hist HR on W.compucom_user_id = HR.F_RESOURCE_NET_ID and DT.FRI_WEEKEND_DATE = HR.F_WEEK_ENDING

	WHERE
	   WT.TASK_CODE = ''HRS WRKD''
	   AND WT.timesheet_status in (''Invoiced'',''Paid'')
	   AND WT.Time_Entry_Dt >= (select trunc(last_day(add_months(sysdate,-2))+1) FROM dual) --to_date(''01/01/2017'', ''mm/dd/yyyy'')
	   and WT.Time_Entry_Dt < (select trunc(last_day(add_months(sysdate,-1))+1) FROM dual)
	   and WT.department_code in( ''5364'', ''5363'', ''5300'')
	group by
	   HR.F_RESOURCE_DISTRICT_ID,
	   DT.CLNDR_MO_START_DT '
	) ) FS
	on PL.Geo  = FS.GEO and PL.Period =  FS.Period

	left join
	-- Workday Paid and OT Hours
	(select * from openquery([DW],
	'Select
		PT.F_GEO_ID as Geo,
		DT.CLNDR_MO_START_DT  as Period,
		sum(case when F_TOTAL_RPTD_HRS < 0 then 0 else F_TOTAL_RPTD_HRS end)as Paid,
		sum (case when F_OT_HRS < 0 then 0 else F_OT_HRS end) as OT,
		--BEGING 10/5/2018
		(select sum(o.HOURS)
	             from DW.T_CM_MAPOVERTIME o
	             inner join DW.T_DM_HUMAN_RESOURCES hr on o.EMPLID = hr.F_RESOURCE_ID
	             inner join DW.T_CM_MAPCODES mc on o.reason = mc.codeid
	             where
	                   trunc(o.OVERTIMEDATE, ''MM'') = DT.CLNDR_MO_START_DT
	                   and hr.f_resource_hr_district_id = PT.F_GEO_ID
	                   and mc.codevalue like ''BIL%'' and mc.codevalue <> ''BIL_CNT''
	             group by
	             trunc(o.OVERTIMEDATE, ''MM''),
	             hr.f_resource_hr_district_id) AS BILLED_OT
		--END 10/5/2018
	From
		DW.T_DM_LABOR_PAYTIME						 PT
		inner join DW.T_DIM_DATE                     DT on PT.F_DUR = DT.DAY_DT
		inner join dw.t_dm_human_resources_wkly_hist HR on PT.F_RESOURCE_NET_ID = HR.F_RESOURCE_NET_ID and DT.FRI_WEEKEND_DATE = HR.F_WEEK_ENDING
	Where PT.F_DUR >= (select trunc(last_day(add_months(sysdate,-2))+1) FROM dual) --to_date(''01/01/2017'', ''mm/dd/yyyy'')
		and PT.F_DUR < (select trunc(last_day(add_months(sysdate,-1))+1) FROM dual)
		and hr.f_resource_comp_class in ''Hourly''
	group by
		PT.F_GEO_ID,
		DT.CLNDR_MO_START_DT'
	 )) HRS on PL.Geo = HRS.Geo and PL.Period =   HRS.Period

	) as PL_H
	on gg.geo = PL_H.geo

	group by gg.Group_Name,
	PL_H.Dashboard,
	PL_H.Division,
	PL_H.Director,
	PL_H.Period
	--BEGING 10/5/2018
	--PL_H.[Geo Desc]
	--END 10/5/2018
	)
	dw
	left hash join
	(SELECT SA.Service_area as Division, V.* FROM
	(V_ACCOUNT_COUNTS AS V
	INNER JOIN GEO_GROUPS ON V.Account = GEO_GROUPS.GROUP_NAME)
	INNER JOIN SERVICE_AREAS AS SA ON GEO_GROUPS.SERVICE_AREA_ID = SA.ID
	)
	a on dw.Division = a.Division and dw.Account = a.account and dw.Period = a.period
) T
GROUP BY T.SOURCE_TYPE,
T.DASHBOARD,
T.DIVISION,
T.DIRECTOR,
T.ACCOUNT,
T.PERIOD;

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
		  ,'FINANCE_DATA_PART_1' AS source_type;
    IF @@TRANCOUNT > 0
        ROLLBACK TRANSACTION;
END CATCH;


END
