
SELECT   CBD.ACCOUNT_NO,
         CBD.BILL_REF_NO,
         CBD.EXTERNAL_ID,
         SSN.FULL_SIN_SEQ,
         BI.FILE_NAME,
         BI.PREP_ERROR_CODE,
         BI.BILL_PERIOD
  FROM   CMF_BALANCE_DETAIL CBD, SIN_SEQ_NO SSN, BILL_INVOICE BI
 WHERE   CBD.BILL_REF_NO = SSN.BILL_REF_NO
   AND   SSN.BILL_REF_NO = BI.BILL_REF_NO
   AND   CBD.BILL_REF_NO = 187319765;
   
   
   Select def.parceiro||', '||par.nome operadora,
       uf,
       eot,
       decode(data_max_critica,to_date('31/12/2999','dd/mm/yyyy'),'NAO','SIM') POSSUI_DEFERIMENTO
from grc_deferimento_fiscal def, grc_parceiros par
where par.codigo = def.parceiro
and upper(par.nome)  like ('%TIM%') 
order by def.parceiro, def.uf
