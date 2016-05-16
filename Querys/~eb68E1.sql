select gdgfe.cod_agente_arrecadador,
               gdgfe.external_id,
               EIAM.ACCOUNT_NO,
               gdgfe.tp_evento,
               GDPGTO.COD_AGENTE_ARRECADADOR v_cod_banco,
               gdgfe.cod_agencia v_ag,
               gdgfe.num_cc_cartao v_cc,
               gdgfe.dt_evento,
               GDPGTO.PAY_METHOD,
               gdgfe.status_evento
from customer_id_acct_map eiam,
     gvt_dacc_gerencia_fila_eventos gdgfe,
     GVT_DACC_GERENCIA_MET_PGTO GDPGTO
where eiam.external_id = gdgfe.external_id
and gdgfe.status_evento = 9
AND GDPGTO.STATUS_CADASTRAMENTO = 3
AND GDPGTO.EXTERNAL_ID = GDGFE.EXTERNAL_ID
and EIAM.INACTIVE_DATE is null
--and months_between(to_date(sysdate + 5, 'dd/mm/yyyy'),to_date(gdgfe.dt_evento, 'dd/mm/yyyy')) <= 5;
AND TRUNC(gdgfe.dt_evento) >= TO_dATE('01/04/2012','DD/MM/YYYY')
AND TRUNC(gdgfe.dt_evento) <= TO_dATE('24/05/2012','DD/MM/YYYY')



select gdgfe.cod_agente_arrecadador,
               gdgfe.external_id,
               EIAM.ACCOUNT_NO,
               gdgfe.tp_evento,
               GDPGTO.COD_AGENTE_ARRECADADOR v_cod_banco,
               gdgfe.cod_agencia v_ag,
               gdgfe.num_cc_cartao v_cc,
               gdgfe.dt_evento,
               GDPGTO.PAY_METHOD
from customer_id_acct_map eiam,
     gvt_dacc_gerencia_fila_eventos gdgfe,
     GVT_DACC_GERENCIA_MET_PGTO GDPGTO
where eiam.external_id = gdgfe.external_id
and gdgfe.status_evento = 9
AND GDPGTO.STATUS_CADASTRAMENTO = 3
AND GDPGTO.EXTERNAL_ID = GDGFE.EXTERNAL_ID
and months_between(to_date(sysdate, 'dd/mm/yyyy'),to_date(gdgfe.dt_evento, 'dd/mm/yyyy')) <= 4
AND TRUNC(gdgfe.dt_evento) >= TO_dATE('14/02/2012','DD/MM/YYYY')
AND TRUNC(gdgfe.dt_evento) <= TO_dATE('24/05/2012','DD/MM/YYYY')


  Create TABLE GVT_ERRO_CADASTRO
  ( EXTERNAL_ID  varchar2(15),
    BILL_REF_NO  number(12),
    VALOR        number(20),
    STATUS       number(5),
    MSG          Varchar2(200)
  );
  

select * from GVT_ERRO_CADASTRO

truncate table GVT_ERRO_CADASTRO

select * from customer_id_acct_map where external_id = '999984611020'