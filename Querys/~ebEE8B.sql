-- ultimas contas da Cardif
select account_no, max(bill_ref_no) faturas from cmf_balance where account_no in (4643727)
group by account_no


GVT_SP_ARQ_CONTA_DETALHADA

select * from all_tables where table_name like '%CONTAFACIL%' 

select NOME_ARQUIVO from ARBORGVT_BILLING.GVT_CONTAFACIL_ARQUIVOS

select * from customer_id_acct_map where external_id = '999983038332'

select * from gvt_conta_internet where account_no = 4648009 order by 4


update GVT_CONTA_INTERNET set NOME_ARQUIVO = 'Agosto/4/2013Agosto777777775034_250.cdc', BILL_REF_NO = 152225726, external_id = '777777775034', existe_fatura = 1 where ACCOUNT_NO = 2856019 and trunc(DATA_PROCESSAMENTO) = to_date('27/07/2013','dd/mm/yyyy');

commit;

update GVT_CONTA_INTERNET set NOME_ARQUIVO = 'Maio/2/2013Maio999983038332_250.cdc', BILL_REF_NO = 142443915, where ACCOUNT_NO = 4648009 and trunc(DATA_PROCESSAMENTO) = to_date('19/04/2013','dd/mm/yyyy');

update GVT_CONTA_INTERNET set NOME_ARQUIVO = 'Junho/2/2013Junho999983038332_250.cdc', BILL_REF_NO = 145382519, where ACCOUNT_NO = 4648009 and trunc(DATA_PROCESSAMENTO) = to_date('19/05/2013','dd/mm/yyyy');

commit;

update GVT_CONTA_INTERNET set EXTERNAL_ID = '999983038332', EXISTE_FATURA = '1' where ACCOUNT_NO = 4648009 and NOME_ARQUIVO is not null;

commit;


Obrigado!
----------------------------------------------------

CONTAFACIL_CORP

select account_no, bill_ref_no from cmf_balance where bill_ref_no in (156496671,156496673,156496674,156496675,156496676,156496678,156496677,156496680,156496679,156496682,156496683,156496685,156496686,156496687,156496688,156496691,157413903,157413902,157413502)

select account_no,count(1) from GVT_CONTA_INTERNET where 1 = 1 --bill_ref_no in (156496671,156496673,156496674,156496675,156496676,156496678,156496677,156496680,156496679,156496682,156496683,156496685,156496686,156496687,156496688,156496691,157413903,157413902,157413502)
and account_no in (select account_no from cmf_balance where bill_ref_no in (156496671,156496673,156496674,156496675,156496676,156496678,156496677,156496680,156496679,156496682,156496683,156496685,156496686,156496687,156496688,156496691,157413903,157413902,157413502))
group by account_no