/*
Conta Cobrança    Descrição "Serviço"    Vencimento fatura atual    Valor fatura atual    Valor encargos fatura atual    Vencimento da fatura paga em atraso    Data pagamento da fatura atrasada    Valor da Fatura em atraso    Valor da fatura em atraso sem encargos (se tiver )
899999736835         Juros e Multa               15/abr                 R$ 297,22               R$ 8,91    15/fev    10/mar    10/jun    R$ 159,03
*/

select map.external_id            "CONTA_COBRANCA",
       --de.description_text        "DESCRICAO_SERVICO",
       --BILL.BILL_REF_NO           "FATURA",
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
   and BILL.PREP_STATUS = 4
   --and bill.PREP_DATE > sysdate - 5
   and bill.PREP_ERROR_CODE is null
   and det.type_code IN (3, 4)
   and bill.BILL_REF_NO = det.BILL_REF_NO
   and det.description_code = de.description_code
   and de.language_code = 2
   and bill.BILL_REF_RESETS = det.BILL_REF_RESETS
   and EXISTS (SELECT 1 FROM cmf WHERE CMF.ACCOUNT_NO = MAP.ACCOUNT_NO and CMF.ACCOUNT_CATEGORY in (10,11))
   and DET.SUBTYPE_CODE in (12500, 12501)
   and MAP.EXTERNAL_ID = '899999736835'
   group by map.external_id 

select * from cmf where CONTACT1_PHONE

select * from GVT_LOTERICA_CONSULTA_CPFCNPJ where CONTACT1_PHONE = '03106066911'

select * from all_tables where table_name like '%CPF%'

select map.external_id            "CONTA_COBRANCA",
       de.description_text        "DESCRICAO_SERVICO",
       BILL.BILL_REF_NO           "FATURA",
       bill.PAYMENT_DUE_DATE      "VENCIMENTO_FATURA_ATUAL",
       (det.amount + det.federal_tax) "VALOR_FATURA_ATUAL",
       det.federal_tax              "VALOR_ENCARGOS_FATURA_ATUAL",
       null    "VENCIMENTO_FATURA_PAGA_ATRASO",
       null    "DATA_PAGAMENTO_FATURA_ATRASADA",
       null    "VL_FATURA_EM_ATRASO",
       null    "VL_FATURA_ATRASO_SEM_ENCARGOS",
       det.type_code
  from customer_id_acct_map map,
       bill_invoice bill,
       bill_invoice_detail det,
       descriptions de
 where inactive_date is null
   and external_id_type = 1
   and MAP.ACCOUNT_NO = BILL.ACCOUNT_NO
   --and bill.BILL_PERIOD = 'M20'
   and BILL.PREP_STATUS = 4
   --and bill.PREP_DATE > sysdate - 5
   and bill.PREP_ERROR_CODE is null
   and det.type_code IN (3, 4)
   and bill.BILL_REF_NO = det.BILL_REF_NO
   and det.description_code = de.description_code
   and de.language_code = 2
   and bill.BILL_REF_RESETS = det.BILL_REF_RESETS
   --and EXISTS (SELECT 1 FROM cmf WHERE CMF.ACCOUNT_NO = MAP.ACCOUNT_NO and CMF.ACCOUNT_CATEGORY in (10,11))
   --and DET.SUBTYPE_CODE in (12500, 12501)
   and MAP.EXTERNAL_ID = '899999736835'
   
   and det.component_id = 12500
   
   select * from customer_id_acct_map where external_id = '899999736835'

   12500, 12501
   
   select * from bill_invoice where account_no = 7563523 and prep_status = 1
   
   select * from bill_invoice_detail where bill_ref_no = 178753769 and SUBTYPE_CODE in (12500, 12501)
   
   select * from nrc_key where tracking_id = 97627221
   
   
   select substr(annotation,16,9) as fatura_paga_em_atraso, n.*
      from nrc n
   where billing_account_no = 7563523
     and tracking_id = 129937608

   select *--, n.*
      from nrc n
   where billing_account_no = 7563523
     and tracking_id = 129937608

   