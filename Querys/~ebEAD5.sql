--considerando somente pay_method = 1, pois o pay_method = 2 será outra campanha

m02 --ok
m05 --ok
m10 --ok
m15 --ok
m20 --ok
m28 --ok


--criar tabela por ciclo, verificar tablespace com produção
/*create table tmp_fernando 
( account_no  number(10),
  contact1_phone char(20),
  bill_lname varchar2(56),
  service_city varchar2(35),
  service_state  varchar2(28))*/



insert into tmp_fernando (
select c.account_no, c.contact1_phone, c.bill_lname, e.service_city, e.service_state from cmf c, emf e
where e.account_no = c.account_no
and e.service_end is null
and e.no_bill = 0
and e.equip_status = 0   
and c.pay_method = 1
--and c.bill_period = 'M15'
and c.no_bill = 0
and c.date_inactive is null 
group by c.account_no, c.contact1_phone, c.bill_lname, e.service_city, e.service_state
)


--truncate table tmp_fernando
 
  
select * from g0007324sql.tmp_fernando --> tablespace hugo


--CONCATENADO
select 'I' ||
       rpad(eiam.external_id,25,' ') || 
       (case when length (trim(contact1_phone)) >= 14 then '1'
       else  '2' end) ||
       rpad(t.contact1_phone,14,' ') || 
       rpad(t.bill_lname ,40,' ') ||
       rpad(t.service_city,30,' ') || 
       rpad(t.service_state, 39,' ')  
from g0007324sql.tmp_fernando t, external_id_acct_map eiam
where eiam.account_no = t.account_no
and eiam.external_id_type = 1

select * from all_tables where owner = 'G0023421SQL'

