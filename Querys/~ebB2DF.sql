--Gera INSERT Fatweb
select 
bill_ref_no,a.display_value,
case
    when (cm.account_category = 9) then
        ('insert into fatweb_SME (bill_ref_no) values ('||c.bill_ref_no||');')
        when (cm.account_category in(10,11)) then
        ('insert into fatweb_RETAIL (bill_ref_no) values ('||c.bill_ref_no||');')
    when (cm.account_category in(12,13,14,15,21,22)) then
        ('insert into fatweb_CORP (bill_ref_no) values ('||c.bill_ref_no||');') 
end InsertFatweb
from cmf_balance c,cmf cm, account_category_values a
where c.account_no = cm.account_no
and cm.account_category = a.account_category
and a.language_code = 2
and c.bill_ref_no in(267751480,274724578,260728180,275796602,276008247,261814597,276146958) --faturas
order by 2;