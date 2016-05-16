select d.description_text,b.account_no,s.*
from bill_invoice_Detail s
join bill_invoice b on b.bill_ref_no = s.bill_ref_no
join descriptions d on d.language_code = 2 and d.description_code = s.subtype_code
where b.bill_Ref_no in(282875286,283502801)
and d.description_text like 'Taxa%';

-- 283502801   ERRO
-- 282875286 cenário igual porém certo

select * from all_tables where table_name like '%EIF%'

select * from GVT_PRODUCTS_SUMMARY_EIF where component_id in (29904,23297)

select * from GVT_PRODUCTS_SUMMARY_EIF where display_name like '%Taxa%'

select * from GVT_TMP_EIF_RESUMIDO where bill_Ref_no in(282875286,283502801)

select no_bill, remark from cmf where account_no in (10394380,10433028)

select * from gvt_log_cmf where account_no = 9126292

select account_no from customer_id_acct_map where external_id in ('899999626707','899997760911','899997179769','899998454966','899996922298')

select * from CONTRACT_ASSIGNMENTS_HQ where account_no in (select account_no from customer_id_acct_map where external_id in ('999979824572','999979664011','999981126814','999979721238','999982055320','999990699391','999983146445','777777744388'))

select * from customer_id_acct_map where external_id in ('999979824572','999979664011','999981126814','999979721238','999982055320','999990699391','999983146445','777777744388')