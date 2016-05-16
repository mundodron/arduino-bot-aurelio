--concatenado
select*
from g0023421sql.tmp_eve_relatorio_dacc t, customer_id_acct_map eiam
where eiam.account_no = t.account_no
and eiam.external_id_type = 1


select * from customer_id_acct_map where external_id = '999986621193'-- '999986553878'

select * from bmf where account_no = 3451729

select * from cmf where account_no = 3451729

