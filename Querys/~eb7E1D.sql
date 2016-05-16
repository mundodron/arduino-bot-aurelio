A evidencia de testes se baseia na execução da query abaixo, que deve retornar apenas um registro.

Base PBCT2:

SELECT exempt_state, exempt_city
    --INTO v_out_exempt_state, v_out_exempt_city
FROM cmf_exempt
WHERE cmf_exempt.account_no = 8040619 -- v_in_account_no
  AND cmf_exempt.date_expiration is null;

