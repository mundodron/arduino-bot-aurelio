set echo off;
set pagesize 100000 ;
spool C:\DPtt.txt;

DECLARE
AUX_GLOBAL_NAME     VARCHAR(100);
AUX_CICLO           VARCHAR(10) := 'M28';
V_PATH              VARCHAR2 (100) := 'BILLING_FAT_LOG'; -- Diretorio onde sera gravado o arquivo ex: (BILLING_FAT_LOG) /app/GVT_DEV2/c2/billing/faturamento/log
V_FILENAME          VARCHAR2(50);
V_FILE              UTL_FILE.FILE_TYPE;

CURSOR FATURA IS
SELECT   MAP.EXTERNAL_ID,
         MAP.ACCOUNT_NO,
           B.BILL_PERIOD,
           C.BILL_STATE,
           d.element_id,
           d.bill_ref_no,
           eq.external_id "EQUIP",
           d.type_code,
           d.subtype_code,
           (select tira_acento(description_text) from descriptions dt where dt.description_code = d.description_code and language_code = 2) "PRODUTO",
           ((d.amount + d.federal_tax))/100 valor,
           ((d.amount + d.federal_tax + d.discount))/100 valor_liq,
           DECODE(PY.PAY_METHOD, 1, 'FATURA', 2, 'CARTAO', 3, 'DEBITO', PY.PAY_METHOD) "PAY_METHOD",
           B.FROM_DATE,
           dateadd('dd',-1,b.to_date) "TO_DATE",
           PREP_DATE,
           --d.tax_rate,
           DECODE(LENGTH(D.UNITS),6,D.UNITS,NULL) "SAFRA",
           (d.discount)/100 "DISCOUNT_NVL",
           (select tira_acento(description_text) from descriptions dt where dt.description_code = D.DISCOUNT_ID and language_code = 2) "DISCOUNT"
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
           AND B.BILL_PERIOD = AUX_CICLO
           AND B.PREP_DATE > sysdate - 15
           AND B.PREP_STATUS = 4 --> 4 proforma 1 production
           AND B.PREP_ERROR_CODE is null
           AND EQ.SUBSCR_NO = D.SUBSCR_NO;
           
    BEGIN
    select trim(GLOBAL_NAME) into AUX_GLOBAL_NAME from GLOBAL_NAME;
    V_FILENAME := 'REL_PROFORMA_FULL_' || AUX_CICLO || '_' ||to_char( sysdate ,'yyyymmdd_hh24miss' ) || '_' || AUX_GLOBAL_NAME ||'.csv';
    dbms_output.put_line('Inicio - ' || AUX_GLOBAL_NAME || ' : ' || to_char( sysdate ,'dd/mm/yyyy - hh24:mi:ss'));
    dbms_output.put_line('EXTERNAL_ID' ||' ; '|| 'ACCOUNT_NO' ||' ; '|| 'BILL_PERIOD' ||' ; '|| 'BILL_STATE' ||' ; '|| 'ELEMENT_ID' ||' ; '|| 'BILL_REF_NO' ||' ; '|| 'EQUIP' ||' ; '|| 'TYPE_CODE' ||' ; '|| 'SUBTYPE_CODE' ||' ; '|| 'PRODUTO' ||' ; '|| 'VALOR' ||' ; '|| 'VALOR_LIQ' ||' ; '|| 'PAY_METHOD' ||' ; '|| 'FROM_DATE' ||' ; '|| 'TO_DATE' ||' ; '|| 'PREP_DATE' ||' ; '|| 'SAFRA' ||' ; '|| 'DISCOUNT NVL' ||' ; '|| 'DISCOUNT');
    
        FOR C1 IN FATURA LOOP
            BEGIN
                dbms_output.put_line(C1.EXTERNAL_ID ||' ; '|| C1.ACCOUNT_NO ||' ; '|| C1.BILL_PERIOD ||' ; '|| C1.BILL_STATE ||' ; '|| C1.ELEMENT_ID ||' ; '|| C1.BILL_REF_NO ||' ; '|| C1.EQUIP ||' ; '|| C1.TYPE_CODE ||' ; '|| C1.SUBTYPE_CODE ||' ; '|| C1.PRODUTO ||' ; '|| C1.VALOR ||' ; '|| C1.VALOR_LIQ ||' ; '|| C1.PAY_METHOD ||' ; '|| C1.FROM_DATE ||' ; '|| C1.TO_DATE ||' ; '|| C1.PREP_DATE ||' ; '|| C1.SAFRA ||' ; '|| C1.DISCOUNT_NVL ||' ; '|| C1.DISCOUNT);
            END;
        END LOOP;

    
    dbms_output.put_line('_________________________________________________________________');
    dbms_output.put_line('*** FIM - '||dbms_reputil.global_name()||' - '||to_char(sysdate, 'dd/mm/yyyy hh24:mi:ss'));
END;
/
spool off;