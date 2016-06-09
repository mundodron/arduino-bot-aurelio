      SELECT a.external_id,
             a.dt_abertura,
             a.dt_fechamento,
             a.num_ss,
             a.desc_ss,
             a.tipo_produto,
             b.account_no
      FROM   arborgvt_billing.gvt_credito_interrupcao_carga a,
             arbor.customer_id_acct_map                     b
      WHERE  a.external_id      = b.external_id
      AND    b.external_id_type = 1
      --AND    (a.dt_fechamento - a.dt_abertura) * 24 * 60 >= 30 -- Deve ter pelo menos 30 min de interrupcao
   

 AND    NOT EXISTS
             (
               SELECT 1
               FROM   arborgvt_billing.gvt_credito_interrupcao_log c
               WHERE  a.num_ss = c.num_ss
             ) -- nao deve ser uma SS ja processada na tabela de log
      AND    NOT EXISTS
             (
               SELECT 1
               FROM   arborgvt_billing.gvt_credito_interrupcao_bkp d
               WHERE  a.num_ss = d.num_ss
             ); -- nao deve ser uma SS ja processada na tabela de backup

