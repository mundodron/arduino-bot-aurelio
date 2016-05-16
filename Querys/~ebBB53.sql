select R.external_ID, R.BILL_REF_NO, f.ACCOUNT_NO, f.TRACKING_ID, f.TRACKING_ID_SERV, f.TRANS_AMOUNT,  R.V_PAGO, F.GL_AMOUNT, f.PAY_METHOD, f.TRANS_SUBMITTER
  from bmf f,
       G0023421SQL.GVT_RAJADAS_bill R
  where F.ACCOUNT_NO = R.ACCOUNT_NO
    and F.ORIG_BILL_REF_NO = R.BILL_REF_NO
    -- and F.DISTRIBUTED_AMOUNT = 0
    and R.V_PAGO = F.TRANS_AMOUNT
    and R.status = 999
    and R.ACCOUNT_NO is not null;
    
    
select *
  from bmf_distribution
 where bmf_tracking_id in (64372488,64373497) 
   and orig_bill_ref_no not in ( 97326609,0)
   
   select * from gvt_rajadas_bill where bill_ref_no = 97326609 --11057

    
    select D.*
      from BMF_DISTRIBUTION D,
           BMF B,
           G0023421SQL.GVT_RAJADAS_bill R
     where D.bmf_tracking_id = B.TRACKING_ID 
       and D.orig_bill_ref_no <> 0
       and D.orig_bill_ref_no <> B.orig_bill_ref_no
       and B.ACCOUNT_NO = R.ACCOUNT_NO
       and D.ACCOUNT_NO = B.ACCOUNT_NO
       and R.BILL_REF_NO = B.ORIG_BILL_REF_NO
       and R.V_PAGO = B.TRANS_AMOUNT
       and R.STATUS = 999
       and R.ACCOUNT_NO is not null
       and R.V_PAGO = B.TRANS_AMOUNT;
       
       
       
       select * from all_tables where table_name like '%%' 
       
       
       select * from bank_seqs order by bank_id