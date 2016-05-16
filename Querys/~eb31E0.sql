           select N.TRACKING_ID,
                  N.TRACKING_ID_SERV
           FROM   NRC N, NRC_KEY NRCK
           WHERE  N.BILLING_ACCOUNT_NO = C_ACCOUNT
           AND    N.EFFECTIVE_DATE < C_DATA_DO_INIBE
           AND    N.NO_BILL=0
           AND    N.TRACKING_ID = NRCK.TRACKING_ID
           AND    N.TRACKING_ID_SERV = NRCK.TRACKING_ID_SERV
           AND    NRCK.BILL_REF_NO=0
           AND    N.RATE>0
           AND      N.TYPE_ID_NRC NOT IN (12201, 12200, 12152, 12176, 12178, 12186, 12025, 12034, 12158, 12184, 12035);
           
          SELECT MIN(cutoff_date)
          FROM BILL_CYCLE
          WHERE upper(BILL_PERIOD)=upper(rtrim(ltrim(SUBSTR('M20',1,3))))
          AND ppdd_date >= ADD_MONTHS(SYSDATE,-2);
          
          select bill_period,max(cutoff_date) from bill_cycle where bill_period like 'M%' group by bill_period
          
          
select c.account_no,
       c.bill_period
  from BIPM20_CORP v,
       cmf c
 where c.account_no = v.account_no
   and c.account_category between 9 and 11
   and c.account_status <> -2
   
   
   select * from bill_invoice where bill_ref_no = 175097502
   
   
   select TRACKING_ID, count(1) from GVT_PRODUCT_VELOCITY  group by TRACKING_ID having count(1) >1