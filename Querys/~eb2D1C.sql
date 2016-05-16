select * from external_id_equip_map where external_id = '6130218866'

select * from external_id_equip_map where subscr_no = 11175153

select * from external_id_equip_map_view where subscr_no = 11175153

update external_id_equip_map_view set inactive_date = to_date ('28/08/2012', 'DD/MM/YYYY') where view_id in (776046716025909003,776046716025908003);

select * from external_id_equip_map_view where view_id in (776046716025909003,776046716025908003);

