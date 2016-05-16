update GRCOWN.GRC_SERVICOS_PRESTADOS set tcoe = 'REM.' || lote || '.NC'
where TCOE is null
and  trunc(data_insercao) >to_date ('01/01/2013', 'dd/mm/yyyy')
and status not in ('R','Rj','DE');

commit;