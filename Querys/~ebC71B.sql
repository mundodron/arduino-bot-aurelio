SELECT   distinct(MAP.EXTERNAL_ID),
         MAP.ACCOUNT_NO,
           d.BILL_REF_NO,
           D.SUBSCR_NO,
           D.COMPONENT_ID,
           B.PREP_DATE,
           B.PREP_STATUS,
           B.BILL_PERIOD  
    FROM   bill_invoice b,
           bill_invoice_detail d,
           cmf c,
           customer_id_acct_map map,
           customer_id_equip_map eq
   WHERE   d.bill_ref_resets = b.bill_ref_resets
           AND d.type_code IN (2)
           AND MAP.ACCOUNT_NO = B.ACCOUNT_NO
           AND MAP.INACTIVE_DATE is null
           AND C.ACCOUNT_NO = MAP.ACCOUNT_NO
           AND C.ACCOUNT_CATEGORY in (10,11) -- Retail
           AND MAP.EXTERNAL_ID_TYPE = 1
           AND EQ.SUBSCR_NO = D.SUBSCR_NO
           AND EQ.SUBSCR_NO_RESETS = D.BILL_REF_RESETS
           AND EQ.INACTIVE_DATE is null
           AND EQ.IS_CURRENT = 1
           AND EQ.EXTERNAL_ID_TYPE in (6,7)
           AND MAP.IS_CURRENT = 1
           AND B.BILL_REF_NO = D.BILL_REF_NO
           AND B.BILL_REF_RESETS = D.BILL_REF_RESETS
           --AND B.BILL_PERIOD = AUX_CICLO
           --AND B.PREP_DATE > sysdate - 15
           --AND B.PREP_STATUS = 4 --> 4 proforma 1 production
           AND B.PREP_ERROR_CODE is null
           -- AND B.BILL_REF_NO = 202065847
           -- AND MAP.EXTERNAL_ID in ('899999360809')
           AND MAP.ACCOUNT_NO = 8891739
           -- AND D.COMPONENT_ID in (30367,30368,30369,30370) -- LAVOISIER
           AND D.COMPONENT_ID in (31072,31073,31074,31075,31076,31077,31078,31079,31080,31081,31082,31083,31084) -- Touche
           AND D.FROM_DATE = B.FROM_DATE;

select CDV.DISPLAY_VALUE, p.*
from product p, component_definition_values cdv
where p.component_id = cdv.component_id
and cdv.language_code = 2
and P.PRODUCT_INACTIVE_DT is null      
and p.parent_account_no = 8891739


SELECT *
FROM product p
where p.component_id = 31080
and P.PRODUCT_INACTIVE_DT is null
and not exists(select 1
                from product p1
                where P1.PARENT_ACCOUNT_NO = P.PARENT_ACCOUNT_NO
                and P1.PRODUCT_INACTIVE_DT is null
                and P1.COMPONENT_ID = 31075
                )
                
                
SELECT * FROM g0023421sql.GVT_VAL_PLANO where NOME_PLANO = 'TOUCHE'