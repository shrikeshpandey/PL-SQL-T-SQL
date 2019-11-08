/***********************************************************************************
||   QUERY INFORMATION
||
||   Department:     Data Warehouse
||   Programmer:     Luis Fuentes
||   Date:           06/27/2018
||   Category:       Table creation
||
||   Description:    Creates table PS_LOAD_VERIFY
||
||   Parameters:     None
||
||   Historic Info:
||    Name:              Date:        Brief Description:
||   -----------------------------------------------------------------------------
||   Luis Fuentes        06/27/2018   Initial Creation
||   -----------------------------------------------------------------------------
||
||   CURRENT REVISION STANDARD:  v1.50
||
***********************************************************************************/

USE [Clerk]
GO

/****** Object:  Table [dbo].[PS_LOAD_VERIFY]    Script Date: 7/4/2018 3:25:41 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[PS_LOAD_VERIFY](
  [id_ps_load_verify] [int] IDENTITY(1000,1) NOT NULL,
  [error_number] [int] NULL,
  [error_severity] [int] NULL,
  [error_state] [int] NULL,
  [error_procedure] [varchar](255) NULL,
  [error_line] [int] NULL,
  [error_message] [varchar](255) NULL,
  [last_modified] [datetime] NOT NULL,
  [source_type] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_id_ps_load_verify] PRIMARY KEY CLUSTERED
(
  [id_ps_load_verify] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 100) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[PS_LOAD_VERIFY] ADD  DEFAULT (getdate()) FOR [last_modified]
GO
