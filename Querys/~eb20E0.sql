SELECT SRV.PARENT_ID
, SRV.ACCOUNT_CATEGORY
, SRV.DISPLAY_VALUE
, SRV.BILL_INVOICE_ROW
, SRV.BILL_REF_NO
, SRV.CONTA
, SRV.ACCOUNT_NO
, SRV.UF
, SRV.BILL_LNAME
, SRV.BILL_ADDRESS1
, SRV.BILL_ADDRESS2
, SRV.BILL_ADDRESS3 
, SRV.BILL_CITY 
, SRV.BILL_ZIP 
, SRV.BILL_STATE 
, SRV.BILL_PERIOD 
, SRV.BILL_REF_NO
, SRV.STATEMENT_DATE 
, SRV.FROM_DATE 
, SRV.TO_DATE 
, SRV.EQUIP_EXTERNAL_ID
, SRV.SUBTYPE_CODE 
, SRV.DESCRIPTION_TEXT
, SRV.POP_UNITS
, SRV.QUANT
, SRV.UNITS
, SRV.AMOUNT
, SRV.DISCOUNT
, ICMS.TAX_RATE/10000  AS "ICMS"
, PIS.TAX_RATE /10000  AS "PIS"
FROM
 (SELECT
  CLIENTE.PARENT_ID 
 ,ACCVA.ACCOUNT_CATEGORY 
 ,ACCVA.DISPLAY_VALUE
 ,DETALHE.BILL_INVOICE_ROW 
 ,DETALHE.BILL_REF_NO 
 ,TRIM (CONTA.EXTERNAL_ID) CONTA
 ,CLIENTE.ACCOUNT_NO
 ,TRIM (SUBSTR (UF.DISPLAY_VALUE, INSTR (UF.DISPLAY_VALUE, ',') + 1,  3 )) UF
 ,CLIENTE.BILL_LNAME
 ,CLIENTE.BILL_ADDRESS1
 ,CLIENTE.BILL_ADDRESS2 
 ,CLIENTE.BILL_ADDRESS3
 ,CLIENTE.BILL_CITY 
 ,CLIENTE.BILL_ZIP
 ,CLIENTE.BILL_STATE 
 ,FATURA.BILL_PERIOD
 ,FATURA.STATEMENT_DATE
 ,DETALHE.FROM_DATE 
 ,DETALHE.TO_DATE
 ,TRIM (EQUIP.EXTERNAL_ID) EQUIP_EXTERNAL_ID
 ,DETALHE.SUBTYPE_CODE 
  ,DE.DESCRIPTION_TEXT
 ,S.POP_UNITS
 ,COUNT (*)                         QUANT
 ,SUM (DETALHE.UNITS)               UNITS
 ,SUM (DETALHE.AMOUNT / 100)        AMOUNT
 ,SUM (DETALHE.DISCOUNT / 100)      DISCOUNT
FROM 
 ARBOR.CMF                       CLIENTE
,ARBOR.FRANCHISE_CODE_VALUES     UF 
,ARBOR.ACCOUNT_CATEGORY_VALUES   ACCVA 
,ARBOR.BILL_INVOICE              FATURA
,ARBOR.BILL_INVOICE_DETAIL       DETALHE
,ARBOR.CUSTOMER_ID_ACCT_MAP      CONTA
,ARBOR.DESCRIPTIONS              DE
,ARBOR.SERVICE                   S
,ARBOR.CUSTOMER_ID_EQUIP_MAP     EQUIP
WHERE 
    CLIENTE.ACCOUNT_NO              =2871360
AND CLIENTE.ACCOUNT_CATEGORY        =ACCVA.ACCOUNT_CATEGORY
AND CLIENTE.CUST_FRANCHISE_TAX_CODE = UF.FRANCHISE_CODE
AND UF.LANGUAGE_CODE                =2
AND ACCVA.LANGUAGE_CODE             =2    
AND CLIENTE.ACCOUNT_NO              =FATURA.ACCOUNT_NO
AND FATURA.BILL_REF_NO              =231925743
AND FATURA.BILL_REF_NO              =DETALHE.BILL_REF_NO
AND FATURA.ACCOUNT_NO               =CONTA.ACCOUNT_NO
AND FATURA.PREP_STATUS              =1
AND FATURA.BACKOUT_STATUS           ='0'
AND FATURA.FORMAT_ERROR_CODE        IS NULL
AND FATURA.PREP_ERROR_CODE          IS NULL
AND CONTA.EXTERNAL_ID_TYPE          =1
AND DETALHE.DESCRIPTION_CODE        =DE.DESCRIPTION_CODE
AND DE.LANGUAGE_CODE                =2 
AND DETALHE.TYPE_CODE               IN (2,3,7)
AND DETALHE.SUBSCR_NO               =S.SUBSCR_NO (+)
AND S.SUBSCR_NO                     =EQUIP.SUBSCR_NO (+)
AND EQUIP.EXTERNAL_ID_TYPE          (+)= 1       
GROUP BY
  CLIENTE.PARENT_ID 
 ,ACCVA.ACCOUNT_CATEGORY 
 ,ACCVA.DISPLAY_VALUE
 ,DETALHE.BILL_INVOICE_ROW 
 ,DETALHE.BILL_REF_NO 
 ,CONTA.EXTERNAL_ID
 ,CLIENTE.ACCOUNT_NO
 ,UF.DISPLAY_VALUE
 ,CLIENTE.BILL_LNAME
 ,CLIENTE.BILL_ADDRESS1
 ,CLIENTE.BILL_ADDRESS2 
 ,CLIENTE.BILL_ADDRESS3
 ,CLIENTE.BILL_CITY 
 ,CLIENTE.BILL_ZIP
 ,CLIENTE.BILL_STATE 
 ,FATURA.BILL_PERIOD
 ,FATURA.BILL_REF_NO 
 ,FATURA.STATEMENT_DATE
 ,DETALHE.FROM_DATE 
 ,DETALHE.TO_DATE
 ,EQUIP.EXTERNAL_ID
 ,DETALHE.SUBTYPE_CODE 
 ,DE.DESCRIPTION_TEXT
 ,S.POP_UNITS) SRV
,(SELECT 
         B.BILL_REF_NO
        ,B.FEDERAL_RATE 
        ,C.SHORT_DISPLAY 
        ,B.TAX_PKG_INST_ID 
        ,B.TAX_RATE
        ,B.BILL_INVOICE_ROW
     FROM ARBOR.BILL_INVOICE_DETAIL A
          ,ARBOR.BILL_INVOICE_TAX B
          ,ARBOR.TAX_PKG_INST_ID_VALUES C
    WHERE A.BILL_REF_NO = 231925743
      AND A.BILL_REF_NO = B.BILL_REF_NO
      AND A.BILL_INVOICE_ROW = B.BILL_INVOICE_ROW
      AND B.TAX_PKG_INST_ID = C.TAX_PKG_INST_ID
      AND C.LANGUAGE_CODE = 2
      AND B.FEDERAL_TAX > 0
      AND UPPER(C.DISPLAY_VALUE) LIKE '%ICMS%') ICMS
,(SELECT   
         B.BILL_REF_NO
        ,B.FEDERAL_RATE 
        ,C.SHORT_DISPLAY 
        ,B.TAX_PKG_INST_ID 
        ,B.TAX_RATE
        ,B.BILL_INVOICE_ROW
     FROM ARBOR.BILL_INVOICE_DETAIL A
          ,ARBOR.BILL_INVOICE_TAX B
          ,ARBOR.TAX_PKG_INST_ID_VALUES C
    WHERE A.BILL_REF_NO = 231925743
      AND A.BILL_REF_NO = B.BILL_REF_NO
      AND A.BILL_INVOICE_ROW = B.BILL_INVOICE_ROW
      AND B.TAX_PKG_INST_ID = C.TAX_PKG_INST_ID
      AND C.LANGUAGE_CODE = 2
      AND B.FEDERAL_TAX > 0
      AND UPPER(C.DISPLAY_VALUE) LIKE '%PIS%') PIS     
WHERE SRV.BILL_INVOICE_ROW=ICMS.BILL_INVOICE_ROW  (+)    
AND   SRV.BILL_INVOICE_ROW=PIS.BILL_INVOICE_ROW   (+)