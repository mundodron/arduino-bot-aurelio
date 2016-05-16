select * from customer_id_equip_map where inactive_date is null

select * from customer_id_acct_map where inactive_date is null and external_id_type = 1
and account_no not in (select * from gvt_cadastro_cliente)