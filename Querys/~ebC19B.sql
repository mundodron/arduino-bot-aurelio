   select C.EXTERNAL_ID
     from customer_id_equip_map c,
          bill_invoice_detail d
    where C.SUBSCR_NO = D.SUBSCR_NO
      and C.SUBSCR_NO_RESETS = D.SUBSCR_NO_RESETS
      --and C.INACTIVE_DATE is null
      and C.EXTERNAL_ID_TYPE = 1
      and D.BILL_REF_NO = 113556654
      
      
  select * from customer_id_equip_map where external_id = '8130398017' and inactive_date is null and external_id_type = 1
      
      and d.bill_ref_no in (select bill_ref_no from g0023421sql.GVT_ERRO_SANTANDER where account_no is not null and external_id = 999984786425)


external_id = 999984786425