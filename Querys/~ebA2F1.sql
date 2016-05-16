create table bill_invoice_detail_BK as(
select * from bill_invoice_detail
 where OPEN_ITEM_ID between 4 and 89
   and TYPE_CODE in  7
   and bill_ref_no in ( Select vava.bill_ref_no
   from g0010388sql.vrc_cdr_cob_zerado_1 vava,
        cmf_balance bl
 where VAVA.ACCOUNT_NO = BL.ACCOUNT_NO
   and VAVA.BILL_ref_no = BL.BILL_REF_NO
   and BL.CLOSED_DATE is null)
   and AMOUNT = 0)
   
   
   
   
