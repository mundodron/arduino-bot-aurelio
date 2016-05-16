set serverout on size 1000000;
/*----------------------------------------------------------------------------------------------------
 NAME.............: PL_Seleciona_retail.sql
 PURPOSE..........: Seleciona contas Retail 
 DATA BASE........: PBCT1 e PBCT2
 USER.............: ARBOR
 
----------------------------------------------------------------------------------------------------
Vers?:  Autor:               DATA      DOC         PM/RDM       Motivo:
------  -------------------- --------- ----------- -----------  ------------------------------------
1.00    Aurelio Avanzi       19/10/15  RDM29507               
---------------------------------------------------------------------------------------------------- */

DECLARE

v_total number(10) :=0;

CURSOR CONTAS_RETAIL IS
      SELECT account_no, bill_period
        FROM cmf
       WHERE no_bill = 0
         AND account_status != -2
         AND account_category IN (9, 10, 11)
         AND contact1_phone IS NOT NULL
         AND cust_zip IS NOT NULL
         AND UPPER(BILL_PERIOD) in (SELECT BILL_PERIOD FROM GVT_PROCESSAMENTO_CICLO WHERE PROCESSAMENTO = UPPER('P19'))
         AND  next_bill_date >= sysdate 
         AND EXISTS (SELECT 1
                       FROM service
                      WHERE service.parent_account_no = cmf.account_no
                       -- AND service.service_inactive_dt IS NULL)
                       AND (service.service_inactive_dt is null or (service.service_inactive_dt + 7) > nvl(cmf.prev_cutoff_date,cmf.date_active) and cmf.date_active > (sysdate - 90))                    
                     )
         AND EXISTS (SELECT 1
                       FROM sin_group_ref SIN
                      WHERE SIN.GROUP_ID = cmf.mkt_code
                        AND SIN.inactive_date IS NULL)
   UNION
      SELECT account_no, bill_period
        FROM cmf
       WHERE UPPER(BILL_PERIOD) in (SELECT BILL_PERIOD FROM GVT_PROCESSAMENTO_CICLO WHERE PROCESSAMENTO = UPPER('P19'))
         AND account_category IN (9, 10, 11)
         AND child_count >= 1
         AND contact1_phone IS NOT NULL
         AND cust_zip IS NOT NULL
         AND no_bill = 0
         AND EXISTS (SELECT 1
                       FROM service
                      WHERE service.parent_account_no = cmf.account_no
                       -- AND service.service_inactive_dt IS NULL)
                        AND (service.service_inactive_dt is null or (service.service_inactive_dt + 7) > nvl(cmf.prev_cutoff_date,cmf.date_active) and cmf.date_active > (sysdate - 90))                     
                     )
         AND EXISTS (SELECT 1
                       FROM sin_group_ref SIN
                      WHERE SIN.GROUP_ID = cmf.mkt_code
                        AND SIN.inactive_date IS NULL);           
   -- Fim Cursor FATURA
   BEGIN
        FOR C1 IN CONTAS_RETAIL LOOP
            BEGIN
               insert into G0023421SQL.BIPP15_TESTE (ACCOUNT_NO, BILL_PERIOD, PROCESSO, DURACAO) values (C1.ACCOUNT_NO, C1.BILL_PERIOD, 0, 0);
               v_total:= v_total + 1;
               --if mod(v_total, 1000) = 0 then commit; end if; 
            EXCEPTION
             WHEN OTHERS
              THEN
               DBMS_OUTPUT.put_line ('Relan�ar e comunicar o Suporte por email, Acionar o Plant�o caso aborte novamente.');
               DBMS_OUTPUT.put_line ('Erro no Insert da conta: ' || C1.ACCOUNT_NO ||' - ERRO: ' || SQLERRM );
            END;
               COMMIT;
        END LOOP;
   DBMS_OUTPUT.PUT_LINE('Fim do processo: ' || to_char( sysdate ,'dd/mm/yyyy - hh24:mi:ss') || ' Total de clientes selectionados: '|| v_total);
END;
/

--select count(*) from G0023421SQL.BIPP15_TESTE
--truncate table G0023421SQL.BIPP15_TESTE

