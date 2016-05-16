
        Select 
        count(1) qtde,
        trunc(prep_date) data_processamento, 
        --decode(format_status,2,'Ok',3,'Ok',0,'Pendente',1,'Pendente','Erro') status
        decode(format_status, 2, 'Gerado', -1, 'Não Gerado') status
      from BILL_INVOICE bi
     where bi.prep_status = 1
     and format_status in (2,-1)
     and bi.prep_date >= to_date('01/01/2016','dd/mm/rrrr')
     and bi.prep_error_code is null
     group by 
        trunc(prep_date), 
        --decode(format_status,2,'Ok',3,'Ok',0,'Pendente',1,'Pendente','Erro')
        decode(format_status, 2, 'Gerado', -1, 'Não Gerado')     


CREATE OR REPLACE PROCEDURE "ARBORGVT_BILLING"."GVT_GET_MET_PGTO" 
( v_EXTERNAL_ID   IN  VARCHAR2,
  cursor_met_pgto OUT GVT_TIPO_CURSOR.CURSORTYPE,
  codigo_erro       OUT NUMBER,
  mensagem           OUT VARCHAR2)
IS
    l_dummy VARCHAR2(1);
BEGIN

    SELECT 1 into l_dummy
    FROM GVT_DACC_GERENCIA_MET_PGTO
    WHERE EXTERNAL_ID = v_EXTERNAL_ID
    AND PAY_METHOD IN (2,3)
    AND rownum < 2;

    open cursor_met_pgto for
    SELECT *
    FROM GVT_DACC_GERENCIA_MET_PGTO
    WHERE EXTERNAL_ID = v_EXTERNAL_ID
    AND PAY_METHOD IN (2,3);


codigo_erro := 0;
mensagem    := NULL;

EXCEPTION

WHEN NO_DATA_FOUND THEN
/*Retorna MENSAGEM de CLIENTE NÃO ENCONTRADO*/
    codigo_erro := -12;
    mensagem    := 'CLIENTE NÃO ENCONTRADO';
WHEN OTHERS THEN

/*Retorna MENSAGEM de ERRO*/
    codigo_erro := -13;
    mensagem    := 'ERRO NA BUSCA DO CLIENTE ->' || TO_CHAR (SQLCODE) || '-' || SQLERRM;

END;


select * from GVT_DACC_GERENCIA_MET_PGTO order by DT_CADASTRO desc

select PAY_METHOD from GVT_DACC_GERENCIA_MET_PGTO where external_id = '999990000515'

select PAY_METHOD from GVT_DACC_GERENCIA_MET_PGTO where external_id in ('999990000515','999988260505','899996246745')

select M.EXTERNAL_ID, DECODE(PY.PAY_METHOD, 1, 'FATURA', 2, 'CARTAO', 3, 'DEBITO', PY.PAY_METHOD) "PAY_METHOD"
  from payment_profile py,
       customer_id_acct_map m
 where Py.ACCOUNT_NO = M.ACCOUNT_NO
   and M.EXTERNAL_ID in ('999990000515','999988260505','899996246745')
   
   and m.
   
 where account_no in (select account_no from customer_id_acct_map where external_id in ('999990000515','999988260505','899996246745'))

select * from customer_id_acct_map where external_id in ('999990000515','999988260505','899996246745')

select * from payment_trans where account_no in (10287165,2816752)