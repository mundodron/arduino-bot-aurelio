select G.*
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
--      and SS.ACCOUNT_NO = G.ACCOUNT_NO
--     and SS.BILL_REF_NO = G.BILL_REF_NO
     --and B.BILL_INVOICE_ROW = 1
     --and B.RATE_PERIOD = 'R'
     --and B.DESCRIPTION_CODE = 10033
     and g.telefone is null
     
     
       select account_no,
              Bill_ref_no,
              Valor,
              -- Status Bixas,
              Bill_period,
              Telefone,
              Conta_serv
        from G0023421SQL.GVT_ERRO_SANTANDER