--
-- NOME ARQUIVO : PL_CONTROLE_JURISDICTION.SQL 
-- VERSÃO : 1.0
-- AUTOR : WILLSON COELHO MARTINS 
-- DATA: 23/03/2012
-- 
-- FUNCAO : ESTA PL SERVE PARA TIRAR A "FOTO" DAS CHAVES DE TARIFACAO
--
-- Ultima alteração:
-- Aurelio Avanzi  -  01/07/2015 - RDM23328.
---------------------------------------------------------------------------------
-- VARIAVEIS

DECLARE

    v_diretorio_arquivo VARCHAR2(100) := '&1'; -- BILLING_FAT_LOG
    v_prep_status       VARCHAR2(10) := '&2'; -- prep_status
    v_prep_date         VARCHAR2(19) := '&3'; -- Data Inicio BIP
    --  parametro      4   -- tabela de bipm02 bipm05 tabela_bip_avulso
    v_nome_arquivo VARCHAR2(60);
    v_harqsaida    UTL_FILE.file_type;
    v_msg          VARCHAR2(500);
    v_count_rows   number(10) = 0;


    ------------INICIO PROGRAMA ---------------------
BEGIN

    v_nome_arquivo := 'PL_Controle_Jurisdiction_' || TO_CHAR(SYSDATE, 'YYYYMMDDHH24MISS') || '.LOG';
    v_harqsaida    := UTL_FILE.fopen(v_diretorio_arquivo, v_nome_arquivo, 'W', 32000);

    v_msg := 'Inicio Processamento : ' || TO_CHAR(SYSDATE, 'DD/MM/YYYY HH24:MI:SS');

    UTL_FILE.put_line(v_harqsaida, v_msg);
    UTL_FILE.fflush(v_harqsaida);


    INSERT INTO GVT_BILL_PRODUCT_RATE_KEY
        SELECT /*+ ordered FULL(TABELA_BIP) PARALLEL(TABELA_BIP 40) */
        DISTINCT BI.ACCOUNT_NO,
                         BID.BILL_REF_NO,
                         BID.BILL_REF_RESETS,
                         BID.SUBSCR_NO,
                         BID.SUBSCR_NO_RESETS,
                         BID.TRACKING_ID,
                         BID.TRACKING_ID_SERV,
                         PRK.JURISDICTION,
                         --  DES.SHORT_DESCRIPTION_TEXT REGION, -- ALTERADO PROJETO ALFAIATE  / MARCELO MAZETTI GOMIDES
                         (SELECT DES.SHORT_DESCRIPTION_TEXT
                                FROM DESCRIPTIONS DES
                             WHERE DES.LANGUAGE_CODE = 2
                                 AND DES.DESCRIPTION_CODE = PRK.JURISDICTION) REGION,
                         PRK.UNITS,
                         PRK.UNITS_TYPE,
                         PRK.ACTIVE_DT,
                         PRK.INACTIVE_DT,
                         PS.ELEMENT_ID,
                         BI.PREP_DATE
            FROM BILL_INVOICE BI,
                     BILL_INVOICE_DETAIL BID,
                     PRODUCT_RATE_KEY PRK,
                     (SELECT DISTINCT ELEMENT_ID
                            FROM PRODUCT_ELEMENTS P
                         WHERE P.RATE_UNITS = 1
                        --               AND P.RATE_JURISDICTION = 1  -- ALTERADO PROJETO ALFAIATE  / MARCELO MAZETTI GOMIDES
                        ) PS,
                     &4 TABELA_BIP
         WHERE BI.ACCOUNT_NO = TABELA_BIP.ACCOUNT_NO
             AND BI.PREP_DATE >= TO_DATE(v_prep_date, 'YYYYMMDD hh24:mi:ss')
             AND BI.BILL_REF_NO = BID.BILL_REF_NO
             AND BI.BILL_REF_RESETS = BID.BILL_REF_RESETS
             AND BID.TYPE_CODE = 2
             AND BID.SUBTYPE_CODE = PS.ELEMENT_ID
             AND BID.TRACKING_ID = PRK.TRACKING_ID
             AND BID.TRACKING_ID_SERV = PRK.TRACKING_ID_SERV
             AND BID.TO_DATE >= PRK.ACTIVE_DT
             AND (BID.FROM_DATE <= PRK.INACTIVE_DT OR PRK.INACTIVE_DT IS NULL)
             AND BI.PREP_STATUS = v_prep_status;

    v_msg := 'Fim Processamento : ' || TO_CHAR(SYSDATE, 'DD/MM/YYYY HH24:MI:SS');

    UTL_FILE.put_line(v_harqsaida, v_msg);
    UTL_FILE.fflush(v_harqsaida);
    UTL_FILE.fclose(v_harqsaida);

    v_count_rows = sql%rowcount;
    commit;
EXCEPTION
    WHEN OTHERS THEN
        v_msg := 'O processo terminou com erro : ' || TO_CHAR(SYSDATE, 'DD/MM/YYYY HH24:MI:SS' || SQLERRM);
        UTL_FILE.put_line(v_harqsaida, v_msg);
        UTL_FILE.fflush(v_harqsaida);
        UTL_FILE.fclose(v_harqsaida);
    rollback;
         DBMS_OUTPUT.put_line ('ERRO AO GERAR ARQUIVO: ' || substr(SQLERRM,1,250) ;
         DBMS_OUTPUT.put_line ('Inseridos: ' || v_count_rows || 'Registros na tabela GVT_BILL_PRODUCT_RATE_KEY');
         DBMS_OUTPUT.put_line ('Favor relançar o Job e comunicar o plantão Billing por email' );
END;
/
