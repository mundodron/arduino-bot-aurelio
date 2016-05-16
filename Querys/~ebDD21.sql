select * from GVT_CONTA_INTERNET where account_no = 3858364


select *  from cmf where account_no = 4360900

      SELECT * --C.ACCOUNT_NO
      FROM   CMF C , 
             GVT_CONTAS_CONTAFACIL G
      WHERE  C.ACCOUNT_NO = G.ACCOUNT_NO 
       AND   C.ACCOUNT_TYPE = 1
       AND   G.account_category in (10)
       and   G.processo = 1;
       
    select * from GVT_CONTAS_CONTAFACIL