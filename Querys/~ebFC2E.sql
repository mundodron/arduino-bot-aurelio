--Safra
drop table teste_safra;

create table teste_safra as

select MAP.EXTERNAL_ID ,P.PARENT_ACCOUNT_NO, C.BILL_PERIOD as CICLO, K.UNITS as SAFRA
  from product p,
       customer_id_acct_map map,
       customer_id_equip_map eq,
       cmf c,
       product_rate_key k,
       service s
 where P.TRACKING_ID = K.TRACKING_ID
   and P.TRACKING_ID_SERV = K.TRACKING_ID_SERV
   and K.UNITS = 201305 -- Maio/13
   and EQ.SUBSCR_NO = S.SUBSCR_NO
   and EQ.SUBSCR_NO_RESETS = S.SUBSCR_NO_RESETS
   and S.PARENT_ACCOUNT_NO = MAP.ACCOUNT_NO
   and S.SERVICE_INACTIVE_DT is null
   and c.account_category in (10,11)
   and K.INACTIVE_DT is null
   and C.ACCOUNT_NO = MAP.ACCOUNT_NO
   and P.BILLING_INACTIVE_DT is null
   and MAP.ACCOUNT_NO = P.PARENT_ACCOUNT_NO
   and MAP.INACTIVE_DATE is null
   and MAP.EXTERNAL_ID_TYPE = 1
   and EQ.EXTERNAL_ID_TYPE = 10;
   
   
   -- select EXTERNAL_ID_TYPE, count(1) from customer_id_acct_map group by EXTERNAL_ID_TYPE
   
   select * from rate_rc where ELEMENT_ID = 10069 and INACTIVE_DATE is null and UNITS_UPPER_LIMIT = 201305
   
   -- select * from customer_id_equip_map
    
   -- select * from cmf where 