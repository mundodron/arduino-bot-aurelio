 select S.EXTERNAL_ID, S.BILL_REF_NO, se.x_acct_id_num
  from GVT_ERRO_SANTANDER S,
       cmf_balance b,
       s_org_ext se,
       s_org_ext s2,
       s_org_ext s3
 where S.account_no is not null
   and S.ACCOUNT_NO = B.ACCOUNT_NO
   and B.BILL_REF_NO = 0
   and S.TELEFONE = 'ND'
   and se.master_ou_id = s2.row_id
   and se.par_ou_id = s3.row_id
   and se.x_acct_id_num = S.EXTERNAL_ID  
   
   
   select to_char(s2.x_acct_id_num) CLIENTE,
to_char(s.x_acct_id_num) COBRANÇA
from s_org_ext s,
     s_org_ext s2,
     s_org_ext s3
where s.master_ou_id = s2.row_id
and s.par_ou_id = s3.row_id