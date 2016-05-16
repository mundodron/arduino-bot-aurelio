 select to_char(s2.x_acct_id_num) CLIENTE,
to_char(s3.x_acct_id_num)AGREGADORA,
to_char(s.x_acct_id_num) COBRANÇA, 
     s.master_ou_id MASTER_OU_ID, s.par_ou_id PAR_OU_ID, s.row_id ROW_ID, 
     s2.x_acct_billable_status CLIENTE, s3.x_acct_billable_status AGREG, s.x_acct_billable_status COB
from s_org_ext s,
     s_org_ext s2,
     s_org_ext s3
-- where s.x_acct_id_num in ('999982152279')
where s.master_ou_id = s2.row_id
and s.par_ou_id = s3.row_id;



