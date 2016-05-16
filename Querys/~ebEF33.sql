SELECT statement_date, COUNT(*)
FROM BILL_INVOICE A, 
     bipp09_corp B
WHERE A.ACCOUNT_NO = B.ACCOUNT_NO
AND A.PREP_DATE >= TO_DATE ('2016020921:50:24','YYYYMMDDHH24:MI:SS')
AND A.PREP_ERROR_CODE IS NULL
AND A.PREP_STATUS = 4
AND B.ACCOUNT_NO NOT IN (select account_no from GVT_LAYOUT_FATURAS_CORP
                         where flag =5
                         and status = 'Ativo')
GROUP BY statement_date;