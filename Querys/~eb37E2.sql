select -- index (bil bill_invoice_xsum_bill_ref_no, bad cmf_balance_detail_xbll_rf_n)
       --+ index (bad cmf_balance_detail_xbll_rf_n)
        count(distinct bil.bill_ref_no) qtde
 from cmf_balance_detail bad, 
      bill_invoice bil
where bil.prep_date >= '02-feb-2012'
  and bil.prep_status = 1
    and bil.prep_error_code is null
    and bad.account_no = bil.account_no
  and bad.bill_ref_no = bil.bill_ref_no
  and bad.bill_ref_resets = bil.bill_ref_resets
    and not exists ( select 1 from sin_seq_no sin where sin.bill_ref_no = bil.bill_ref_no
                      and decode(bad.open_item_id,0,1,2,1,3,1,bad.open_item_id) = decode(sin.open_item_id,0,1,2,1,3,1,sin.open_item_id));