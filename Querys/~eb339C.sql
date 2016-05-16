select * from bill_invoice where bill_ref_no = 173903103

select * from GVT_BILL_INVOICE_TOTAL_TAX

select * from gvt_bill_invoice_total where bill_ref_no = 177801384

select * from gvt_bill_invoice_total_tax where bill_ref_no = 177801384

select * from bill_invoice_detail where bill_ref_no = 177801384

select * from all_tables where table_name like '%TAX%' and owner like'%ARBOR%'

select * from TAX_ASSIGNMENTS 

select * from GVT_TAXAS_IMPOSTOS

select BT.BILL_REF_NO, TI.RATE, TI.SHORT_DISPLAY, TI.DISPLAY_VALUE, TI.FIXED_AMT, BT.BILL_INVOICE_ROW
  from BILL_INVOICE_TAX bt,
       GVT_TAXAS_IMPOSTOS ti,
       bill_invoice_detail bi
 where bt.bill_ref_no = 177801384
   and BT.TAX_PKG_INST_ID = TI.TAX_PKG_INST_ID
   and TI.LANGUAGE_CODE = 2
   and BI.BILL_REF_NO = BT.BILL_REF_NO
   and BT.BILL_INVOICE_ROW = BI.BILL_INVOICE_ROW
   and BT.BILL_REF_NO = 177801384
   
   select * from BILL_INVOICE_TAX where bill_ref_no = 127400108
   
   select * from bill_invoice_detail where bill_ref_no = 127400108