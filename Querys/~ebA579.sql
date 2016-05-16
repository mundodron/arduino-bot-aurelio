  select * from arborgvt_billing.GVT_CONTROLE_NO_BILL
  
  select * from all_tables where table_name like '%NO_BILL%' 
  
  SELECT * FROM USER_ROLE_PRIVS
  
   select * from arborgvt_billing.
   
   GVT_CONTROLE_NO_BILL
   
   select * from all_tables where table_name like '%NO_BILL%' 
   
   select * from GVT_CONTROLE_NOBILL order by 1 desc
   
   select b.account_no, CMF.ACCOUNT_CATEGORY, 1
     from customer_id_acct_map m,
          cmf_balance b,
          cmf
    where external_id in ('999985075483','999983162696','999980014348','999985076299','999985074903','999985075701','999985076443','999985075150','999985077366','999983162696','999985076443','999985076299','999985075701','999985075150','999985075483','999980014348','999985074903')
      and M.ACCOUNT_NO = B.ACCOUNT_NO
      and B.BILL_REF_NO in (141811218,141787537,141811210,141811224,141811211,141811220,141811225,141811214,141811226,138833903,138842927,138842926,138842922,138842916,138842920,138842912,138842913)
      and CMF.ACCOUNT_NO = M.ACCOUNT_NO
      
      
      select * from GVT_CONTAS_CONTAFACIL