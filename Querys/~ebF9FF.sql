    INSERT INTO GVT_CONTAS_CONTAFACIL
    select ACCOUNT_NO,
           ACCOUNT_CATEGORY,
           Processo
      from backlog_cdc
     where account_no not in (select account_no from GVT_CONTAS_CONTAFACIL);
     
     select * from GVT_CONTA_INTERNET
     
     