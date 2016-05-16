select * from customer_id_acct_map where external_id = '9999881269690'



CREATE OR REPLACE PROCEDURE ARBORGVT_BILLING.GVT_LCgetInfoPgtoEletronico (p_recordset OUT SYS_REFCURSOR,
                                        p_external_id IN VARCHAR2) AS 
BEGIN 
OPEN p_recordset FOR


 SELECT PL.BILL_REF_NO FATURA,
        NVL((TOTAL_DUE / 100),0) VALOR_PAGO,
        CASE WHEN TIPO  = '0001' THEN 'PAGAMENTO BANCO'   
             WHEN TIPO  = '0520' THEN 'PAGAMENTO ELETRONICO' 
        END TIPO_PAGAMENTO, 
        TO_CHAR(TRUNC(DT_PGTO),'DD/MM/YYYY') DATA_PAGAMENTO, 
        TO_CHAR(DT_PGTO,'HH24:MI:SS') HORA_PAGAMENTO, 
        TO_CHAR(TRUNC(PAYMENT_DUE_DATE),'DD/MM/YYYY') DATA_VENCIMENTO 
 FROM   GVT_PAGAMENTOS_LOTERICA PL,
        BILL_INVOICE BI 
 WHERE  EXTERNAL_ID = p_external_id
 AND PL.BILL_REF_NO = BI.BILL_REF_NO 
 ORDER BY DT_PGTO, FATURA;


select * from FILE_STATUS where file_id = 3787476

select * from all_tables where table_name like '%FILE_STATUS%' 


 select * from payment_trans where trans_status = 0