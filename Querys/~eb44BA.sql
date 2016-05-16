select C.COD_AGENTE_ARRECADADOR, A.*
from GVT_CDBARRAS A,
     cmf_balance B,
     GVT_DACC_GERENCIA_MET_PGTO C
Where A.BILL_REF_NO = B.BILL_REF_NO
  and B.CLOSED_DATE is not null
  and A.EXTERNAL_ID = C.EXTERNAL_ID
  

select * from all_tables where table_name like '%DACC%' 
  
  select * from GVT_DACC_GERENCIA_MET_PGTO
  
  select * from GVT_DACC_VALIDACAO_BANCOS
  
update GVT_CDBARRAS set status where external_id not in (select external_id from customer_id_acct_map)

update GVT_CDBARRAS set status = 1 where 
  
  
  select A.*
from GVT_CDBARRAS A,
     cmf_balance B
Where A.BILL_REF_NO = B.BILL_REF_NO
  and B.CLOSED_DATE is not null
  
  delete from GVT_CDBARRAS
  
  
  select * from cmf_balance where bill_ref_no = 138817612