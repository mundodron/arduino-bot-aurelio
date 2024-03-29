SELECT  C.NO_BILL, 
        C.REMARK, 
        B.ACCOUNT_NO, -- C�DIGO DO CLIENTE
        C.BILL_LNAME, -- NOME DO CLIENTE
        B.BILL_REF_NO, -- CODIGO DA FATURA
        ACCT.EXTERNAL_ID  -- CONTA_COBRANCA
FROM 
       BILL_INVOICE        B, -- TABELA DE FATURAS
       CMF                 C -- TABELA DE CLIENTES (CADASTRO)
       CUSTOMER_ID_ACCT_MAP ACCT,  -- CONTA_COBRANCA
       GVT_FEBRABAN_ACCOUNTS  FBACT
WHERE b.prep_status = 1 -- PRODUCTION
AND b.prep_error_code is null    
 AND ACCT.EXTERNAL_ID_TYPE = 1
 AND ACCT.ACCOUNT_NO = B.ACCOUNT_NO
AND C.ACCOUNT_NO = B.account_no 
and b.bill_period = $BILL_PERIOD_CONTROL_M
and b.prep_date >= $PREP_DATE_CONTROL_M
and FBACT.ACCOUNT_NO = B.ACCOUNT_NO 
AND VERSION_FEED = 2 -- para vers�o 2 
AND NOT EXISTS (
SELECT 1 FROM
GVT_FBB_BILL_INVOICE fbb
WHERE FBB. BILL_REF_NO = B.BILL_REF_NO 
AND FBB. BILL_REF_RESETS =  B.BILL_REF_RESETS
)
select * from gvt_fbb_bill_invoice where bill_ref_no in (114481737)

select * from gvt_fbb_bill_invoice where bill_ref_no in (114481737,114481921,114483944)

select * from gvt_febraban_bill_invoice where bill_ref_no in (114481737,114481921,114483944)


select * from gvt_febraban_bill_invoice where bill_ref_no in (0117701511,0117989167,0117213437,0117045386,0117044358,0117044161,0117043539,0118340712,114481921,114483944,116649941,116650149,116650223,116650372,116650737,116651631,116651518,116651424,116650927,116653327,116653143,116652523,116652219,116651826,116651743,116650737)
