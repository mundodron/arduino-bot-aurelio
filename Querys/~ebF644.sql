select MAP.EXTERNAL_ID,
       MAP.ACCOUNT_NO,
       EQ.EXTERNAL_ID as INSTANCIA_TV,
       C.BILL_PERIOD as CICLO,
       D.DESCRIPTION_TEXT as PRODUTO,
       (R.RATE/100) as VALOR
  from customer_id_acct_map map,
       customer_id_equip_map eq,
       service s,
       cmf c,
       product p,
       descriptions d,
       product_rate_key k,
       rate_rc r
 where MAP.INACTIVE_DATE is null
   and MAP.EXTERNAL_ID_TYPE = 1
   and MAP.ACCOUNT_NO = S.PARENT_ACCOUNT_NO
   and S.SUBSCR_NO = EQ.SUBSCR_NO
   and S.SUBSCR_NO_RESETS = EQ.SUBSCR_NO_RESETS
   --and MAP.EXTERNAL_ID = '899999567465'
   and MAP.EXTERNAL_ID_TYPE = 1
   and EQ.EXTERNAL_ID_TYPE = 10
   and MAP.ACCOUNT_NO = C.ACCOUNT_NO
   and c.account_category in (10,11)
   and P.PARENT_ACCOUNT_NO = MAP.ACCOUNT_NO
   and P.ELEMENT_ID = D.DESCRIPTION_CODE
   and D.LANGUAGE_CODE = 2
   and EQ.INACTIVE_DATE is null
   and P.PARENT_SUBSCR_NO = EQ.SUBSCR_NO
   and P.PARENT_SUBSCR_NO_RESETS = EQ.SUBSCR_NO_RESETS
   and P.PRODUCT_INACTIVE_DT is null
   and K.TRACKING_ID = P.TRACKING_ID
   and K.TRACKING_ID_SERV = P.TRACKING_ID_SERV
   and K.UNITS = 201305 -- Maio/13
   and R.INACTIVE_DATE is null
   and P.ELEMENT_ID = R.ELEMENT_ID
   and K.UNITS = R.UNITS_UPPER_LIMIT
   and P.COMPONENT_ID = R.COMPONENT_ID;
   
   select * from product_rate_key where TRACKING_ID in (80337555,80337555,80337557)


select MAP.EXTERNAL_ID ,P.PARENT_ACCOUNT_NO,  EQ.EXTERNAL_ID as INSTANCIA_TV, C.BILL_PERIOD, K.UNITS as SAFRA, D.DESCRIPTION_TEXT as PRODUTO, (R.RATE/100) as VALOR 
  from product p,
       customer_id_acct_map map,
       customer_id_equip_map eq,
       cmf c,
       product_rate_key k,
       descriptions d,
       service s,
       rate_rc r
 where P.TRACKING_ID = K.TRACKING_ID
   and P.TRACKING_ID_SERV = K.TRACKING_ID_SERV
   and K.UNITS = 201305 -- Maio/13
   and R.UNITS_UPPER_LIMIT = 201305 
   and EQ.SUBSCR_NO = S.SUBSCR_NO
   and EQ.SUBSCR_NO_RESETS = S.SUBSCR_NO_RESETS
   and S.PARENT_ACCOUNT_NO = MAP.ACCOUNT_NO
   and S.SERVICE_INACTIVE_DT is null
   and c.account_category in (10,11)
   and K.INACTIVE_DT is null
   and P.COMPONENT_ID = R.COMPONENT_ID
   and P.ELEMENT_ID = R.ELEMENT_ID
   and C.ACCOUNT_NO = MAP.ACCOUNT_NO
   and P.BILLING_INACTIVE_DT is null
   and MAP.ACCOUNT_NO = P.PARENT_ACCOUNT_NO
   and MAP.INACTIVE_DATE is null
   and D.LANGUAGE_CODE = 2
   and R.INACTIVE_DATE is null
   and P.ELEMENT_ID = D.DESCRIPTION_CODE
   and K.UNITS = R.UNITS_UPPER_LIMIT
   and MAP.EXTERNAL_ID_TYPE = 1
   and EQ.EXTERNAL_ID_TYPE = 10
   and MAP.EXTERNAL_ID = '899999567465'
   --and p.COMPONENT_ID = 30941
   
   
   select P.COMPONENT_ID , D.DESCRIPTION_TEXT
     from product p,
          descriptions d
    where P.PARENT_ACCOUNT_NO = 7699443
      and P.ELEMENT_ID = D.DESCRIPTION_CODE
      and P.PRODUCT_INACTIVE_DT is null
      and D.LANGUAGE_CODE = 2
      
      
      
  select * from product where 
     
  select * from rate_rc where component_id = 30941 and inactive_date is null and UNITS_UPPER_LIMIT = 201305