     SELECT  a.external_id,
             b.account_no,
             a.tipo_produto,
             a.subscr_no,
             a.subscr_no_resets,
             a.flag_processado,
             DECODE(a.tipo_produto,0,12789,1,12788,2,CASE WHEN s.display_external_id_type = 10 THEN 12787 ELSE 12812 END) nrc,
             DECODE(s.display_external_id_type,
             6,valor.valor_ressarcimento, --VOZ
             7,valor2.soma, --BANDA LARGA
             10,valor2.soma, --TV
             12,valor2.soma) valor_ressarc, --TV
             --SUM(a.valor_ressarc)                                         valor_ressarc,
             --valor.valor_ressarcimento                                        valor_ressarc,
             CASE WHEN s.display_external_id_type = 10 THEN 90 ELSE 1 END open_item_id
    FROM   arborgvt_billing.gvt_credito_interrupcao_log a,
         arbor.customer_id_acct_map                   b,
         service                                      s,  --RFC 426127
         ( SELECT sum(duracao_final) as tempo_interrupcao,
            trunc (sum((valor_produto / 30 / 1440) * duracao_final),0) valor_ressarcimento,
            external_id,
            tipo_produto
             FROM (SELECT external_id,
                          tipo_produto,
                           CASE
                              WHEN (dt_fechamento - dt_abertura) * 24 * 60 <= 30 THEN 30
                              ELSE
                               CASE
                                 WHEN (dt_fechamento - dt_abertura) * 24 * 60 >= 1440 THEN
                                  (CEIL((dt_fechamento - dt_abertura) * 24 * 60 / 1440) * 1440)
                                 ELSE
                                  1440
                               END
                            END duracao_final,
                           (l.valor_produto) valor_produto
                     FROM arborgvt_billing.gvt_credito_interrupcao_log l
                    WHERE flag_processado  IN (0,2)
                   )
         GROUP BY external_id, tipo_produto ) valor, 
        (select x.external_id,
                x.tipo_produto,
                trunc (sum((valor_produto / 30 / 1440) * ((dt_fechamento - dt_abertura) * 24 * 60)),0) soma 
           from arborgvt_billing.gvt_credito_interrupcao_log x
          group by x.external_id,x.tipo_produto) valor2     
      WHERE  a.external_id      = b.external_id
      AND    valor.external_id = b.external_id
      AND    valor.tipo_produto = a.tipo_produto
      AND    valor2.external_id = b.external_id
      AND    valor2.tipo_produto = a.tipo_produto       
      AND    b.external_id_type = 1
      AND    a.flag_processado  IN (0,2) -- nao processado ainda ou com erro de insercao da NRC. Erro de preco e ignorado (3).
      AND    a.subscr_no        = s.subscr_no
      AND    a.subscr_no_resets = s.subscr_no_resets
      GROUP  BY a.external_id,
         b.account_no,
         a.tipo_produto,
         a.subscr_no,
         a.subscr_no_resets,
         a.flag_processado,
         DECODE(a.tipo_produto,0,12789,1,12788,2,CASE WHEN s.display_external_id_type = 10 THEN 12787 ELSE 12812 END),
         CASE WHEN s.display_external_id_type = 10 THEN 90 ELSE 1 END,
         DECODE(s.display_external_id_type,
         6,valor.valor_ressarcimento, --VOZ
         7,valor2.soma, --BANDA LARGA
         10,valor2.soma, --TV
         12,valor2.soma);
       
    -- Obs.:
    -- 12787   Credito Restituicao Reparo TV
    -- 12788   Credito Restituicao Reparo Dados
    -- 12789   Credito Restituicao Reparo Voz
    
    select account_no from customer_id_acct_map where external_id in ('999982838342','899996894821','899999487798','999981074138','899999487798')

select max(bill_ref_no) from bill_invoice where account_no in (9767552)
group by account_no

 order by 2 desc