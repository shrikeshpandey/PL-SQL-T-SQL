/***********************************************************************************
   ||   PROCEDURE INFORMATION
   ||
   ||   Department:     Value Engineering
   ||   Creator:        Luis Fuentes
   ||   Date:           27/08/2019
   ||   Category:       Side project for Eric Dush
   ||
   ||   Description:    This query is used for Qlik Sense Data Engine
   ||
   ||
   ||   Parameters:     iCommit:   None
   ||
   ||   Load Sequence Number:  NNN
   ||
   ||   Historic Info:
   ||    Name:               Date:        Brief Description:
   ||   -----------------------------------------------------------------------------
   ||    Luis Fuentes        27/08/2019   Initial Creation
   ||    Luis Fuentes        27/08/2019   Adding country, state, city, street, zip code
   ||   -----------------------------------------------------------------------------
   ||
   ||   CURRENT REVISION STANDARD:  v1.50
   ||
   ***********************************************************************************/
/*******************************************************************************************
*  Generated using sp_gen_bulk() jg 2006
*******************************************************************************************/
SELECT KNOW.*, 
       INC.sys_id,
       CMP.state, 
       CMP.city, 
       CMP.street, 
       CMP.zip 
FROM DW.T_DIM_KNOW_ARTICLE KNOW
LEFT JOIN IAAS.INCIDENT INC
 ON INC.u_knowledge_article = KNOW.know_article_key
LEFT JOIN IAAS.TASK TSK
 ON TSK.sys_id = INC.sys_id
LEFT JOIN IAAS.CORE_COMPANY cmp
 ON TSK.company = CMP.sys_id  
WHERE KNOW.company_name LIKE ('%%');