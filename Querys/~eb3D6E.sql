DECLARE
AUX_CICLO           VARCHAR(10) := 'M28';
AUX_COUNT           NUMBER := 0;

CURSOR C_FATURA IS -- C1
SELECT   distinct(MAP.EXTERNAL_ID),
         MAP.ACCOUNT_NO,
           d.bill_ref_no,
           D.SUBSCR_NO,
           D.COMPONENT_ID --,
           CM.COMPONENT_ID "ASS_COMPONENT_ID",
           (select tira_acento(dt.DISPLAY_VALUE) from COMPONENT_DEFINITION_VALUES dt where CM.COMPONENT_ID = DT.COMPONENT_ID and dt.language_code = 2) "ASSINATURA"
    FROM   bill_invoice b,
           bill_invoice_detail d,
           cmf c,
           CMF_PACKAGE_COMPONENT cm,
           customer_id_acct_map map
   WHERE   d.bill_ref_resets = b.bill_ref_resets
           AND d.type_code IN (2, 3, 7)
           AND MAP.ACCOUNT_NO = B.ACCOUNT_NO
           AND MAP.INACTIVE_DATE is null
           AND C.ACCOUNT_NO = MAP.ACCOUNT_NO
           AND C.ACCOUNT_CATEGORY in (10,11) -- Retail
           AND MAP.EXTERNAL_ID_TYPE = 1
           AND MAP.IS_CURRENT = 1
           -- AND CM.PARENT_SUBSCR_NO = D.SUBSCR_NO
           -- AND CM.PARENT_SUBSCR_NO_RESETS = D.SUBSCR_NO_RESETS
           -- and CM.INACTIVE_DT is null
           -- AND CM.PARENT_ACCOUNT_NO = MAP.ACCOUNT_NO
           AND B.BILL_REF_NO = D.BILL_REF_NO
           AND B.BILL_REF_RESETS = D.BILL_REF_RESETS
           AND B.BILL_PERIOD = 'M28'
           AND B.PREP_DATE > sysdate - 15
           AND B.PREP_STATUS = 4 --> 4 proforma 1 production
           AND B.PREP_ERROR_CODE is null
           AND D.COMPONENT_ID in (30367,30368,30369,30370)
           --AND map.account_no = 8512678;
           and rownum < 2000;
                                    
          -- select * from gvt_val_plano where ELEMENTO like ('%Assinatura%')

 CURSOR C_BUSCA_DUPLICIDADE(acc_no number) is -- C2
           select pk.COMPONENT_ID, EQ.EXTERNAL_ID , VL.DISPLAY_VALUE, count(1) total
             from CMF_PACKAGE_COMPONENT pk,
                  customer_id_equip_map eq,
                  COMPONENT_DEFINITION_VALUES vl
            where pk.parent_account_no = acc_no
              and pk.inactive_dt is null
              and PK.PARENT_SUBSCR_NO = EQ.SUBSCR_NO
              and PK.PARENT_SUBSCR_NO_RESETS = EQ.SUBSCR_NO_RESETS
              and EQ.INACTIVE_DATE is null
              and EQ.IS_CURRENT = 1
              and EQ.EXTERNAL_ID_TYPE <> 1
              and EQ.EXTERNAL_ID_TYPE in (6,7)
              and PK.COMPONENT_ID = vl.COMPONENT_ID
              and VL.LANGUAGE_CODE = 2
              and (pk.component_id in (SELECT to_number(COMPONENT_ID)FROM GVT_VAL_PLANO) or pk.component_id in (SELECT to_number(COMPONENT_ID)FROM GVT_VAL_PLANO_DADOS))
            group by (pk.COMPONENT_ID,VL.DISPLAY_VALUE,EQ.EXTERNAL_ID)
            having count(1) > 1;
            
 CURSOR C_BUSCA_PROD_PLANO(acc_no number) is -- C3
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
              and component_id not in (SELECT to_number(COMPONENT_ID)FROM GVT_VAL_PLANO)
              and component_id not in (SELECT to_number(COMPONENT_ID)FROM GVT_VAL_PLANO_DADOS)
              and (component_id in (SELECT component_id FROM BQ_TP_ARBOR_LOCAL) or component_id in (SELECT component_id FROM BQ_TP_ARBOR_FRANQUIA));
            
 CURSOR C_BUSCA_PROD_FALTANDO(acc_no number, sub_no number, ass varchar2) is -- C4
        SELECT   A.COMPONENT_ID, tira_acento(A.COMPONENTE) as COMPONENTE
          FROM   g0023421sql.gvt_val_plano a
         WHERE   a.plano = ass AND a.tipoelemento = 'RC - Conta'
                 AND NOT EXISTS
                       (SELECT   1
                          FROM   cmf_package_component cpc
                         WHERE       cpc.parent_account_no = acc_no
                                 AND CPC.INACTIVE_DT IS NULL
                                 AND a.component_id = cpc.component_id)
        UNION
       SELECT   A.COMPONENT_ID, tira_acento(A.COMPONENTE) as COMPONENTE
          FROM   g0023421sql.gvt_val_plano a
         WHERE   a.plano = ass AND a.tipoelemento <> 'RC - Conta'
                 AND NOT EXISTS
                       (SELECT   1
                          FROM   cmf_package_component cpc
                         WHERE       cpc.parent_subscr_no = sub_no
                                 AND CPC.INACTIVE_DT IS NULL
                                 AND a.component_id = cpc.component_id);

 CURSOR C_BUSCA_PROD_SOBRANDO(acc_no number) is -- C5
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

CURSOR C_BUSCA_CARDINALIDADE(acc_no number) is -- C6
          select cm.*,EQ.EXTERNAL_ID,
                  (select tira_acento(dt.DISPLAY_VALUE) from COMPONENT_DEFINITION_VALUES dt where CM.COMPONENT_ID = DT.COMPONENT_ID and dt.language_code = 2) "COMPONENTE"
             from CMF_PACKAGE_COMPONENT cm, 
                  customer_id_equip_map eq
            where cm.parent_account_no = 7529061 --acc_no
              and cm.inactive_dt is null
              and EQ.INACTIVE_DATE is null
              and EQ.EXTERNAL_ID_TYPE <> 1
              and EQ.EXTERNAL_ID_TYPE in (6,7)
              and CM.PARENT_SUBSCR_NO = EQ.SUBSCR_NO
              and CM.PARENT_SUBSCR_NO_RESETS = EQ.SUBSCR_NO_RESETS
              and component_id not in (SELECT to_number(COMPONENT_ID)FROM GVT_VAL_PLANO)
              and component_id not in (SELECT to_number(COMPONENT_ID)FROM GVT_VAL_PLANO_DADOS)
              and (component_id in (SELECT component_id FROM BQ_TP_ARBOR_LOCAL) or component_id in (SELECT component_id FROM BQ_TP_ARBOR_FRANQUIA));
 
  
begin

    dbms_output.put_line('*** Inicio - '||dbms_reputil.global_name()||' - '||to_char(sysdate, 'dd/mm/yyyy hh24:mi:ss'));
    dbms_output.put_line('CENARIO' ||';'|| 'CONTA_COBRANCA' ||';'|| 'ACCOUNT' ||';'|| 'INSTANCIA' ||';'|| 'FAT_ATUAL' ||';'|| 'COMPONENTE_ID' ||';'|| 'COMPONENTE' ||';'|| 'COMENTARIO');    
    for c1 in C_FATURA loop
        for c2 in C_BUSCA_DUPLICIDADE(c1.account_no) loop
            dbms_output.put_line('C2 Duplicidade' ||';'|| c1.EXTERNAL_ID ||';'|| c1.account_no ||';'|| c2.EXTERNAL_ID ||';'|| c1.bill_ref_no ||';'|| c2.COMPONENT_ID ||';'|| c2.DISPLAY_VALUE ||'; Total='|| c2.total);
            null;
        end loop;        

        for c3 in C_BUSCA_PROD_PLANO(c1.account_no) loop
            dbms_output.put_line('C3 Produto fora do Plano' ||';'|| c1.EXTERNAL_ID ||';'|| c1.ACCOUNT_NO  ||';'|| c3.EXTERNAL_ID ||';'|| c1.bill_ref_no ||';'|| c3.COMPONENT_ID ||';'|| c3.COMPONENTE);
            null;
        end loop;        

--        for c4 in C_BUSCA_PROD_FALTANDO(c1.account_no, c1.SUBSCR_NO, C1.ASSINATURA) loop
--            dbms_output.put_line('C4 Produto Faltando' ||';'|| c1.EXTERNAL_ID ||';'|| c1.account_no ||';'|| c1.EXTERNAL_ID ||';'|| c1.bill_ref_no ||';'|| c4.COMPONENT_ID ||';'|| c4.COMPONENTE);
--            null;
--        end loop; 

--        for c5 in C_BUSCA_PROD_SOBRANDO(c1.account_no) loop
--            dbms_output.put_line('C5' ||';'|| c1.account_no ||';'|| c1.bill_ref_no ||';'|| c4.COMPONENT_ID);
--            null;
--        end loop;

--        for c6 in C_BUSCA_CARDINALIDADE(c1.account_no) loop
--            dbms_output.put_line('C4' ||';'|| c1.account_no ||';'|| c1.bill_ref_no ||';'|| c4.COMPONENT_ID);
--            null;
--        end loop; 

    end loop;
    dbms_output.put_line('*** FIM - '||dbms_reputil.global_name()||' - '||to_char(sysdate, 'dd/mm/yyyy hh24:mi:ss'));

end;
/
