select * from payment_trans where account_no in (select status from gvt_nrc_invalida)

select * from gvt_nrc_invalida order by external_id

-- update gvt_nrc_invalida g set CNPJ = (select CONTACT1_PHONE from GVT_LOTERICA_CONSULTA_CPFCNPJ where account_no = g.account_no)

select external_id, count(*) from gvt_nrc_invalida group by external_id having count(*) >= 2 order by 2 desc

select * from customer_id_acct_map where external_id = '999983688812'

select * from bmf where account_no = 2817271


select * from gvt_nrc_invalida

insert into gvt_nrc_invalida (EXTERNAL_ID,STATUS) values ('999989298568','F');

update gvt_nrc_invalida G set G.account_no = (select account_no from customer_id_acct_map where external_id = G.EXTERNAL_ID and external_id_type = 1 and inactive_date is null);


select count(*) from gvt_nrc_invalida where status = 'F' and account_no is not null

select G.*, P.PAY_METHOD
  from gvt_nrc_invalida G,
  GVT_DACC_GERENCIA_MET_PGTO P
 where G.status = 'F'
   and G.account_no is not null
   and G.external_id = P.EXTERNAL_ID
   and P.PAY_METHOD != 3
   
   select * from all_tables where table_name like '%DACC%' 