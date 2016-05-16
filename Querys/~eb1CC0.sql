select CODIGO_CLIENTE, NUMERO_FATURA, IMAGE_TYPE, IMAGE_NUMBER, DATA_EMISSAO 
  from customer_care
 where CODIGO_CLIENTE in (select trim(external_id_a) from gvt_bankslip where sequencial = 1198)
   and IMAGE_TYPE = 02
   and DATA_EMISSAO > trunc(sysdate - 10)
   
   
   select * from gvt_bankslip where bill_ref_no = 138831173
