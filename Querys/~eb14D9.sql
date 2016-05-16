select N.BILL_REF_NO  "FATURA_PAGA_ATRASO",
       n.PPDD_DATE    "VENCIMENTO_FATURA_PAGA_ATRASO",
       n.CLOSED_DATE  "DATA_PAGAMENTO_FATURA_ATRASADA",
       n.TOTAL_DUE    "VL_FATURA_EM_ATRASO"
  from CMF_BALANCE n where n.bill_ref_no in (
 SELECT   to_number(trim(substr(annotation,16,9))) as fatura_paga_em_atraso
    FROM   nrc, nrc_key nk
   WHERE   nk.tracking_id = nrc.tracking_id
     AND   nk.tracking_id_serv = nrc.tracking_id_serv
     AND   nrc.billing_account_no = 1916465 -- IN (SELECT   account_no
                                  --       FROM   g0023421sql.GVT_REL_ENCARGOS
                                  --     WHERE   ROWNUM < 3000)
     --AND nk.bill_ref_no = 0
     AND nrc.type_id_nrc IN (12500, 12501)
     AND nrc.no_bill = 0);
     
     
     