select 1 
  from tbl_dados_faturas c,
       contas d   
 where c.cod_campa = '1'
   --and c.num_prest = b.num_prest
   --and c.des_regis = b.des_regis
   and c.des_contr = d.external_id
   and c.des_fatura = d.bill_ref_no