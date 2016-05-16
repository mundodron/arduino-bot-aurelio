    INSERT INTO ARBORGVT_BILLING.GVT_AVULSO_FATURACD (account_no, bill_ref_no) 
         select account_no, bill_ref_no from bill_invoice where account_no = 3736947 and bill_ref_no in (186934153,201046105,208356306,207393305);
    commit;

select * from GVT_AVULSO_FATURACD

select * from bill_invoice