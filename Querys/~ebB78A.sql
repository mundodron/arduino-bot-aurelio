
INSERT INTO ARBORGVT_BILLING.GVT_AVULSO_FATURACD (account_no, bill_ref_no)

select account_no, bill_ref_no from bill_invoice where account_no = 272799319 and bill_ref_no in (9231556);

commit;

select bill_period from cmf where account_no = 4434714

select * from bill_invoice where account_no = 4434714

select * from all_tables where OWNER = 'G0023421SQL'

select * from GVT_LOTERICA_CONSULTA_CPFCNPJ where contact1_phone = '04284802925'

drop table VRC_SOBREPOSICAO_DUPLICADA

drop table GVT_FATURAS_SEMPRE_LOCAL


select * from customer_id_acct_map where

select * from bill_invoice where account_no in (4273196) order by 2 desc

select * from bill_invoice where account_no in (4434714) order by 2 desc

select * from bill_invoice where account_no in (2348130) order by 2 desc


select * from bipp15_corp

select * from bill_invoice where bill_ref_no in (288977702,288967757)

select * from customer_id_acct_map where account_no in (4273196,4434714)