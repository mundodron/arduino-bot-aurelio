select * from gvt_nrc_invalida order by external_id


select * from GVT_LOTERICA_CONSULTA_CPFCNPJ 


update gvt_nrc_invalida g set CNPJ = (select CONTACT1_PHONE from GVT_LOTERICA_CONSULTA_CPFCNPJ where account_no = g.account_no)

select * from gvt_nrc_invalida where status = 'F' and account_no is not null

update gvt_nrc_invalida G set G.account_no = (select account_no from customer_id_acct_map where external_id = G.EXTERNAL_ID and external_id_type = 1 and inactive_date is null);


select * from gvt_nrc_invalida where status = 'F' and account_no is not null

select account_no from customer_id_acct_map where external_id = '999992861901' and inactive_date is not null

select count(*) from gvt_nrc_invalida where status = 'F' and account_no is not null


select * from all_tables where table_name like '%DACC%'

select * from GVT_DACC_GERENCIA_FILA_EVENTOS

select G.*, P.PAY_METHOD, P.DT_CADASTRO
  from gvt_nrc_invalida G,
  GVT_DACC_GERENCIA_MET_PGTO P
 where G.status = 'F'
   and G.account_no is not null
   and G.external_id = P.EXTERNAL_ID
   and P.PAY_METHOD != 3
 order by P.DT_CADASTRO asc
   