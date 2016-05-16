select MAP.EXTERNAL_ID, b.account_no, b.bill_ref_no 
  from bill_invoice b,
       bill_invoice_detail d,
       product_rate_key k,
       customer_id_acct_map map
 where B.PREP_DATE > sysdate - 10
   and B.BILL_REF_NO = D.BILL_REF_NO
   and B.BILL_REF_RESETS = D.BILL_REF_RESETS
   and D.SUBTYPE_CODE = 10069
   and K.INACTIVE_DT is null
   and K.TRACKING_ID = D.TRACKING_ID
   and K.UNITS not in (201206,201207,201208)
   and d.type_code IN (2, 3, 7)
   and B.PREP_ERROR_CODE is null
   and MAP.ACCOUNT_NO = B.ACCOUNT_NO
   and MAP.INACTIVE_DATE is null
   and MAP.EXTERNAL_ID_TYPE =1
   and K.TRACKING_ID_SERV = K.TRACKING_ID_SERV
   and EXISTS (SELECT 1 FROM cmf WHERE CMF.ACCOUNT_NO = MAP.ACCOUNT_NO and CMF.ACCOUNT_CATEGORY in (10,11));