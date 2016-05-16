ALTER TABLE G0023421SQL.GVT_REL_ENCARGOS
MODIFY(CONTA_COBRANCA VARCHAR2(20));

select * from GVT_REL_ENCARGOS


update GVT_REL_ENCARGOS a set (a.account_no) = (select m.account_no from customer_id_acct_map m where M.EXTERNAL_ID = to_char(a.CONTA_COBRANCA) and m.external_id_type = 1 and m.inactive_date is null )  

update GVT_REL_ENCARGOS a set (VALOR_ENCARGOS_FATURA_ATUAL) = ( 
select sum(det.amount + det.federal_tax)
  from customer_id_acct_map map,
       bill_invoice bill,
       bill_invoice_detail det,
       descriptions de
 where inactive_date is null
   and external_id_type = 1
   and MAP.ACCOUNT_NO = BILL.ACCOUNT_NO
   and bill.BILL_PERIOD = 'M28'
   and BILL.PREP_STATUS = 4
   and bill.PREP_DATE > sysdate - 15
   and bill.PREP_ERROR_CODE is null
   --and det.type_code IN (3, 4)
   and bill.BILL_REF_NO = det.BILL_REF_NO
   and det.description_code = de.description_code
   and de.language_code = 2
   and bill.BILL_REF_RESETS = det.BILL_REF_RESETS
   and EXISTS (SELECT 1 FROM cmf WHERE CMF.ACCOUNT_NO = MAP.ACCOUNT_NO and CMF.ACCOUNT_CATEGORY in (10,11))
   and DET.SUBTYPE_CODE in (12500, 12501)
   and MAP.EXTERNAL_ID = A.CONTA_COBRANCA
   --and MAP.ACCOUNT_NO = 7563523
   --and BILL.BILL_REF_NO = 156180943
   group by map.external_id);
