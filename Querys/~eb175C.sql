                
      
                SELECT TO_CHAR(CIEM.VIEW_ID) AS CUSTOMER_ID, CIEM.VIEW_STATUS AS CUSTOMER_STATUS,
       CASE
         WHEN CIEM.VIEW_STATUS = 1
              AND CIEM.INACTIVE_DATE IS NULL
              THEN 'UPDATE CUSTOMER_ID_EQUIP_MAP_VIEW CIEM
                           SET CIEM.VIEW_STATUS = 2
                           WHERE CIEM.SUBSCR_NO = '||CIEM.SUBSCR_NO||' 
                           AND CIEM.VIEW_ID = '||TO_CHAR(CIEM.VIEW_ID)||';'
             WHEN CIEM.VIEW_STATUS = 1
               AND CIEM.INACTIVE_DATE IS NOT NULL
               THEN 'UPDATE CUSTOMER_ID_EQUIP_MAP_VIEW CIEM
                           SET CIEM.VIEW_STATUS = 4
                           WHERE CIEM.SUBSCR_NO = '||CIEM.SUBSCR_NO||' 
                           AND CIEM.VIEW_ID = '||TO_CHAR(CIEM.VIEW_ID)||';'
       ELSE
          'Sem registros pendentes na customer_id_equip_map_view'
       END CUSTOMER,       
       CIEM.ACTIVE_DATE, CIEM.INACTIVE_DATE,
       S.VIEW_ID AS SERVICE_ID, S.VIEW_STATUS AS SERVICE_STATUS,
       CASE
         WHEN S.VIEW_STATUS = 1
              AND S.SERVICE_INACTIVE_DT IS NULL
              THEN 'UPDATE SERVICE_VIEW S
                           SET S.VIEW_STATUS = 2
                           WHERE S.SUBSCR_NO = '||S.SUBSCR_NO||' 
                           AND S.VIEW_ID = '||TO_CHAR(S.VIEW_ID)||';'
             WHEN S.VIEW_STATUS = 1
               AND S.SERVICE_INACTIVE_DT IS NOT NULL
               THEN 'UPDATE SERVICE_VIEW S
                           SET S.VIEW_STATUS = 4
                           WHERE S.SUBSCR_NO = '||S.SUBSCR_NO||' 
                           AND S.VIEW_ID = '||TO_CHAR(S.VIEW_ID)||';'
       ELSE
          'Sem registros pendentes na SERVICE_VIEW'
       END SERVICE,
       S.SERVICE_ACTIVE_DT, S.SERVICE_INACTIVE_DT,
       P.VIEW_ID AS PRODUCT_ID, P.VIEW_STATUS AS PRODUCT_STATUS, 
       CASE
         WHEN P.VIEW_STATUS = 1
              AND ( P.PRODUCT_INACTIVE_DT IS NULL
                    OR P.BILLING_INACTIVE_DT IS NULL )
              THEN 'UPDATE PRODUCT_VIEW P
                           SET P.VIEW_STATUS = 2
                           WHERE P.PARENT_SUBSCR_NO = '||P.PARENT_SUBSCR_NO||' 
                           AND P.VIEW_ID = '||TO_CHAR(P.VIEW_ID)||';'
              WHEN P.VIEW_STATUS = 1
              AND ( P.PRODUCT_INACTIVE_DT IS NOT NULL
                    OR P.BILLING_INACTIVE_DT IS NOT NULL )
              THEN 'UPDATE PRODUCT_VIEW P
                           SET P.VIEW_STATUS = 4
                           WHERE P.PARENT_SUBSCR_NO = '||P.PARENT_SUBSCR_NO||' 
                           AND P.VIEW_ID = '||TO_CHAR(P.VIEW_ID)||';'                  
            ELSE
          'Sem registros pendentes na PRODUCT_VIEW'
       END PRODUCT,
       P.PRODUCT_ACTIVE_DT, P.PRODUCT_INACTIVE_DT,
       SAA.SERVICE_ADDRESS_ASSOC_ID AS ASSOC_ID, SAA.ASSOCIATION_STATUS AS ASSOC_STATUS,
              CASE
         WHEN SAA.ASSOCIATION_STATUS = 1
              AND ( SAA.INACTIVE_DT IS NULL )
              THEN 'UPDATE SERVICE_ADDRESS_ASSOC SAA
                           SET SAA.ASSOCIATION_STATUS = 2
                           WHERE SAA.SUBSCR_NO = '||SAA.SUBSCR_NO||' 
                           AND SAA.SERVICE_ADDRESS_ASSOC_ID = '||TO_CHAR(SAA.SERVICE_ADDRESS_ASSOC_ID)||';'
         WHEN SAA.ASSOCIATION_STATUS = 1
              AND ( SAA.INACTIVE_DT IS NOT NULL )
              THEN 'UPDATE SERVICE_ADDRESS_ASSOC SAA
                           SET SAA.ASSOCIATION_STATUS = 4
                           WHERE SAA.SUBSCR_NO = '||SAA.SUBSCR_NO||' 
                           AND SAA.SERVICE_ADDRESS_ASSOC_ID = '||TO_CHAR(SAA.SERVICE_ADDRESS_ASSOC_ID)||';'
            ELSE
          'Sem registros pendentes na SERVICE_ADDRESS_ASSOC'
       END SERVICE_ADDRESS_ASSOC,
       SAA.ACTIVE_DT, SAA.INACTIVE_DT,
       CCV.VIEW_ID AS CONTRACT_ID, CCV.VIEW_STATUS AS CONTRACT_STATUS,
                     CASE
         WHEN CCV.VIEW_STATUS = 1
              AND ( CCV.END_DT IS NULL )
              THEN 'UPDATE CUSTOMER_CONTRACT_VIEW CCV
                           SET CCV.VIEW_STATUS = 2
                           WHERE CCV.PARENT_SUBSCR_NO = '||CCV.PARENT_SUBSCR_NO||' 
                           AND CCV.VIEW_ID = '||TO_CHAR(CCV.VIEW_ID)||';'
         WHEN CCV.VIEW_STATUS = 1
              AND ( CCV.END_DT IS NOT NULL )
              THEN 'UPDATE CUSTOMER_CONTRACT_VIEW CCV
                           SET CCV.VIEW_STATUS = 4
                           WHERE CCV.PARENT_SUBSCR_NO = '||CCV.PARENT_SUBSCR_NO||' 
                           AND CCV.VIEW_ID = '||TO_CHAR(CCV.VIEW_ID)||';'
            ELSE
          'Sem registros pendentes na CUSTOMER_CONTRACT_VIEW'
       END SERVICE_ADDRESS_ASSOC,
       CCV.START_DT, CCV.END_DT     
       FROM CUSTOMER_ID_EQUIP_MAP_VIEW CIEM       
            LEFT JOIN SERVICE_VIEW S ON CIEM.SUBSCR_NO = S.SUBSCR_NO 
                 AND S.VIEW_STATUS = 1    
            LEFT JOIN PRODUCT_VIEW P ON CIEM.SUBSCR_NO = P.PARENT_SUBSCR_NO
                 AND P.VIEW_STATUS = 1
            LEFT JOIN CUSTOMER_CONTRACT_VIEW CCV ON CIEM.SUBSCR_NO = CCV.PARENT_SUBSCR_NO
                 AND CCV.VIEW_STATUS = 1
            LEFT JOIN SERVICE_ADDRESS_ASSOC SAA ON CIEM.SUBSCR_NO = SAA.SUBSCR_NO                         
                 AND SAA.ASSOCIATION_STATUS = 1
       WHERE CIEM.EXTERNAL_ID in ('1144520407','2127123863','3125125961','2138566826','2730916205');