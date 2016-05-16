select NSA, SUM(valor) from E9502359SQL.CANCEL_CEF group by nsa

 SELECT D.EXTERNAL_ID, A.ACCOUNT_NO, B.BILL_REF_NO, A.VALOR, b.tracking_id FROM E9502359SQL.cancel_cef A,
                    PAYMENT_TRANS B,
                    CMF_BALANCE C,
                    CUSTOMER_ID_ACCT_MAP D
                WHERE  A.ACCOUNT_NO = B.ACCOUNT_NO
                AND  A.ACCOUNT_NO = C.ACCOUNT_NO
                AND  A.ACCOUNT_NO = D.ACCOUNT_NO
                AND A.TRACKING_ID = B.TRACKING_ID
--                AND B.PAYMENT_DUE_DATE >= TO_DATE ('01/12/2011','DD/MM/YYYY')
--                AND B.PAYMENT_DUE_DATE <= TO_DATE ('31/12/2011','DD/MM/YYYY')
                AND C.BILL_REF_NO <> 0
                AND C.CLOSED_DATE IS NULL
                AND D.EXTERNAL_ID_TYPE = 1
                
                and D.EXTERNAL_ID = '999984807209'
                
                
                