
SELECT   MAP.EXTERNAL_ID,
           B.BILL_PERIOD,
           C.BILL_STATE,
           d.element_id,
           d.bill_ref_no,
           eq.external_id "EQUIP",
           d.type_code,
           d.subtype_code,
           (select description_text from descriptions dt where dt.description_code = d.description_code and language_code = 2) "PRODUTO",
           ((d.amount + d.federal_tax))/100 valor,
           ((d.amount + d.federal_tax + d.discount))/100 valor_liq,
           DECODE(PY.PAY_METHOD, 1, 'FATURA', 2, 'CARTAO', 3, 'DEBITO', PY.PAY_METHOD) "PAY_METHOD",
           B.FROM_DATE,
           B.TO_DATE,
           PREP_DATE,
           DECODE(LENGTH(D.UNITS),6,D.UNITS,NULL) "SAFRA",
           (d.discount)/100 "DISCOUNT NVL",
           (select description_text from descriptions dt where dt.description_code = D.DISCOUNT_ID and language_code = 2) "DISCOUNT"
    FROM   bill_invoice b,
           bill_invoice_detail d,
           cmf c,
           customer_id_acct_map map,
           customer_id_equip_map eq,
           payment_profile py
   WHERE   d.bill_ref_resets = b.bill_ref_resets
           AND d.type_code IN (2, 3, 7)
           AND EQ.INACTIVE_DATE is null
           and EQ.EXTERNAL_ID_TYPE = 1
           AND D.SUBSCR_NO = EQ.SUBSCR_NO
           AND D.SUBSCR_NO_RESETS = EQ.SUBSCR_NO_RESETS
           AND MAP.ACCOUNT_NO = B.ACCOUNT_NO
           AND MAP.INACTIVE_DATE is null
           AND C.ACCOUNT_NO = MAP.ACCOUNT_NO
           AND D.PROFILE_ID = PY.PROFILE_ID
           AND C.ACCOUNT_CATEGORY in (10,11)
           AND MAP.EXTERNAL_ID_TYPE = 1
           AND B.BILL_REF_NO = D.BILL_REF_NO
           AND B.BILL_REF_RESETS = D.BILL_REF_RESETS
           AND B.BILL_PERIOD = 'M28'
           AND B.PREP_DATE > sysdate - 15
           AND B.PREP_STATUS = 4 --> 4 proforma 1 production
           AND B.PREP_ERROR_CODE is null
           --AND MAP.EXTERNAL_ID = '999979865472'
           and B.BILL_REF_NO = 191013386
           AND EQ.SUBSCR_NO = D.SUBSCR_NO
           order by 6
           
           
                     select cm.*,EQ.EXTERNAL_ID,
                  (select tira_acento(dt.DISPLAY_VALUE) from COMPONENT_DEFINITION_VALUES dt where CM.COMPONENT_ID = DT.COMPONENT_ID and dt.language_code = 2) "COMPONENTE"
             from CMF_PACKAGE_COMPONENT cm, 
                  customer_id_equip_map eq
            where cm.parent_account_no = 7484736
              and cm.inactive_dt is null
              and EQ.INACTIVE_DATE is null
              and EQ.EXTERNAL_ID_TYPE <> 1
              and EQ.EXTERNAL_ID_TYPE in (6,7)
              and CM.PARENT_SUBSCR_NO = EQ.SUBSCR_NO
              and CM.PARENT_SUBSCR_NO_RESETS = EQ.SUBSCR_NO_RESETS

    
           
           --AND EQ.SUBSCR_NO_RESETS = D.SUBSCR_NO_RESETS order by 6