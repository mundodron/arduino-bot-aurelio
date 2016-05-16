select * from cmf_balance

select * from all_tables where table_name like '%JNL%'

select * from JNL_DETAIL

select B.BILL_REF_NO, B.PREP_STATUS, B.PREP_DATE from bill_invoice b where B.PREP_STATUS = 4 and prep_date > sysdate - 1

SELECT d.element_id,
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
       decode(d.open_item_id, 1, 0, 2, 0, 3, 0, d.open_item_id) open_item_id,
       d.rate_type,
       decode(g.charge_id, NULL, 'S', 'N') aparece_nota,
       i.cod_fiscal,
       i.tipo_utilizacao,
       decode(o.subtype_code, NULL, 'N', 'S') subtype_outras,
       decode(f.discount_id, NULL, 0, f.discount_id) cod_desconto
  FROM gvt_fatura_minima      f,
       gvt_campo_outras       o,
       gvt_classificacao_item i,
       gvt_cobilling_prod_fat g,
       bill_invoice_detail    d,
       descriptions           de
 WHERE d.bill_ref_no = 175153705 -- 175153309 --  175153138 -- 175153304 
   AND d.bill_ref_resets = 0
      --   AND    DECODE(d.open_item_id,1,0,2,0,3,0,d.open_item_id) = v_open_item_id_nf
   AND d.type_code IN (2, 3, 4, 7)
   AND g.charge_id(+) = d.subtype_code
   AND g.open_item_id(+) = d.open_item_id
   AND i.cod_gvt(+) = d.subtype_code
   AND o.subtype_code(+) = d.subtype_code
   AND f.description_code(+) = d.subtype_code
   AND d.description_code = de.description_code
   AND de.language_code = 2