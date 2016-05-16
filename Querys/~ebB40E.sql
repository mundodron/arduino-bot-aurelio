select * from all_tables where table_name like '%CPF%' 

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
 
 
  
select count(*)
  from g0007405sql.TRACKS_CEF_7244 A,
       bmf B
 where  A.TRACKING_ID = B.TRACKING_ID
 
 
 select count(*) from g0007405sql.TRACKS_CEF_7244
  
 select * from cmf_balance where account_no = 1076084
 
 select * from BMF_DISTRIBUTION where account_no = 1076084 and bill_ref_no = 22163536
                                                                             80468773