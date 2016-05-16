select 
equip.EXTERNAL_ID,
equip.EXTERNAL_ID_TYPE,
equip.SUBSCR_NO,
equip.SUBSCR_NO_RESETS,
equip.ACTIVE_DATE,
s.PARENT_ACCOUNT_NO as "ACCOUNT_NO",
 '3' as SERVER_ID,
equip.IS_FROM_INVENTORY,
equip.INACTIVE_DATE,
equip.VIEW_ID
 from customer_id_equip_map equip,
      service s
  where equip.external_id = '6130218866'
   and  S.SUBSCR_NO = EQUIP.SUBSCR_NO


select c.VIEW_ID,
       c.VIEW_STATUS,
       c.VIEW_CREATED_DT,
       c.VIEW_EFFECTIVE_DT,
       c.INTENDED_VIEW_EFFECTIVE_DT,
       c.PREV_VIEW_ID,
       c.EXTERNAL_ID,
       c.EXTERNAL_ID_TYPE,
       c.SUBSCR_NO,
       c.SUBSCR_NO_RESETS,
       c.ACTIVE_DATE,
       S.PARENT_ACCOUNT_NO ACCOUNT_NO,
       3 SERVER_ID,
       c.IS_FROM_INVENTORY,
       c.INACTIVE_DATE
 from customer_ID_EQUIP_MAP_VIEW c,
      service_view s
where c.subscr_no = 11175153 and c.external_id = '6130218866'
  and C.SUBSCR_NO = S.SUBSCR_NO
  and C.SUBSCR_NO_RESETS = S.SUBSCR_NO_RESETS

select * from service where subscr_no = 11175153

select * from service_view


