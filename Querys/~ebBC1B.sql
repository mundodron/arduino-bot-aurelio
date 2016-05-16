/*
Descrição: A fatura 161213913 do cliente account_no 3201733 (base PBCT2) não consta o produto "Degustação Canal a La Carte 1", mesmo constando na tabela gvt_summary_zero_allowed. O cliente possui também o produto "Degustação Fox Sports" o qual aparece.
component_id: 29649 e 29897 respectivamente.
*/


select de.description_text,
b.type_id_usg,
       b.point_origin,
       b.point_target,
       b.billed_amount,
       b.billed_base_amt,
       b.amount_credited
  from descriptions de,
       cdr_billed b
 where b.bill_ref_no = 161213913
   and b.bill_ref_resets = 0
   and b.type_id_usg +16000 = de.description_code(+)
   and de.language_code(+) = 2
 order by 2,
          4;


SELECT d.element_id,
       d.bill_ref_no,
       d.bill_ref_resets,
       d.type_code,
       d.subtype_code,
       de.description_text,
       (d.amount + d.federal_tax) / 100 valor,
       (d.amount + d.federal_tax + d.discount) / 100 valor_liq,
       d.bill_invoice_row,
       d.subscr_no,
       d.subscr_no_resets,
       d.discount,
       d.secondary_amount,
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
 WHERE d.bill_ref_no = 165269902 --v_ign_index_bill_ref
   AND d.bill_ref_resets = 0 --v_ign_index_resets
      --   AND    DECODE(d.open_item_id,1,0,2,0,3,0,d.open_item_id) = v_open_item_id_nf
   AND d.type_code IN (2) --(2, 3, 4, 7)
   AND g.charge_id(+) = d.subtype_code
   AND g.open_item_id(+) = d.open_item_id
   AND i.cod_gvt(+) = d.subtype_code
   AND o.subtype_code(+) = d.subtype_code
   AND f.description_code(+) = d.subtype_code
   AND d.description_code = de.description_code
   AND de.language_code = 2
 ORDER BY decode(d.open_item_id, 1, 0, 2, 0, 3, 0, d.open_item_id),
          d.type_code,
          d.subtype_code,
          valor DESC,
          d.rate_type,
          d.bill_invoice_row;

select A.BILL_REF_NO,
       a.component_id,
       a.element_id,
       a.description_code,
       B.DESCRIPTION_TEXT
  from bill_invoice_detail a,
       descriptions b
 where a.bill_ref_no = 161213913
   and A.DESCRIPTION_CODE = B.DESCRIPTION_CODE
   and B.LANGUAGE_CODE = 2
   and a.component_id in (29649,29897)
   
select * from bill_invoice_detail where bill_ref_no = 161213913 and type_code = 2 and element_id in (10203,10327)
   
select * from gvt_summary_zero_allowed where element_id in (10203,10327)

select * from descriptions where description_code in (10203,10327) and language_code = 2

select * from cmf_balance where account_no = 3201733 order by 3