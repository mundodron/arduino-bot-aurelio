select account_no, DATE_CREATED, DATE_ACTIVE, next_bill_date, account_category  from cmf where prev_cutoff_date is null


select * from service where service_active_dt < 

select substr('P19',2,2) || to_char(sysdate, 'MMYYYY') from dual