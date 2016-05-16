
select C.ACCOUNT_NO,
       C.EXTERNAL_ID,
       C.CONTACT1_PHONE,
       B.BILL_REF_NO
       ---B.CHG_DATE
  from g0007405sql.TRACKS_CEF_7244 A,
       payment_trans B,
       GVT_LOTERICA_CONSULTA_CPFCNPJ C
 where  A.TRACKING_ID = B.TRACKING_ID
   and  B.ACCOUNT_NO = C.ACCOUNT_NO
   
   
   
 select * from payment_trans
 