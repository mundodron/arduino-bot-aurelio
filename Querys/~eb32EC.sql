   SELECT e.bill_ref_no
     FROM gvt_bill_invoice_total gvt,
          PAYMENT_TRANS e,
          cmf_balance bal
    WHERE e.bill_ref_no = gvt.bill_ref_no
      and e.bill_ref_no = bal.bill_ref_no
      AND e.amount <> gvt.bill_amount
      AND e.amount <> bal.balance_due
      AND e.trans_status = 0
      
      update PAYMENT_TRANS P set p.amount = (select bill_amount from gvt_bill_invoice_total b where b.bill_ref_no = P.bill_ref_no) where bill_ref_no in (99596357,99598952,99597557,99596952,99598032,99597146,99597147,99597148,99597827,99598354)
      
      select * from gvt_bill_invoice_total
      
     (select bill_amount from gvt_bill_invoice_total where bill_ref_no = P.bill_ref_no)


select * from PAYMENT_TRANS where bill_ref_no = 99596357


select external_id, bill_ref_no, valor from gvt_rajadas where status = 1 order by external_id