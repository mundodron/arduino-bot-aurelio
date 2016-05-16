      SELECT i.account_no,      i.from_date,             dateadd('dd', -1, i.to_date),           i.prep_date,
             i.statement_date,  i.special_code,          i.bill_hold_code,                       i.prep_error_code,
             i.currency_code,   r.format_code,           i.bill_disp_meth,                       i.pay_method,
             i.prev_bill_refno, i.prev_bill_ref_resets,  b.statement_date,                       dateadd('dd', -1, i.next_to_date),
             i.prep_status,     i.format_status,         i.from_date,                            i.interim_bill_flag,
             i.include_nrc,     i.include_rc,            i.include_adj,                          i.include_usage,
             i.include_bmf,     c.hierarchy_id,          i.prev_ppdd,                            i.bill_ref_no,
             i.bill_ref_resets, i.prev_balance_refno,    i.prev_balance_ref_resets,              i.backout_status,
             i.payment_due_date,                         to_char(i.statement_date, 'YYYY MM DD HH24:MI:SS')
      FROM   BILL_INVOICE i,      RATE_CURRENCY_REF r, BILL_INVOICE b, CMF c
      WHERE  i.bill_ref_no          = 246231919 -- :p_bill_ref_no
        AND  i.bill_ref_resets      = 0 -- :p_bill_ref_resets
        AND  i.currency_code        = r.currency_code
        AND  i.prev_bill_refno      = b.bill_ref_no (+)
        AND  i.prev_bill_ref_resets = b.bill_ref_resets (+)
        AND  i.account_no           = c.account_no;
