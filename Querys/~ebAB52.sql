select c.account_category, V.DISPLAY_VALUE, count(*)
from GVT_CONTA_INTERNET g, cmf c, ACCOUNT_CATEGORY_VALUES v
where data_processamento >= to_date('20130622','yyyymmdd')
and bill_ref_no is null
and external_id is null
and g.account_no = c.account_no
and V.ACCOUNT_CATEGORY = C.ACCOUNT_CATEGORY
and V.LANGUAGE_CODE = 2
group by c.account_category, V.DISPLAY_VALUE