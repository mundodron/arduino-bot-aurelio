DECLARE
AUX_GLOBAL_NAME     VARCHAR(100);
AUX_CICLO           VARCHAR(10) := 'M15';
V_PATH              VARCHAR2 (100) := 'BILLING_FAT_LOG'; -- Diretorio onde sera gravado o arquivo ex: (BILLING_FAT_LOG) /app/GVT_DEV2/c2/billing/faturamento/log
V_FILENAME          VARCHAR2(50);
V_FILE              UTL_FILE.FILE_TYPE;

CURSOR FATURA IS
  SELECT   MAP.EXTERNAL_ID,
           B.BILL_PERIOD,
           d.element_id,
           d.bill_ref_no,
           d.type_code,
           d.subtype_code,
           de.description_text,
           ((d.amount + d.federal_tax))/100 valor,
           ((d.amount + d.federal_tax + d.discount))/100 valor_liq,
           (d.discount)/100 discount,
           (d.federal_tax)/100 federal_tax,
           d.bill_invoice_row,
           d.subscr_no,
           d.tax,
           d.tax_pkg_inst_id,
           d.tax_rate,
           B.FROM_DATE,
           B.TO_DATE,
           d.rate_type,
           DECODE (g.charge_id, NULL, 'S', 'N') aparece_nota,
           i.cod_fiscal,
           i.tipo_utilizacao,
           DECODE (o.subtype_code, NULL, 'N', 'S') subtype_outras,
           DECODE (f.discount_id, NULL, 0, f.discount_id) cod_desconto,
           PREP_DATE,
           k.UNITS,
           D.TRACKING_ID
    FROM   gvt_fatura_minima f,
           gvt_campo_outras o,
           gvt_classificacao_item i,
           gvt_cobilling_prod_fat g,
           bill_invoice_detail d,
           bill_invoice b,
           customer_id_acct_map map,
           descriptions de,
           product_rate_key k
   WHERE   d.bill_ref_resets = 0
           AND d.type_code IN (2, 3, 7)
           -- AND d.type_code IN (2, 3, 4, 7, 6, 5)
           AND g.charge_id(+) = d.subtype_code
           AND g.open_item_id(+) = d.open_item_id
           AND i.cod_gvt(+) = d.subtype_code
           AND o.subtype_code(+) = d.subtype_code
           AND f.description_code(+) = d.subtype_code
           AND d.description_code = de.description_code
           AND de.language_code = 2
           AND MAP.ACCOUNT_NO = B.ACCOUNT_NO
           AND MAP.INACTIVE_DATE is null
           AND MAP.EXTERNAL_ID_TYPE =1
           AND B.BILL_REF_NO = D.BILL_REF_NO
           AND B.BILL_REF_RESETS = D.BILL_REF_RESETS
           AND B.BILL_PERIOD = AUX_CICLO
           AND B.PREP_DATE > sysdate - 15
           AND B.PREP_STATUS = 4 --> 4 proforma 1 production
           AND D.TRACKING_ID = K.TRACKING_ID(+)
           AND B.PREP_ERROR_CODE is null
           --AND B.PREP_DATE in (select max(BILL.PREP_DATE) from bill_invoice bill where bill.account_no = B.ACCOUNT_NO and BILL.PREP_STATUS =1)
           AND EXISTS (SELECT 1 FROM cmf WHERE CMF.ACCOUNT_NO = MAP.ACCOUNT_NO and CMF.ACCOUNT_CATEGORY in (10,11));
    BEGIN
    select trim(GLOBAL_NAME) into AUX_GLOBAL_NAME from GLOBAL_NAME;
    V_FILENAME := 'TESTE_PROFORMA_FULL_' || AUX_CICLO || '_' ||to_char( sysdate ,'yyyymmdd_hh24miss' ) || '_' || AUX_GLOBAL_NAME ||'.csv';
    V_FILE := UTL_FILE.FOPEN(V_PATH, V_FILENAME, 'W');
    UTL_FILE.PUT_LINE( V_FILE, 'Inicio - ' || AUX_GLOBAL_NAME || ' : ' || to_char( sysdate ,'dd/mm/yyyy - hh24:mi:ss'));
    UTL_FILE.PUT_LINE( V_FILE, 'EXTERNAL_ID' ||' ; '|| 'BILL_PERIOD' ||' ; '||'ELEMENT_ID' ||' ; '|| 'BILL_REF_NO' ||' ; '|| 'TYPE_CODE' ||' ; '|| 'SUBTYPE_CODE' ||' ; '|| 'DESCRIPTION_TEXT' ||' ; '|| 'VALOR' ||' ; '|| 'VALOR_LIQ' ||' ; '|| 'DISCOUNT' ||' ; '|| 'FEDERAL_TAX' ||' ; '|| 'BILL_INVOICE_ROW' ||' ; '|| 'SUBSCR_NO' ||' ; '|| 'TAX' ||' ; '|| 'TAX_PKG_INST_ID' ||' ; '|| 'TAX_RATE' ||' ; '|| 'RATE_TYPE' ||' ; '|| 'APARECE_NOTA' ||' ; '|| 'COD_FISCAL' ||' ; '|| 'TIPO_UTILIZACAO' ||' ; '|| 'SUBTYPE_OUTRAS' ||' ; '|| 'COD_DESCONTO' ||' ; '||'FROM_DATE' ||' ; '|| 'TO_DATE' ||' ; '|| 'PREP_DATE'||' ; '|| 'SAFRA');
    
        FOR C1 IN FATURA LOOP
            BEGIN
                UTL_FILE.PUT_LINE( V_FILE, C1.EXTERNAL_ID ||' ; '|| C1.BILL_PERIOD ||' ; '|| C1.ELEMENT_ID ||' ; '|| C1.BILL_REF_NO ||' ; '|| C1.TYPE_CODE ||' ; '|| C1.SUBTYPE_CODE ||' ; '|| C1.DESCRIPTION_TEXT ||' ; '|| C1.VALOR ||' ; '|| C1.VALOR_LIQ ||' ; '|| C1.DISCOUNT ||' ; '|| C1.FEDERAL_TAX ||' ; '|| C1.BILL_INVOICE_ROW ||' ; '|| C1.SUBSCR_NO ||' ; '|| C1.TAX ||' ; '|| C1.TAX_PKG_INST_ID ||' ; '|| C1.TAX_RATE ||'  ; '|| C1.RATE_TYPE ||' ; '|| C1.APARECE_NOTA ||' ; '|| C1.COD_FISCAL ||' ; '|| C1.TIPO_UTILIZACAO ||' ; '|| C1.SUBTYPE_OUTRAS ||' ; '|| C1.COD_DESCONTO ||' ; '|| C1.FROM_DATE ||' ; '|| C1.TO_DATE ||' ; '|| C1.PREP_DATE ||' ; '|| C1.UNITS);
            END;
        END LOOP;

    COMMIT;
    UTL_FILE.PUT_LINE( V_FILE, 'Fim do processo: ' || to_char( sysdate ,'dd/mm/yyyy - hh24:mi:ss'));
    UTL_FILE.FFLUSH (V_FILE);
    UTL_FILE.FCLOSE(V_FILE);
END;
/