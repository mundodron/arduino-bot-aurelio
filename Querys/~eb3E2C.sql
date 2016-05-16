DECLARE
AUX_CICLO           VARCHAR(10);
AUX_COUNT           NUMBER := 0;

CURSOR C_FATURA IS -- C1
SELECT   distinct(MAP.EXTERNAL_ID),
         MAP.ACCOUNT_NO,
           d.BILL_REF_NO,
           D.SUBSCR_NO,
           D.COMPONENT_ID
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
           AND B.BILL_PERIOD = AUX_CICLO
           AND B.PREP_DATE > sysdate - 15
           AND B.PREP_STATUS = 4 --> 4 proforma 1 production
           AND B.PREP_ERROR_CODE is null
           --AND B.BILL_REF_NO = '207017124'
           -- AND MAP.EXTERNAL_ID in ('899999360809')
           --AND MAP.ACCOUNT_NO = 4922384
           AND D.COMPONENT_ID in (30367,30368,30369,30370);
           

 CURSOR C_BUSCA_DUPLICIDADE(bill_no number, subs_no number) is -- C2
           select pk.COMPONENT_ID, EQ.EXTERNAL_ID , VL.DISPLAY_VALUE, PK.FROM_DATE count(1) total
             from bill_invoice_detail pk,
                  customer_id_equip_map eq,
                  COMPONENT_DEFINITION_VALUES vl
            where pk.bill_ref_no = bill_no
              and EQ.SUBSCR_NO = subs_no
              and PK.SUBSCR_NO = EQ.SUBSCR_NO
              and PK.TYPE_CODE = 2
              and PK.SUBSCR_NO_RESETS = EQ.SUBSCR_NO_RESETS
              and EQ.INACTIVE_DATE is null
              and EQ.IS_CURRENT = 1
              and PK.PRORATE_CODE not in (1,2)
              and EQ.EXTERNAL_ID_TYPE <> 1
              and EQ.EXTERNAL_ID_TYPE in (6,7)
              and PK.COMPONENT_ID = vl.COMPONENT_ID
              and VL.LANGUAGE_CODE = 2
              and (pk.component_id in (SELECT to_number(COMPONENT_ID)FROM g0023421sql.GVT_VAL_PLANO where NOME_PLANO = 'LAVOISIER') or pk.component_id in (SELECT to_number(COMPONENT_ID)FROM g0023421sql.GVT_VAL_PLANO_DADOS))
              and EXISTS (SELECT 1 FROM CMF_PACKAGE_COMPONENT bd WHERE bd.COMPONENT_ID = pk.COMPONENT_ID and bd.PARENT_SUBSCR_NO = subs_no and bd.INACTIVE_DT is null)
            group by (pk.COMPONENT_ID,VL.DISPLAY_VALUE,EQ.EXTERNAL_ID, PK.FROM_DATE)
            having count(1) > 1;
begin

   Select bill_period into AUX_CICLO
     from bill_cycle where bill_period like 'M%' and prep_date = (Select max(prep_date) from bill_cycle where bill_period like 'M%' and prep_date <= sysdate);
   
   AUX_CICLO:= 'M10';
   
    dbms_output.put_line('_________________________________________________________________');
    dbms_output.put_line('*** Inicio - '|| dbms_reputil.global_name() || ' - ' || AUX_CICLO ||' - '||to_char(sysdate, 'dd/mm/yyyy hh24:mi:ss'));
    dbms_output.put_line('CENARIO' ||';'|| 'CONTA_COBRANCA' ||';'|| 'ACCOUNT' ||';'|| 'SUBSCR_NO' ||';'|| 'INSTANCIA' ||';'|| 'FAT_ATUAL' ||';'|| 'COMPONENTE_ID' ||';'|| 'COMPONENTE' ||';'|| 'COMENTARIO');    
  
  for c1 in C_FATURA loop
        for c2 in C_BUSCA_DUPLICIDADE(c1.bill_ref_no, c1.SUBSCR_NO) loop
            dbms_output.put_line('C2 Duplicidade' ||';'|| c1.EXTERNAL_ID ||';'|| c1.account_no ||';'|| c1.SUBSCR_NO ||';'||c1.EXTERNAL_ID ||';'|| c1.bill_ref_no ||';'|| c2.COMPONENT_ID ||';'|| c2.DISPLAY_VALUE ||'; Total='|| c2.total);
            null;
        end loop;

    end loop;
    dbms_output.put_line('_________________________________________________________________');
    dbms_output.put_line('*** Fim - '||dbms_reputil.global_name()|| ' - ' || AUX_CICLO ||' - '||to_char(sysdate, 'dd/mm/yyyy hh24:mi:ss'));

end;
/