select a.account_no, 
       b.external_id, 
       a.bill_lname, 
       a.account_category,
       a.next_bill_date,
       a.bill_period
  from customer_id_acct_map b,
       cmf a
 where 1=1 --a.account_category in (&1)
   and a.account_type = 1 
   --and a.bill_period IN (select bill_period from GVT_PROCESSAMENTO_CICLO where upper(processamento) = upper('&2'))
   and a.no_bill = 0
   and a.account_status != -2 
   and a.account_no in (select parent_account_no
                          from service
                         where service.parent_account_no = a.account_no 
                           and (service.service_inactive_dt is null or (service.service_inactive_dt + 7) > nvl(a.prev_cutoff_date,a.date_active) and nvl(a.prev_cutoff_date,a.date_active) > (sysdate - 90))  
                       )          
   and a.account_no = b.account_no
   and b.external_id_type = 1
   and B.account_no in (select account_no from customer_id_acct_map where external_id in('777777706495','999979765387','777777711847','999984448639','999987874999','999982452897','999982612372','999979740351','999989811587','999989811811'))
   and exists ( select 1 
                  from SIN_GROUP_REF sin
                 where sin.group_id = a.mkt_code 
                   and sin.inactive_date is null);
                   
                   
                   select * from customer_id_acct_map where external_id = '777777706495'
                   
                   select A.BILL_LNAME,
                          service_inactive_dt,
                          a.date_active,
                          a.prev_cutoff_date,
                          b.service_inactive_dt + 7,
                          b.service_inactive_dt - 7
                     from service b,
                          cmf a
                    where A.ACCOUNT_NO = B.PARENT_ACCOUNT_NO 
                    and b.parent_account_no in (select account_no from customer_id_acct_map where external_id in('777777706495','999979765387','777777711847','999984448639','999987874999','999982452897','999982612372','999979740351','999989811587','999989811811'))
                    and (b.service_inactive_dt + 7) > nvl(a.prev_cutoff_date,a.date_active)
                    --and a.date_active > (sysdate - 90)
                   
               
select B.BILL_LNAME ,a.service_inactive_dt
  from service a, 
           cmf b
 where a.parent_account_no in (4634509,4572642,8289109,4920583,4459381)
   and B.ACCOUNT_NO = A.PARENT_ACCOUNT_NO
   
   
 select account_no from customer_id_acct_map where external_id in('777777706495','999979765387','777777711847','999984448639','999987874999','999982452897','999982612372','999979740351','999989811587','999989811811')
 
 select * from customer_id_acct_map where external_id = '999984448639'