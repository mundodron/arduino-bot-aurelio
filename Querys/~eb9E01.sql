DECLARE
AUX_GLOBAL_NAME     VARCHAR(100);
V_PATH              VARCHAR2 (100) := 'BILLING_FAT_LOG'; -- Diretorio onde sera gravado o arquivo /app/GVT_DEV2/c2/billing/faturamento/log
V_FILENAME          VARCHAR2(50)  := 'TESTE_PROFORMA_' || to_char( sysdate ,'yyyymmdd_hh24miss' ) || '.csv';
V_FILE              UTL_FILE.FILE_TYPE;

CURSOR FATURA IS
  SELECT   d.element_id,
           d.bill_ref_no,
           d.type_code,
           d.subtype_code,
           de.description_text,
           (d.amount + d.federal_tax) / 100 valor,
           (d.amount + d.federal_tax + d.discount) / 100 valor_liq,
           d.discount,
           d.federal_tax,
           d.bill_invoice_row,
           d.subscr_no,
           d.tax,
           d.tax_pkg_inst_id,
           d.tax_rate,
           DECODE (d.open_item_id, 1, 0, 2, 0, 3, 0, d.open_item_id)
              open_item_id,
           d.rate_type,
           DECODE (g.charge_id, NULL, 'S', 'N') aparece_nota,
           i.cod_fiscal,
           i.tipo_utilizacao,
           DECODE (o.subtype_code, NULL, 'N', 'S') subtype_outras,
           DECODE (f.discount_id, NULL, 0, f.discount_id) cod_desconto
    FROM   gvt_fatura_minima f,
           gvt_campo_outras o,
           gvt_classificacao_item i,
           gvt_cobilling_prod_fat g,
           bill_invoice_detail d,
           descriptions de
   WHERE       d.bill_ref_no = 175732740             -- 175153138 -- 175153304
           AND d.bill_ref_resets = 0
           --   AND    DECODE(d.open_item_id,1,0,2,0,3,0,d.open_item_id) = v_open_item_id_nf
           --AND d.type_code IN (2, 3, 4, 7)
           AND g.charge_id(+) = d.subtype_code
           AND g.open_item_id(+) = d.open_item_id
           AND i.cod_gvt(+) = d.subtype_code
           AND o.subtype_code(+) = d.subtype_code
           AND f.description_code(+) = d.subtype_code
           AND d.description_code = de.description_code
           AND de.language_code = 2
ORDER BY   10;

BEGIN
    V_FILE := UTL_FILE.FOPEN(V_PATH, V_FILENAME, 'W');
    select trim(GLOBAL_NAME) into AUX_GLOBAL_NAME from GLOBAL_NAME;
    UTL_FILE.PUT_LINE( V_FILE, 'Inicio - ' || AUX_GLOBAL_NAME || ' : ' || to_char( sysdate ,'yyyymmdd_hh24miss' ));
    UTL_FILE.PUT_LINE( V_FILE, 'ELEMENT_ID' ||' ; '|| 'BILL_REF_NO' ||' ; '|| 'TYPE_CODE' ||' ; '|| 'SUBTYPE_CODE' ||' ; '|| 'DESCRIPTION_TEXT' ||' ; '|| 'VALOR' ||' ; '|| 'VALOR_LIQ' ||' ; '|| 'DISCOUNT' ||' ; '|| 'FEDERAL_TAX' ||' ; '|| 'BILL_INVOICE_ROW' ||' ; '|| 'SUBSCR_NO' ||' ; '|| 'TAX' ||' ; '|| 'TAX_PKG_INST_ID' ||' ; '|| 'TAX_RATE' ||' ; '|| 'OPEN_ITEM_ID' ||' ; '|| 'RATE_TYPE' ||' ; '|| 'APARECE_NOTA' ||' ; '|| 'COD_FISCAL' ||' ; '|| 'TIPO_UTILIZACAO' ||' ; '|| 'SUBTYPE_OUTRAS' ||' ; '|| 'COD_DESCONTO');
    
    FOR C1 IN FATURA LOOP
    BEGIN
        UTL_FILE.PUT_LINE( V_FILE, C1.ELEMENT_ID ||' ; '|| C1.BILL_REF_NO ||' ; '|| C1.TYPE_CODE ||' ; '|| C1.SUBTYPE_CODE ||' ; '|| C1.DESCRIPTION_TEXT ||' ; '|| C1.VALOR ||' ; '|| C1.VALOR_LIQ ||' ; '|| C1.DISCOUNT ||' ; '|| C1.FEDERAL_TAX ||' ; '|| C1.BILL_INVOICE_ROW ||' ; '|| C1.SUBSCR_NO ||' ; '|| C1.TAX ||' ; '|| C1.TAX_PKG_INST_ID ||' ; '|| C1.TAX_RATE ||' ; '|| C1.OPEN_ITEM_ID ||' ; '|| C1.RATE_TYPE ||' ; '|| C1.APARECE_NOTA ||' ; '|| C1.COD_FISCAL ||' ; '|| C1.TIPO_UTILIZACAO ||' ; '|| C1.SUBTYPE_OUTRAS ||' ; '|| C1.COD_DESCONTO);
    END;
    END LOOP;

    COMMIT;
    UTL_FILE.PUT_LINE( V_FILE, 'Fim: ' || to_char( sysdate ,'yyyymmdd_hh24miss' ));
    UTL_FILE.FCLOSE(V_FILE);
END;
/