select * from bill_invoice where account_no = 7563523 and bill_ref_no = 178753769

select * from bill_invoice_detail where bill_ref_no = 178753769 and tracking_id = 129937608 

       null    "VENCIMENTO_FATURA_PAGA_ATRASO",
       null    "DATA_PAGAMENTO_FATURA_ATRASADA",
       null    "VL_FATURA_EM_ATRASO",
       null    "VL_FATURA_ATRASO_SEM_ENCARGOS"


select bill.BILL_REF_NO "FATURA PAGA EM ATRASO",
       --bill.PREP_DATE "VENCIMENTO_FATURA_PAGA_ATRASO",
       --bill.PAYMENT_DUE_DATE "DATA_PAGAMENTO_FATURA_ATRASADA",
       sum(det.amount + det.federal_tax)   "VL_FATURA_EM_ATRASO",
       sum(det.amount)    "VL_FATURA_ATRASO_SEM_ENCARGOS"
 from bill_invoice bill,
      bill_invoice_detail det 
  where BILL.BILL_REF_NO = DET.BILL_REF_NO
    and BILL.BILL_REF_RESETS = DET.BILL_REF_RESETS 
    and bill.bill_ref_no in (
select to_number(trim(substr(n.annotation,16,9))) as fatura_paga_em_atraso
  from nrc n
 where n.billing_account_no = 7563523
   and tracking_id = 129937608)
  group by BILL.BILL_REF_NO



select bill.BILL_REF_NO "FATURA PAGA EM ATRASO",
       bill.PREP_DATE "VENCIMENTO_FATURA_PAGA_ATRASO",
       bill.PAYMENT_DUE_DATE "DATA_PAGAMENTO_FATURA_ATRASADA"
 from bill_invoice bill,
      bill_invoice_detail det 
  where BILL.BILL_REF_NO = DET.BILL_REF_NO
    and BILL.BILL_REF_RESETS = DET.BILL_REF_RESETS 
    and bill.bill_ref_no in (
select to_number(trim(substr(n.annotation,16,9))) as fatura_paga_em_atraso
  from nrc n
 where n.billing_account_no = 7563523
   and tracking_id = 129937608)
   
  group by BILL.BILL_REF_NO
  
   02:14:16

