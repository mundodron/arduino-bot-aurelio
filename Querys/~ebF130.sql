select a.cod_parce, a.des_regis, a.des_contr, a.ind_pagto from tbl_parcelamento a
where a.cod_produ = '1'
and a.ind_pagto = 'Q'--quebrada
and exists (select 1 from tbl_produto_pendencia b
                  where b.cod_produ = '1'
                  and b.cod_carte = 'PARC'
                  and b.des_regis = a.des_regis
                  and b.des_contr = a.cod_parce
                  and exists (select 1 
  from tbl_dados_faturas c,
       contas d   
 where c.cod_campa = '1'
   and c.num_prest = b.num_prest
   and c.des_regis = b.des_regis
   and c.des_contr = d.external_id
   and c.des_fatura = d.bill_ref_no
                              )
                  );