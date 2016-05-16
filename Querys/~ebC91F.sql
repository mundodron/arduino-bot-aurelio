select map.external_id            "CONTA_COBRANCA",
       de.description_text        "DESCRICAO_SERVICO",
       BILL.BILL_REF_NO           "FATURA",
       bill.PAYMENT_DUE_DATE      "VENCIMENTO_FATURA_ATUAL",
       det.amount + det.federal_tax "VALOR_FATURA_ATUAL",
       det.federal_tax              "VALOR_ENCARGOS_FATURA_ATUAL"
  from customer_id_acct_map map,
       bill_invoice bill,
       bill_invoice_detail det,
       descriptions de
 where inactive_date is null
   and external_id_type = 1
   and MAP.ACCOUNT_NO = BILL.ACCOUNT_NO
   --and bill.BILL_PERIOD = 'M28'
   and BILL.PREP_STATUS = 4
   and bill.PREP_DATE > sysdate - 25
   and bill.PREP_ERROR_CODE is null
   and det.type_code IN (3, 4)
   and bill.BILL_REF_NO = det.BILL_REF_NO
   and det.description_code = de.description_code
   and de.language_code = 2
   and bill.BILL_REF_RESETS = det.BILL_REF_RESETS
   and EXISTS (SELECT 1 FROM cmf WHERE CMF.ACCOUNT_NO = MAP.ACCOUNT_NO and CMF.ACCOUNT_CATEGORY in (10,11))
   and DET.SUBTYPE_CODE in (12500, 12501)
   --and MAP.EXTERNAL_ID = '899999736835'
   
   
   