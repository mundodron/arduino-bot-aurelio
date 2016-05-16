DECLARE
AUX_CICLO           VARCHAR(10) := 'M15';
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
           -- and B.BILL_REF_NO = '197047615'
           -- AND MAP.EXTERNAL_ID in ('899998913679','899998886616','999989390119','999987582262')
           -- and MAP.ACCOUNT_NO in (7769170,3390292,8167060,7871960,8633370,8129262,8424115)
           AND D.COMPONENT_ID in (30367,30368,30369,30370)
           AND D.PRORATE_CODE <> 1;
           

 CURSOR C_BUSCA_DUPLICIDADE(bill_no number, subs_no number) is -- C2
           select pk.COMPONENT_ID, EQ.EXTERNAL_ID , VL.DISPLAY_VALUE, count(1) total
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
              and EQ.EXTERNAL_ID_TYPE <> 1
              and EQ.EXTERNAL_ID_TYPE in (6,7)
              and PK.COMPONENT_ID = vl.COMPONENT_ID
              and VL.LANGUAGE_CODE = 2
              and (pk.component_id in (SELECT to_number(COMPONENT_ID)FROM g0023421sql.GVT_VAL_PLANO) or pk.component_id in (SELECT to_number(COMPONENT_ID)FROM g0023421sql.GVT_VAL_PLANO_DADOS))
              and EXISTS (SELECT 1 FROM CMF_PACKAGE_COMPONENT bd WHERE bd.COMPONENT_ID = pk.COMPONENT_ID and bd.PARENT_SUBSCR_NO = subs_no and bd.INACTIVE_DT is null)
            group by (pk.COMPONENT_ID,VL.DISPLAY_VALUE,EQ.EXTERNAL_ID)
            having count(1) > 1;
                        
 CURSOR C_BUSCA_PROD_PLANO(bill_no number, subs_no number) is -- C3
          select cm.*,EQ.EXTERNAL_ID,
                  (select tira_acento(dt.DISPLAY_VALUE) from COMPONENT_DEFINITION_VALUES dt where CM.COMPONENT_ID = DT.COMPONENT_ID and dt.language_code = 2) "COMPONENTE"
             from bill_invoice_detail cm, 
                  customer_id_equip_map eq
            where cm.bill_ref_no = bill_no
              and CM.SUBSCR_NO = subs_no
              and EQ.INACTIVE_DATE is null
              and EQ.EXTERNAL_ID_TYPE <> 1
              and CM.TYPE_CODE = 2
              and EQ.EXTERNAL_ID_TYPE in (6,7)
              and CM.SUBSCR_NO = EQ.SUBSCR_NO
              and CM.SUBSCR_NO_RESETS = EQ.SUBSCR_NO_RESETS
              and cm.component_id not in (SELECT to_number(COMPONENT_ID)FROM g0023421sql.GVT_VAL_PLANO)
              and cm.component_id not in (SELECT to_number(COMPONENT_ID)FROM g0023421sql.GVT_VAL_PLANO_DADOS)
              and (cm.component_id in (SELECT component_id FROM BQ_TP_ARBOR_LOCAL) or component_id in (SELECT component_id FROM BQ_TP_ARBOR_FRANQUIA))
              and EXISTS (SELECT 1 FROM CMF_PACKAGE_COMPONENT pk WHERE CM.COMPONENT_ID = PK.COMPONENT_ID and PK.PARENT_SUBSCR_NO = subs_no and PK.INACTIVE_DT is null );
            
 CURSOR C_BUSCA_PROD_FALTANDO(acc_no number, bill_no number, cc_id number, subs_cc number) is -- C4
        SELECT   A.COMPONENT_ID, TIRA_ACENTO(A.COMPONENTE) AS COMPONENTE
          FROM   G0023421SQL.GVT_VAL_PLANO A
         WHERE   A.PLANO = (SELECT PLANO FROM g0023421sql.GVT_VAL_PLANO WHERE COMPONENT_ID = cc_id) 
           AND A.TIPOELEMENTO = 'RC - Conta'
                 AND NOT EXISTS
                       (SELECT   1
                          FROM   bill_invoice_detail CPC,
                                 bill_invoice BB
                         WHERE   BB.ACCOUNT_NO = acc_no
                           AND   CPC.BILL_REF_NO = bill_no
                           AND   CPC.TYPE_CODE = 2
                           AND   CPC.BILL_REF_NO = BB.BILL_REF_NO
                           AND   CPC.BILL_REF_RESETS = BB.BILL_REF_RESETS
                           AND   A.COMPONENT_ID = CPC.COMPONENT_ID)
        UNION
       SELECT   A.COMPONENT_ID, TIRA_ACENTO(A.COMPONENTE) AS COMPONENTE
          FROM   G0023421SQL.GVT_VAL_PLANO A
         WHERE   A.PLANO = (SELECT PLANO FROM g0023421sql.GVT_VAL_PLANO WHERE COMPONENT_ID = CC_ID) 
           AND A.TIPOELEMENTO = 'RC - Instancia'
           and A.COMPONENT_ID <> 30491 --Verificar, o caso de type_code = 6 ignorar por enquanto.
                 AND NOT EXISTS
                       (SELECT   1
                          FROM   bill_invoice_detail CPC,
                                 bill_invoice BB
                         WHERE   BB.ACCOUNT_NO = acc_no
                           AND   CPC.BILL_REF_NO = bill_no
                           AND   CPC.BILL_REF_NO = BB.BILL_REF_NO
                           AND   CPC.SUBSCR_NO = subs_cc
                           AND   CPC.TYPE_CODE = 2
                           AND   CPC.BILL_REF_RESETS = BB.BILL_REF_RESETS
                           AND   CPC.BILL_REF_RESETS = 0
                           AND   A.COMPONENT_ID = CPC.COMPONENT_ID);

 CURSOR C_BUSCA_PROD_COMPATIVEIS(acc_no number) is -- C5
          select cm.*,EQ.EXTERNAL_ID,
                  (select tira_acento(dt.DISPLAY_VALUE) from COMPONENT_DEFINITION_VALUES dt where CM.COMPONENT_ID = DT.COMPONENT_ID and dt.language_code = 2) "COMPONENTE"
             from CMF_PACKAGE_COMPONENT cm, 
                  customer_id_equip_map eq
            where cm.parent_account_no = acc_no
              and cm.inactive_dt is null
              and EQ.INACTIVE_DATE is null
              and EQ.EXTERNAL_ID_TYPE <> 1
              and EQ.EXTERNAL_ID_TYPE in (6,7)
              and CM.PARENT_SUBSCR_NO = EQ.SUBSCR_NO
              and CM.PARENT_SUBSCR_NO_RESETS = EQ.SUBSCR_NO_RESETS
              and (component_id in (SELECT component_id FROM BQ_TP_ARBOR_LOCAL) or component_id in (SELECT component_id FROM BQ_TP_ARBOR_FRANQUIA));

begin

    dbms_output.put_line('*** Inicio - '||dbms_reputil.global_name()||' - '||to_char(sysdate, 'dd/mm/yyyy hh24:mi:ss'));
    dbms_output.put_line('CENARIO' ||';'|| 'CONTA_COBRANCA' ||';'|| 'ACCOUNT' ||';'|| 'INSTANCIA' ||';'|| 'FAT_ATUAL' ||';'|| 'COMPONENTE_ID' ||';'|| 'COMPONENTE' ||';'|| 'COMENTARIO');    
    for c1 in C_FATURA loop
        for c2 in C_BUSCA_DUPLICIDADE(c1.bill_ref_no, c1.SUBSCR_NO) loop
            dbms_output.put_line('C2 Duplicidade' ||';'|| c1.EXTERNAL_ID ||';'|| c1.account_no ||';'||c2.EXTERNAL_ID ||';'|| c1.bill_ref_no ||';'|| c2.COMPONENT_ID ||';'|| c2.DISPLAY_VALUE ||'; Total='|| c2.total);
            null;
        end loop;        

        for c3 in C_BUSCA_PROD_PLANO(c1.bill_ref_no, c1.SUBSCR_NO) loop
            dbms_output.put_line('C3 Produto fora do Plano' ||';'|| c1.EXTERNAL_ID ||';'|| c1.ACCOUNT_NO  ||';'|| c3.EXTERNAL_ID ||';'|| c1.bill_ref_no ||';'|| c3.COMPONENT_ID ||';'|| c3.COMPONENTE ||','|| c1.SUBSCR_NO);
            null;
        end loop;        

        for c4 in C_BUSCA_PROD_FALTANDO(c1.ACCOUNT_NO, c1.BILL_REF_NO, C1.COMPONENT_ID, C1.SUBSCR_NO ) loop
            dbms_output.put_line('C4 Produto Faltando' ||';'|| c1.EXTERNAL_ID ||';'|| c1.account_no ||';'|| c1.SUBSCR_NO ||';'|| c1.bill_ref_no ||';'|| c4.COMPONENT_ID ||';'|| c4.COMPONENTE);
           -- dbms_output.put_line(C1.COMPONENT_ID);
            null;
        end loop; 

--        for c5 in C_BUSCA_PROD_COMPATIVEIS(c1.account_no) loop
--            dbms_output.put_line('C5 Produto Imcompativel no Plano' ||';'|| c1.account_no ||';'|| c1.bill_ref_no ||';'|| c4.COMPONENT_ID);
--            null;
--        end loop;


    end loop;
    dbms_output.put_line('_________________________________________________________________');
    dbms_output.put_line('*** FIM - '||dbms_reputil.global_name()||' - '||to_char(sysdate, 'dd/mm/yyyy hh24:mi:ss'));

end;
/