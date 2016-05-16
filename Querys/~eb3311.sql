SELECT '${GVT_MODE}',
       '${DATA}',
       EIAM.EXTERNAL_ID,
       CMF.ACCOUNT_NO,
       CMF.PARENT_ID,
       CMF.ACCOUNT_CATEGORY,
       CMF.NO_BILL,
       CMF.BILL_PERIOD,
       CMF.BILL_LNAME,
       CMF.CONTACT1_PHONE,
       CMF.PREV_CUTOFF_DATE,
       CMF.PREV_BILL_DATE,
       CMF.NEXT_BILL_DATE,
       NULL,
       NULL,
       NULL,
       NULL,
       NULL,
       NULL,
       NULL,
       NULL,
       NULL,
       NULL,
       NULL,
       NULL,
       'CONTA IGNORADA PELO BIP',
       SYSDATE,
       NULL
FROM   CMF CMF,
       CUSTOMER_ID_ACCT_MAP EIAM
WHERE  CMF.ACCOUNT_NO IN (
                          SELECT ACCOUNT_NO FROM ${TABELA}
                          MINUS
                          SELECT ACCOUNT_NO
                          FROM BILL_INVOICE
                          WHERE PREP_DATE >= TO_DATE('${DATA_BIP}','YYYYMMDDHH24:MI:SS')
                         )
AND    CMF.ACCOUNT_CATEGORY IN (${CATEGORIA})
AND    CMF.ACCOUNT_NO = EIAM.ACCOUNT_NO
AND    EIAM.EXTERNAL_ID_TYPE = 1;

--------------------------------------------------------------------------------
          SELECT COUNT(*) FROM GVT_DETALHAMENTO_CICLO
           WHERE DATA_PROCESSO >= TO_DATE ('${DATA_BIP}','YYYYMMDDHH24:MI:SS')
                         AND GVT_DATE = '${DATA}'
                         AND BILL_PERIOD = UPPER('${CICLO}')
                         AND GVT_MODE = '${GVT_MODE}'
                         AND ANOTATION = 'CONTA IGNORADA PELO BIP'
                         AND ACCOUNT_CATEGORY IN (${CATEGORIA});