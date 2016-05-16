select map.external_id            "CONTA_COBRANCA",
       null        "DESCRICAO_SERVICO",
       max(BILL.BILL_REF_NO)           "FATURA",
       max(bill.PAYMENT_DUE_DATE)      "VENCIMENTO_FATURA_ATUAL",
       sum(det.amount + det.federal_tax) "VALOR_FATURA_ATUAL",
       sum(det.federal_tax)              "VALOR_ENCARGOS_FATURA_ATUAL",
       null    "VENCIMENTO_FATURA_PAGA_ATRASO",
       null    "DATA_PAGAMENTO_FATURA_ATRASADA",
       null    "VL_FATURA_EM_ATRASO",
       null    "VL_FATURA_ATRASO_SEM_ENCARGOS"
  from customer_id_acct_map map,
       bill_invoice bill,
       bill_invoice_detail det,
       descriptions de
 where inactive_date is null
   and external_id_type = 1
   and MAP.ACCOUNT_NO = BILL.ACCOUNT_NO
   --and bill.BILL_PERIOD = 'M28'
   --and BILL.PREP_STATUS = 4
   --and bill.PREP_DATE > sysdate - 15
   and bill.PREP_ERROR_CODE is null
   --and det.type_code IN (3, 4)
   and bill.BILL_REF_NO = det.BILL_REF_NO
   and det.description_code = de.description_code
   and de.language_code = 2
   and bill.BILL_REF_RESETS = det.BILL_REF_RESETS
   and EXISTS (SELECT 1 FROM cmf WHERE CMF.ACCOUNT_NO = MAP.ACCOUNT_NO and CMF.ACCOUNT_CATEGORY in (10,11))
   and DET.SUBTYPE_CODE in (12500, 12501)
   --and MAP.EXTERNAL_ID = '899999736835'
   and MAP.ACCOUNT_NO = 7563523
   --and BILL.BILL_REF_NO = 156180943
   group by map.external_id ;
   
   select * from bill_invoice where bill_ref_no = 156180943