


--------------------------------------------------------------------------------
-- Lista a quantidade de Faturas que não geraram pelo menos 1 Nota Fiscal

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


--------------------------------------------------------------------------------
-- Query da PL exclui_fatura_zerada

/*12 cmf_balance */Select account_no, bill_ref_no, ppdd_date, orig_ppdd_date, trunc(closed_date) closed_date, new_charges/100 new_charges, total_adj/100 total_adj, total_paid/100 total_paid, (new_charges+total_adj+total_paid)/100 "devedor", balance_due/100 balance_due, open_item_id open_item, replace(external_id,'GVT Co-billing ',null) external_id, trunc(chg_date) chg_date from cmf_balance_detail det where ( (account_no = :account_no) or (bill_ref_no = :bill_ref_no) )

/*12 sin_seq_no */Select sin.bill_ref_no, sin.sin_seq_ref_no, trim(sin.full_sin_seq) full_sin_seq, sin.group_id, trunc(sin.prep_date) prep_date, sin.payment_due_date, sin.statement_date, lpad(sin.open_item_id,2,' ')||' · '||replace(oVal.display_value,'GVT Co-billing ','') open_item_id, nfst.amount, nfst.serie_nf, nfst.subserie_nf, nfst.hash_code from open_item_id_values oVal, GVT_BILL_INVOICE_NFST nfst, SIN_SEQ_NO sin WHERE :bill_ref_no is null and sin.full_sin_seq = rpad(:Nota_Fiscal,80,' ') and sin.prep_date > sysdate-60 and nfst.bill_ref_no(+) = sin.bill_ref_no and nfst.open_item_id(+) = sin.open_item_id and oVal.open_item_id(+) = sin.open_item_id and oVal.language_code(+) = 2 UNION Select sin.bill_ref_no, sin.sin_seq_ref_no, trim(sin.full_sin_seq) full_sin_seq , sin.group_id, trunc(sin.prep_date) prep_date, sin.payment_due_date, sin.statement_date, lpad(sin.open_item_id,2,' ')||' · '||replace(oVal.display_value,'GVT Co-billing ','') open_item_id, nfst.amount, nfst.serie_nf, nfst.subserie_nf, nfst.hash_code from open_item_id_values oVal, GVT_BILL_INVOICE_NFST nfst, SIN_SEQ_NO sin WHERE :bill_ref_no is not null and sin.bill_ref_no = :bill_ref_no and nfst.bill_ref_no(+) = sin.bill_ref_no and nfst.open_item_id(+) = sin.open_item_id  and oVal.open_item_id(+) = sin.open_item_id and oVal.language_code(+) = 2 order by prep_date desc


select --bi.account_no, bi.bill_ref_no, bi.prep_status, bi.format_status, bi.prep_error_code, cb.balance_due, cmf.bill_lname, cmf.bill_period
      count(distinct bi.bill_ref_no) qtde, prep_error_code
            --*
from  cmf_balance cb ,
            bill_invoice bi 
where bi.prep_date >= '02-feb-2012'
and bi.account_no = cb.account_no
and bi.bill_ref_no = cb.bill_ref_no
and cb.new_charges=0
and bi.prep_status = 1
and bi.prep_error_code is null
and not exists  (select 'X' from bill_invoice_detail x 
                          where x.bill_ref_no = bi.bill_ref_no
                          and x.type_code in (2,3,7)
                          and x.amount <> 0)
and exists (select 1 from sin_seq_no sin where sin.bill_ref_no = bi.bill_ref_no)
group by prep_error_code;