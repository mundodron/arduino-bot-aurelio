Precisamso do arquivo FEBRABAN das faturas abaixo. Para isto, favor seguir os 3 passos abaixo:

1) Rodar o script em PBCT2:
----------------------------------------------------------------------------------------
Insert into ARBORGVT_PAYMENTS.GVT_FEBRABAN_PONTA_B_ARBOR
   (ROW_ID, CMF_EXT_ID, EMF_EXT_ID, SERVICE_START, SERVICE_END, DEGRAU, VELOCIDADE, UNID_VELOCIDADE, CNLA, CNLB, ADDRESS_B, NUMBER_B, COMPL_B, DISTRICT_B, PHONE_NUMBER)
 Values
   ('3-16T7HBN      ', '999982202062', 'CTA-3016T7HBM-032', TO_DATE('06/11/2012 00:00:00', 'MM/DD/YYYY HH24:MI:SS'), NULL, 
    's/', 0, '          ', '41000', '41000', 
    ' RUA        TENENTE FRANCISCO FERREIRA DE SOUZA 766', NULL, NULL, 'SP', NULL);
COMMIT;
----------------------------------------------------------------------------------------

2) Rodar o insert abaixo na mesma base.
----------------------------------------------------------------------------------------
INSERT INTO GVT_FEBRABAN_BILL_INVOICE 
select ACCOUNT_NO, BILL_REF_NO, BILL_REF_RESETS,0,1,0,NULL,NULL,NULL,0,NULL,NULL,0,NULL,NULL,2
FROM BILL_INVOICE
WHERE BILL_REF_NO in (116872531);
commit;
----------------------------------------------------------------------------------------

3) Executar o job de geração de arquivos Febraban.

4) Executar o job que move os arquivos Febraban para o servidor do HSBC

Por favor me enviar os arquivos gerados.

Obrigado!