                  SELECT external_id,status_evento, count(status_evento)
                    FROM gvt_dacc_gerencia_fila_eventos
                   WHERE 1 =1 --external_id = v_external_id
                     AND status_evento <> 1   --0 = Processar / 1 = Ja Processado / 9 = Pendente
                     AND origem IS NULL
                   group by external_id,status_evento
                   having count(status_evento)>10
                   
                   
                   select * from gvt_dacc_gerencia_fila_eventos