select * from cmf_balance where account_no = 815099


create table ativos as 
select MAP.EXTERNAL_ID,
       bill.account_no,
       bill.bill_ref_no,
       (BILL.Total_paid*-1/100) Total_pago
  from cmf_balance bill, 
       customer_id_acct_map map
 where MAP.EXTERNAL_ID = '999997315554'
   and BILL.ACCOUNT_NO = MAP.ACCOUNT_NO
   and MAP.EXTERNAL_ID_TYPE = 1
   and BILL.PPDD_DATE > trunc(sysdate - 90) 



select MAP.EXTERNAL_ID,
       bill.account_no,
       bill.bill_ref_no,
       (BILL.Total_paid*-1/100) Total_pago
  from cmf_balance bill, 
       customer_id_acct_map map
 where MAP.EXTERNAL_ID = '999997315554'
   and BILL.ACCOUNT_NO = MAP.ACCOUNT_NO
   and MAP.EXTERNAL_ID_TYPE = 1
   and BILL.PPDD_DATE > trunc(sysdate - 90) and  BILL.PPDD_DATE < trunc(sysdate - 60) 
   
   
select MAP.EXTERNAL_ID,
       bill.account_no,
       bill.bill_ref_no,
       (BILL.Total_paid*-1/100) Total_pago
  from cmf_balance bill, 
       customer_id_acct_map map
 where MAP.EXTERNAL_ID = '999997315554'
   and BILL.ACCOUNT_NO = MAP.ACCOUNT_NO
   and MAP.EXTERNAL_ID_TYPE = 1
   and BILL.PPDD_DATE > trunc(sysdate - 60) and  BILL.PPDD_DATE < trunc(sysdate - 30)
   
select MAP.EXTERNAL_ID,
       bill.account_no,
       bill.bill_ref_no,
       (BILL.Total_paid*-1/100) Total_pago
  from cmf_balance bill, 
       customer_id_acct_map map
 where MAP.EXTERNAL_ID = '999997315554'
   and BILL.ACCOUNT_NO = MAP.ACCOUNT_NO
   and MAP.EXTERNAL_ID_TYPE = 1
   and BILL.PPDD_DATE > trunc(sysdate - 90)
   
   
   
   
   select * from ativos
   
   INSERT INTO ativos (EXTERNAL_ID) VALUES (999997315554);