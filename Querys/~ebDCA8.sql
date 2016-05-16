select d.description_text,b.account_no,s.*
from bill_invoice_Detail s
join bill_invoice b on b.bill_ref_no = s.bill_ref_no
join descriptions d on d.language_code = 2 and d.description_code = s.subtype_code
where b.bill_Ref_no in(282875286,283502801)
and d.description_text like 'Taxa%';



select * from nrc where tracking_id in (179486971,178495424,178495892,179486980)

select * from nrc_trans_descr


-- 283502801   ERRO
-- 282875286 cenário igual porém certo