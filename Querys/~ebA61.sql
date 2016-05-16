select *
  from customer_id_acct_map C
 where external_id in ('777777727495','999982298387','999982298387','999982298387','999982298387','777777775034')
 
 select account_no, bill_ref_no 
   from cmf_balance
  where account_no in (select account_no
  from customer_id_acct_map C
 where external_id in  ('777777727495','999982298387','999982298387','999982298387','999982298387','777777775034'))
  and trunc(PPDD_DATE) >= to_date('01/08/2013','dd/mm/yyyy') 
  
  152225726
  
  
select * 
  from GVT_CONTA_INTERNET
 where ACCOUNT_NO in (6435913)
   and trunc(DATA_PROCESSAMENTO) = trunc(sysdate -1)