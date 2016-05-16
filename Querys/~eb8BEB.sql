select * from all_tables where table_name like '%DACC%' 

select * from customer_id_acct_map where external_id = '999988276012'

select * from GVT_DACC_HIST_MET_PGTO where external_id = '999988276012'

select * from GVT_DACC_GERENCIA_MET_PGTO where external_id = 999988276012

select * from payment_trans where account_no = 2814180

select * from payment_profile where CUST_BANK_ACC_NUM = '999988276012'

select * from ARBORGVT_PAYMENTS.GVT_DACC_CONTROLE_NSA

select * from GVT_DACC_GERENCIA_FILA_EVENTOS where external_id = 999988276012

select * from cmf_balance where bill_ref_no in (104704404,104808348,104758956,104760507,104760508)
