    select account_no
      from cmf_balance 
     where CHG_WHO = 'G0010724SQL                    '
       and trunc(CHG_DATE) = to_date('15/02/2013','DD/MM/YYYY')
     group by account_no having count(1) > 1
     
     ACCOUNT_NO

4143698
3643599
4392401
2273230
3419065

     
 select * from bmf where account_no in (4143698,3643599,4392401,2273230,3419065,4618459,4908215,6762467,7317512,7338290,4561495,4511342,4595452)
     and TRANS_SUBMITTER = 'ARBORGVT_BILLING              '
      and trunc(CHG_DATE) = to_date('15/02/2013','DD/MM/YYYY')
      
      select * from bmf where orig_bill_ref_no = 130714445