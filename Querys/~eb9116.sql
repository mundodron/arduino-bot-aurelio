update GVT_ERRO_SANTANDER SS set SS.telefone = (
select C.EXTERNAL_ID
    from bill_invoice_detail B,
          customer_id_equip_map c,
          service s,
          GVT_ERRO_SANTANDER G
   where B.SUBSCR_NO = C.SUBSCR_NO
     --and C.EXTERNAL_ID_type = 1
     and C.INACTIVE_DATE is null
     and B.SUBSCR_NO = S.SUBSCR_NO
     and B.SUBSCR_NO_RESETS = S.SUBSCR_NO_RESETS
     and G.ACCOUNT_NO = S.PARENT_ACCOUNT_NO
     and G.BILL_REF_NO = B.BILL_REF_NO
     and SS.ACCOUNT_NO = G.ACCOUNT_NO
     and SS.BILL_REF_NO = G.BILL_REF_NO
     --and B.BILL_INVOICE_ROW = 1
     --and B.RATE_PERIOD = 'R'
     and B.DESCRIPTION_CODE = 10033 
     )
     where telefone is null
     
     
 select * from GVT_ERRO_SANTANDER where telefone is null
 
 select * from bill_invoice_detail