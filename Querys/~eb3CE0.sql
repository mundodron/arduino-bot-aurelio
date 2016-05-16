-- select * from g0023421sql.GVT_VAL_PLANO where component_id = 30361

-- delete g0023421sql.GVT_VAL_PLANO where component_id = 25011

select * from g0023421sql.GVT_VAL_PLANO where component_id = 25011


Insert into G0023421SQL.GVT_VAL_PLANO
   (PLANO, COMPONENT_ID, COMPONENTE, ELEMENTOSCOMPONENTE, ELEMENTO, TIPOELEMENTO, ARQUIVO, NOME_PLANO)
 Values
   ('GVT - Na Medida Casa', '25011', 'Plano Basico - 5 minutos', NULL, NULL, 
    'RC - Conta', NULL, 'LAVOISIER');
COMMIT;
