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
WHERE 1=1 --service.parent_ACCOUNT_NO = 3847517
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
and   GPV.END_DT is null
AND   SERVICE.EMF_CONFIG_ID = ECI.EMF_CONFIG_ID
AND   ECI.LANGUAGE_CODE = 2
AND   NOT EXISTS (SELECT 1 FROM GVT_FEBRABAN_PONTA_B_ARBOR B WHERE B.EMF_EXT_ID = EIEM.EXTERNAL_ID)
and   GPV.VELOCITY is not null
order by GPV.VELOCITY desc

select * from COBILLING.RETORNO_ENVIADOS where dt_envio > sysdate -15

select * from COBILLING.RETORNO_ENVIADOS where dsname like  'TCOR.T061141.S00.D150415.H035943.NC'

insert into retorno_enviados          (DSNAME,   EOT, QTDE_REGISTRO, VALOR_LIQUIDO, DT_ENVIO, OPERADORA, N_PROCESSO)
values ('TCOR.T061141.S00.D150415.H035943.NC', '141',    '6730285', '260          6', to_date('15/04/2015','dd/mm/yyyy'),'BRT','')


'TCOR.T061141.S00.D150415.H035943.NC'
 TCOR.T061141.S00.D170415.H015247.NC
 
 