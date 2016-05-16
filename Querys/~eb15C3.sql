   SELECT e.amount, bal.NEW_CHARGES, gvt.bill_amount, gvt.bill_ref_no
     FROM gvt_bill_invoice_total gvt,
          PAYMENT_TRANS e,
          cmf_balance bal
    WHERE e.bill_ref_no = gvt.bill_ref_no
      and e.bill_ref_no = bal.bill_ref_no
      AND e.amount <> gvt.bill_amount
      --AND e.amount <> BAL.NEW_CHARGES
      AND e.trans_status = 0
      
      and trunc(E.CHG_DATE) >= to_date ('19/04/2012','dd/mm/yyyy')
      
      
      