select c.*
    from bill_invoice_detail B,
          customer_id_equip_map c
   where B.SUBSCR_NO = C.SUBSCR_NO
     and C.EXTERNAL_ID = '1'
     and C.INACTIVE_DATE is null;