  SELECT   MAP.EXTERNAL_ID,
           MAP.ACCOUNT_NO,
           B.BILL_PERIOD,
           d.element_id,
           D.TYPE_CODE,
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
           D.FROM_DATE,
           D.TO_DATE,
           D.RATE_PERIOD,
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
           --AND B.BILL_PERIOD = AUX_CICLO
           --AND B.PREP_DATE > sysdate - 15
           AND B.BILL_REF_NO = 186128327
           AND B.PREP_STATUS = 4 -->production
           AND D.TRACKING_ID = K.TRACKING_ID(+)
           AND B.PREP_ERROR_CODE is null
           --AND B.PREP_DATE in (select max(BILL.PREP_DATE) from bill_invoice bill where bill.account_no = B.ACCOUNT_NO and BILL.PREP_STATUS =1)
           AND EXISTS (SELECT 1 FROM cmf WHERE CMF.ACCOUNT_NO = MAP.ACCOUNT_NO and CMF.ACCOUNT_CATEGORY in (10,11));
           
           
 select * from CDR_UNBILLED where account_no = 1625676 and subscr_no = 2409554 and TYPE_ID_USG = 619
 
 select * from cdr_data where msg_id = 292333817  and subscr_no = 2409554
 
 select * from all_tables where table_name like '%VARIA%' 
 
 
 