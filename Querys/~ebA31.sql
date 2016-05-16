
SELECT BI.ACCOUNT_NO, BI.BILL_REF_NO 
FROM BILL_INVOICE BI,GVT_INVOICE_CONTROL_DETAIL GI
WHERE BI.BILL_REF_NO = GI.BILL_REF_NO
AND GI.GVT_MODE = 'AVULSO'
--AND GI.GVT_ACCOUNT_TYPE = 'CORP'
AND GI.PREP_STATUS = 1
AND BI.PREP_DATE BETWEEN TRUNC(SYSDATE-7) AND TRUNC(SYSDATE);
