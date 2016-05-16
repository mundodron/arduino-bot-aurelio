select * from GVT_CADASTRO_CLIENTE where SUBSCR_NO in (select SUBSCR_NO from customer_id_equip_map where inactive_date is null and external_id_type = 1)

