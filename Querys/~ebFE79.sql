 select cd.corridor_plan_id corridor,
 cd.type_id_usg,
 des.description_text,
 cd.jurisdiction juri, d
 es_jur.description_text des_jur,
 cd.external_id,
 cd.element_id ele ,
 des_ele.description_text des_ele,
 cd.point_target,
 cd.point_origin,
 up.point_city cid,
 up.point_state_abbr uf,
 cd.trans_dt, 
 cd.primary_units,
 cd.rated_units,
 (cd.amount / 100) am,
 cd.rate_period
 from  cdr_data cd,
       cdr_unbilled,
       usage_types tp_uso,
       usage_points up,
       jurisdictions jur,
       descriptions des_jur,
       descriptions des ,
       descriptions des_ele
  where cdr_unbilled.account_no = ?
   and cd.no_bill = 0
   and cd.msg_id = cdr_unbilled.msg_id
   and cd.msg_id2 = cdr_unbilled.msg_id2
   and cd.msg_id_serv = cdr_unbilled.msg_id_serv
   and tp_uso.type_id_usg = cd.type_id_usg
   and tp_uso.type_id_usg not in (100,101,103,104,150,151,152,153)
   and des.description_code = tp_uso.description_code
   and des.language_code = 2
   and cd.element_id = des_ele.description_code
   and des_ele.language_code  = 2
   and cd.point_id_target = up.point_id (+)
   and cd.jurisdiction = jur.jurisdiction (+)
   and jur.description_code = des_jur.description_code (+)
   and ( des_jur.language_code = 2 or des_jur.language_code is null )