DECLARE
VLR   NUMBER(10);
AUX_GLOBAL_NAME VARCHAR(200);
V_PATH                    VARCHAR2(200) := '&1'; --Pasta para o arquivo de Log
V_FILENAME                VARCHAR2(50)  := 'LOG_BMF_DELETE_' || to_char( sysdate ,'yyyymmdd_hh24miss' ) || '.log';
V_FILE                    UTL_FILE.FILE_TYPE;

CURSOR FATURA IS
SELECT * FROM BMF WHERE TRACKING_ID IN
(60351075,
60353131,
60350931,
60351052,
60351735,
60351077,
60351042,
60351566,
60350926);


BEGIN
    V_FILE := UTL_FILE.FOPEN(V_PATH, V_FILENAME, 'W');
    select trim(GLOBAL_NAME) into AUX_GLOBAL_NAME from GLOBAL_NAME;
    UTL_FILE.PUT_LINE( V_FILE, 'Inicio - ' || AUX_GLOBAL_NAME || ' : ' || to_char( sysdate ,'yyyymmdd_hh24miss' ));

    FOR C1 IN FATURA LOOP
    BEGIN
        UTL_FILE.PUT_LINE( V_FILE, 'VAI FAZER => ' || C1.ACCOUNT_NO || ' - ' || C1.TRACKING_ID || ' - ' || C1.TRACKING_ID_SERV);
        BMF_DELETE(C1.TRACKING_ID, C1.TRACKING_ID_SERV);
        COMMIT;

    EXCEPTION
    WHEN OTHERS THEN
        UTL_FILE.PUT_LINE( V_FILE, 'ERRO AO EXCLUIR PAGAMENTO = ' || C1.ACCOUNT_NO || ' - ' || C1.TRACKING_ID || ' - ' || C1.TRACKING_ID_SERV);
        UTL_FILE.PUT_LINE( V_FILE, sqlerrm(sqlcode));
    END;
    END LOOP;

    COMMIT;
    UTL_FILE.PUT_LINE( V_FILE, 'Fim: ' || to_char( sysdate ,'yyyymmdd_hh24miss' ));
    UTL_FILE.FCLOSE(V_FILE);
END;
/
