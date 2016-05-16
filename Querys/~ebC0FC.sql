set serverout on size 1000000;
/*
----------------------------------------------------------------------------------------------------
 NAME.............: 
 PURPOSE..........: 
 DATA BASE........: PBCT1 e PBCT2
 USER.............: ARBOR
 
----------------------------------------------------------------------------------------------------
Vers?:  Autor:               DATA      DOC         PM/RDM       Motivo:
------  -------------------- --------- ----------- -----------  ------------------------------------
1.00    Aurelio Avanzi       28/07/15  
----------------------------------------------------------------------------------------------------
 */

DECLARE
   v_errcode               NUMBER (10) := 0;
   v_proforma              varchar2(20);
   v_production            varchar2(20);
   v_total                 number(10)  := 0;

  CURSOR c1
  IS
    select account_no, bill_period from G0009075SQL.bip_production
     union all
    select account_no, bill_period from G0009075SQL.bip_proforma;

  CURSOR c2(account number)
  IS
    select M.EXTERNAL_ID,
           C.ACCOUNT_NO,
           C.BILL_LNAME,
           C.BILL_PERIOD,
           (select ACCOUNT_NO from G0009075SQL.bip_production where account_no = C.ACCOUNT_NO and bill_period = C.BILL_PERIOD) Production,
           (select ACCOUNT_NO from G0009075SQL.bip_proforma where account_no = C.ACCOUNT_NO and bill_period = C.BILL_PERIOD) Proforma
      from cmf c,
           customer_id_acct_map m
     where C.account_no = account 
       and C.ACCOUNT_NO = M.ACCOUNT_NO
       and M.INACTIVE_DATE is null
       and M.EXTERNAL_ID_TYPE = 1;

begin

  for x in c1 loop
  
        for y in c2(x.account_no) loop
            --null;
             BEGIN
               -- dbms_output.put_line('Clientes' ||';'|| y.EXTERNAL_ID ||';'|| y.account_no ||';'|| y.bill_LNAME  ||';'|| y.bill_period  ||';'|| y.Production  ||';'|| y.Proforma);
               insert into LEVANTAMENTO_SELECAO (EXTERNAL_ID, ACCOUNT_NO, BILL_LNAME, BILL_PERIOD, Production, Proforma) values (y.EXTERNAL_ID, y.ACCOUNT_NO, y.BILL_LNAME, y.BILL_PERIOD, y.Production, y.Proforma);
               v_total:= v_total + 1;
               if mod(v_total, 1000) = 0 then commit; end if; 
            EXCEPTION
             WHEN OTHERS
              THEN
               DBMS_OUTPUT.put_line ('Relançar e comunicar o Suporte por email, Acionar o Plantao caso aborte novamente.');
               DBMS_OUTPUT.put_line ('Erro no Insert da conta: ' || x.ACCOUNT_NO ||' - ERRO: ' || SQLERRM );
            END;
               COMMIT;
           
        end loop; 

    end loop;
    dbms_output.put_line('_________________________________________________________________');
    dbms_output.put_line('*** Fim - '||dbms_reputil.global_name()|| ' - ' || v_total || ' - '||to_char(sysdate, 'dd/mm/yyyy hh24:mi:ss'));
end;
/

exit;