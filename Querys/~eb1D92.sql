 select SUBSCR_NO, count(1)
   from service_address_assoc
  where account_no = 7426812
  group by SUBSCR_NO having count(1) > 1
  
 select *
   from service_address_assoc
  where account_no = 7426812