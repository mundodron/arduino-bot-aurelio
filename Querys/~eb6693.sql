
 insert into gvt_products_summary_eif
 (component_id, charge_id, group_id, display_name, charge_category, lines_flag, id_anatel)
 values 
 (0, 12789, -15001, 'Isenção de Cob. por Interrupção Pontual do Serviço Voz', 4, null, null);
 
 insert into gvt_products_summary_eif
 (component_id, charge_id, group_id, display_name, charge_category, lines_flag, id_anatel)
 values 
 (0, 12788, -15001, 'Isenção de Cob. por Interrupção Pontual do Serviço Dados', 4, null, null);
 
 insert into gvt_products_summary_eif
 (component_id, charge_id, group_id, display_name, charge_category, lines_flag, id_anatel)
 values 
 (0, 12787, -15001, 'Isenção de Cob. por Interrupção Pontual do Serviço TV', 4, null, null);
 
 insert into gvt_products_summary_eif
 (component_id, charge_id, group_id, display_name, charge_category, lines_flag, id_anatel)
 values 
 (0, 12812, -15001, 'Isenção de Cob. por Interrupção Pontual do Serviço TV', 4, null, null);

 commit;
 
 update descriptions set description_text = 'Isenção de Cob. por Interrupção Pontual do Serviço IPTV' where description_code = 12812;

 update gvt_products_summary_eif set display_name = 'Isenção de Cob. por Interrupção Pontual do Serviço IPTV' where charge_id = 12812;
 
 commit;
 
 
 select * from descriptions where description_code = 12812