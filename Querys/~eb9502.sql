select ACCOUNT_NO, BILL_REF_NO, BILL_REF_RESETS,0,1,0,NULL,NULL,NULL,0,NULL,NULL,0,NULL,NULL,2
FROM BILL_INVOICE
WHERE BILL_REF_NO in (191758394,195976987,200289902,206574750,213172814,191758394,195976987,200289902,206574750,213172814);



select * from GRC_SERVICOS_PRESTADOS gr where GR.DATA_INSERCAO < (sysdate -30) and tcoe is not null

