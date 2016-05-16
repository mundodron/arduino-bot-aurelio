set serverout on size 1000000;
/*----------------------------------------------------------------------------------------------------
 NAME.............: conta_corporate.sql
 PURPOSE..........: Seleciona contas Corporate 
 DATA BASE........: PBCT1 e PBCT2
 USER.............: ARBOR
 
----------------------------------------------------------------------------------------------------
Vers?:  Autor:               DATA      DOC         PM/RDM       Motivo:
------  -------------------- --------- ----------- -----------  ------------------------------------
1.00    Aurelio Avanzi       19/10/15  RDM29507               
---------------------------------------------------------------------------------------------------- */
DECLARE

v_total number(10) :=0;

cursor CONTAS_CORPORATE is
select a.account_no, 
       b.external_id, 
       a.bill_lname, 
       a.account_category,
       a.next_bill_date,
       a.bill_period
  from customer_id_acct_map b,
       cmf a
 where a.account_category in (12,13,14,15,21,22)
   and a.account_type = 1 
   and a.bill_period IN (select bill_period from GVT_PROCESSAMENTO_CICLO where upper(processamento) = upper('P27'))
   and a.no_bill = 0
   and a.account_status != -2 
   and a.account_no in (select parent_account_no
                          from service
                         where service.parent_account_no = a.account_no 
                        -- and (service.service_inactive_dt is null or service.service_inactive_dt > a.prev_cutoff_date)
                           AND (service.service_inactive_dt is null or (service.service_inactive_dt + 7) > nvl(a.prev_cutoff_date,a.date_active) and a.date_active > (sysdate - 90))  
                        )          
   and a.account_no = b.account_no
   and b.external_id_type = 1
   and exists ( select 1 
                  from SIN_GROUP_REF sin
                 where sin.group_id = a.mkt_code 
                   and sin.inactive_date is null);
BEGIN
        FOR CC1 IN CONTAS_CORPORATE LOOP
            BEGIN
               insert into BIPP15_TESTE (ACCOUNT_NO, BILL_PERIOD, PROCESSO, DURACAO) values (CC1.ACCOUNT_NO, CC1.BILL_PERIOD, 0, 0);
               v_total:= v_total + 1;
               --if mod(v_total, 1000) = 0 then commit; end if;
            EXCEPTION
            WHEN OTHERS
            THEN
               DBMS_OUTPUT.put_line ('Relançar e comunicar o Suporte por email, Acionar o Plantão caso aborte novamente.');
               DBMS_OUTPUT.put_line ('Erro no Insert da conta: ' || CC1.ACCOUNT_NO ||' - ERRO: ' || SQLERRM );
            END;
        END LOOP;
     COMMIT;
    DBMS_OUTPUT.PUT_LINE('Fim do processo: ' || to_char( sysdate ,'dd/mm/yyyy - hh24:mi:ss') || ' Total de clientes selectionados: '|| v_total);
END;
/


select count(*) from BIPP15_TESTE;

-- truncate table BIPP15_TESTE

-- select count(*) from BIPP27

