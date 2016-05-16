  SELECT   MAP.EXTERNAL_ID,
           B.BILL_PERIOD,
           d.element_id,
           d.bill_ref_no,
           d.type_code,
           d.subtype_code,
           de.description_text,
           (d.amount + d.federal_tax) valor,
           (d.amount + d.federal_tax + d.discount) valor_liq,
           d.discount,
           d.federal_tax,
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
           PREP_DATE
    FROM   gvt_fatura_minima f,
           gvt_campo_outras o,
           gvt_classificacao_item i,
           gvt_cobilling_prod_fat g,
           bill_invoice_detail d,
           bill_invoice b,
           customer_id_acct_map map,
           descriptions de
   WHERE   d.bill_ref_resets = 0
           AND d.type_code IN (2, 3, 4, 7, 6, 5)
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
           --AND B.BILL_PERIOD = 'M10'
           --AND B.PREP_DATE > sysdate - 5
           AND B.PREP_ERROR_CODE is null
           AND B.BILL_REF_NO = 178022627 
           --AND B.PREP_DATE in (select max(BILL.PREP_DATE) from bill_invoice bill where bill.account_no = B.ACCOUNT_NO and BILL.PREP_STATUS =1)
           --AND EXISTS (SELECT 1 FROM cmf WHERE CMF.ACCOUNT_NO = MAP.ACCOUNT_NO and CMF.ACCOUNT_CATEGORY in (10,11));