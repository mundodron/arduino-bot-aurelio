select S.FULL_SIN_SEQ FULL_SIN_SEQ_ssn,
      S.BILL_REF_NO bill_ref_no_ssn,
      S.OPEN_ITEM_ID OPEN_ITEM_ID_ssn,
      C.BILL_REF_NO bill_ref_no_cbd,
      C.OPEN_ITEM_ID  OPEN_ITEM_ID_cbd ,
      c.external_id
from sin_seq_no s, 
    cmf_balance_detail c
where C.BILL_REF_NO = S.BILL_REF_NO (+)
and c.bill_ref_no in (103980702)
and C.OPEN_ITEM_ID not in (2,3)
and S.OPEN_ITEM_ID(+) = decode(C.OPEN_ITEM_ID,1,0,C.OPEN_ITEM_ID);