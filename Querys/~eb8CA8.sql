select B.TRACKING_ID
  from g0023421sql.GVT_ERRO_SANTANDER S,
       bmf B
 where S.account_no is not null
   and S.ACCOUNT_NO = B.ACCOUNT_NO
   and S.BILL_REF_NO = B.ORIG_BILL_REF_NO
   and B.DISTRIBUTED_AMOUNT = 0
   and S.ACCOUNT_NO IS not null
   
   and S.EXTERNAL_ID = 999989543951
   
   select * from customer_id_acct_map where external_id = '999989543951'
   
   select * from cmf_balance where account_no = 2504371 and bill_ref_no = 0
   
   select * from bmf where account_no = 2504371 and distributed_amount = 0
   
SELECT * FROM BMF WHERE TRACKING_ID IN
(select account_no, bill_ref_no, TRANS_AMOUNT, distributed_amount from bmf where account_no = 2504371 and distributed_amount = 0)


select BMF.TRANS_DATE, account_no, BMF.ORIG_BILL_REF_NO, bill_ref_no ,BMF.TRANS_AMOUNT, BMF.DISTRIBUTED_AMOUNT from bmf where account_no = 2504371  --and distributed_amount = 0
and trunc(BMF.TRANS_DATE) > to_date('10/06/2012', 'dd/mm/yyyy')



select B.*
    from bill_invoice_detail B,
          customer_id_equip_map c,
          service s,
          GVT_ERRO_SANTANDER G
   where B.SUBSCR_NO = C.SUBSCR_NO
     and C.EXTERNAL_ID_type = 1
     and C.INACTIVE_DATE is null
     and B.SUBSCR_NO = S.SUBSCR_NO
     and B.SUBSCR_NO_RESETS = S.SUBSCR_NO_RESETS
     and G.ACCOUNT_NO = S.PARENT_ACCOUNT_NO
     and G.BILL_REF_NO = B.BILL_REF_NO
     --and B.BILL_INVOICE_ROW = 1
     --and B.RATE_PERIOD = 'R'
     --and B.DESCRIPTION_CODE = 11448 
     and G.TELEFONE is null