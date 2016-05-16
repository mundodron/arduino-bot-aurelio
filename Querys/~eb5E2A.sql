DECLARE
  AUX_GLOBAL_NAME                  VARCHAR2(100);
  V_ACCOUNT_NO                      NUMBER(10);
  V_BILL_REF_NO                     NUMBER(10);
  V_CONTA_COBRANCA                  NUMBER(12);
  V_DESCRICAO_SERVICO               VARCHAR2(20);
  V_FATURA                          NUMBER(10);
  V_FATURA_PAGA_ATRASO              NUMBER(10);
  V_VENCI_FAT_ATUAL                 DATE;
  V_VALOR_FATURA_ATUAL              NUMBER(12);
  V_VALOR_ENCARGOS_FATURA_ATUAL     NUMBER(12);
  V_VENCI_FATURA_PAGA_ATRASO        NUMBER(12);
  V_DATA_PGTO_FATURA_ATRASADA       DATE;
  V_VL_FATURA_EM_ATRASO             NUMBER(12);
  V_VL_FAT_ATRASO_SEM_ENCARGOS   NUMBER(12);
  
CURSOR FATURA_ATUAL IS
select max(map.account_no) "ACCOUNT_NO",
       map.external_id            "CONTA_COBRANCA",
       null        "DESCRICAO_SERVICO",
       max(BILL.BILL_REF_NO)           "FATURA",
       max(bill.PAYMENT_DUE_DATE)      "VENCIMENTO_FATURA_ATUAL",
       sum(det.amount + det.federal_tax) "VALOR_FATURA_ATUAL",
       sum(det.federal_tax)              "VALOR_ENCARGOS_FATURA_ATUAL"
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
   group by map.external_id;
   
  
  CURSOR FATURA_ATRASO IS
  SELECT N.BILL_REF_NO  "FATURA_PAGA_ATRASO",
         N.PPDD_DATE    "VENCI_FATURA_PAGA_ATRASO",
         N.CLOSED_DATE  "DATA_PGTO_FATURA_ATRASADA",
         N.TOTAL_DUE    "VL_FATURA_EM_ATRASO"
    FROM CMF_BALANCE n
   WHERE n.bill_ref_no in ( SELECT   to_number(trim(substr(annotation,16,9))) as fatura_paga_em_atraso
                              FROM   nrc, nrc_key nk
                             WHERE   nk.tracking_id = nrc.tracking_id
                               AND   nk.tracking_id_serv = nrc.tracking_id_serv
                               AND   nrc.billing_account_no = 1916465 -- IN (SELECT   account_no
                                  --       FROM   g0023421sql.GVT_REL_ENCARGOS
                                  --     WHERE   ROWNUM < 3000)
                             --AND nk.bill_ref_no = 0
                               AND nrc.type_id_nrc IN (12500, 12501)
                               AND nrc.no_bill = 0);
                               

    BEGIN
    select trim(GLOBAL_NAME) into AUX_GLOBAL_NAME from GLOBAL_NAME;
    dbms_output.put_line( 'Inicio - ' || AUX_GLOBAL_NAME || ' : ' || to_char( sysdate ,'dd/mm/yyyy - hh24:mi:ss'));
    dbms_output.put_line( '        ');
    dbms_output.put_line( 'CONTA_COBRANCA' ||' ; '|| 'DESCRICAO_SERVICO' ||' ; '|| 'FATURA' ||' ; '|| 'VENCIMENTO_FATURA_ATUAL' ||' ; '|| 'VALOR_FATURA_ATUAL' ||' ; '|| 'VALOR_ENCARGOS_FATURA_ATUAL' ||' ; '|| 'VENCIMENTO_FATURA_PAGA_ATRASO' ||' ; '|| 'DATA_PAG_FATURA_ATRASADA' ||' ; '|| 'VL_FATURA_EM_ATRASO' ||' ; '|| 'VL_FATURA_ATRASO_SEM_ENCARGOS' );
    
         FOR C2 IN FATURA_ATRASO LOOP
            BEGIN
            V_FATURA_PAGA_ATRASO := C2.FATURA_PAGA_ATRASO;
            --V_VENCI_FATURA_PAGA_ATRASO := C2.VENCI_FATURA_PAGA_ATRASO;
            V_DATA_PGTO_FATURA_ATRASADA  := C2.DATA_PGTO_FATURA_ATRASADA;

            END;
       END LOOP; --C2

      FOR C1 IN FATURA_ATUAL LOOP
            BEGIN

            V_ACCOUNT_NO := C1.ACCOUNT_NO;
            V_BILL_REF_NO :=  C1.FATURA;
            V_CONTA_COBRANCA := C1.CONTA_COBRANCA;
            V_DESCRICAO_SERVICO := C1.DESCRICAO_SERVICO;
            V_FATURA := C1.FATURA;
            V_VENCI_FAT_ATUAL := C1.VENCIMENTO_FATURA_ATUAL;
            V_VALOR_FATURA_ATUAL := C1.VALOR_FATURA_ATUAL;
            V_VALOR_ENCARGOS_FATURA_ATUAL := C1.VALOR_ENCARGOS_FATURA_ATUAL;

             dbms_output.put_line(V_ACCOUNT_NO ||' ; '|| V_BILL_REF_NO ||' ; '|| V_CONTA_COBRANCA ||' ; '|| V_DESCRICAO_SERVICO ||' ; '|| V_FATURA ||' ; '|| V_FATURA_PAGA_ATRASO ||' ; '|| V_VENCI_FAT_ATUAL ||' ; '|| V_VALOR_FATURA_ATUAL ||' ; '|| V_VALOR_ENCARGOS_FATURA_ATUAL ||' ; '|| V_VENCI_FATURA_PAGA_ATRASO ||' ; '|| V_DATA_PGTO_FATURA_ATRASADA ||' ; '|| V_VL_FATURA_EM_ATRASO ||' ; '|| V_VL_FAT_ATRASO_SEM_ENCARGOS);

            END;
       END LOOP; --C1
       
    -- COMMIT;
    dbms_output.put_line( '______________________________________________________________________________________');
    dbms_output.put_line( 'Fim do processo: ' || to_char( sysdate ,'dd/mm/yyyy - hh24:mi:ss'));
END;
/