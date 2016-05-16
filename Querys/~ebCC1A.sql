  SELECT
  '999' as SEQUENCIAL,
  a.account_no as ACCOUNT_NO,
  e.external_id  as EXTERNAL_ID_A,
  a.subscr_no as SUBSCR_NO,
  a.subscr_no_resets as SUBSCR_NO_RESETS,
  F.EXTERNAL_ID as EXTERNAL_ID_B,
  c.BILL_LNAME,
  c.account_category,-- decode(c.account_category, 12,13,14,15,21,22,'C') as BILL_TIPO_CLIENTE,
  c.BILL_ADDRESS1,
  c.BILL_ADDRESS2,
  c.BILL_ADDRESS3,
  c.BILL_CITY,
  c.BILL_STATE,
  c.BILL_ZIP,
  a.orig_bill_ref_no,
  a.orig_bill_ref_resets,
  s.full_sin_seq as FULL_SIN_SEQ,
  trunc(d.ppdd_date) as PPDD_DATE,
  g.trans_amount as TOTAL_ADJ,
  g.trans_amount as BILL_DRAFT_AMOUNT,
  d.new_charges as BILL_AMOUNT,
  trunc(d.ppdd_date) as ORIG_PPDD_DATE,
  c.CUST_STATE as SHORT_DISPLAY,
  sysdate as DATA_MOVIMENTO,
  'T' as STATUS,
  sysdate as DATA_ATUALIZACAO
  FROM adj a,
       chamados b,
       cmf c,
       customer_id_acct_map e,
       sin_seq_no s,
       cmf_balance d,
       customer_id_equip_map f,
       bmf g
  where A.BILL_REF_NO = B.FATURA
    and A.ACCOUNT_NO = C.ACCOUNT_NO
    and A.BILL_REF_NO = S.BILL_REF_NO
    and A.BILL_REF_RESETS = S.BILL_REF_RESETS
    and A.BILL_REF_NO = D.BILL_REF_NO
    and A.BILL_REF_RESETS = D.BILL_REF_RESETS
    and A.ACCOUNT_NO = E.ACCOUNT_NO
    and E.EXTERNAL_ID_TYPE = 1
    and E.INACTIVE_DATE is null
    and A.SUBSCR_NO = F.SUBSCR_NO
    and A.SUBSCR_NO_RESETS = F.SUBSCR_NO_RESETS
    and G.ORIG_BILL_REF_NO = A.BILL_REF_NO
    and G.ORIG_BILL_REF_RESETS = A.BILL_REF_RESETS
    and G.ACCOUNT_NO = A.ACCOUNT_NO
  
  select * from gvt_bankslip
  
  select * from customer_id_equip_map
  
  select * from cmf
  
  select * from adj
  
  select * from gvt_bill_invoice_total
  
  decode(account_category, 12,13,14,15,21,22,'C')