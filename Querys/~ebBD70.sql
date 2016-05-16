select G.EXTERNAL_ID, G.ACCOUNT_NO, P.PAY_METHOD,  P.DT_CADASTRO, P.DT_ULTIMO_RETORNO, P.ULTIMO_COD_RETORNO
  from gvt_nrc_invalida G,
       GVT_DACC_GERENCIA_MET_PGTO P
 where status = 'F'
   and account_no is not null
   and G.EXTERNAL_ID = P.EXTERNAL_ID
   and P.PAY_METHOD != 3
   
select * from customer_id_acct_map where external_id = '999988610327'
   
select * from bmf where account_no = 2720266

select * from all_tables where table_name like '%DACC%'

select * from GVT_DACC_GERENCIA_FILA_EVENTOS where external_id = '999988610327'

select * from GVT_DACC_HIST_MET_PGTO where external_id = '999988610327'

select * from cmf_balance where bill_ref_no in (107914502)

select * from GVT_DACC_GERENCIA_MET_PGTO where external_id = '999988610327'
   

select * from cmf_balance where bill_ref_no = '777777766916'

select distinct(external_id) from gvt_nrc_invalida where status is null and account_no is not null  and account_no in (
select account_no from cmf_balance_detail C where C.OPEN_ITEM_ID in (91,92))