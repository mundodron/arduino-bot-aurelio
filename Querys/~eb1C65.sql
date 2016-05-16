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
                         
select * from customer_id_acct_map where EXTERNAL_ID = '999979656398'

select account_category from cmf where account_no = 7564090                         


select * from customer_id_equip_map  where subscr_no in (19478366,19478367);

update customer_id_equip_map set is_current=0
where subscr_no in (19478366,19478367)
and inactive_date is not null;


 select * from customer_id_equip_map where external_id like '%30616700'
 
 
 
 select * from bill_invoice where bill_ref_no = 0264933187