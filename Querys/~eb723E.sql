SELECT d.bill_ref_no,  
          d.bill_ref_resets,  
          d.type_code,  
          d.subtype_code,  
          d.amount + d.federal_tax valor,  
          d.bill_invoice_row,  
          d.subscr_no,  
          d.subscr_no_resets,  
          d.discount,  
          d.secondary_amount,  
          d.tax,  
          d.tax_pkg_inst_id,  
          d.tax_rate,  
          --DECODE(d.open_item_id,1,0,2,0,3,0,d.open_item_id) open_item_id,
      DECODE(d.open_item_id,1,0,2,0,3,0,91,90,92,90,d.open_item_id) open_item_id,
          d.rate_type,
          DECODE(g.charge_id , NULL,'S', 'N' ) aparece_nota,
          i.cod_fiscal,
          i.tipo_utilizacao,
          DECODE(o.subtype_code, NULL, 'N','S') subtype_outras,
          DECODE(f.discount_id, NULL, 0,f.discount_id) cod_desconto
--   FROM   arborgvt_journals.gvt_fatura_minima f,
   FROM   gvt_fatura_minima f,
          gvt_campo_outras o,
          gvt_classificacao_item i,
          gvt_cobilling_prod_fat g,
          bill_invoice_detail  d
   WHERE  d.bill_ref_no        = 284704319
    AND    d.bill_ref_resets    = 0
   --AND    DECODE(d.open_item_id,1,0,2,0,3,0,d.open_item_id) = v_open_item_id_nf
   AND    DECODE(d.open_item_id,1,0,2,0,3,0,91,90,92,90,d.open_item_id) = 0
   AND    d.type_code             in (2,3,4,7) -- RC, NRC, USO ...
   AND    g.charge_id(+)          = d.subtype_code
   AND    g.open_item_id(+)       = d.open_item_id 
   AND    i.cod_gvt(+)            = d.subtype_code
   AND    o.subtype_code(+)       = d.subtype_code
   AND    f.description_code(+)   = d.subtype_code
   --AND    D.SUBTYPE_CODE NOT IN (12787, 12251, 12280)
   ORDER BY --DECODE(d.open_item_id,1,0,2,0,3,0,d.open_item_id),
            DECODE(d.open_item_id,1,0,2,0,3,0,91,90,92,90,d.open_item_id),
            d.type_code,  
            d.subtype_code,
            valor desc,
            d.rate_type,
            d.bill_invoice_row
