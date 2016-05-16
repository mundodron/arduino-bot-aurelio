Por favor, rodar o Delete abaixo, retirar os arquivos já processados da pasta e relancear o Job.

delete from gvt_dacc_gerencia_met_pgto where external_id = 899999657882 and rownum = 1;

delete from gvt_dacc_gerencia_fila_eventos where external_id = 899999657882 and rownum = 1;

commit;

          SELECT account_no
            FROM customer_id_acct_map
           and inactive_date is null
           group by account_no
                   
select external_id, count(1) from gvt_dacc_gerencia_met_pgto
--where dt_cadastro>=trunc(sysdate-1)
group by external_id
having count(1)>1

select external_id from gvt_dacc_gerencia_fila_eventos
group by external_id
having count(1)>1

select * from GVT_DACC_GERENCIA_FILA_EVENTOS
where STATUS_EVENTO = 9
and DT_EVENTO>=trunc(sysdate-2)


select * from gvt_dacc_gerencia_met_pgto
--where STATUS_EVENTO = 9
where DT_CADASTRO>=trunc(sysdate-2)

group by external_id
having count(1)>1


select * from gvt_dacc_gerencia_met_pgto where external_id = 899999261556


select * from gvt_dacc_gerencia_met_pgto where external_id = 999997005728

select * from gvt_dacc_gerencia_fila_eventos where external_id = 999985517241

select * from gvt_dacc_gerencia_met_pgto where external_id = 999985517241
