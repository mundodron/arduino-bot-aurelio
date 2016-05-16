select * from customer_id_acct_map where external_id = '999983860125'

select * from bmf where account_no = 4227115 and bill_ref_no = 99512390;

select bi.* from bill_invoice  bi where bi.account_no = 4227115 and bi.bill_ref_no = 99512390;

 SELECT PL.BILL_REF_NO FATURA,
        NVL((TOTAL_DUE / 100),0) VALOR_PAGO,
        CASE WHEN TIPO  = '0001' THEN 'PAGAMENTO BANCO'   
             WHEN TIPO  = '0520' THEN 'PAGAMENTO ELETRONICO' 
        END TIPO_PAGAMENTO, 
        TO_CHAR(TRUNC(DT_PGTO),'DD/MM/YYYY') DATA_PAGAMENTO, 
        TO_CHAR(DT_PGTO,'HH24:MI:SS') HORA_PAGAMENTO, 
        TO_CHAR(TRUNC(PAYMENT_DUE_DATE),'DD/MM/YYYY') DATA_VENCIMENTO 
 FROM   GVT_PAGAMENTOS_LOTERICA PL, BILL_INVOICE BI 
 WHERE  EXTERNAL_ID = '999983860125'
 AND PL.BILL_REF_NO = BI.BILL_REF_NO
 
 
select * from bmf where bmf_trans_type = 90 and trunc (post_date) = to_date('06/12/2011', 'DD/MM/YYYY') 

-- update gvt_rajadas R set R.account_no = (select account_no from customer_id_acct_map where external_id = R.EXTERNAL_ID)

select B.*
  from gvt_rajadas R,
       bmf B
 where R.ACCOUNT_NO = B.ACCOUNT_NO
   and R.BILL_REF_NO = B.ORIG_BILL_REF_NO
   and B.BMF_TRANS_TYPE = 90
   and trunc(B.POST_DATE) = to_date('06/12/2011', 'DD/MM/YYYY') 
   
   
select R.EXTERNAL_ID, C.BILL_REF_NO, C.PREP_DATE BAIXA, B.CHG_DATE ESTORNO, B.TRANS_AMOUNT, R.VALOR, B.TRACKING_ID
  from gvt_rajadas R,
       bmf B,
       bill_invoice C
 where R.ACCOUNT_NO = B.ACCOUNT_NO
   and R.BILL_REF_NO = B.ORIG_BILL_REF_NO
   and B.ACCOUNT_NO = C.ACCOUNT_NO
   and B.BILL_REF_NO = C.BILL_REF_NO
   and B.BMF_TRANS_TYPE = 90
   and trunc(B.POST_DATE) = to_date('06/12/2011', 'DD/MM/YYYY')
   and C.PREP_DATE < B.CHG_DATE
   and C.account_no = 4227115
   

select R.EXTERNAL_ID, C.BILL_REF_NO, C.PREP_DATE BAIXA, B.CHG_DATE ESTORNO, B.TRANS_AMOUNT, R.VALOR, D.AMOUNT
  from gvt_rajadas R,
       bmf B,
       bill_invoice C,
       bmf_distribution D
 where R.ACCOUNT_NO = B.ACCOUNT_NO
   and R.BILL_REF_NO = B.ORIG_BILL_REF_NO
   and B.ACCOUNT_NO = C.ACCOUNT_NO
   and B.BILL_REF_NO = C.BILL_REF_NO
   and B.ACCOUNT_NO = D.ACCOUNT_NO
   --and R.BILL_REF_NO = D.BILL_REF_NO
   and D.BILL_REF_NO <> 0
   and B.TRACKING_ID = D.BMF_TRACKING_ID
   and B.BMF_TRANS_TYPE = 90
   and trunc(B.POST_DATE) = to_date('06/12/2011', 'DD/MM/YYYY')
   and C.PREP_DATE < B.CHG_DATE
   and C.account_no = 4227115
      
   select * from bmf_distribution where account_no = 4227115 and bill_ref_no = 99512390 and bmf_TRACKING_ID = 64350158
   

 


 
 
 
 