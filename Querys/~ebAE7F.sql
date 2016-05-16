
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
   -- and K.UNITS = 201305 -- Maio/13
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
   
   select p.*, D.DESCRIPTION_TEXT
     from product p,
          descriptions d
    where P.PARENT_ACCOUNT_NO = 7699443
      and P.ELEMENT_ID = D.DESCRIPTION_CODE
      and P.PRODUCT_INACTIVE_DT is null
      and D.LANGUAGE_CODE = 2
      
      
      
  select * from  
     
  select * from rate_rc where component_id = 30941 and inactive_date is null and UNITS_UPPER_LIMIT = 201305