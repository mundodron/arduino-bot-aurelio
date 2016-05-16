select * from cmf_balance where bill_ref_no in (select bill_ref_no from CITIBANK_LBX)

select * from cmf_balance where bill_ref_no = 134664740

select * from bmf where bill_ref_no = 134664740 and account_no = 3419065

select B.* 
  from CITIBANK_LBX A,
       cmf_balance B
 where A.BILL_REF_NO = B.BILL_REF_NO
   and A.ACCOUNT_NO = B.ACCOUNT_NO


select *
  from bmf A,
       citibank_lbx B
  where A.ACCOUNT_NO = B.ACCOUNT_NO
    and A.orig_BILL_REF_NO = B.ACCOUNT_NO 
  
   where orig_bill_ref_no in (select bill_ref_no from )