select bill_ref_no from bill_invoice b where B.PREP_STATUS = 4 and prep_date > sysdate -1 and rownum < 100