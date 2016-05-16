Select trunc(sysdate) DATA, 
       sum(case when bill.prep_error_code = 2 then 1 end) PDF_GERADO,
       sum(case when bill.prep_error_code <> 2 then 1 end) PDF_NOK
  from BILL_INVOICE bill
 where BILL.PREP_STATUS = 1
 
   and trunc(bill.prep_date) = trunc(sysdate)


Select BILL.ACCOUNT_NO, BILL.PREP_STATUS, BILL.FORMAT_STATUS, BILL.FORMAT_ERROR_CODE, BILL.IMAGE_DONE, BILL.FILE_NAME
  from BILL_INVOICE bill
 where bill.account_no in (
        SELECT DISTINCT PROD.PARENT_ACCOUNT_NO
          FROM ARBOR.PRODUCT PROD
          JOIN P9909295SQL.CARDIONALIDADE_PLANOS CP
            ON CP.COMPONENT_MASTER = PROD.COMPONENT_ID
           AND CP.PLAN_ID IN (40105,40106,40107,40108,40114,40113,40101,40102,40103,40104,40109,40110,40111,40112)
         WHERE  PROD.PRODUCT_INACTIVE_DT IS NULL
                AND EXISTS (SELECT NULL 
                              FROM ARBOR.PRODUCT PROD1 
                             WHERE  PROD1.PARENT_ACCOUNT_NO = PROD.PARENT_ACCOUNT_NO 
                             --       AND PROD1.CHG_DT BETWEEN TRUNC(SYSDATE -1 ) AND TRUNC(SYSDATE)
                           )
                     )
                --AND trunc(prep_date) = trunc(sysdate) 


