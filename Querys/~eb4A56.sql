select * from cmf where account_no = 831931

select * from gvt_log_cmf where account_no = 831931

  select bill_period 
    from bill_cycle
   where bill_period like 'M%'
     and prep_date = (Select max(prep_date)
                        from bill_cycle
                       where bill_period like 'M%'
                         and prep_date <= sysdate);
            
 select * from bill_invoice
    