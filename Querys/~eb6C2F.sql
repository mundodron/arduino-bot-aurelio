 select x.chg_date, x.account_no, bill_ref_no, orig_bill_ref_no, trans_amount/100 trans_amount, x.bmf_trans_type
    , a.description_code description, description_text
    , x.tracking_id, orig_tracking_id, no_bill
from bmf x, BMF_TRANS_DESCR a, descriptions d
where x.account_no = 2459833
--and bmf.tracking_id = 41091680
--and bmf.bmf_trans_type = -315
 and x.orig_bill_ref_no = 83689003
 and x.bmf_trans_type = a.bmf_trans_type
 and a.description_code = d.description_code
 and language_code = 2