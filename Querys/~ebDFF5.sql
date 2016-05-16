drop table Bad_do_contenda;

create table Bad_do_contenda as 
SELECT   MAP.EXTERNAL_ID,
         MAP.ACCOUNT_NO,
           B.BILL_PERIOD,
           C.BILL_STATE,
           d.bill_ref_no,
           sum((d.amount + d.federal_tax))valor_PF,
           sum((d.amount + d.federal_tax))valor,
           sum((d.amount + d.federal_tax + d.discount)) valor_liq_PF,
           sum((d.amount + d.federal_tax + d.discount)) valor_liq,
           sum(d.discount) "DISCOUNT_NVL_PF",
           sum(d.discount) "DISCOUNT_NVL"
    FROM   bill_invoice b,
           bill_invoice_detail d,
           cmf c,
           customer_id_acct_map map,
           customer_id_equip_map eq
   WHERE   d.bill_ref_resets = b.bill_ref_resets
           AND d.type_code IN (2, 3, 7)
           AND EQ.INACTIVE_DATE is null
           and EQ.EXTERNAL_ID_TYPE = 1
           AND D.SUBSCR_NO = EQ.SUBSCR_NO
           AND D.SUBSCR_NO_RESETS = EQ.SUBSCR_NO_RESETS
           AND MAP.ACCOUNT_NO = B.ACCOUNT_NO
           AND MAP.INACTIVE_DATE is null
           AND C.ACCOUNT_NO = MAP.ACCOUNT_NO
--           AND C.ACCOUNT_CATEGORY in (10,11)
           AND MAP.EXTERNAL_ID_TYPE = 1
           AND B.BILL_REF_NO = D.BILL_REF_NO
           AND B.BILL_REF_RESETS = D.BILL_REF_RESETS
           AND B.BILL_PERIOD = 'M28'
           AND B.PREP_DATE > sysdate - 15
           AND B.PREP_STATUS = 1 --> 4 proforma 1 production
           AND B.PREP_ERROR_CODE is null
           AND EQ.SUBSCR_NO = D.SUBSCR_NO
           and exists (select 1 from g0009075sql.ativacao_mass_CC where bill_period = 'M28' and external_id = MAP.EXTERNAL_ID)
           --and MAP.EXTERNAL_ID = 999986309882
           group by (MAP.EXTERNAL_ID,
                     MAP.ACCOUNT_NO,
                     B.BILL_PERIOD,
                     C.BILL_STATE,
                     d.bill_ref_no);
                     
grant all on Bad_do_contenda to public
          
update Bad_do_contenda Bad 
set (VALOR, VALOR_LIQ, DISCOUNT_NVL) = (
    SELECT sum((d.amount + d.federal_tax))valor,
           sum((d.amount + d.federal_tax + d.discount)) valor_liq,
           sum(d.discount) "DISCOUNT_NVL"
    FROM   bill_invoice b,
           bill_invoice_detail d,
           cmf c,
           customer_id_acct_map map,
           customer_id_equip_map eq
   WHERE   d.bill_ref_resets = b.bill_ref_resets
           AND d.type_code IN (2, 3, 7)
           AND EQ.INACTIVE_DATE is null
           and EQ.EXTERNAL_ID_TYPE = 1
           AND D.SUBSCR_NO = EQ.SUBSCR_NO
           AND D.SUBSCR_NO_RESETS = EQ.SUBSCR_NO_RESETS
           AND MAP.ACCOUNT_NO = B.ACCOUNT_NO
           AND MAP.INACTIVE_DATE is null
           AND C.ACCOUNT_NO = MAP.ACCOUNT_NO
--           AND C.ACCOUNT_CATEGORY in (10,11)
           AND MAP.EXTERNAL_ID_TYPE = 1
           AND B.BILL_REF_NO = D.BILL_REF_NO
           AND B.BILL_REF_RESETS = D.BILL_REF_RESETS
           AND B.BILL_PERIOD = 'M28'
           AND B.PREP_DATE > sysdate - 15
           AND B.PREP_STATUS = 4 --> 4 proforma 1 production
           AND B.PREP_ERROR_CODE is null
           AND EQ.SUBSCR_NO = D.SUBSCR_NO
           and exists (select 1 from g0009075sql.ativacao_mass_CC where bill_period = 'M28' and external_id = MAP.EXTERNAL_ID)
--           and MAP.EXTERNAL_ID = 999986309882
           group by (MAP.EXTERNAL_ID,
                     MAP.ACCOUNT_NO,
                     B.BILL_PERIOD,
                     C.BILL_STATE,
                     d.bill_ref_no)
   where bad.account_no = map.account_no and bad.bill_ref_no = 
   
   
   select * from Bad_do_contenda