--Pacote Alacarte
create tbale teste_alacarte as
select MAP.EXTERNAL_ID ,P.PARENT_ACCOUNT_NO, C.BILL_PERIOD, K.UNITS
  from product p,
       customer_id_acct_map map,
       cmf c,
       product_rate_key k
 where P.TRACKING_ID = K.TRACKING_ID
   and P.TRACKING_ID_SERV = K.TRACKING_ID_SERV
   -- and K.UNITS = 201305 -- Maio/13
   and P.ELEMENT_ID = 10069
   and K.INACTIVE_DT is null
   and K.UNITS not in (201206,201207,201208)
   and C.ACCOUNT_NO = MAP.ACCOUNT_NO
   and P.BILLING_INACTIVE_DT in null
   and MAP.ACCOUNT_NO = P.PARENT_ACCOUNT_NO
   and MAP.INACTIVE_DATE is null
   and MAP.EXTERNAL_ID_TYPE = 10;
   
   
   
   select * from rate_rc where ELEMENT_ID = 10069 and INACTIVE_DATE is null and UNITS_UPPER_LIMIT = 201305
   
