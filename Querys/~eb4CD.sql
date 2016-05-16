
SELECT
         oo.account_no, oo.order_number,oo.order_id,
         oo.order_status_id || ' - ' || oosv.display_value status_ordem,
         oo.create_who, oo.create_dt, oo.complete_dt, oso.service_order_id,
         oso.service_order_type_id || ' - ' || osotv.display_value tipo,
         oso.subscr_no, oso.subscr_no_resets, oi.item_id,
         oi.item_action_id || ' - ' || oicv.display_value ação,
         oi.member_type || ' - ' || oimtv.display_value member_type,
         oi.member_id ||
         decode(oi.member_type,
                30, (select ' - ' || description_text from contract_types ct,   descriptions d where ct.description_code = d.description_code and ct.contract_type =oi.member_id and d.language_code = 2),
                10, (select ' - ' || description_text from product_elements pe, descriptions d where pe.description_code = d.description_code and pe.element_id  =oi.member_id and d.language_code = 2 ),
                40, (select ' - ' || display_value from component_definition_values cdv where cdv.component_id  = oi.member_id and cdv.language_code =2),
                50, (select ' - ' || display_value from package_definition_values pdv where pdv.package_id = oi.member_id and pdv.language_code =2),
                20, (select ' - ' || description_text from nrc_trans_descr ntd, descriptions d where ntd.description_code = d.description_code and ntd.TYPE_ID_NRC = oi.member_id and d.language_code = 2),
                60, (select ' - ' || external_id from customer_id_equip_map ciem where ciem.view_id = oi.view_id and ciem.external_id_type = oi.member_id),
                78, (' - Alteração de Endereço'), 
                80, (select  ' - ' || display_value from EMF_CONFIG_ID_VALUES eciv where eciv.emf_config_id = oi.member_id and eciv.language_code = 2), --80 = SERVICE
                100, ( 'Elemento de criação de conta'),  
                ' - outro') member_id,
         oi.view_id, oi.member_inst_id, oi.member_inst_id2, oi.is_cancelled
    FROM ord_order oo,
         ord_order_status_values oosv,
         ord_service_order oso,
         ord_service_order_type_values osotv,
         ord_item oi,
         ord_item_member_type_values oimtv,
         ord_item_action_values oicv
   WHERE oo.account_no in (select account_no from customer_id_acct_map where external_id = '899999160685' and external_id_type = 1 and inactive_date is null)
     AND oo.order_number = '8-21503330032-1'
--and oi.item_id = 166547004
     AND oo.order_id = oso.order_id
     AND oso.service_order_id = oi.service_order_id
     AND oo.order_status_id = oosv.order_status_id
     AND oosv.language_code = 2
     AND osotv.service_order_type_id = oso.service_order_type_id
     AND osotv.language_code = 2
     AND oi.member_type = oimtv.item_member_type_id
     AND oimtv.language_code = 2
     AND oi.item_action_id = oicv.item_action_id
     AND oicv.language_code = 2
ORDER BY member_id,oo.order_number, oo.order_id
