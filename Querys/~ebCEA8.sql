
INSERT INTO ARBORGVT_BILLING.GVT_AVULSO_FATURACD (account_no, bill_ref_no) 
select account_no, bill_ref_no from bill_invoice where account_no = 8561141 and bill_ref_no in (225339503,231924505,238526355);

INSERT INTO ARBORGVT_BILLING.GVT_AVULSO_FATURACD (account_no, bill_ref_no) 
select account_no, bill_ref_no from bill_invoice where account_no = 8680090 and bill_ref_no in (225338358,231923546,238525306);

INSERT INTO ARBORGVT_BILLING.GVT_AVULSO_FATURACD (account_no, bill_ref_no) 
select account_no, bill_ref_no from bill_invoice where account_no = 2348130 and bill_ref_no in (225329709,225335946,231915308,231916349,238518508,238522145);

commit;