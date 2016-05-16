-- CARGA

-- passo 1 -- primeira consulta -- kenan cust 1 e 2 --

SELECT EIAM.ACCOUNT_NO,CMF_EXT_ID, EMF_EXT_ID, 
   SERVICE_START, EIAM.INACTIVE_DATE
FROM GVT_FEBRABAN_PONTA_B_ARBOR GFB,
                 CUSTOMER_ID_ACCT_MAP EIAM
WHERE GFB.CMF_EXT_ID = EIAM.EXTERNAL_ID
AND   EIAM.EXTERNAL_ID_TYPE =1
AND   GFB.SERVICE_END IS NULL


-- passo 2 -- se retornar, executa esta -- kenan cust 1 e 2 -- 

select INACTIVE_DATE
from CUSTOMER_ID_EQUIP_MAP, service
WHERE SERVICE.PARENT_ACCOUNT_NO = ?
AND SERVICE.SUBSCR_NO = CUSTOMER_ID_EQUIP_MAP.SUBSCR_NO
AND SERVICE.SUBSCR_NO_RESETS = CUSTOMER_ID_EQUIP_MAP.SUBSCR_NO_RESETS
AND   EXTERNAL_ID = ?
AND   EXTERNAL_ID_TYPE = 7
AND   INACTIVE_DATE IS NOT NULL

-- passo 3 - obtem clientes febraban -- kenan cust 1 e 2

SELECT EXTERNAL_ID,
                   ACCOUNT_NO 
FROM GVT_FEBRABAN_ACCOUNTS GFA
WHERE GFA.INACTIVE_DATE IS NULL

-- passo 4 -- (busca designador) obter o retorno do passo 3 e passar para esta consulta -- kenan

SELECT EIEM.EXTERNAL_ID,
                   SERVICE.EMF_CONFIG_ID,
                   ECI.DISPLAY_VALUE,
                   SERVICE.SERVICE_ACTIVE_DT, 
                   LOCAL_ADDRESS.ADDRESS_1,
                   LOCAL_ADDRESS.ADDRESS_2, 
                   LOCAL_ADDRESS.STATE,              
                   GPV.VELOCITY
FROM CUSTOMER_ID_EQUIP_MAP EIEM,
                 SERVICE,
                 EMF_CONFIG_ID_VALUES ECI,
                 PRODUCT EP,
                 LOCAL_ADDRESS,
                 SERVICE_ADDRESS_ASSOC,          
                 GVT_PRODUCT_VELOCITY GPV
WHERE service.parent_ACCOUNT_NO = ?
AND   SERVICE_ADDRESS_ASSOC.address_id = LOCAL_ADDRESS.address_id
AND   SERVICE_ADDRESS_ASSOC.account_no = service.parent_account_no
AND   SERVICE_ADDRESS_ASSOC.subscr_no = service.subscr_no
AND   SERVICE_ADDRESS_ASSOC.subscr_no_resets = service.subscr_no_resets
AND   EIEM.EXTERNAL_ID_TYPE = 7
AND   EIEM.INACTIVE_DATE IS NULL
AND   EIEM.SUBSCR_NO = SERVICE.SUBSCR_NO
AND   EIEM.SUBSCR_NO = EP.parent_SUBSCR_NO (+)
AND   EP.TRACKING_ID = GPV.TRACKING_ID (+)
AND   EP.TRACKING_ID_SERV = GPV.TRACKING_ID_SERV (+)
AND   SERVICE.EMF_CONFIG_ID = ECI.EMF_CONFIG_ID
AND   ECI.LANGUAGE_CODE = 2
AND   NOT EXISTS (SELECT 1 FROM GVT_FEBRABAN_PONTA_B_ARBOR B WHERE B.EMF_EXT_ID = EIEM.EXTERNAL_ID)

-- passo 5 -- (se designador nao existe) caso o passo 4 n�o retorne, executar esta -- kenan

SELECT 1 
FROM CUSTOMER_ID_EQUIP_MAP, SERVICE
WHERE PARENT_ACCOUNT_NO = ?
AND EXTERNAL_ID_TYPE = 6
AND SERVICE.SUBSCR_NO = CUSTOMER_ID_EQUIP_MAP.SUBSCR_NO
AND SERVICE.SUBSCR_NO_RESETS = CUSTOMER_ID_EQUIP_MAP.SUBSCR_NO_RESETS

-- passo 6 -- (obten��o numero piloto) obter o retorno dos passos 4 e 5 e executar esta consulta - siebel

SELECT B.ROW_ID,B.ASSET_NUM AS PILOTO
FROM GVTPRD.S_QUOTE_SOLN A, 
     GVTPRD.S_QUOTE_SOLN B 
WHERE A.ASSET_NUM = ?
 AND A.STATUS_CD = 'Ativo'
 AND A.SERV_PROD_ID = '1+1M7L+4706'
 AND A.X_APONTAMENTO_ID = B.ROW_ID
UNION
SELECT A.ROW_ID,D.X_TEXTO_LIVRE 
FROM GVTPRD.S_QUOTE_SOLN A, 
     GVTPRD.S_QUOTE_ITEM B, 
     GVTPRD.S_QTEITEM_PARAM C, 
     GVTPRD.S_PARAM D
WHERE A.ROW_ID = B.QUOTE_SOLN_ID
 AND B.ROW_ID = C.QUOTE_ITEM_ID (+)
 AND C.PARAM_ID = D.ROW_ID (+)
 AND A.ASSET_NUM = ?
 AND A.STATUS_CD = 'Ativo'
 AND D.PARAM_NAME_ID IN ('1-BI76', '1-BIBZ', '1-BXLH', '1-BZ8T', '1-CTT6', '1-CTTG', '1-E4KN', '1-N69H', '1-1KTAO', '1-15GCHB', '1-275SQL', '1-8MKK1B')
UNION
SELECT A.ROW_ID,G.X_TEXTO_LIVRE
FROM GVTPRD.S_QUOTE_SOLN A, 
     GVTPRD.S_QUOTE_SOLN B, 
     GVTPRD.S_QUOTE_ITEM C, 
     GVTPRD.S_QTEITEM_PARAM D, 
     GVTPRD.S_PARAM E, 
     GVTPRD.S_QTEITEM_PARAM F, 
     GVTPRD.S_PARAM G
WHERE A.INV_ACCNT_ID = B.INV_ACCNT_ID
 AND B.ROW_ID = C.QUOTE_SOLN_ID
 AND D.QUOTE_ITEM_ID = C.ROW_ID
 AND E.ROW_ID = D.PARAM_ID
 AND A.ASSET_ID = E.X_SERVICE_ID
 AND F.QUOTE_ITEM_ID = C.ROW_ID
 AND G.ROW_ID = F.PARAM_ID
 AND ''||G.PARAM_NAME_ID in ('1-CTTG', '1-N69H')
 AND B.STATUS_CD = 'Ativo'
 AND ''||E.PARAM_NAME_ID in ('1-BPSH', '1-N69G')
 AND ''||B.SERV_PROD_ID in ('1-ADDP', '1-N69F')
 AND ''||C.PROD_ID in ('1-N69K', '1-N69E')
 AND A.ASSET_NUM = ? --  instancia
 AND ROWNUM <= 1
 UNION
 SELECT A.ROW_ID,NULL AS PILOTO
FROM GVTPRD.S_QUOTE_SOLN A
WHERE A.ASSET_NUM = ? -- instancia
 AND A.STATUS_CD = 'Ativo'
 AND A.SERV_PROD_ID in ('1-7JRE','1-BAVZ','1-B4RW')

-- passo 7 -- (obter CNL do numero piloto) executar com o retorno do passo 6 -- kenan

SELECT POINT_CLASS 
FROM USAGE_POINTS
WHERE POINT = ?
AND   INACTIVE_DT IS NULL
UNION
SELECT MIN(point_class)
FROM USAGE_POINTS
WHERE POINT_STATE_ABBR = RPAD(?, 6)
AND   INACTIVE_DT IS NULL
AND LENGTH(point_class)=5

-- passo 8 -- DQ insere os inativos ( resultado do passo 1 e 2 ) na tabela BQ_PONTA_INATIVOS  -- svcpgen

-- passo 9 -- DQ insere o resultado ap�s passo 7 na tabela BQ_FEBRABAN_PONTA -- svcpgen

------------  DADOS QUE O AURELIO PRECISA ---


CNL:

SELECT POINT_CLASS 
FROM USAGE_POINTS
WHERE POINT = ?
AND   INACTIVE_DT IS NULL
UNION
SELECT MIN(point_class)
FROM USAGE_POINTS
WHERE POINT_STATE_ABBR = RPAD(?, 6)
AND   INACTIVE_DT IS NULL
AND LENGTH(point_class)=5

ONDE POINT = COLUNA 2 DO PASSO 6
     POINT_STATE_ABBR = COLUNA 7 DO PASSO 4


VELOCIDADE:

     VELOCITY = COLUNA 8 DO PASSO 4
                 
DEGRAU :

                FIXO = "s/"
                
SERVICE END:

                               NULO



Mauricio Alves
IT - Suporte Billing

 
Av. Visconde de Nacar, 1160 
3� andar - Centro
Curitiba/PR - Brasil CEP 80410-201  
gvt.com.br 
 
 

    Tel +55 41 3025 2006


