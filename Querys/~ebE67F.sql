Thiago,

O problema é que a conta 999992564432 possui 12 registros com status pendente (9) na tabela GVT_DACC_GERENCIA_FILA_EVENTOS, que retornam na query da PL:

SELECT COUNT (*)
INTO v_qtde_evento
FROM gvt_dacc_gerencia_fila_eventos
WHERE external_id = 999992564432
AND status_evento <> 1   --0 = Processar / 1 = Ja Processado / 9 = Pendente
AND origem IS NULL;

Porém a variável v_qtde_evento é NUMBER (1), por isso o abort, pois o retorno da query tinha mais de um dígito.

Por favor execute o update abaixo em c2 e relance o processo:
update  gvt_dacc_gerencia_fila_eventos set status_evento=1
where external_id in ('999992564432')
and status_evento <> 1
and origem is null
and dt_evento < to_date ('07/09/2013 10:20:47','dd/mm/yyyy hh24:mi:ss');
commit;
