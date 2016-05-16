 msg_id,
 msg_id2,
 msg_id_serv,
 account_no,
 subscr_no,
 external_id,
 element_id,
 component_id,
 JURISDICTION,
 TYPE_ID_USG,
 primary_units,
 raw_units_rounded,
 rated_units, 
 amount,
 amount_reduction,
 AMOUNT_REDUCTION_ID,
 ciclo_faturamento,
 BILL_REF_NO
  
  SELECT   
           MAP.ACCOUNT_NO
    FROM   gvt_fatura_minima f,
           gvt_campo_outras o,
           gvt_classificacao_item i,
           gvt_cobilling_prod_fat g,
           bill_invoice b,
           customer_id_acct_map map
   WHERE   MAP.ACCOUNT_NO = 2601204
           AND MAP.ACCOUNT_NO = B.ACCOUNT_NO
           AND MAP.INACTIVE_DATE is null
           AND MAP.EXTERNAL_ID_TYPE =1
           --AND B.BILL_PERIOD = 'M05'
           --AND B.PREP_DATE > sysdate - 5
           AND B.PREP_ERROR_CODE is null
           AND B.PREP_STATUS = 4
           --AND B.PREP_DATE in (select max(BILL.PREP_DATE) from bill_invoice bill where bill.account_no = B.ACCOUNT_NO and BILL.PREP_STATUS =1)
           AND EXISTS (SELECT 1 FROM cmf WHERE CMF.ACCOUNT_NO = MAP.ACCOUNT_NO and CMF.ACCOUNT_CATEGORY in (10,11))
           