select * from bill_invoice_detail where bill_ref_no = 179481950 and subtype_code in (11778,11774)

select * from cmf_balance where bill_ref_no = 179481950

select CMF.ACCOUNT_CATEGORY from cmf where account_no = 2833125


select * from customer_id_acct_map where account_no = 2833125

select * from CUSTOMER_ID_EQUIP_MAP where SUBSCR_NO in (5893910,5893911)

select * from PRODUCT_LINES

select * from DISCOUNT_DEFINITIONS  

select * from GVT_PRODUCT_VELOCITY where END_DT is not null and END_DT > (trunc(sysdate) < 40)

delete GVT_PRODUCT_VELOCITY where  TRACKING_ID in (24184328, 24184330) and END_DT is not null;

select * from cmf_balance where bill_ref_no in (172537880,176054201,179718961,183457875)

2833125
172537880


select * from account_category_values where account_category in (select account_category from cmf where account_no = 2833125) and language_code = 2
