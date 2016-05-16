DECLARE
AUX_CICLO           VARCHAR(10) := 'M28';
AUX_COUNT           NUMBER := 0;

CURSOR C_FATURA IS -- C1
SELECT   distinct(MAP.EXTERNAL_ID),
         MAP.ACCOUNT_NO,
           d.bill_ref_no
    FROM   bill_invoice b,
           bill_invoice_detail d,
           cmf c,
           customer_id_acct_map map
   WHERE   d.bill_ref_resets = b.bill_ref_resets
           AND d.type_code IN (2, 3, 7)
           AND MAP.ACCOUNT_NO = B.ACCOUNT_NO
           AND MAP.INACTIVE_DATE is null
           AND C.ACCOUNT_NO = MAP.ACCOUNT_NO
           AND C.ACCOUNT_CATEGORY in (10,11) -- Retail
           AND MAP.EXTERNAL_ID_TYPE = 1
           AND B.BILL_REF_NO = D.BILL_REF_NO
           AND B.BILL_REF_RESETS = D.BILL_REF_RESETS
           AND B.BILL_PERIOD = 'M02'-- AUX_CICLO
           AND B.PREP_DATE > sysdate - 45
           AND B.PREP_STATUS = 1 --> 4 proforma 1 production
           AND B.PREP_ERROR_CODE is null
           AND MAP.EXTERNAL_ID = 999979865472
           AND D.COMPONENT_ID in (SELECT to_number(COMPONENT_ID)
                                    FROM GVT_VAL_PLANO);

 CURSOR C_BUSCA_DUPLICIDADE(acc_no number) is -- C2
           select COMPONENT_ID,PARENT_SUBSCR_NO, count(1)
             from CMF_PACKAGE_COMPONENT
            where parent_account_no = 7529061 --acc_no
              and inactive_dt is null
            group by (COMPONENT_ID,PARENT_SUBSCR_NO);
            
 CURSOR C_BUSCA_PROD_PLANO(acc_no number) is -- C3
          select cm.*,
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
            
 CURSOR C_BUSCA_PROD_FALTANDO(acc_no number) is -- C4
          select cm.*,
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

CURSOR C_BUSCA_CARDINALIDADE(acc_no number) is -- C5
          select cm.*,
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
    dbms_output.put_line('ACCOUNT_NO' ||';'|| 'CONTA_COBRANCA' ||';'|| 'FATURA_ATUAL' ||';'|| 'VCTO_FAT_ATUAL' ||';'|| 'VALOR_FAT_ATUAL' ||';'|| 'VALOR_JUROS_MULTA_FAT_ATUAL' ||';'|| 'FAT_PAGA_ATRASO' ||';'|| 'VCTO_FAT_PAGA_ATRASO' ||';'|| 'DATA_PGTO_FAT_ATRASO' ||';'|| 'VALOR_FAT_ATRASO');    
    for c1 in C_FATURA loop
        for c2 in C_BUSCA_DUPLICIDADE(c1.account_no) loop
            dbms_output.put_line(c1.ACCOUNT_NO ||';'|| c1.CONTA_COBRANCA ||';'|| c1.FATURA_ATUAL ||';'|| to_char(c1.VCTO_FAT_ATUAL,'dd/mm/yyyy') ||';'|| c1.VALOR_FAT_ATUAL ||';'|| c1.VALOR_JUROS_MULTA_FAT_ATUAL ||';'|| c2.FAT_PAGA_ATRASO ||';'|| to_char(c2.VCTO_FAT_PAGA_ATRASO,'dd/mm/yyyy') ||';'|| to_char(c2.DATA_PGTO_FAT_ATRASO,'dd/mm/yyyy') ||';'|| c2.VALOR_FAT_ATRASO);
            null;
        end loop;        

        for c3 in C_BUSCA_PROD_PLANO(c1.account_no) loop
            dbms_output.put_line(c1.ACCOUNT_NO ||';'|| c1.CONTA_COBRANCA ||';'|| c1.FATURA_ATUAL ||';'|| to_char(c1.VCTO_FAT_ATUAL,'dd/mm/yyyy') ||';'|| c1.VALOR_FAT_ATUAL ||';'|| c1.VALOR_JUROS_MULTA_FAT_ATUAL ||';'|| c2.FAT_PAGA_ATRASO ||';'|| to_char(c2.VCTO_FAT_PAGA_ATRASO,'dd/mm/yyyy') ||';'|| to_char(c2.DATA_PGTO_FAT_ATRASO,'dd/mm/yyyy') ||';'|| c2.VALOR_FAT_ATRASO);
            null;
        end loop;        

        for c4 in C_BUSCA_PROD_FALTANDO(c1.account_no) loop
            dbms_output.put_line(c1.ACCOUNT_NO ||';'|| c1.CONTA_COBRANCA ||';'|| c1.FATURA_ATUAL ||';'|| to_char(c1.VCTO_FAT_ATUAL,'dd/mm/yyyy') ||';'|| c1.VALOR_FAT_ATUAL ||';'|| c1.VALOR_JUROS_MULTA_FAT_ATUAL ||';'|| c2.FAT_PAGA_ATRASO ||';'|| to_char(c2.VCTO_FAT_PAGA_ATRASO,'dd/mm/yyyy') ||';'|| to_char(c2.DATA_PGTO_FAT_ATRASO,'dd/mm/yyyy') ||';'|| c2.VALOR_FAT_ATRASO);
            null;
        end loop; 

       for c5 in C_BUSCA_PROD_FALTANDO(c1.account_no) loop
            dbms_output.put_line(c1.ACCOUNT_NO ||';'|| c1.CONTA_COBRANCA ||';'|| c1.FATURA_ATUAL ||';'|| to_char(c1.VCTO_FAT_ATUAL,'dd/mm/yyyy') ||';'|| c1.VALOR_FAT_ATUAL ||';'|| c1.VALOR_JUROS_MULTA_FAT_ATUAL ||';'|| c2.FAT_PAGA_ATRASO ||';'|| to_char(c2.VCTO_FAT_PAGA_ATRASO,'dd/mm/yyyy') ||';'|| to_char(c2.DATA_PGTO_FAT_ATRASO,'dd/mm/yyyy') ||';'|| c2.VALOR_FAT_ATRASO);
            null;
        end loop;

    end loop;
    dbms_output.put_line('*** FIM - '||dbms_reputil.global_name()||' - '||to_char(sysdate, 'dd/mm/yyyy hh24:mi:ss'));

end;
/
