select distinct(MAP.EXTERNAL_ID) ,P.PARENT_ACCOUNT_NO, K.UNITS
  from product p,
       product_rate_key k,
       customer_id_acct_map map
 where P.TRACKING_ID = K.TRACKING_ID
   and P.TRACKING_ID_SERV = K.TRACKING_ID_SERV
   and K.UNITS = 201305 -- Maio/13
   and K.INACTIVE_DT is null
   and MAP.ACCOUNT_NO = P.PARENT_ACCOUNT_NO
   and MAP.INACTIVE_DATE is null
   and MAP.EXTERNAL_ID_TYPE = 1