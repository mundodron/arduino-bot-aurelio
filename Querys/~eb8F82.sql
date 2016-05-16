
select * --provider_id, template_code, count(1), sum(amount), sum(t.primary_units)/60
  from teste t
 where 1 = 1
   and provider_id = 25
   and trans_dt >= to_date('28/11/2012 18:25:34','dd/mm/yyyy hh24:mi:ss')
and rownum = 1
--   and template_code = 1
--group by provider_id, template_code
--order by 1,2;
order by provider_id, t.ext_a, template_code, to_char(t.trans_dt, 'YYYYMMDDHH24MISS');



select * --provider_id, template_code, count(1), sum(amount), sum(t.primary_units)/60
  from teste t
 where 1 = 1
   and provider_id = 25
   and trans_dt < to_date('28/11/2012 18:25:34','dd/mm/yyyy hh24:mi:ss')
--   and template_code = 1
--group by provider_id, template_code
--order by 1,2;
and rownum = 1
order by provider_id, t.ext_a, template_code, to_char(t.trans_dt, 'YYYYMMDDHH24MISS');

