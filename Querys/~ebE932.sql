select * from gvt_bankslip where sequencial = 1198

select * from gvt_bankslip where bill_ref_no = 137707853


select CODIGO_CLIENTE --, NUMERO_FATURA, IMAGE_TYPE, IMAGE_NUMBER, DATA_EMISSAO 
  from customer_care
 where CODIGO_CLIENTE in (select trim(external_id_a) from gvt_bankslip where sequencial = 1198)
   and IMAGE_TYPE = 02
   and DATA_EMISSAO > trunc(sysdate - 20)
   
   
select CODIGO_CLIENTE, NUMERO_FATURA, IMAGE_TYPE, IMAGE_NUMBER, DATA_EMISSAO 
  from customer_care
 where CODIGO_CLIENTE in (select trim(external_id_a) from gvt_bankslip where sequencial = 1198)
   and IMAGE_TYPE = 02
   and DATA_EMISSAO > trunc(sysdate - 10)
   
   
  select * from gvt_bankslip where '0' || external_id_a || '-0' in ()
  
   select CODIGO_CLIENTE from customer_care where IMAGE_TYPE = 02
   and DATA_EMISSAO > trunc(sysdate - 10)
   and CODIGO_CLIENTE in (select trim(external_id_a) from gvt_bankslip where sequencial = 1198)
 
 
select * from gvt_bankslip where sequencial = 1198
and external_id_a not in (select CODIGO_CLIENTE --, NUMERO_FATURA, IMAGE_TYPE, IMAGE_NUMBER, DATA_EMISSAO 
  from customer_care
 where CODIGO_CLIENTE in (select trim(external_id_a) from gvt_bankslip where sequencial = 1198)
   and IMAGE_TYPE = 02
   and DATA_EMISSAO > trunc(sysdate - 20))
 
select * from gvt_bankslip where bill_ref_no in (137698272,135988873,136296600,137557891,137557891,137788085,138221340,138452726,138550698,138672163,138831173,138925847,138931994,139380126)
   