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
   v_mes_b                 varchar2(20);
   v_arquivo_old           varchar2(150);
   v_mes                   varchar2(20);
   v_nome_arquivo          VARCHAR2(150);

   CURSOR c1
   IS
   select     ARQ,
              EXTERNAL_ID,
              QT,
              ACCOUNT_NO,
              BILL_REF_NO,
              to_char(DATA_PROCESSAMENTO,'YYYYMMDD') DATA_PROCESSAMENTO,
              ACCOUNT_CATEGORY,
              PROCESSO,
              ARQ_OLD              
     from G0023421SQL.backlog_cdc
    where 1=1;

BEGIN
   FOR x IN c1
   LOOP
      IF v_errcode = 0
      THEN
         BEGIN  
          
          v_mes := x.data_processamento;
          v_arquivo_old:= x.ARQ;
         
         
          IF SUBSTR(v_mes, 5, 2) = '12'  THEN v_mes_b := 'Dezembro';  END IF;
          IF SUBSTR(v_mes, 5, 2) = '11'  THEN v_mes_b := 'Novembro';  END IF;
          IF SUBSTR(v_mes, 5, 2) = '10'  THEN v_mes_b := 'Outubro';   END IF;
          IF SUBSTR(v_mes, 5, 2) = '09'  THEN v_mes_b := 'Setembro';  END IF;
          IF SUBSTR(v_mes, 5, 2) = '08'  THEN v_mes_b := 'Agosto';    END IF;
          IF SUBSTR(v_mes, 5, 2) = '07'  THEN v_mes_b := 'Julho';     END IF;
          IF SUBSTR(v_mes, 5, 2) = '06'  THEN v_mes_b := 'Junho';     END IF;
          IF SUBSTR(v_mes, 5, 2) = '05'  THEN v_mes_b := 'Maio';      END IF;
          IF SUBSTR(v_mes, 5, 2) = '04'  THEN v_mes_b := 'Abril';     END IF;
          IF SUBSTR(v_mes, 5, 2) = '03'  THEN v_mes_b := 'Marco';     END IF;
          IF SUBSTR(v_mes, 5, 2) = '02'  THEN v_mes_b := 'Fevereiro'; END IF;
          IF SUBSTR(v_mes, 5, 2) = '01'  THEN v_mes_b := 'Janeiro';   END IF;
          
          
          -- select * from gvt_conta_internet where account_no = x.account_no, bill_ref_no = x.bill_ref_no;

            
          v_nome_arquivo := trim(v_mes_b) || '/' || substr(trim(x.external_id),12,1) || '/' || SUBSTR(v_mes, 1, 4) || TRIM(v_mes_b)||trim(x.external_id) ||'_250.cdc';
          
          --update GVT_CONTA_INTERNET set NOME_ARQUIVO = v_nome_arquivo where ACCOUNT_NO = x.ACCOUNT_NO and BILL_REF_NO = x.BILL_REF_NO;
          
          DBMS_OUTPUT.put_line ('update G0023421SQL.backlog_cdc set ARQ_OLD = v_arquivo_old where ACCOUNT_NO = x.ACCOUNT_NO and BILL_REF_NO = x.BILL_REF_NO;');          

          --DBMS_OUTPUT.put_line ('Cliente: ' || x.external_id || ' - ' || x.account_no||' - '|| x.bill_ref_no || ' OLD: '|| v_arquivo_old ||' NEW: '|| v_nome_arquivo || ' - ' || v_mes);
          -- FIM   
            COMMIT;
         EXCEPTION
            WHEN OTHERS
            THEN
          DBMS_OUTPUT.put_line ('ERRRROOOO  Cliente nao inserido: ' || x.account_no||' - '|| x.bill_ref_no || ' - ' || v_mes);
               --DBMS_OUTPUT.put_line ('Em caso de Aborte FOK e comunicar o Suporte por email, não é necessário acionar o Plantão.');
         END;
      END IF;
   END LOOP;
   COMMIT;
END;