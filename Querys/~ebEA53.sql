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
                          SELECT ACCOUNT_NO FROM bipP27
                          MINUS
                          SELECT ACCOUNT_NO
                          FROM BILL_INVOICE
                          WHERE PREP_DATE >= sysdate - 15
                         )
AND    CMF.ACCOUNT_CATEGORY IN (9)
AND    EIAM.EXTERNAL_ID_TYPE = 1
AND    exists (SELECT 1
                 FROM CUSTOMER_ID_EQUIP_MAP EIEM,
                      SERVICE SERV
                WHERE SERV.SUBSCR_NO         = EIEM.SUBSCR_NO
                  AND SERV.SUBSCR_NO_RESETS  = EIEM.SUBSCR_NO_RESETS
                  AND EIEM.VIEW_ID           = SERV.VIEW_ID
                  AND EIEM.EXTERNAL_ID_TYPE  = 1
                  AND EIEM.INACTIVE_DATE     IS NULL
                  AND SERV.PARENT_ACCOUNT_NO = EIAM.ACCOUNT_NO);
                  
