insert into tmp_eve_relatorio_dacc (
select c.account_no, 
      trim(c.contact1_phone), 
      c.bill_lname, 
      c.bill_city, 
      c.bill_state
from cmf c, 
    service e,
    payment_profile pp
where e.parent_account_no = c.account_no
and c.account_no = pp.account_no
and e.service_inactive_dt is null
and c.contact1_phone is not null
and c.bill_state is not null
and pp.pay_method = 1
and c.bill_period = 'M28'
and c.no_bill = 0
and c.date_inactive is null 
group by c.account_no, c.contact1_phone, c.bill_lname, c.bill_city, c.bill_state
);

commit;