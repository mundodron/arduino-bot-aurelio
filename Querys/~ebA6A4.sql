select ciam.external_id,
       CPC.COMPONENT_ID,
       CDV.DISPLAY_VALUE,
       cpc.active_dt,
       cpc.inactive_dt
from customer_id_acct_map ciam
join cmf_package_component cpc on cpc.parent_account_no= ciam.account_no 
join cmf_component_element cce on cce.association_type in(0,1) and cpc.component_inst_id = cce.component_inst_id and cpc.component_inst_id_serv = cce.component_inst_id_serv
join component_definition_values cdv on cdv.language_code =2  and cdv.component_id = cpc.component_id
where ciam.external_id = '999988501203'
and cpc.inactive_dt is null

-- GVT Ilimitado Total - Franquia LDN