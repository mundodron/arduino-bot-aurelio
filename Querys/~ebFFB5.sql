select * from GVT_DACC_GERENCIA_MET_PGTO where external_id = 999985959329


select * from GVT_DACC_GERENCIA_FILA_EVENTOS where trunc(DT_EVENTO) = trunc(sysdate) and status_evento in (0);

select * from all_tables where table_name like '%FILA%' 


select * from GVT_DACC_GERENCIA_FILA_EVENTOS where trunc(DT_EVENTO) = trunc(sysdate) and status_evento in (0)

Update GVT_DACC_GERENCIA_FILA_EVENTOS set STATUS_EVENTO = 9 where trunc(DT_EVENTO) = trunc(sysdate) and status_evento in (0);

Update GVT_DACC_GERENCIA_FILA_EVENTOS set STATUS_EVENTO = 9 where external_id = 999984322738;

commit;

select * from GVT_DACC_GERENCIA_FILA_EVENTOS where trunc(DT_EVENTO) = trunc(sysdate - 1) and status_evento in (1,9);

commit;

select * from GVT_DACC_GERENCIA_FILA_EVENTOS where external_id = 999982854586 --999985557329 --999983150648

select * from arborgvt_payments.gvt_dacc_controle_nsa where CLEARING_HOUSE_ID = 745 order by 2 desc

select * from cmf_balance where bill_ref_no in (104160720,104404341,104078965,104077570,103178137)

select * from bankseqs

select * from all_tables where table_name like '%BANK%' 