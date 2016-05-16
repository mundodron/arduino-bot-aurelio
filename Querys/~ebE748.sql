DROP TABLE g0023421sql.TMP_INC_RELATORIO_DACC CASCADE CONSTRAINTS;

CREATE TABLE g0023421sql.TMP_INC_RELATORIO_DACC
(
  ACCOUNT_NO      NUMBER(10),
  CONTACT1_PHONE  CHAR(300 BYTE),
  BILL_LNAME      VARCHAR2(96 BYTE),
  SERVICE_CITY    VARCHAR2(35 BYTE),
  SERVICE_STATE   VARCHAR2(28 BYTE)
);

GRANT ALL ON g0023421sql.TMP_INC_RELATORIO_DACC TO PUBLIC;

insert into g0023421sql.TMP_INC_RELATORIO_DACC (
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
-- and c.bill_period like 'M%'
and c.no_bill = 0
and c.date_inactive is null 
group by c.account_no, c.contact1_phone, c.bill_lname, c.bill_city, c.bill_state
);

commit;

-- Relatório 
select 'A140082               GVT/CURITIBA-PR     008SANTANDER MERIDIONAL' || to_char(sysdate,'YYYYMMDD') || '00999804DEBITO AUTOMATICO                                                    ' from dual;

                                          
select 'I' ||
      rpad(eiam.external_id,25,' ') || 
      (case when length (trim(contact1_phone)) >= 14 then '1'
      else  '2' end) ||
      lpad(trim(t.contact1_phone),14,0) || 
      rpad(trim(t.bill_lname) ,40,' ') ||
      rpad(trim(t.service_city),30,' ') || 
      rpad(trim(t.service_state), 39,' ')
from g0023421sql.TMP_INC_RELATORIO_DACC t, customer_id_acct_map eiam
where eiam.account_no = t.account_no
and eiam.external_id_type = 1
and EIAM.INACTIVE_DATE is null;

select 'Z' || Rpad(trim(count(*) + 2),23,0) || Rpad(' ',126,' ') as T_linhas from g0023421sql.TMP_INC_RELATORIO_DACC