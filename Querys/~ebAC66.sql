select G.EXTERNAL_ID, G.ACCOUNT_NO, P.PAY_METHOD, P.OLD_PAY_METHOD, P.ULTIMO_COD_RETORNO
  from gvt_nrc_invalida G,
       GVT_DACC_GERENCIA_MET_PGTO P
 where status = 'F'
   and account_no is not null
   and G.EXTERNAL_ID = P.EXTERNAL_ID
   and P.PAY_METHOD != 3
   
   select * from all_tables where table_name like '%DACC%'  
   
   select * from GVT_DACC_GERENCIA_MET_PGTO
   
   grant all on gvt_nrc_invalida to public
   

