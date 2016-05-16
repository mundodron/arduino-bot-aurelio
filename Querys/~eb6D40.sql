    INSERT INTO ARBORGVT_BILLING.GVT_AVULSO_FATURACD (account_no, bill_ref_no) 
         select account_no, bill_ref_no from bill_invoice where account_no = 8561141 and bill_ref_no in (225339503,231924505,238526355);
    commit;
