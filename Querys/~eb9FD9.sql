-- Executar em DGRC
select v.SITUACAO, telefone, v.OPERADORA_ATUAL, cenario,v.BDR_COD_OPER, pnum_out_dt_janela, v.PNUM_OUT_STATUS, v.PNUM_OUT_OPER_IN
from VW_BSS_ANALYTICS_BDRSIEBEL v where telefone in ('4130823224');

select * from role_tab_privs 

insert into arborgvt_billing.gvt_products_summary_eif (component_id,charge_id,group_id,display_name,charge_category,lines_flag,id_anatel) values (37017,10836,-903,'SOS TV',2,null,null);

select * from gvt_products_summary_eif where component_id = 37017