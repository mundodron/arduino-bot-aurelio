Precisamos dos arquivos FEBRABAN das faturas no chamado. Para isto, favor seguir os passos abaixo:

1) Rodar o delete e insert abaixo em PBCT1.
-------------------------------------------------------------------------
delete from gvt_febraban_bill_invoice where account_no = 3203638 and bill_ref_no in (209604307,216200156);

INSERT INTO GVT_FEBRABAN_BILL_INVOICE 
select ACCOUNT_NO, BILL_REF_NO, BILL_REF_RESETS,0,1,0,NULL,NULL,NULL,0,NULL,NULL,0,NULL,NULL,2
FROM BILL_INVOICE
WHERE BILL_REF_NO in (209604307,216200156);

commit;
-------------------------------------------------------------------------

2) Executar o job de geração de arquivos Febraban.

3) Executar o job que move os arquivos Febraban para o servidor  WEB

Por favor me enviar os arquivos por email 

Obrigado!

select * from customer_id_acct_map where external_id = '999987479971'

delete from gvt_febraban_bill_invoice where account_no = 3203638 and bill_ref_no in (209604307,216200156)