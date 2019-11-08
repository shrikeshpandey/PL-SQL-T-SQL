
select * 
from [service].[dbo].[ReportScheduler]
--WHERE rep_status like 'Pending'
where date_requested > '01-JUN-2019'
 and report_program = 'LABRECLASSFIN';

select MAX(report_key)
from [service].[dbo].[ReportScheduler]
order by 1

USE [service]
GO 

INSERT INTO [service].[dbo].[ReportScheduler]
([report_program]
,[report_name]
,[emp_id]
,[output_file]
,[date_requested]
,[date_executed]
,[consol_invoice_id]
,[rep_status]
,[param1]
,[param2]
,[param3]
,[param4]
,[param5]
)
VALUES
(
'LABRECLASSCA',	--For USA: LABRECLASSFIN, For Canada: LABRECLASSCA
'CA Labor Reclass', -- For USA: Finance Labor Reclass US, For Canada: CA Labor Reclass
'11111', -- Do not change
'LaborReclassUS.zip', -- For USA: LaborReclassUS.zip, For Canada: LaborReclassCA.zip
'7/3/2019 0:00', --Run Date	
NULL,
NULL,
'Pending',	--Should be "Pending" if has not yet executed / will not run if not "Pending"
'20190703',	--Run Date
'20190601',	--Beg Date
'20190701',	--End Date
NULL,	
NULL
);

