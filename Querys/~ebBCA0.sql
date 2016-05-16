select * from GVT_DACC_GERENCIA_FILA_EVENTOS where trunc(DT_EVENTO) = trunc(sysdate) and status_evento in (1);

select * from GVT_DACC_GERENCIA_FILA_EVENTOS where external_id = 999993091452 -- 999982854586 --999985557329 --999983150648


update GVT_DACC_GERENCIA_FILA_EVENTOS set status_evento = 0 where trunc(DT_EVENTO) = trunc(sysdate) and status_evento = 1;

select * from GVT_DACC_GERENCIA_FILA_EVENTOS where trunc(DT_EVENTO) = trunc(sysdate) and status_evento in (1,9);

GVT_DACC_CONTROLE_NSA_PK

select * from GVT_DACC_CONTROLE_NSA

select * from all_tables where table_name like '%DACC%' 

select * from GVT_DACC_GERENCIA_FILA_EVENTOS where external_id = 999993091452



select * from GVT_DACC_GERENCIA_MET_PGTO where external_id = 999993091452


select * from customer_id_acct_map where external_id = '999993091452'

select * from payment_trans where account_no = 1809908 and bill_ref_no in (90539979,92516577,94557962,96855772)

select * from bmf where account_no = 1809908

select * from cmf_balance where account_no = 1809908


