
 insert into gvt_products_summary_eif
 (component_id, charge_id, group_id, display_name, charge_category, lines_flag, id_anatel)
 values 
 (0, 12789, -15001, 'Isen��o de Cob. por Interrup��o Pontual do Servi�o Voz', 4, null, null);
 
 insert into gvt_products_summary_eif
 (component_id, charge_id, group_id, display_name, charge_category, lines_flag, id_anatel)
 values 
 (0, 12788, -15001, 'Isen��o de Cob. por Interrup��o Pontual do Servi�o Dados', 4, null, null);
 
 insert into gvt_products_summary_eif
 (component_id, charge_id, group_id, display_name, charge_category, lines_flag, id_anatel)
 values 
 (0, 12787, -15001, 'Isen��o de Cob. por Interrup��o Pontual do Servi�o TV', 4, null, null);
 
 insert into gvt_products_summary_eif
 (component_id, charge_id, group_id, display_name, charge_category, lines_flag, id_anatel)
 values 
 (0, 12812, -15001, 'Isen��o de Cob. por Interrup��o Pontual do Servi�o TV', 4, null, null);

 commit;
 
 update descriptions set description_text = 'Isen��o de Cob. por Interrup��o Pontual do Servi�o IPTV' where description_code = 12812;

 update gvt_products_summary_eif set display_name = 'Isen��o de Cob. por Interrup��o Pontual do Servi�o IPTV' where charge_id = 12812;
 
 commit;
 
 
 select * from descriptions where description_code = 12812