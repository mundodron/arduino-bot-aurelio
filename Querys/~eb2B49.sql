select * from customer_id_acct_map where external_id = '999987173957'

-- ultimas contas da Cardif
select account_no, max(bill_ref_no) faturas from cmf_balance where account_no in (3857503,7374426,4463548,3858364,3857518)
group by account_no


GVT_SP_ARQ_CONTA_DETALHADA

select * from cmf_balance where account_no = 3857503

select * from all_tables where table_name like '%CDC%' 

select NOME_ARQUIVO from GVT_CONTAFACIL_ARQUIVOS

select * from customer_id_acct_map where external_id = '999983038332'

select * from gvt_conta_internet where account_no = 7374426 order by 4


update GVT_CONTA_INTERNET set NOME_ARQUIVO = 'Agosto/4/2013Agosto777777775034_250.cdc', BILL_REF_NO = 152225726, external_id = '777777775034', existe_fatura = 1 where ACCOUNT_NO = 2856019 and trunc(DATA_PROCESSAMENTO) = to_date('27/07/2013','dd/mm/yyyy');

commit;

update GVT_CONTA_INTERNET set NOME_ARQUIVO = 'Maio/2/2013Maio999983038332_250.cdc', BILL_REF_NO = 142443915, where ACCOUNT_NO = 4648009 and trunc(DATA_PROCESSAMENTO) = to_date('19/04/2013','dd/mm/yyyy');

update GVT_CONTA_INTERNET set NOME_ARQUIVO = 'Junho/2/2013Junho999983038332_250.cdc', BILL_REF_NO = 145382519, where ACCOUNT_NO = 4648009 and trunc(DATA_PROCESSAMENTO) = to_date('19/05/2013','dd/mm/yyyy');

commit;

update GVT_CONTA_INTERNET set EXTERNAL_ID = '999983038332', EXISTE_FATURA = '1' where ACCOUNT_NO = 4648009 and NOME_ARQUIVO is not null;

commit;


Obrigado!
----------------------------------------------------
