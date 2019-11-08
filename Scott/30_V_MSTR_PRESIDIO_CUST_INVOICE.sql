/***********************************************************************************
||   QUERY INFORMATION
||
||   Department:     Data Warehouse
||   Programmer:     Luis Fuentes
||   Date:           08/01/2018
||   Category:       Table
||
||   Description:    Creates view V_MSTR_PRESIDIO_CUST_INVOICE
||
||   Parameters:     None
||
||   Historic Info:
||    Name:           Date:        Brief Description:
||   -----------------------------------------------------------------------------
||   Luis Fuentes     08/01/2018   Initial Creation
||   Luis Fuentes     08/07/2018   Needs to show either ce.add_user or A.ud_user
||   Luis Fuentes     08/08/2018   Adding INVOICE_DATE
||   Luis Fuentes     08/14/2018   Adding CUST_NO
||   -----------------------------------------------------------------------------
||
||   CURRENT REVISION STANDARD:  v1.50
||
***********************************************************************************/

CREATE OR REPLACE VIEW DW.V_MSTR_PRESIDIO_CUST_INVOICE AS
SELECT --Luis Fuentes 08/07/2018
        NVL(CE.AD_USERNAME,UPPER(TRIM(A.AD_USER))) AS AD_USER,
       --Luis Fuentes 08/07/2018
       CE.EMPLOYEE_FULL_NAME,
       CE.DEPARTMENT_NAME,
       CE.AREA,
       CE.TERRITORY,
       A.INVOICE_NO,
       A.SHIP_TO_ADDRESS1,
       A.SHIP_TO_ADDRESS2,
       A.SHIP_TO_CITY,
       A.SHIP_TO_ST,
       A.SHIP_TO_ZIP,
       A.MANUF_CODE,
       A.MAN_PART_NO,
       A.DESCRIPTION,
       A.ASSET_TAG,
       A.SERIAL_NO,
       A.QTY,
      --Luis Fuentes 08/07/2018
       A.UNIT_PRICE,
      --Luis Fuentes 08/07/2018
       A.UNIT_SALES_TAX,
       A.EXT_PRICE,
       A.TOTAL_PRICE_TAX,
       -- Luis Fuentes 08/08/2018
       A.INVOICE_DATE,
       -- Luis Fuentes 08/08/2018
       -- Luis Fuentes 08/14/2018
       A.CUST_NO
       -- Luis Fuentes 08/14/2018
  FROM (
       SELECT DW.GET_UDF('USR_VALUES_HEAD', CUST_NO, ORDER_NO, 1) as AD_User,
              a11.INVOICE_NO INVOICE_NO,
              a11.SHIP_TO_ADDRESS1 SHIP_TO_ADDRESS1,
              a11.SHIP_TO_ADDRESS2 SHIP_TO_ADDRESS2,
              a11.SHIP_TO_CITY SHIP_TO_CITY,
              a11.SHIP_TO_ST SHIP_TO_ST,
              a11.SHIP_TO_ZIP SHIP_TO_ZIP,
              a11.MANUF_CODE MANUF_CODE,
              a11.MAN_PART_NO MAN_PART_NO,
              a11.DESCRIPTION DESCRIPTION,
              a12.ASSET_TAG ASSET_TAG,
              a12.SERIAL_NO SERIAL_NO,
              case
                when SERIAL_FLAG = 1 then 1
                else a11.sku_qty
              end QTY,
               a11.unit_price,
              CASE
                when SERIAL_FLAG = 1 then ROUND((a11.tax_amt / ABS(a11.sku_qty)), 2)
                else a11.tax_amt
              end Unit_sales_tax,
              CASE
                when SERIAL_FLAG = 1 then ROUND(a11.ext_price / ABS(a11.sku_qty), 2)
                else a11.ext_price
              end ext_price,
              CASE
                when SERIAL_FLAG = 1 then ROUND((a11.ext_price / ABS(a11.sku_qty)) + (a11.tax_amt / ABS(a11.sku_qty)),2)
                else a11.tax_amt + a11.ext_price
              end Total_price_tax,
              -- Luis Fuentes 08/08/2018
              a11.invoice_date AS INVOICE_DATE,
              -- Luis Fuentes 08/08/2018
              -- Luis Fuentes 08/14/2018
              a11.cust_no AS CUST_NO
              -- Luis Fuentes 08/14/2018
        from dw.T_FCT_0011_SALES_INVOICE a11
        left outer join DW.SALES_INVOICE_SERIAL_NUMBERS a12
         on (a11.INVOICE_NO = a12.INVOICE_NO and a11.DOC_LINE = a12.DOC_LINE)
         where a11.invoice_date >= '01-JUL-2018'
          AND a11.cust_no in ('530100467','530100513','530100527','530100550','530100551')
           ) A
  LEFT JOIN DW.T_DIM_CLIENT_EMPLOYEE CE
    ON UPPER(TRIM(CE.AD_USERNAME)) = UPPER(TRIM(A.AD_USER))
;
/
GRANT ALL ON DW.V_MSTR_PRESIDIO_CUST_INVOICE TO LF188653;
GRANT SELECT ON DW.V_MSTR_PRESIDIO_CUST_INVOICE TO RPTGEN;
GRANT SELECT ON DW.V_MSTR_PRESIDIO_CUST_INVOICE TO SERVICE_ROLE;
GRANT SELECT ON DW.V_MSTR_PRESIDIO_CUST_INVOICE TO MSTR;
