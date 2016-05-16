select account_no, external_id from customer_id_acct_map where external_id in ('899998502871','999982680760','999982680760')

select * from cmf where account_no in (8551415,4561003)


ALTER TABLE G0023421SQL.GVT_VAL_PLANO_DADOS
ADD (NOME_PLANO VARCHAR2(25 CHAR));

ALTER TABLE G0023421SQL.GVT_VAL_PLANO
ADD (NOME_PLANO VARCHAR2(25 CHAR));

update G0023421SQL.GVT_VAL_PLANO set NOME_PLANO = 'LAVOISIER';

update G0023421SQL.GVT_VAL_PLANO_DADOS set NOME_PLANO = 'LAVOISIER';

select * from cmf where account_no = 4561003

Select BILL_FMT_OPT, BILL_DISP_METH from cmf where account_no = 4561003

update cmf BILL_FMT_OPT = 2 where account_no = 4561003;

commit;

select * from cdr_billed where account_no = 4561003 and bill_ref_no = 180953711

select * from cdr_data where account_no = 4561003 and msg_id in (select msg_id from cdr_billed where account_no = 4561003 and bill_ref_no = 180953711)

select * from payment_profile where account_no = 4561003

select format_status from bill_invoice

select bill_period from cmf where account_no = 9269049