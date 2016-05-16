   SELECT *
     FROM gvt_bill_invoice_total gvt,
          PAYMENT_TRANS e,
          cmf_balance bal
    WHERE e.bill_ref_no = gvt.bill_ref_no
      and e.bill_ref_no = bal.bill_ref_no
      AND e.amount <> gvt.bill_amount
      AND e.amount <> bal.balance_due
      AND e.trans_status = 0
      
      
select external_id, bill_ref_no, valor from gvt_rajadas where status = 1 order by external_id

select * from gvt_rajadas where status is not nulld

select * from cmf_balance where bill_ref_no in (select bill_ref_no from gvt_rajadas) order by new_charges

select b.*
  from bmf b,
       gvt_rajadas r
where  b.orig_bill_ref_no = r.bill_ref_no
  and  B.ACCOUNT_NO = R.ACCOUNT_NO
  and  BMF_TRANS_TYPE <> 90
  and  r.status = 1
