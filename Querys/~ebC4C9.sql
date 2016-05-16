select BILL.BILL_REF_NO,
       sum(det.amount + det.federal_tax),
       sum(det.amount)
 from bill_invoice bill,
      bill_invoice_detail det 
  where BILL.BILL_REF_NO = DET.BILL_REF_NO
    and BILL.BILL_REF_RESETS = DET.BILL_REF_RESETS
    --and DET.SUBTYPE_CODE in (12500,12501)
    and bill.bill_ref_no in (            
            select to_number(trim(substr(n.annotation,16,9))) as fatura_paga_em_atraso
              from nrc n
             -- where n.billing_account_no = 7563523
               -- and n.tracking_id = 129937608 
             where n.billing_account_no in (select account_no from g0023421sql.GVT_REL_ENCARGOS)
                and n.tracking_id = DET.TRACKING_ID
                and N.TYPE_ID_NRC in (12500,12501)
                and N.NO_BILL = 0
                and N.EFFECTIVE_DATE > trunc(sysdate-90)
             )
  group by BILL.BILL_REF_NO