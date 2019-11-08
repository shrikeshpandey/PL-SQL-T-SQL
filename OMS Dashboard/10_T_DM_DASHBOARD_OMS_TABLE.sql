
/***********************************************************************************
||   QUERY INFORMATION
||
||   Department:     Data Warehouse
||   Programmer:     Luis Fuentes
||   Date:           06/26/2018
||   Category:       Table creation
||
||   Description:    Creates table DASHBOARD_OMS
||
||   Parameters:     None
||
||   Historic Info:
||    Name:              Date:        Brief Description:
||   -----------------------------------------------------------------------------
||   Luis Fuentes        06/26/2018   Initial Creation
||	 Luis Fuentes				 06/27/2018   Adding [LOAD_DATE]
||	 Luis Fuentes				 09/13/2018   Adding [OT_COSTS]
||   -----------------------------------------------------------------------------
||
||   CURRENT REVISION STANDARD:  v1.50
||
***********************************************************************************/

USE [clerk]
GO

ALTER TABLE [dbo].[DASHBOARD_FINANCE_DATA] DROP CONSTRAINT [DF__DASHBOARD__LOAD___552B87C2]
GO

/****** Object:  Table [dbo].[DASHBOARD_FINANCE_DATA]    Script Date: 9/18/2018 8:50:24 AM ******/
DROP TABLE [dbo].[DASHBOARD_FINANCE_DATA]
GO

/****** Object:  Table [dbo].[DASHBOARD_FINANCE_DATA]    Script Date: 9/18/2018 8:50:24 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[DASHBOARD_FINANCE_DATA](
	[SOURCE_TYPE] [nvarchar](50) NOT NULL,
	[DASHBOARD] [nvarchar](50) NOT NULL,
	[DIVISION] [nvarchar](255) NOT NULL,
	[DIRECTOR] [nvarchar](255) NOT NULL,
	[ACCOUNT] [nvarchar](255) NOT NULL,
	[PERIOD] [datetime] NOT NULL,
	[TOTAL_REVENUE] [float] NULL,
	[MS_REVENUE] [float] NULL,
	[SA_REVENUE] [float] NULL,
	[TOTAL_COGS] [float] NULL,
	[MS_COGS] [float] NULL,
	[MS_COGS_ADJ] [float] NULL,
	[MS_COGS_LABOR] [float] NULL,
	[SA_COGS] [float] NULL,
	[SA_COGS_ADJ] [float] NULL,
	[TOTAL_GM] [float] NULL,
	[SUBCONTRACTOR_EXP] [float] NULL,
	[SUBCONTRACTOR_EXP_ADJ] [float] NULL,
	[MS_SUBCONTRACTOR_EXP] [float] NULL,
	[SA_SUBCONTRACTOR_EXP] [float] NULL,
	[SA_SUBCONTRACTOR_EXP_ADJ] [float] NULL,
	[NET_ALLOCATIONS_EXP] [float] NULL,
	[TEMPORARY_EXP] [float] NULL,
	[DIRECT_LABOR_COMPENSATION] [float] NULL,
	[DIRECT_LABOR_TRAVEL_ENTER] [float] NULL,
	[MS_DIRECT_LABOR_TRAVEL_ENTER] [float] NULL,
	[SA_DIRECT_LABOR_TRAVEL_ENTER] [float] NULL,
	[ANNUITY_REV] [float] NULL,
	[PROJ_REV] [float] NULL,
	[PART_SALES_REV] [float] NULL,
	[FREIGHT_REV] [float] NULL,
	[ANNUITY_EXP] [float] NULL,
	[ANNUITY_TEMP_EXP] [float] NULL,
	[PARTS_EXP] [float] NULL,
	[FREIGHT_EXP] [float] NULL,
	[MS_PARTS_FREIGHT_COSTS] [float] NULL,
	[MS_PARTS_FREIGHT_COSTS_ADJ] [float] NULL,
	[SA_PARTS_FREIGHT_COSTS] [float] NULL,
	[DISPATCH_COSTS] [float] NULL,
	[DISPATCH_COSTS_ADJ] [float] NULL,
	[MS_DISPATCH_COSTS] [float] NULL,
	[MS_DISPATCH_COSTS_ADJ] [float] NULL,
	[SA_DISPATCH_COSTS] [float] NULL,
	[ONSITE_LABOR_COSTS] [float] NULL,
	[MS_ONSITE_LABOR_COSTS] [float] NULL,
	[SA_ONSITE_LABOR_COSTS] [float] NULL,
	[OTHER_COSTS] [float] NULL,
	[MS_OTHER_COSTS] [float] NULL,
	[SA_OTHER_COSTS] [float] NULL,
	[ITO_COSTS] [float] NULL,
	[OPEX_EXP] [float] NULL,
	[PL_HC] [float] NULL,
	[WD_MS_DAYS] [float] NULL,
	[WD_SA_DAYS] [float] NULL,
	[WD_FIN_DAYS] [float] NULL,
	[FG_MS_DAYS] [float] NULL,
	[FG_SA_DAYS] [float] NULL,
	[FG_FIN_DAYS] [float] NULL,
	[PAID] [float] NULL,
	[OT] [float] NULL,
	[FIELD_ANNUITY_CASES] [int] NULL,
	[FIELD_ANNUITY_HOURS] [float] NULL,
	[FIELD_PROJ_CASES] [int] NULL,
	[FIELD_PROJ_HOURS] [float] NULL,
	[FIELD_IMAC_CASES] [int] NULL,
	[FIELD_IMAC_HOURS] [float] NULL,
	[HC_MS_SDM] [float] NULL,
	[HC_SA_SDM] [float] NULL,
	[HC_MS_Tech] [float] NULL,
	[HC_SA_Tech] [float] NULL,
	[HC_MS_1_5_Desk] [float] NULL,
	[HC_SA_1_5_Desk] [float] NULL,
	[HC_MS_Solution_Cafe] [float] NULL,
	[HC_SA_Solution_Cafe] [float] NULL,
	[HC_MS_Temps] [float] NULL,
	[HC_MS_Annuity_Temps] [float] NULL,
	[HC_MS_Proj_Temps] [float] NULL,
	[HC_SA_Temps] [float] NULL,
	[HC_SA_Annuity_Temps] [float] NULL,
	[HC_SA_Proj_Temps] [float] NULL,
	[HC_MS_Other] [float] NULL,
	[HC_SA_Other] [float] NULL,
	[Laptops] [int] NULL,
	[Desktops] [int] NULL,
	[Mobile_Devices_Phones] [int] NULL,
	[Mobile_Devices_Tablets] [int] NULL,
	[Thin_clients] [int] NULL,
	[Printers] [int] NULL,
	[Managed_Printers] [int] NULL,
	[Tk_MS_Annuity] [int] NULL,
	[Tk_SA_Annuity] [int] NULL,
	[Tk_MS_IMAC] [int] NULL,
	[Tk_SA_IMAC] [int] NULL,
	[Tk_MS_Project] [int] NULL,
	[Tk_SA_Project] [int] NULL,
	[Tk_MS_Solution_Cafe] [int] NULL,
	[Tk_SA_Solution_Cafe] [int] NULL,
	[Tk_Laptops] [int] NULL,
	[Tk_Desktops] [int] NULL,
	[Tk_Mobile_Device_Phones] [int] NULL,
	[Tk_Mobile_Devices_Tablets] [int] NULL,
	[Tk_Thin_Clients] [int] NULL,
	[TK_Printers_Mgd_Printers] [int] NULL,
	[TK_Monitors] [int] NULL,
	[Tk_Misc_HW] [int] NULL,
	[TS_HC_TECH] [int] NULL,
	[TS_MS_TECH] [int] NULL,
	[TS_SA_TECH] [int] NULL,
	[TS_NO_TYPE_TECH] [int] NULL,
	[TS_MS_1_5] [int] NULL,
	[TS_SA_1_5] [int] NULL,
	[TS_NO_TYPE_1_5] [int] NULL,
	[TS_MS_CAFE] [int] NULL,
	[TS_SA_CAFE] [int] NULL,
	[TS_NO_TYPE_CAFE] [int] NULL,
	[TS_MS_NO_ROLE] [int] NULL,
	[TS_SA_NO_ROLE] [int] NULL,
	[TS_NO_TYPE_NO_ROLE] [int] NULL,
	[TS_Activities] [int] NULL,
	[TS_Resumes] [int] NULL,
	[TS_Days] [int] NULL,
	[TS_TechDays] [float] NULL,
	[TS_WD_FG_Days] [float] NULL,
	[LOAD_DATE] [date] NULL,
	[OT_COSTS] [float] NULL,
	[BILLED_OT] [float] NULL,
 CONSTRAINT [PK_DASHBOARD_FINANCE_DATA] PRIMARY KEY CLUSTERED
(
	[SOURCE_TYPE] ASC,
	[DASHBOARD] ASC,
	[DIVISION] ASC,
	[DIRECTOR] ASC,
	[ACCOUNT] ASC,
	[PERIOD] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[DASHBOARD_FINANCE_DATA] ADD  DEFAULT (getdate()) FOR [LOAD_DATE]
GO
