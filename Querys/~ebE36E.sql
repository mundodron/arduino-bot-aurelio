select * from g0030353sql.contas_loren_siebel;

select * from all_tables where table_name like '%PRODUCT%'


select * from gvt_disc_component

insert into gvt_disc_component(serv_inst, package_id, component_instance_id, end_date, run_status, user_insert, user_update, ext_id_type_inst, error_message, sauto_id, rotina) 
values(?, ?, ?, ?, ?, null, null, ?, null, null, ?)




pst.setObject(1, servInst);
pst.setObject(2, packageId);
pst.setObject(3, componentInstId);
pst.setObject(4, endDate);
pst.setObject(5, 10);
pst.setObject(6, extIdTypeInst);
pst.setObject(7, cenario);