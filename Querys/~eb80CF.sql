   select * from cmf_balance where bill_ref_no = 134860477
   
   select ACCOUNT_NO, BILL_REF_NO, CLOSED_DATE, TOTAL_PAID, TOTAL_DUE, CHG_DATE  from cmf_balance where account_no in (4595452,4511342,4561495,7338290,7317512,6762467,4618459,4908215) and CHG_WHO = 'G0010724SQL'
   
   select BILL_REF_NO, CLOSED_DATE, TOTAL_PAID, TOTAL_DUE, CHG_DATE from cmf_balance where trunc(chg_date) = to_date('15/02/2013','dd/mm/yyyy') and CHG_WHO = 'G0010724SQL'
  
 group by account_no order by 2
 
 select * from cmf_balance where bill_ref_no = 130475958
 
 select * from cmf_balance where account_no = 4511342 order by CHG_DATE
 
 select * from gvt_bankslip where bill_ref_no = 130911388