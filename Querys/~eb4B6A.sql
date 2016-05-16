Precisamos dos arquivos FEBRABAN das faturas abaixo. Para isto, favor seguir os passos abaixo:

1) Rodar o insert abaixo em PBCT1
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Insert into ARBORGVT_PAYMENTS.GVT_FEBRABAN_PONTA_B_ARBOR
  (ROW_ID,     CMF_EXT_ID, EMF_EXT_ID        , SERVICE_START                                          , DEGRAU, VELOCIDADE, UNID_VELOCIDADE,    CNLA,    CNLB,                ADDRESS_B, COMPL_B, DISTRICT_B)
Values
  ('3-109FV13', '999983795899', 'PROTECT-30109FV14', TO_DATE('21/10/2011 00:00:00', 'MM/DD/YYYY HH24:MI:SS'), 's/'  , 0, ''   , '41000', '41000', 'RODV.      BR 277 (GVT:009903) 591',  '', 'PR');

commit;
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

2) Rodar o insert abaixo em PBCT1.
-------------------------------------------------------------------------
INSERT INTO GVT_FEBRABAN_BILL_INVOICE 
select ACCOUNT_NO, BILL_REF_NO, BILL_REF_RESETS,0,1,0,NULL,NULL,NULL,0,NULL,NULL,0,NULL,NULL,2
FROM BILL_INVOICE
WHERE BILL_REF_NO in (156525720,156523327,156524132,156523576,156524570,156524772,156524773,156524974,156522923,156523322,156523931,156524317,156524929,156525539,156524538,156524577,156525538,156525584);

commit;
-------------------------------------------------------------------------

2) Executar o job de geração de arquivos Febraban.

3) Executar o job que move os arquivos Febraban para o servidor  WEB

Por favor me enviar os arquivos por email para o usuaria Cintia Pesse Ribas <cintia.ribas@gvt.com.br>

Obrigado!