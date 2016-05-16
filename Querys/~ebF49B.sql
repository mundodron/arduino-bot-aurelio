 delete from gvt_rajadas
 
 update gvt_rajadas R set R.account_no = (select account_no from customer_id_acct_map where external_id = R.EXTERNAL_ID)
 
 
 select R.EXTERNAL_ID, C.BILL_REF_NO, C.PREP_DATE BAIXA, B.CHG_DATE ESTORNO, B.TRANS_AMOUNT, R.VALOR, D.GL_AMOUNT
  from gvt_rajadas R,
       bmf B,
       bill_invoice C,
       bmf_distribution D
 where R.ACCOUNT_NO = B.ACCOUNT_NO
   and R.BILL_REF_NO = B.ORIG_BILL_REF_NO
   and B.ACCOUNT_NO = C.ACCOUNT_NO
   and B.BILL_REF_NO = C.BILL_REF_NO
   and B.ACCOUNT_NO = D.ACCOUNT_NO
   and R.BILL_REF_NO = D.BILL_REF_NO
   and B.BMF_TRANS_TYPE = 90
   and trunc(B.POST_DATE) = to_date('06/12/2011', 'DD/MM/YYYY')
   and C.PREP_DATE < B.CHG_DATE
   
   and C.account_no = 4227115