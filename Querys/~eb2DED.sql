select *
  from gvt_rajadas_bill g,
       customer_id_acct_map m,
       cmf_balance b
 where G.ACCOUNT_NO = m.account_no
   and M.INACTIVE_DATE is null
   and m.external_id_type = 1
   and B.ACCOUNT_NO = G.ACCOUNT_NO
   and G.V_PAGO = B.TOTAL_DUE
   and B.BILL_REF_NO = G.BILL_REF_NO
   
   
     update gvt_rajadas_bill set status = 00 