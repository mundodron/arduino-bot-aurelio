select * from customer_id_acct_map where external_id = '999979735355'

select * from bill_invoice where account_no = 8366359 order by 2 desc


SELECT *
  FROM LOCAL_ADDRESS
 WHERE ADDRESS_ID IN
       (SELECT ADDRESS_ID
          FROM SERVICE_ADDRESS_ASSOC
         WHERE SUBSCR_NO IN
               (SELECT SUBSCR_NO
                  FROM SERVICE
                 WHERE PARENT_ACCOUNT_NO IN
                       (SELECT ACCOUNT_NO
                          FROM CUSTOMER_ID_ACCT_MAP
                         WHERE EXTERNAL_ID = '777777713402')));
                         

select account_category from cmf where account_no = 9699511
                       
SELECT *
  FROM LOCAL_ADDRESS
 WHERE ADDRESS_ID IN
       (SELECT ADDRESS_ID
          FROM SERVICE_ADDRESS_ASSOC
         WHERE SUBSCR_NO IN
               (SELECT SUBSCR_NO
                  FROM SERVICE
                 WHERE PARENT_ACCOUNT_NO IN
                       (SELECT ACCOUNT_NO
                          FROM CUSTOMER_ID_ACCT_MAP
                         WHERE EXTERNAL_ID = '999979656398')));
                         
                         
SELECT *
  FROM LOCAL_ADDRESS
 WHERE ADDRESS_ID IN
       (SELECT ADDRESS_ID
          FROM SERVICE_ADDRESS_ASSOC
         WHERE SUBSCR_NO IN
               (SELECT SUBSCR_NO
                  FROM SERVICE
                 WHERE PARENT_ACCOUNT_NO IN
                       (SELECT ACCOUNT_NO
                          FROM CUSTOMER_ID_ACCT_MAP
                         WHERE EXTERNAL_ID = '999980702894')));
                         

select * from SERVICE_ADDRESS_ASSOC where ADDRESS_ID=  4332267003        