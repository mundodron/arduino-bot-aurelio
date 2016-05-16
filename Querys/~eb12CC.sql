SELECT 
      trunc(B.PREP_DATE) DATA_BIP 
FROM 
      bill_invoice b 
WHERE b.prep_status = 1 
  AND B.PREP_ERROR_CODE IS NULL  
  AND ROWNUM = 1 
  ORDER BY B.PREP_DATE DESC