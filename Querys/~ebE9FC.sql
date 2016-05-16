                  SELECT COUNT (*)
                    FROM gvt_dacc_gerencia_fila_eventos
                   WHERE external_id = v_external_id
                     AND status_evento <> 1   --0 = Processar / 1 = Ja Processado / 9 = Pendente
                     AND origem IS NULL;