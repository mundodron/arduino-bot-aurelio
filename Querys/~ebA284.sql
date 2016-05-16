--drop table gvt_semprelocal;


grant all on gvt_semprelocal to public

select * from gvt_semprelocal where component_id = 30491

create table gvt_semprelocal as
SELECT   bi.msg_id,
         bi.msg_id2,
         bi.msg_id_serv,
         bi.account_no,
         bi.subscr_no,
         map.external_id,
         d.element_id,
         d.component_id,
         d.JURISDICTION,
         bi.TYPE_ID_USG,
         d.primary_units,
         d.raw_units_rounded,
         d.rated_units,
         d.amount_reduction,
         d.AMOUNT_REDUCTION_ID,
         BILL.BILL_PERIOD,
         bi.BILL_REF_NO
  FROM   cdr_billed BI,
         cdr_data D,
         customer_id_acct_map MAP,
         bill_invoice BILL
 WHERE       Bi.MSG_ID = D.MSG_ID
         AND Bi.MSG_ID2 = D.MSG_ID2
         AND Bi.MSG_ID_SERV = D.MSG_ID_SERV
         AND Bi.TYPE_ID_USG IN (288, 274, 276)
         AND BI.ACCOUNT_NO = MAP.ACCOUNT_NO
         AND map.ACCOUNT_NO = 2601204
         AND D.component_id = 30491
         AND D.ELEMENT_ID in (10333)
         AND MAP.INACTIVE_DATE IS NULL
         AND MAP.EXTERNAL_ID_TYPE = 1
         AND BI.BILL_REF_NO = BILL.BILL_REF_NO
         AND BILL.PREP_ERROR_CODE IS NULL
         --and BILL.PREP_STATUS = 4
         AND BILL.ACCOUNT_NO = MAP.ACCOUNT_NO
         AND BILL.BILL_REF_NO IN
                  (SELECT   MAX (bill_ref_no)
                     FROM   bill_invoice
                    WHERE   account_no = MAP.ACCOUNT_NO AND PREP_STATUS = 1)
         -- AND BILL.PREP_DATE IN (SELECT   MAX (BI.PREP_DATE) FROM   bill_invoice bi WHERE   bi.account_no = BILL.ACCOUNT_NO AND bi.PREP_STATUS = 1)
         --AND BILL.BILL_PERIOD = 'M10'
         --AND BILL.PREP_DATE > sysdate - 15
         AND EXISTS
               (SELECT   1
                  FROM   cmf
                 WHERE   CMF.ACCOUNT_NO = MAP.ACCOUNT_NO
                         AND CMF.ACCOUNT_CATEGORY IN (10, 11));




--select max(bill_ref_no) from bill_invoice where account_no = 2601204 and PREP_STATUS = 1

--select * from bill_invoice where account_no = 2601204

