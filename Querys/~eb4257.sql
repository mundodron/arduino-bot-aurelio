select B.TRACKING_ID
  from g0023421sql.GVT_ERRO_SANTANDER S,
       bmf B
 where S.account_no is not null
   and S.ACCOUNT_NO = B.ACCOUNT_NO
   and S.BILL_REF_NO = B.ORIG_BILL_REF_NO
   and B.DISTRIBUTED_AMOUNT = 0
   and S.ACCOUNT_NO IS not null
   order by s.bill_period
   --and S.BILL_PERIOD = 'M28'
   --and external_id = '999984786425'
   --group by B.TRACKING_ID 
  -- HAVING count(*) > 1
  
  select * from GVT_FEBRABAN_BILL_INVOICE where bill_ref_no in (111570148,111568521,111569932,111568934,111568725,111568940,111570511,111570912,111568134,111569325,111571312)
  
     grant all on GVT_ERRO_SANTANDER to public