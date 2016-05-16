        SELECT   A.COMPONENT_ID, TIRA_ACENTO(A.COMPONENTE) AS COMPONENTE
          FROM   G0023421SQL.GVT_VAL_PLANO A
         WHERE   A.PLANO = (SELECT PLANO FROM GVT_VAL_PLANO WHERE COMPONENT_ID in (30367)) 
           AND A.TIPOELEMENTO = 'RC - Conta'
                 AND NOT EXISTS
                       (SELECT   1
                          FROM   CMF_PACKAGE_COMPONENT CPC
                         WHERE       CPC.PARENT_ACCOUNT_NO = 7345220
                                 AND CPC.INACTIVE_DT IS NULL
                                 AND A.COMPONENT_ID = CPC.COMPONENT_ID)
        UNION
       SELECT   A.COMPONENT_ID, TIRA_ACENTO(A.COMPONENTE) AS COMPONENTE
          FROM   G0023421SQL.GVT_VAL_PLANO A
         WHERE   A.PLANO = (SELECT PLANO FROM GVT_VAL_PLANO WHERE COMPONENT_ID = 30367) 
           AND A.TIPOELEMENTO = 'RC - Instancia'
                 AND NOT EXISTS
                       (SELECT   1
                          FROM   CMF_PACKAGE_COMPONENT CPC
                         WHERE       CPC.PARENT_SUBSCR_NO = 22882634 -- 19535443
                                 AND CPC.INACTIVE_DT IS NULL
                                 AND A.COMPONENT_ID = CPC.COMPONENT_ID);