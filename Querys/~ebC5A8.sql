
select C.ACCOUNT_NO,
       C.EXTERNAL_ID,
       C.CONTACT1_PHONE
       ---B.CHG_DATE
  from g0007405sql.TRACKS_CEF_7244 A,
       payment_trans B,
       GVT_LOTERICA_CONSULTA_CPFCNPJ C
 where  A.TRACKING_ID = B.TRACKING_ID
   and  B.ACCOUNT_NO = C.ACCOUNT_NO
   --and  B.PAY_METHOD = 1
   
 select * from payment_profile where account_no = 7680768
   
 select * from payment_trans
 
 grant all on VERIPARCELAMENTO to public
 
 select * from all_tables where owner = 'G0023421SQL'
 
 select * from g0023421sql.VERIPARCELAMENTO