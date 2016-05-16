

SELECT conta,ACCOUNT_NO, BILL_REF_NO, state, EXTERNAL_ID, BILL_LNAME, BILL_PERIOD, CATEGORY, CLOSED_DATE, gerou_fat, NF, cb_valor, VALOR, global_name
 FROM (
SELECT   DISTINCT 
       CIAM.EXTERNAL_ID conta,
       c.account_no,
       bi.bill_ref_no,
       la.STATE,
       cb.open_item_id,
       cb.external_id,
       c.bill_lname,
       c.bill_period,
       acv.display_value category,
       CBAL.CLOSED_DATE,
       case 
            when (length(bi.bill_ref_no) = 8) then 
                    (select '00'||bill_ref_no||'-0' from bill_invoice bil, customer_care cc
                      where 
                      bil.bill_ref_no =bi.bill_ref_no
                      and bil.prep_status = 1
                      and substr(bil.file_name,-6) like '%F%'
                      and cc.numero_fatura = '00'||bil.bill_ref_no||'-0')         
            when (length(bi.bill_ref_no) = 9) then 
                    (select '0'||bill_ref_no||'-0' from bill_invoice bil, customer_care cc
                      where 
                      bil.bill_ref_no =bi.bill_ref_no
                      and bil.prep_status = 1
                      and substr(bil.file_name,-6) like '%F%'
                      and cc.numero_fatura = '0'||bil.bill_ref_no||'-0')   
                                                                               
       end gerou_fat,                                        
       --(nf.amount / 100) valor,
       (SELECT   full_sin_seq
          FROM   sin_seq_no SIN
         WHERE   SIN.bill_ref_no = cb.bill_ref_no
                 AND SIN.bill_ref_resets = cb.bill_ref_resets
                 AND cb.open_item_id =
                       DECODE (SIN.open_item_id, 0, 1, SIN.open_item_id)) nf,
       CB.GL_AMOUNT /100 cb_valor,                        
       (select amount from  GVT_BILL_INVOICE_NFST nf where nf.bill_ref_no = bi.bill_ref_no AND cb.open_item_id = DECODE (nf.open_item_id, 0, 1, nf.open_item_id)) /100 valor,
       (select count(1) from cmf_balance_detail cbd where cbd.bill_ref_no = cb.bill_ref_no and cbd.bill_ref_resets = cb.bill_ref_resets and cbd.new_charges <> 0 and CBD.OPEN_ITEM_ID not IN (2, 3,91, 92) ) CMF_BALANCE_DETAIL  ,
       (select count(1) from sin_seq_no sqn where sqn.bill_ref_no = cb.bill_ref_no and sqn.bill_ref_resets = cb.bill_ref_resets) SIN_SEQ,
       global_name     
FROM   cmf c,
       global_name,
       cmf_balance_detail cb,
       cmf_balance cbal,
       bill_invoice bi,
       account_category_values acv,
       service_address_assoc ass, 
       local_address la, 
       service s,
       customer_id_acct_map ciam,
       sin_seq_no sin
WHERE --c.bill_period = 'M02'
       c.account_type = 1
       and CIAM.ACCOUNT_NO = CB.ACCOUNT_NO
       and ciam.external_id_type = 1
       and CB.ACCOUNT_NO = S.PARENT_ACCOUNT_NO
       and S.PARENT_ACCOUNT_NO = ASS.ACCOUNT_NO
       and ass.account_no = BI.ACCOUNT_NO
       and cb.account_no = CBAL.ACCOUNT_NO
       and cb.bill_Ref_no = cbal.bill_ref_no
       and cb.BILL_REF_RESETS = CBAL.BILL_REF_RESETS
       and ASS.ADDRESS_ID = LA.ADDRESS_ID
       and ASS.SUBSCR_NO = S.SUBSCR_NO
       and (S.SERVICE_INACTIVE_DT is null or (S.SERVICE_INACTIVE_DT > trunc(bi.from_date)))
       and ASS.SUBSCR_NO_RESETS = S.SUBSCR_NO_RESETS        
       AND cb.bill_ref_no <> 0
       AND cb.bill_ref_no = bi.bill_ref_no(+)
       AND c.account_category = acv.account_category
       AND acv.language_code = 2
       AND cb.bill_ref_resets = bi.bill_ref_resets
--       AND bi.prep_date > SYSDATE - 90
--       and BI.BILL_REF_NO in(96781165)
       AND c.no_bill = 0
       AND c.account_no = cb.account_no
       AND cb.open_item_id NOT IN (2, 3,91, 92)
       and cb.bill_ref_no = sin.bill_ref_no (+)
       AND cb.bill_ref_resets = sin.bill_ref_resets(+)   
       and cb.new_charges <> 0
       AND cb.open_item_id = DECODE (sin.open_item_id(+), 0, 1, sin.open_item_id(+)))
WHERE CMF_BALANCE_DETAIL > SIN_SEQ