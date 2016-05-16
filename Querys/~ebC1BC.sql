-- verificar se houve estouro de franquia nesse periodo,
-- verificar que tipo de bonus
select CPC.PARENT_ACCOUNT_NO, CDV.DISPLAY_VALUE, cpc.component_inst_id, CCK.TRACKING_ID, CCK.AVAIL_PERIODS 
  from cmf_package_component cpc, 
       component_definition_values cdv, 
       g0023421sql.VERIPARCELAMENTO a, 
       cmf_component_element cce,
       customer_contract_key cck
 where cpc.component_id = CDV.COMPONENT_ID
   and cdv.language_code = 2
   and CPC.PARENT_ACCOUNT_NO = A.ACCOUNT_NO
   and CPC.PARENT_SUBSCR_NO is null
   and cpc.component_id = 26347
   and cpc.inactive_dt is null
   and CCE.COMPONENT_INST_ID =  CPC.COMPONENT_INST_ID
   and CCE.ASSOCIATION_TYPE = 2
   and CCK.TRACKING_ID = CCE.ASSOCIATION_ID
   and CCK.TRACKING_ID_SERV = CCE.ASSOCIATION_ID_SERV

select * from cmf_component_element