
Precisamos do arquivo FEBRABAN das faturas abaixo para isto, favor seguir os 3 passos abaixo:
1) INSERT INTO GVT_FEBRABAN_BILL_INVOICE 

select ACCOUNT_NO, BILL_REF_NO, BILL_REF_RESETS,0,1,0,NULL,NULL,NULL,0,NULL,NULL,0,NULL,NULL,2
FROM BILL_INVOICE
WHERE BILL_REF_NO in (102366509,102366708,102306903,103154913,103155105,103155320,103155325,103155733,103155906,103155929,103156105,103156109,103156113,103156332,103156333,103156504,103156706,103157113,103157311,103157314,103157316,103157322,103157508,103157717,103157724,103158122,103168310,103174953,103227730);

commit;

2) Executar o job de gera��o de arquivos Febraban.

3) Executar o job que move os arquivos Febraban para o servidor WEB


