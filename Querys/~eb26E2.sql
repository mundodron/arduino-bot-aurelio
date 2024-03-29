SELECT        CBD.ACCOUNT_NO, CBD.BILL_REF_NO, CBD.EXTERNAL_ID,
              SSN.FULL_SIN_SEQ, 
              BI.FILE_NAME, 
              BI.PREP_ERROR_CODE, 
              BI.BILL_PERIOD
FROM          CMF_BALANCE_DETAIL CBD, SIN_SEQ_NO SSN, BILL_INVOICE BI
WHERE         CBD.BILL_REF_NO = SSN.BILL_REF_NO
AND           SSN.BILL_REF_NO = BI.BILL_REF_NO
AND           CBD.BILL_REF_NO = 187319765;