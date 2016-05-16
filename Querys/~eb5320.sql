set verify             off;                                               
set serverout     on size 1000000;                                             
set feed                 off;                                                 
set space             0;                                                  
set pagesize         0;                                               
set line                 500;
set wrap                 on;                                                  
set heading         off;

--*************************************************************************************
--Parametros: sem
--*************************************************************************************

DECLARE

   v_file_type_log       UTL_FILE.FILE_TYPE; --Variavel que recebera o status de retorno - Arquivo de LOG
   v_caminho_arquivo_log VARCHAR(100) := '&1';
   v_nome_arquivo_log    VARCHAR(100):= '&2';
   wProc            varchar2(20);        -- controle erro: nome proced. em execucao

--*************************************************************************************
--Variáveis
--*************************************************************************************
  v_cont_conta           NUMBER:=0;

CURSOR c_loop IS
SELECT CMF.ACCOUNT_NO,BILL_LNAME,CMF.REMARK,ACCOUNT_CATEGORY
FROM CMF
WHERE UPPER('&3') LIKE '%'||UPPER(CMF.BILL_PERIOD)||'%'
AND CMF.NO_BILL = 1
AND CMF.ACCOUNT_CATEGORY IN (&4)
AND ( REMARK IS NULL OR UPPER(REMARK) NOT LIKE '%ANALISE%')
AND EXISTS (SELECT 'X' FROM CUSTOMER_ID_EQUIP_MAP EE,PRODUCT EP
              WHERE EP.PARENT_ACCOUNT_NO = CMF.ACCOUNT_NO
              AND EE.SUBSCR_NO_RESETS = EP.PARENT_SUBSCR_NO_RESETS
              AND EE.SUBSCR_NO = EP.PARENT_SUBSCR_NO
              AND EE.INACTIVE_DATE IS NULL
             );

BEGIN
 dbms_output.put_line('inicio: caminho ' || v_caminho_arquivo_log || ' nome arq ' || v_nome_arquivo_log); 

 v_file_type_log := UTL_FILE.FOPEN(v_caminho_arquivo_log, v_nome_arquivo_log,'A');

 for x IN c_loop LOOP
  BEGIN
    UPDATE CMF SET NO_BILL=0,REMARK=NULL WHERE ACCOUNT_NO = x.ACCOUNT_NO;
    commit;

    v_cont_conta := v_cont_conta + 1;

    UTL_FILE.PUT_LINE(v_file_type_log ,x.account_no || ';' || x.bill_lname || ';' || x.remark || ';' || x.account_category);

    EXCEPTION
      WHEN NO_DATA_FOUND then
      dbms_output.put_line('Erro Loop - Não existem contas para retirar o no_bill');
      WHEN OTHERS then
      dbms_output.put_line('Erro Loop ->'||sqlerrm||wproc);
  END;
 END LOOP;

 COMMIT;

 UTL_FILE.PUT_LINE(v_file_type_log ,'-> Total de contas alteradas : ' || v_cont_conta);
 UTL_FILE.FCLOSE(v_file_type_log);

 EXCEPTION 
   WHEN UTL_FILE.INVALID_PATH then
   UTL_FILE.PUT_LINE(v_file_type_log ,'Erro 6 -> UTL_FILE.INVALID_PATH');
   WHEN UTL_FILE.INVALID_OPERATION then
   UTL_FILE.PUT_LINE(v_file_type_log ,'Erro 7 -> INVALID_OPERATION');
   WHEN UTL_FILE.WRITE_ERROR then
   UTL_FILE.PUT_LINE(v_file_type_log ,'Erro 8 -> WRITE_ERROR');
   when OTHERS then
   UTL_FILE.PUT_LINE(v_file_type_log ,'Erro 9 ->'||sqlerrm||wproc); 
END;
/
set serverout off;                                                
set feed on;
exit;