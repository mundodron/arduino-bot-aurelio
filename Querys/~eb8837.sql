select * from customer_id_equip_map where SUBSCR_NO not in (select SUBSCR_NO from gvt_cadastro_cliente) and inactive_date is null and external_id_type = 1

select * from gvt_cadastro_cliente

select * from payment_trans