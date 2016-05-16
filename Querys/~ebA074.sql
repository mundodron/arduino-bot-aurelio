-- 196693208, 201274261

select * from cmf_balance where bill_ref_no in (196693208,201274261)

select *
  from adj
 where account_no = 7382339
   and bill_ref_no in (196693208,201274261)

select account_category
  from cmf
 where account_no = 7382339