select * from GVT_FEBRABAN_ACCOUNTS
where account_no in
(select account_no ---b.file_name, b.prep_date, b.*
from bill_invoice b
where bill_ref_no in ('0103156150','0103157717','0103156573')
and prep_date > sysdate-45)
