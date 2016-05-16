DECLARE
AUX_CICLO           VARCHAR(10);
AUX_COUNT           NUMBER := 0;

CURSOR C_FATURA IS -- C1
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
           AND B.PREP_DATE > sysdate - 15
           AND B.PREP_STATUS = 4 --> 4 proforma 1 production
           AND B.PREP_ERROR_CODE is null
           -- AND B.BILL_REF_NO = 202065847
           -- AND MAP.EXTERNAL_ID in ('899999360809')
           AND MAP.ACCOUNT_NO in (9070935,8903533,9027891,7774736,9112753,9443460,8825590,9061133,8988520,9073149,8930385,9279304,3964733,8448581,9129966,8968199,7029933,3760499,2399641,9319310,8988391,3175450,9340510,9192401,9298827,8992569,9322479,9244522,9089824,6496832,9370783,7538162,9151506,3835420,9106342,9161081,8763777,8858650,8974849,8810135,3453948,8984389,8975443,2596671,9014553,7581672,8041825,2066222,8046999,9072617,4823656,2424293,3078416,8815423,4777815,4277484,8792226,9092937,1755695,1755695,8960902,8720595,8910258,7528216,1583022,1583022,8826554,8829749,9303802,8968474,9142966,6970919,9437677,1298076,9231157,8928982,8861624,8680551,9042431,8901733,9127301,8890653,6893339,8929935,8930790,9149742,7388184,8825508,8069701,9055435,9230835,7972961,8927290,9146688,8615948,8615948,2656161,9113313,9345946,8982146,2482138,3065435,8133638,8936016,8967646,8949881,4814190,4814190,2469670,8904285,4321885,9165461,8956717,7872695,8005934,7442874,9287551,8825429,198784,4558001,9160243,4451530,8957899,9340392,8854488,7543049,7543049,8126101,8910663,9071866,9332785,1779699,1565793,3355388,9187785,9176769,9145053,9115324,9169237,7626934,8869998,1700856,3616551,8930354,8434762,8706031,9118145,8927044,8781757,8994803,8929503,7236958,8666131,9195725,8925841,8980976,8787505,8790996,8968198,9281409,7624644,8956746,8903822,3756658,8875384,2617522,4609551,8187051,9186579,9187357,8759842,8872254,8660630,9357551,9103768,7527929,9119875)
           -- AND D.COMPONENT_ID in (30367,30368,30369,30370) -- LAVOISIER
           AND D.COMPONENT_ID in (31072,31073,31074,31075,31076,31077,31078,31079,31080,31081,31082,31083,31084) -- Touche
           AND D.FROM_DATE = B.FROM_DATE;
           

 CURSOR C_BUSCA_DUPLICIDADE(bill_no number) is -- C2
        select pk.COMPONENT_ID, BI.BILL_REF_NO, BI.ACCOUNT_NO, VL.DISPLAY_VALUE, PK.SUBSCR_NO, PK.FROM_DATE, count(1) total
          from bill_invoice_detail pk,
               bill_invoice bi,
               COMPONENT_DEFINITION_VALUES vl
         where PK.BILL_REF_NO = BI.BILL_REF_NO
           and PK.BILL_REF_RESETS = BI.BILL_REF_RESETS
           and PK.COMPONENT_ID = vl.COMPONENT_ID
           and VL.LANGUAGE_CODE = 2
           and PK.TYPE_CODE = 2
           and PK.PRORATE_CODE not in (1,2)
           and BI.BILL_REF_NO = bill_no
        group by (pk.COMPONENT_ID, BI.BILL_REF_NO, BI.ACCOUNT_NO, VL.DISPLAY_VALUE, PK.SUBSCR_NO, PK.FROM_DATE)
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
              and cm.component_id not in (SELECT to_number(COMPONENT_ID)FROM g0023421sql.GVT_VAL_PLANO where NOME_PLANO = 'TOUCHE')
              and cm.component_id not in (SELECT to_number(COMPONENT_ID)FROM g0023421sql.GVT_VAL_PLANO_DADOS)
              and (cm.component_id in (SELECT component_id FROM BQ_TP_ARBOR_LOCAL) or component_id in (SELECT component_id FROM BQ_TP_ARBOR_FRANQUIA))
              and EXISTS (SELECT 1 FROM CMF_PACKAGE_COMPONENT pk WHERE CM.COMPONENT_ID = PK.COMPONENT_ID and PK.PARENT_SUBSCR_NO = subs_no and PK.INACTIVE_DT is null );
            
 CURSOR C_BUSCA_PROD_FALTANDO(acc_no number, bill_no number, cc_id number, subs_cc number) is -- C4
        SELECT   A.COMPONENT_ID, TIRA_ACENTO(A.COMPONENTE) AS COMPONENTE
          FROM   G0023421SQL.GVT_VAL_PLANO A
         WHERE   A.PLANO = (SELECT PLANO FROM g0023421sql.GVT_VAL_PLANO WHERE NOME_PLANO = 'TOUCHE' AND COMPONENT_ID = cc_id) 
           AND   A.TIPOELEMENTO = 'RC - Conta'
                 AND NOT EXISTS
                       (SELECT   1
                          FROM   bill_invoice_detail CPC,
                                 bill_invoice BB
                         WHERE   BB.ACCOUNT_NO = acc_no
                           AND   CPC.BILL_REF_NO = bill_no
                           AND   CPC.TYPE_CODE = 2
                           AND   CPC.BILL_REF_NO = BB.BILL_REF_NO
                           AND   CPC.BILL_REF_RESETS = BB.BILL_REF_RESETS)
        UNION ALL
        SELECT A.COMPONENT_ID, TIRA_ACENTO(A.COMPONENTE) AS COMPONENTE
          FROM G0023421SQL.GVT_VAL_PLANO A
         WHERE A.PLANO = (SELECT PLANO FROM g0023421sql.GVT_VAL_PLANO WHERE NOME_PLANO = 'TOUCHE' AND COMPONENT_ID = CC_ID) 
           AND A.TIPOELEMENTO = 'RC - Instancia'
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
                           AND   CPC.COMPONENT_ID = A.COMPONENT_ID);

 

begin

   Select bill_period into AUX_CICLO
     from bill_cycle where bill_period like 'M%' and prep_date = (Select max(prep_date) from bill_cycle where bill_period like 'M%' and prep_date <= sysdate);
   
   AUX_CICLO:= 'M20';
   
    dbms_output.put_line('_________________________________________________________________');
    dbms_output.put_line('*** Inicio - '|| dbms_reputil.global_name() || ' - ' || AUX_CICLO ||' - '||to_char(sysdate, 'dd/mm/yyyy hh24:mi:ss'));
    dbms_output.put_line('CENARIO' ||';'|| 'CONTA_COBRANCA' ||';'|| 'ACCOUNT' ||';'|| 'SUBSCR_NO' ||';'|| 'INSTANCIA' ||';'|| 'FAT_ATUAL' ||';'|| 'COMPONENTE_ID' ||';'|| 'COMPONENTE' ||';'|| 'COMENTARIO');    
  
  for c1 in C_FATURA loop
  
        for c2 in C_BUSCA_DUPLICIDADE(c1.bill_ref_no) loop
            dbms_output.put_line('C2 Duplicidade' ||';'|| c1.EXTERNAL_ID ||';'|| c2.account_no ||';'|| c2.SUBSCR_NO ||';'||c1.EXTERNAL_ID ||';'|| c2.bill_ref_no ||';'|| c2.COMPONENT_ID ||';'|| c2.DISPLAY_VALUE ||'; Total='|| c2.total);
            dbms_output.put_line('C2 Duplicidade' ||'-'|| C1.COMPONENT_ID);
            null;
        end loop;        

        for c3 in C_BUSCA_PROD_PLANO(c1.bill_ref_no, c1.SUBSCR_NO) loop
            dbms_output.put_line('C3 Produto fora do Plano' ||';'|| c1.EXTERNAL_ID ||';'|| c1.ACCOUNT_NO  ||';'|| c1.SUBSCR_NO ||';'|| c3.EXTERNAL_ID ||';'|| c1.bill_ref_no ||';'|| c3.COMPONENT_ID ||';'|| c3.COMPONENTE );
            dbms_output.put_line('C3 Produto fora do Plano' ||'-'|| C1.COMPONENT_ID);
            null;
        end loop;        

        for c4 in C_BUSCA_PROD_FALTANDO(c1.ACCOUNT_NO, c1.BILL_REF_NO, C1.COMPONENT_ID, C1.SUBSCR_NO ) loop
            dbms_output.put_line('C4 Produto Faltando' ||';'|| c1.EXTERNAL_ID ||';'|| c1.account_no ||';'|| c1.SUBSCR_NO ||';'|| c1.EXTERNAL_ID ||';'|| c1.bill_ref_no ||';'|| c4.COMPONENT_ID ||';'|| c4.COMPONENTE);
            dbms_output.put_line('C4 Produto Faltando' ||'-'|| C1.COMPONENT_ID);
            null;
        end loop; 

    end loop;
    dbms_output.put_line('_________________________________________________________________');
    dbms_output.put_line('*** Fim - '||dbms_reputil.global_name()|| ' - ' || AUX_CICLO ||' - '||to_char(sysdate, 'dd/mm/yyyy hh24:mi:ss'));

end;
/