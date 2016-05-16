   -- Declarando Cursor

      SELECT C.ACCOUNT_NO
      FROM   CMF C , 
             backlog_cdc G 
      WHERE  C.ACCOUNT_NO = G.ACCOUNT_NO 
       AND   C.ACCOUNT_TYPE = 1
       AND   G.account_category in (&5)
       and   G.processo = &6;

  
select * from GVT_CONTAS_CONTAFACIL
    INSERT INTO GVT_CONTAS_CONTAFACIL
    select ACCOUNT_NO,
           ACCOUNT_CATEGORY,
           Processo
     from backlog_cdc
     
select * from backlog_cdc where rownum < 200
    
    
    INSERT INTO GVT_CONTAS_CONTAFACIL
select ACCOUNT_NO,
12 as ACCOUNT_CATEGORY,
1 as PROCESSO
from contafacil_corp;


select * from GVT_CONTAS_CONTAFACIL

select * from gvt_con