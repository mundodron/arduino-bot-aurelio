     drop table backlog_cdc
     
     create table backlog_cdc as
     select nome_arquivo arq, external_id, count(1) QT, max(account_no) account_no, max(bill_ref_no) bill_ref_no, max(data_processamento) data_processamento,10 ACCOUNT_CATEGORY,
       (1+ABS(MOD(dbms_random.random,100))) as PROCESSO
       from GVT_CONTA_INTERNET
      where data_processamento between to_date('20151001','yyyymmdd') and to_date('20160401','yyyymmdd')
        and bill_ref_no is not null
   group by nome_arquivo, external_id 
     having count(1) > 1
     
     -- 295366152 13/11/2015 14:27:12
     
   select bill_ref_no from backlog_cdc 
     
   select * from GVT_CONTA_INTERNET where bill_ref_no = 295366152
   
     SELECT MAX(BILL_REF_NO),
             TO_CHAR(DATA_PROCESSAMENTO,'YYYYMM')
      FROM   backlog_cdc a
      WHERE  account_no = v_cliente;