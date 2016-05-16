DECLARE
AUX_GLOBAL_NAME     VARCHAR(100);

CURSOR FATURA IS
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
   and BILL.PREP_STATUS = 4
   and bill.PREP_DATE > sysdate - 15
   and bill.PREP_ERROR_CODE is null
   and det.type_code IN (3, 4)
   and bill.BILL_REF_NO = det.BILL_REF_NO
   and det.description_code = de.description_code
   and de.language_code = 2
   and bill.BILL_REF_RESETS = det.BILL_REF_RESETS
   and EXISTS (SELECT 1 FROM cmf WHERE CMF.ACCOUNT_NO = MAP.ACCOUNT_NO and CMF.ACCOUNT_CATEGORY in (10,11))
   --and DET.SUBTYPE_CODE in (12500, 12501)
   and MAP.EXTERNAL_ID = '899999736835'
   group by map.external_id ;
   
   CURSOR C2 ATRASO
    
   ;

    BEGIN
    select trim(GLOBAL_NAME) into AUX_GLOBAL_NAME from GLOBAL_NAME;
    dbms_output.put_line( 'Inicio - ' || AUX_GLOBAL_NAME || ' : ' || to_char( sysdate ,'dd/mm/yyyy - hh24:mi:ss'));
    dbms_output.put_line( '        ');
    dbms_output.put_line( 'CONTA_COBRANCA' ||' ; '|| 'DESCRICAO_SERVICO' ||' ; '|| 'FATURA' ||' ; '|| 'VENCIMENTO_FATURA_ATUAL' ||' ; '|| 'VALOR_FATURA_ATUAL' ||' ; '|| 'VALOR_ENCARGOS_FATURA_ATUAL' ||' ; '|| 'VENCIMENTO_FATURA_PAGA_ATRASO' ||' ; '|| 'DATA_PAGAMENTO_FATURA_ATRASADA' ||' ; '|| 'VL_FATURA_EM_ATRASO' ||' ; '|| 'VL_FATURA_ATRASO_SEM_ENCARGOS' );
    
            FOR C1 IN FATURA LOOP
            BEGIN
                dbms_output.put_line( C1.CONTA_COBRANCA ||' ; '|| C1.DESCRICAO_SERVICO ||' ; '|| C1.FATURA ||' ; '|| C1.VENCIMENTO_FATURA_ATUAL ||' ; '|| C1.VALOR_FATURA_ATUAL ||' ; '|| C1.VALOR_ENCARGOS_FATURA_ATUAL ||' ; '|| C1.VENCIMENTO_FATURA_PAGA_ATRASO ||' ; '|| C1.DATA_PAGAMENTO_FATURA_ATRASADA ||' ; '|| C1.VL_FATURA_EM_ATRASO ||' ; '|| C1.VL_FATURA_ATRASO_SEM_ENCARGOS );
            END;
       END LOOP;

    --COMMIT;
    dbms_output.put_line( '______________________________________________________________________________________');
    dbms_output.put_line( 'Fim do processo: ' || to_char( sysdate ,'dd/mm/yyyy - hh24:mi:ss'));
END;
/