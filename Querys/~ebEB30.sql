select map.external_id,
       cmf.bill_lname,
       LENGTH(cmf.bill_lname) "LENGTH",
       trunc(cmf.DATE_CREATED) DATE_CREATED
  from cmf,
       customer_id_acct_map map
 where cmf.account_no = map.account_no
   and LENGTH(bill_lname) >56 
   and external_id_type = 1
   and inactive_date is null
   and MAP.ACCOUNT_NO = 2671018 
   
 order by 4 desc
 
 
 select * from cmf_balance where bill_ref_no = 267143812 