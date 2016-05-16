select External_id, account_no, Bill_ref_no, cnpj, valor 
  from gvt_nrc_invalida
 where status is null and account_no is not null
   and account_no in (select account_no from cmf_balance_detail C where C.OPEN_ITEM_ID in (91,92))
group by (External_id, account_no, Bill_ref_no, cnpj, valor);