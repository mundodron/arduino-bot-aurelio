set serverout on size 1000000;
/*----------------------------------------------------------------------------------------------------
 NAME.............: 
 PURPOSE..........:  
 DATA BASE........: PBCT1 e PBCT2
 USER.............: ARBOR
 
----------------------------------------------------------------------------------------------------
Vers?:  Autor:               DATA      DOC         PM/RDM       Motivo:
------  -------------------- --------- ----------- -----------  ------------------------------------
1.00    Aurelio Avanzi       24/11/15                 
---------------------------------------------------------------------------------------------------- */
DECLARE

v_total number(10) :=0;
v_Rank number(10) :=0;
   
CURSOR C_CONTAS_NO_BILL is
select * from (
    select ciam.external_id conta, 
           cmf.bill_period ciclo,
           to_number(substr(dbms_reputil.global_name,-1)) kenan_db_id,
           account_category segmento,
           cdu.msg_id, 
           cd.msg_id2, 
           cdu.msg_id_serv,
           cdu.account_no,
           cdu.subscr_no, 
           cd.point_origin,
           cd.point_target,
           cdu.trans_dt data_chamada,
           cd.second_units duracao,
           cd.type_id_usg uso,
           row_number () over(partition by cdu.subscr_no,cd.point_target order by cdu.subscr_no, cd.point_target) rank
     from cdr_data  cd,
          cdr_unbilled cdu,   
          cmf, 
          customer_id_acct_map ciam
    where 1=1
      and cdu.type_id_usg in(925,926,927)
      and cdu.rate_dt >= trunc(sysdate-90)
      and cdu.account_no = cmf.account_no
      and cd.msg_id = cdu.msg_id
      and cd.msg_id2 = cdu.msg_id2
      and cd.msg_id_serv = cdu.msg_id_serv
      and cd.split_row_num = cdu.split_row_num
      and cd.account_no = cmf.account_no
      and cd.no_bill = 0
      and cmf.account_category in (10,11)
      and UPPER(cmf.bill_period) in (SELECT BILL_PERIOD FROM GVT_PROCESSAMENTO_CICLO WHERE PROCESSAMENTO = UPPER('P19'))
      and ciam.account_no = cmf.account_no
      and ciam.external_id_type = 1
      and ciam.is_current = 1)
    where rank > (SELECT RANKING 
                    FROM GVT_NUMEROS_EPECIAIS
                   WHERE INACTIVE_DT is null
                     AND CAMPANHA = point_target);

BEGIN
        FOR CC1 IN C_CONTAS_NO_BILL LOOP
            BEGIN
               UPDATE MAU_cdr_data SET NO_BILL = 1, ANNOTATION = 'CAMPANHAS ESPECIAIS' WHERE MSG_ID = CC1.MSG_ID AND MSG_ID2 = CC1.MSG_ID2 AND msg_id_serv = CC1.msg_id_serv and account_no = CC1.account_no and NO_BILL = 0;
               v_total:= v_total + 1;
               --if mod(v_total, 1000) = 0 then commit; end if;
            EXCEPTION
            WHEN OTHERS
            THEN
               DBMS_OUTPUT.put_line ('Relançar e comunicar o Suporte por email, Acionar o Plantão caso aborte novamente.');
               DBMS_OUTPUT.put_line ('Erro no update da conta: ' || CC1.ACCOUNT_NO ||' - ERRO: ' || SQLERRM );
            END;
        END LOOP;
     COMMIT;
    DBMS_OUTPUT.PUT_LINE('Fim do processo: ' || to_char( sysdate ,'dd/mm/yyyy - hh24:mi:ss') || ' Total de clientes marcados: '|| v_total);
END;
/


select * from MAU_cdr_data where no_bill = 1