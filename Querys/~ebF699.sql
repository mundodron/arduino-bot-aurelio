 select B.ACCOUNT_NO, B.BILL_REF_NO, B.AMOUNT, B.PAYMENT_DUE_DATE, B.TRACKING_ID, B.TRACKING_ID_SERV 
   from E9502359SQL.cancel_cef a,
        payment_trans b
  where A.ACCOUNT_NO = B.ACCOUNT_NO
    and A.TRACKING_ID = B.TRACKING_ID
    and a.nsa = 2700;
    
    
    
    "insert into  gvt_rajadas_bill ( EXTERNAL_ID, BILL_REF_NO,VL_BAIXA,STATUS) values ('999985307724',97456367,00,777);"
    
    =CONCATENAR("insert into  gvt_rajadas_bill ( EXTERNAL_ID, BILL_REF_NO,VL_BAIXA,STATUS) values ('";B7; "',";C7;"00,777;";

select * from gvt_rajadas_bill



insert into  gvt_rajadas_bill ( EXTERNAL_ID, BILL_REF_NO,VL_BAIXA,STATUS) values ('999984594571',999763300,00,777);

