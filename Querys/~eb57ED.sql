drop table backlog_cdc
    
 create table backlog_cdc as
     select nome_arquivo arq, external_id, count(1) QT, max(account_no) account_no, max(bill_ref_no) bill_ref_no, min(data_processamento) data_processamento,10 ACCOUNT_CATEGORY,
       (1+ABS(MOD(dbms_random.random,100))) as PROCESSO
       from GVT_CONTA_INTERNET
      where data_processamento between to_date('20151001','yyyymmdd') and to_date('20160401','yyyymmdd')
        and bill_ref_no is not null
        and data_processamento > sysdate - 180
   group by nome_arquivo, external_id 
     having count(1) > 1
     
     select * from backlog_cdc where account_no = 10384704 and bill_ref_no = 298428542
     
      select count(*) from backlog_cdc where mod(processo,5)=2
     
     
     select * from user_role_privs;
     select * from GVT_CONTA_INTERNET where account_no = 10384704 and bill_ref_no = 298428542
     
     
     update GVT_CONTAS_CONTAFACIL set processo = 1 where ACCOUNT_NO in (select account_no from contafacil_corp);
     
     select * from GVT_CONTAS_CONTAFACIL where account_no in (select account_no from backlog_cdc)
     
     select account_no, account_category, processo from backlog_cdc 
     
     select count(1) from backlog_cdc where account_no in (select account_no from backlog_cdc)
          
          
     grant select,update on G0023421SQL.backlog_cdc to public
     
    SELECT   ACCOUNT_NO, data_processamento
      FROM   backlog_cdc
     WHERE   processo = &6;

    select account_no,PROCESSO, count(1) from backlog_cdc group by account_no, PROCESSO having count(1) > 1
    
    
          ------ Processamento avulso -----
    SELECT bill_ref_no,
           TO_CHAR(Max(payment_due_date),'YYYYMM')
      FROM backlog_cdc
     WHERE processo = &6;    
      ---------------------------------
      

     SELECT bill_ref_no,
            TO_CHAR(DATA_PROCESSAMENTO,'YYYYMM')
       FROM backlog_cdc
      WHERE account_no = v_cliente 
        AND processo = &6;



select * from backlog_cdc where external_id = 899996182621

select * from gvt_conta_internet where account_no = 10313801


select * from G0023421SQL.backlog_cdc
        set processo = nvl(processo,0) + 500
        
        where account_no = v_cliente
        and bill_ref_no = v_bill_ref_no;
        
        select * from gvt
        
        
