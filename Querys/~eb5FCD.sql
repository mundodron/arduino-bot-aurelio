      SELECT external_id
        --INTO v_count_external_id
        FROM customer_id_acct_map
       WHERE external_id in (SELECT   external_id
        FROM gvt_dacc_gerencia_fila_eventos gdgfe
       WHERE gdgfe.status_evento = 0   --0 = Processar / 1 = Ja Processado / 9 = Pendente
         AND gdgfe.aguarda_retorno = 'S')
         group by external_id
         HAVING count(external_id) > 1;
         
         
         
         SELECT   external_id
        FROM gvt_dacc_gerencia_fila_eventos gdgfe
       WHERE gdgfe.status_evento = 0   --0 = Processar / 1 = Ja Processado / 9 = Pendente
         AND gdgfe.aguarda_retorno = 'S'