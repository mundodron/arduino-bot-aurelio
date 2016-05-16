select bid.*
  from bill_invoice b,
       bill_invoice_detail bid
 where 1 = 1
   and b.bill_ref_no = bid.bill_ref_no
   and b.bill_ref_resets = bid.bill_ref_resets
   and b.bill_ref_no = 109365502 
   
   and type_code = 7
   
   select * from cmf_balance where account_no = 4143698 
   
   select * from cmf_balance where bill_ref_no = 134860477
   
   select * from bmf where account_no = 4143698 order by TRANS_SUBMITTER
   
   select * from bmf where account_no = 4143698 order by TRANS_SUBMITTER
   
   
   BILL_REF_NO    CLOSED_DATE    TOTAL_PAID    CHG_DATE    CHG_WHO

0                                   -38939    15/02/2013 19:34:36    G0010724SQL                   
133788796    15/02/2013 19:33:54    -38939    15/02/2013 19:33:54    G0010724SQL  


select * from bmf where account_no = 4143698 order by chg_date 

select * from cmf_balance where trunc(chg_date) = to_date('15/02/2013','dd/mm/yyyy') and CHG_WHO = 'G0010724SQL'
 and account_no in (4143698,3643599,4392401,2273230,3419065)

group by account_no HAVING count(1) > 1          

select * from cmf_balance where account_no in (4143698,3643599,4392401,2273230,3419065)

select account_no from cmf_balance where bill_ref_no in (134457092,132623183,133085843,134019210,134951309,135002529,133523316,130714445,134128014,135467162,134455446,134506309,134951093,134980488,135512112,134949834,134953088,134127781,133460023,134386461,135023012,134387509,134144132,135010475,132578797,133537049,134952451,134997152,134994457,134996813,134946311,135122162,134648024,134711886,135198281,134278606,135129657,135065911,132927018,135630652,135146945,135686922,135646704,133766162,135188130,134634529,134267045,131789009,134680821,134685964,134697915,134190632,133885153,133849132,133543370,134000086,134070677,133564998,133499663,134860477,133788796,135702118,132793750,134664740,133543370,134019210,134951309,135002529,134000086,134070677,133564998,133499663,134860477,133788796,135702118,132793750,134664740)


  select ACCOUNT_NO, BILL_REF_NO, CLOSED_DATE, TOTAL_PAID, TOTAL_DUE, CHG_DATE  from cmf_balance where account_no in (4143698,3643599,4392401,2273230,3419065) and CHG_WHO = 'G0010724SQL'
  
   select * from gvt_bankslip where bill_ref_no = 130911388