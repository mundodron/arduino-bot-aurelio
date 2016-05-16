select distinct C.EXTERNAL_ID, B.BILL_REF_NO
    from bill_invoice_detail B,
          customer_id_equip_map c,
          service s,
          GVT_ERRO_SANTANDER G
   where B.SUBSCR_NO = C.SUBSCR_NO
     and C.EXTERNAL_ID_type = 3
     and C.INACTIVE_DATE is null
     and B.SUBSCR_NO = S.SUBSCR_NO
     and B.SUBSCR_NO_RESETS = S.SUBSCR_NO_RESETS
     and G.ACCOUNT_NO = S.PARENT_ACCOUNT_NO
     and G.BILL_REF_NO = B.BILL_REF_NO


select * from GVT_ERRO_SANTANDER

select max(subscr_no) from bill_invoice_detail where bill_ref_no = 113296478 and account_no = 8134295416

select * from bill_invoice_detail where bill_ref_no = 113296478 and BILL_INVOICE_ROW = 2



delete from GVT_ERRO_SANTANDER where account_no is null


