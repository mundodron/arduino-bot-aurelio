CREATE OR REPLACE PACKAGE BODY "BILL_CORP_OWNER"."GVT_PKG_KENAN_CORP" IS
 TYPE TIPO_ret IS RECORD
    (
        EXTERNAL_ID varchar2(200),
        ACCOUNT_NO   varchar2(200),
        SERVER_ID  varchar2(200),
        SERVER_TYPE varchar2(200),
        HOSTNAME varchar2(200),
        IP_ADDRESS varchar2(200),
        DSQUERY  varchar2(200), 
        DS_DATABASE  varchar2(200),
        ARBORDATA  varchar2(200)
    );
    PROCEDURE GET_ACCOUNT_NO(P_EXTERNAL_ID_IN       IN VARCHAR2,
                             P_EXTERNAL_ID_TYPE_IN  IN VARCHAR2,
                             P_ACCOUNT_NO_OUT       OUT VARCHAR2,
                             P_NUM_ERRO_OUT         OUT NUMBER,
                             P_DES_ERRO_OUT         OUT VARCHAR2) IS
    BEGIN
        SELECT ACCOUNT_NO
          INTO P_ACCOUNT_NO_OUT
          FROM (SELECT eam.account_no
                  FROM arbor.external_id_acct_map eam
                 WHERE (eam.external_id = P_EXTERNAL_ID_IN OR
                       eam.external_id = RPAD(P_EXTERNAL_ID_IN, 48))
                   AND eam.external_id_type = P_EXTERNAL_ID_TYPE_IN
                   AND eam.inactive_date IS NULL
                 ORDER BY eam.inactive_date DESC)
         WHERE rownum = 1;
        P_NUM_ERRO_OUT := 0;
        P_DES_ERRO_OUT := 'SUCESSO';
    EXCEPTION
        WHEN OTHERS THEN
            P_NUM_ERRO_OUT := -1;
            P_DES_ERRO_OUT := '[ERRO] ' || substr(sqlerrm,1,250);
    END GET_ACCOUNT_NO;
    PROCEDURE GET_SUBSCR_NO(P_EXTERNAL_ID_IN       IN VARCHAR2,
                            P_EXTERNAL_ID_TYPE_IN  IN VARCHAR2,
                            P_SUBSCR_NO_OUT        OUT VARCHAR2,
                            P_NUM_ERRO_OUT         OUT NUMBER,
                            P_DES_ERRO_OUT         OUT VARCHAR2) IS
    BEGIN
        SELECT SUBSCR_NO
          INTO P_SUBSCR_NO_OUT
          FROM (SELECT cem.subscr_no
               FROM arbor.external_id_equip_map cem
               WHERE (cem.external_id = P_EXTERNAL_ID_IN OR
                     cem.external_id = RPAD(P_EXTERNAL_ID_IN, 48))
                 AND cem.external_id_type = P_EXTERNAL_ID_TYPE_IN
                 AND cem.inactive_date IS NULL
               ORDER BY CEM.INACTIVE_DATE DESC)
       WHERE rownum = 1;
        P_NUM_ERRO_OUT := 0;
        P_DES_ERRO_OUT := 'SUCESSO';
    EXCEPTION
        WHEN OTHERS THEN
            P_NUM_ERRO_OUT := -1;
            P_DES_ERRO_OUT := '[ERRO] ' || substr(sqlerrm,1,250);
    END GET_SUBSCR_NO;
    PROCEDURE GET_DADOS_CICLO(  P_CICLO         IN VARCHAR2,
                                P_STATUS_FLG    OUT VARCHAR2,
                                P_NUM_ERRO      OUT NUMBER,
                                P_DES_ERRO      OUT VARCHAR2) IS
    BEGIN
        P_STATUS_FLG := 'N';
        SELECT 'Y' INTO P_STATUS_FLG FROM ARBORGVT_BILLING.STATUS_CICLO WHERE CICLO = P_CICLO AND STATUS_FLG = 'Y';
        P_NUM_ERRO := 0;
        P_DES_ERRO := 'SUCESSO';
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
        BEGIN
            SELECT DECODE(CICLO,'MENSAL', 'N', 'AVULSO','A') INTO P_STATUS_FLG 
            FROM ARBORGVT_BILLING.STATUS_CICLO WHERE CICLO IN ('MENSAL', 'AVULSO') 
            AND STATUS_FLG = 'Y';
            EXCEPTION
            WHEN NO_DATA_FOUND THEN
            BEGIN
                P_STATUS_FLG := 'N';
            END;
        END;
        WHEN OTHERS THEN
            P_NUM_ERRO := -1;
            P_DES_ERRO := '[ERRO] ' || substr(sqlerrm,1,250);
    END GET_DADOS_CICLO;
    PROCEDURE VERIFY_ACCOUNT_CREATED
    ( 
        P_DOCUMENTO IN VARCHAR2,
        P_CONTA     IN VARCHAR2,
        P_CONTA_PAI IN  VARCHAR2,
        P_CICLO     IN VARCHAR2,
        P_ACCT_FOUND OUT VARCHAR2,
        P_SERVER_ID OUT VARCHAR2,
        P_NUM_ERRO  OUT NUMBER,
        P_DES_ERRO  OUT VARCHAR2
    )
    IS
    BEGIN
        P_ACCT_FOUND:= 'N';
        P_SERVER_ID := 0;
        P_NUM_ERRO := 0;
        P_DES_ERRO := 'SUCESSO';
        SELECT 'Y' INTO P_ACCT_FOUND FROM EXTERNAL_ID_ACCT_MAP WHERE EXTERNAL_ID = P_CONTA AND INACTIVE_DATE IS NULL;
        SELECT  TO_CHAR(EIAM.SERVER_ID)
        INTO P_SERVER_ID
        FROM ARBOR.SERVER_DEFINITION SD, EXTERNAL_ID_ACCT_MAP EIAM
        WHERE EIAM.EXTERNAL_ID = P_CONTA
        AND EIAM.EXTERNAL_ID_TYPE = 2
        AND SD.SERVER_ID = EIAM.SERVER_ID
        AND INACTIVE_DATE IS NULL;
        EXCEPTION
        WHEN NO_DATA_FOUND THEN 
        BEGIN
            -- NÃO ENCONTROU A CONTA , VERIFICAR SE EXISTE ALGUMA OUTRA CONTA CRIADA NA HIERARQUIA
            -- Pesquisa pela conta pai
            SELECT  TO_CHAR(EIAM.SERVER_ID)
            INTO  P_SERVER_ID
            FROM ARBOR.SERVER_DEFINITION SD, EXTERNAL_ID_ACCT_MAP EIAM
            WHERE EIAM.EXTERNAL_ID = P_CONTA_PAI
            AND EIAM.EXTERNAL_ID_TYPE = 2
            AND SD.SERVER_ID = EIAM.SERVER_ID;
            EXCEPTION
            WHEN NO_DATA_FOUND THEN
            BEGIN
                IF(P_SERVER_ID = 0) THEN -- NÃO ENCONTROU NENHUMA CONTA DA HIERARQUIA CRIADA, PROCURAR O SERVERID PELO CICLO
                    SELECT TO_CHAR(SD.SERVER_ID)
                    INTO P_SERVER_ID
                    FROM   GVT_BALANCEAMENTO_CUSTOMERS GBC, SERVER_DEFINITION SD
                    WHERE  GBC.SERVER_ID IN 
                        (SELECT SERVER_ID
                        FROM GVT_BALANCEAMENTO_CUSTOMERS
                        WHERE (QTDE_INST_ATIVA, BILL_PERIOD) IN 
                            (SELECT MIN(QTDE_INST_ATIVA), BILL_PERIOD
                            FROM   GVT_BALANCEAMENTO_CUSTOMERS A
                            WHERE BILL_PERIOD = REPLACE(SUBSTR(P_CICLO,1,LENGTH(P_CICLO)),'V','M')
                            GROUP BY BILL_PERIOD)
                        )
                    AND GBC.SERVER_ID = SD.SERVER_ID
                    GROUP BY SD.SERVER_ID;
                END IF;
            END;
        END;
            --DBMS_OUTPUT.PUT_LINE('P_ACCT_FOUND:' || P_ACCT_FOUND || '  P_SERVER_ID: ' || P_SERVER_ID || '  P_SERVER_ID: ' || P_SERVER_ID);
        WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('EXCEPTION - P_ACCT_FOUND:' || P_ACCT_FOUND || '  P_SERVER_ID: ' || P_SERVER_ID || '  P_SERVER_ID: ' || P_SERVER_ID);
        P_NUM_ERRO := -1;
        P_DES_ERRO := '[ERRO] ' || substr(sqlerrm,1,250);
    END VERIFY_ACCOUNT_CREATED;
    PROCEDURE VERIFY_INSTANCE_CREATED( P_ASSET_NUM IN VARCHAR2,
                                       P_ACCOUNT_ID  IN VARCHAR2,
                                       P_START_DATE IN VARCHAR2,
                                       P_ACCT_FOUND OUT VARCHAR2,
                                       P_INST_FOUND OUT VARCHAR2,
                                       P_SERVER_ID OUT VARCHAR2,
                                       P_ACCT_EXTERNAL_ID_TYPE OUT VARCHAR2,
                                       P_NUM_ERRO  OUT NUMBER,
                                       P_DES_ERRO  OUT VARCHAR2) IS
    BEGIN
        P_NUM_ERRO := 0;
        P_DES_ERRO := 'SUCESSO';
        P_ACCT_FOUND:='N';
        P_INST_FOUND:='N';
        P_SERVER_ID:=0;
        SELECT 'Y', SERVER_ID, C.EXTERNAL_ID_TYPE  INTO P_ACCT_FOUND, P_SERVER_ID, P_ACCT_EXTERNAL_ID_TYPE  
        FROM EXTERNAL_ID_ACCT_MAP C 
        WHERE C.EXTERNAL_ID = P_ACCOUNT_ID AND INACTIVE_DATE IS NULL; 
        SELECT 'Y' INTO P_INST_FOUND
        FROM EXTERNAL_ID_ACCT_MAP C, EXTERNAL_ID_EQUIP_MAP E
        WHERE C.EXTERNAL_ID = P_ACCOUNT_ID
        AND C.ACCOUNT_NO = E.ACCOUNT_NO
        AND E.EXTERNAL_ID = P_ASSET_NUM
        AND E.EXTERNAL_ID_TYPE = 1
        AND E.INACTIVE_DATE IS NULL;
        EXCEPTION
        WHEN NO_DATA_FOUND THEN
        IF (P_ACCT_FOUND = 'Y') THEN -- ENCONTROU A CONTA MAS NÃO A INSTANCIA
            P_NUM_ERRO := -2;
            P_DES_ERRO := '[NÃO ENCONTROU A INSTANCIA]=[' || P_ASSET_NUM || '] DATA=[' || P_START_DATE || ']';
        ELSE
            P_NUM_ERRO := -3;
            P_DES_ERRO := '[NÃO ENCONTROU A CONTA]=[' || P_ACCOUNT_ID || ']';
        END IF;
        WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('EXCEPTION ');
            P_NUM_ERRO := -1;
            P_DES_ERRO := '[ERRO] ' || substr(sqlerrm,1,250);
    END VERIFY_INSTANCE_CREATED;
    PROCEDURE VERIFY_INSTANCE_DISCONNECTED( P_ASSET_NUM IN VARCHAR2,
                                       P_ACCOUNT_ID  IN VARCHAR2,
                                       P_NUM_ERRO  OUT NUMBER,
                                       P_DES_ERRO  OUT VARCHAR2) IS
    T_ACTIVE NUMBER;
    T_INACTIVE NUMBER;
    T_ACTIVE_DATE DATE; 
    BEGIN                                       
        P_NUM_ERRO := 0;
        P_DES_ERRO := 'SUCESSO';
        T_ACTIVE := 0;
        T_INACTIVE := 0;
        -- PROCURA INSTANCIA ATIVA
        SELECT COUNT(*), MAX(E.ACTIVE_DATE) INTO T_ACTIVE, T_ACTIVE_DATE
        FROM EXTERNAL_ID_ACCT_MAP C, EXTERNAL_ID_EQUIP_MAP E
        WHERE C.EXTERNAL_ID = P_ACCOUNT_ID
        AND C.ACCOUNT_NO = E.ACCOUNT_NO
        AND E.EXTERNAL_ID = P_ASSET_NUM
        AND E.EXTERNAL_ID_TYPE = 1
        AND E.INACTIVE_DATE IS NULL;
        -- PROCURA INSTANCIA INATIVA
        SELECT COUNT(*) INTO T_INACTIVE
        FROM EXTERNAL_ID_ACCT_MAP C, EXTERNAL_ID_EQUIP_MAP E
        WHERE C.EXTERNAL_ID = P_ACCOUNT_ID
        AND C.ACCOUNT_NO = E.ACCOUNT_NO
        AND E.EXTERNAL_ID = P_ASSET_NUM
        AND E.EXTERNAL_ID_TYPE = 1
        AND E.INACTIVE_DATE IS NOT NULL;
        -- ENCONTROU INSTANCIAS ATIVAS
        IF (T_ACTIVE > 0)  THEN
            P_NUM_ERRO := -1;
            P_DES_ERRO := '[INSTANCIA ESTÁ ATIVA COM DATA ]=[' || T_ACTIVE_DATE || ']';
        END IF;
        -- SÓ ENCONTROU INSTANCIAS INATIVAS
        IF (T_ACTIVE = 0) AND (T_INACTIVE > 0)THEN
            P_NUM_ERRO := 0;
            P_DES_ERRO := '[SUCESSO]';
        END IF;
        -- NÃO ENCONTROU NENHUMA INSTANCIA
        IF (T_ACTIVE = 0) AND (T_INACTIVE = 0)THEN
            P_NUM_ERRO := -2;
            P_DES_ERRO := '[NÃO ENCONTROU A INSTANCIA]=[' || P_ASSET_NUM || '] NA CONTA =[' || P_ACCOUNT_ID || ']';
        END IF;
        EXCEPTION
        WHEN NO_DATA_FOUND THEN
            P_NUM_ERRO := -2;
            P_DES_ERRO := '[NÃO ENCONTROU A INSTANCIA]=[' || P_ASSET_NUM || '] NA CONTA =[' || P_ACCOUNT_ID || ']';
        WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('EXCEPTION ');
            P_NUM_ERRO := -1;
            P_DES_ERRO := '[ERRO] ' || substr(sqlerrm,1,250);
    END VERIFY_INSTANCE_DISCONNECTED;
    PROCEDURE GVT_GET_SERVER_BY_CONTA_COBR
( v_conta_cobranca IN  VARCHAR2,
  cursor_ext_ids   OUT TYPE_CURSOR,
  codigo_erro      OUT NUMBER,
  mensagem         OUT VARCHAR2
)
IS
  l_dummy VARCHAR2(1);
   t_cursor TYPE_CURSOR;
    var_TIPO_ret TIPO_ret;
BEGIN
    SELECT 1 into l_dummy
      FROM EXTERNAL_ID_ACCT_MAP eiam, SERVER_DEFINITION sd 
     WHERE eiam.EXTERNAL_ID = v_conta_cobranca 
       AND sd.SERVER_ID = EIAM.SERVER_ID
       AND rownum < 2;
    open  t_cursor for
    SELECT eiam.EXTERNAL_ID,eiam.ACCOUNT_NO, eiam.SERVER_ID, 
           sd.SERVER_TYPE, sd.HOSTNAME, sd.IP_ADDRESS, sd.DSQUERY,   
           sd.DS_DATABASE, sd.ARBORDATA
      FROM EXTERNAL_ID_ACCT_MAP eiam, SERVER_DEFINITION sd 
     WHERE eiam.EXTERNAL_ID = v_conta_cobranca 
       AND sd.SERVER_ID = EIAM.SERVER_ID;
        <<LOOP_CURSOR_EXT_IDS>>
        LOOP
        FETCH  t_cursor INTO var_TIPO_ret;
        EXIT LOOP_CURSOR_EXT_IDS WHEN  t_cursor%NOTFOUND;
        BEGIN
           dbms_output.put_line('param_name: ' ||  var_TIPO_ret.SERVER_ID || '   MENSAGEM: ' || MENSAGEM);
        END;
   END LOOP LOOP_CURSOR_EXT_IDS;
codigo_erro := 0;
mensagem    := NULL;
EXCEPTION
WHEN NO_DATA_FOUND THEN
/*Retorna MENSAGEM de CLIENTE NÃO ENCONTRADO*/
    codigo_erro := -12;
    mensagem    := 'CLIENTE NÃO ENCONTRADO';
WHEN OTHERS THEN
/*Retorna MENSAGEM de ERRO*/
    codigo_erro := -13;
    mensagem    := 'ERRO NA BUSCA DO CLIENTE ->' || TO_CHAR (SQLCODE) || '-' || SQLERRM;
END GVT_GET_SERVER_BY_CONTA_COBR;
END GVT_PKG_KENAN_CORP;