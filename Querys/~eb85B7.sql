SELECT D.BILL_REF_NO, -- d.type_code,
       sum(d.amount + d.federal_tax) valor,
       sum(d.amount + d.federal_tax + d.discount) valor_liq
  FROM gvt_fatura_minima      f,
       gvt_campo_outras       o,
       gvt_classificacao_item i,
       gvt_cobilling_prod_fat g,
       bill_invoice_detail    d,
       descriptions           de
 WHERE d.bill_ref_no = 117043539 --v_ign_index_bill_ref
   AND d.bill_ref_resets = 0 --v_ign_index_resets
      --   AND    DECODE(d.open_item_id,1,0,2,0,3,0,d.open_item_id) = v_open_item_id_nf
   AND d.type_code IN (2, 3, 4, 7)
   AND g.charge_id(+) = d.subtype_code
   AND g.open_item_id(+) = d.open_item_id
   AND i.cod_gvt(+) = d.subtype_code
   AND o.subtype_code(+) = d.subtype_code
   AND f.description_code(+) = d.subtype_code
   AND d.description_code = de.description_code
   AND de.language_code = 2
   group by D.BILL_REF_NO
   
   