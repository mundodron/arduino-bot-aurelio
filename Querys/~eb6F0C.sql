Por favor, rodar o Delete abaixo, retirar os arquivos já processados da pasta e relancear o Job.

delete from gvt_dacc_gerencia_met_pgto where external_id = 899999657882 and rownum = 1;

delete from gvt_dacc_gerencia_fila_eventos where external_id = 899999657882 and rownum = 1;

commit;

          SELECT account_no
            FROM customer_id_acct_map
           and inactive_date is null
           group by account_no
                   
select external_id, count(1) from gvt_dacc_gerencia_met_pgto
where dt_cadastro>=trunc(sysdate-1)
group by external_id
having count(1)>1

select * from gvt_dacc_gerencia_met_pgto where external_id = 999997005728

select * from gvt_dacc_gerencia_fila_eventos where external_id = 999980954951