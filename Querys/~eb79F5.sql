select * from cmf_balance where bill_ref_no in (select bill_ref_no from CITIBANK_LBX)

select * from cmf_balance where bill_ref_no = 132927018

select A.TOTAL_DUE, count(1)
  from cmf_balance A,
       citibank_lbx B
  where A.ACCOUNT_NO = B.ACCOUNT_NO
    and A.BILL_REF_NO = B.bill_ref_no
    --and A.BILL_REF_NO <> 0
    group by A.TOTAL_DUE
    having count(1) > 1
    
    and A.ACCOUNT_NO = 1865714
    
    select * from cmf_balance
    
    select account_no, count (*)
      from cmf_balance 
     where CHG_WHO = 'G0010724SQL                    '
       and trunc(CHG_DATE) = to_date('15/02/2013','DD/MM/YYYY')
     group by account_no
     having count(1) > 1
     
           select * from bmf where orig_bill_ref_no = 130714445
   
  
      select account_no
      from cmf_balance 
     where CHG_WHO = 'G0010724SQL                    '
       and trunc(CHG_DATE) = to_date('15/02/2013','DD/MM/YYYY')
     group by account_no having count(1) > 1
     
     
     select * from citibank_lbx where account_no in (4143698,3643599,4392401,2273230,3419065,4618459,4908215,6762467,7317512,7338290,4561495,4511342,4595452)
     
     select * from cmf_balance where account_no in (4143698,3643599,4392401,2273230,3419065,4618459,4908215,6762467,7317512,7338290,4561495,4511342,4595452)
     and CHG_WHO = 'G0010724SQL                    '
     
     select * from bmf where account_no in (4143698,3643599,4392401,2273230,3419065,4618459,4908215,6762467,7317512,7338290,4561495,4511342,4595452)
     and TRANS_SUBMITTER = 'ARBORGVT_BILLING              '
      and trunc(CHG_DATE) = to_date('15/02/2013','DD/MM/YYYY')
      --and orig_bill_ref_no = 133564998
      and account_no = 4511342
      
      
      select * from 
     