select 'update cmf set rate_class_default=1 where account_no='||account_no||';'
   from (select * from cmf where account_no in (?)
               and cmf.rate_class_default=2));
