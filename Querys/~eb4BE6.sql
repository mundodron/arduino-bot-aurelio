
select A.account_no, count(1)
  from cmf_balance A,
       citibank_lbx B
  where A.ACCOUNT_NO = B.ACCOUNT_NO
    and A.BILL_REF_NO = B.bill_ref_no
    and A.BILL_REF_NO <> 0
    group by A.account_no
    order by 2 asc
    
    select * from cmf_balance where bill_ref_no = 133564998