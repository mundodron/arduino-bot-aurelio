select S.PARENT_ACCOUNT_NO
    from bill_invoice_detail B,
          customer_id_equip_map c,
          service s
   where B.SUBSCR_NO = C.SUBSCR_NO
     and C.EXTERNAL_ID_type = 1
     and C.INACTIVE_DATE is null
     and B.SUBSCR_NO = S.SUBSCR_NO
     and B.SUBSCR_NO_RESETS = S.SUBSCR_NO_RESETS;