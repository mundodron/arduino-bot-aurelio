select G.EXTERNAL_ID, G.ACCOUNT_NO, P.PAY_METHOD,  P.DT_CADASTRO, P.DT_ULTIMO_RETORNO, P.ULTIMO_COD_RETORNO
  from gvt_nrc_invalida G,
       GVT_DACC_GERENCIA_MET_PGTO P
 where status = 'F'
   and account_no is not null
   and G.EXTERNAL_ID = P.EXTERNAL_ID
   and P.PAY_METHOD != 3
      
   select * from all_tables where table_name like '%DACC%'  
   
   select * from GVT_DACC_GERENCIA_MET_PGTO where external_id = 999988610327
   
   select * from all_tables where table_name like '%DACC%' 
   
   

   