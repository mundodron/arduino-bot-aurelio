DROP TABLE G0023421SQL.GVT_VAL_PLANO CASCADE CONSTRAINTS;

CREATE TABLE G0023421SQL.GVT_VAL_PLANO
(
  PLANO                VARCHAR2(150 BYTE),
  COMPONENT_ID         VARCHAR2(150 BYTE),
  COMPONENTE           VARCHAR2(250 BYTE),
  ELEMENTOSCOMPONENTE  VARCHAR2(150 BYTE),
  ELEMENTO             VARCHAR2(450 BYTE),
  TIPOELEMENTO         VARCHAR2(250 BYTE),
  ARQUIVO              VARCHAR2(250 BYTE)

);

 select * from GVT_VAL_PLANO;
 
 update GVT_VAL_PLANO set plano = 'GVT Ilimitado Local Casa' where component_id in (30492,29917)
 
 delete GVT_VAL_PLANO where component_id is null
 

 -- C_FATURA
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
           AND B.BILL_PERIOD = 'M28'-- AUX_CICLO
           AND B.PREP_DATE > sysdate - 15
           AND B.PREP_STATUS = 4 --> 4 proforma 1 production
           AND B.PREP_ERROR_CODE is null
           --AND MAP.EXTERNAL_ID = 999979865472
           and MAP.ACCOUNT_NO = 6760798
           AND D.COMPONENT_ID in (SELECT to_number(COMPONENT_ID)
                                    FROM GVT_VAL_PLANO);
                                    
         -- "EXTERNAL_ID";"ACCOUNT_NO";"BILL_REF_NO"
         -- 999979865472;7529061;188385851


                    
 -- C_BUSCA_DUPLICIDADE(acc_no number) is
           
           select COMPONENT_ID,PARENT_SUBSCR_NO, count(1)
             from CMF_PACKAGE_COMPONENT
            where parent_account_no = 7529061 --acc_no
              and inactive_dt is null
            group by (COMPONENT_ID,PARENT_SUBSCR_NO)
            HAVING count(1) > 1;
         
 -- C_BUSCA_PROD_PLANO(acc_no number) is
          select cm.component_id,
                  (select tira_acento(dt.DISPLAY_VALUE) from COMPONENT_DEFINITION_VALUES dt where CM.COMPONENT_ID = DT.COMPONENT_ID and dt.language_code = 2) "COMPONENTE"
             from CMF_PACKAGE_COMPONENT cm, 
                  customer_id_equip_map eq
            where cm.parent_account_no = 6760798 --acc_no
              and cm.inactive_dt is null
              and EQ.INACTIVE_DATE is null
              and EQ.EXTERNAL_ID_TYPE <> 1
              and EQ.EXTERNAL_ID_TYPE in (6,7)
              and CM.PARENT_SUBSCR_NO = EQ.SUBSCR_NO
              and CM.PARENT_SUBSCR_NO_RESETS = EQ.SUBSCR_NO_RESETS
              and component_id not in (SELECT to_number(COMPONENT_ID)FROM GVT_VAL_PLANO)
              and component_id not in (SELECT to_number(COMPONENT_ID)FROM GVT_VAL_PLANO_DADOS)
              and (component_id in (SELECT component_id FROM BQ_TP_ARBOR_LOCAL) or component_id in (SELECT component_id FROM BQ_TP_ARBOR_FRANQUIA));



 -- CURSOR C_BUSCA_PROD_FALTANDO(acc_no number) is 
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
              and component_id in (SELECT to_number(COMPONENT_ID)FROM GVT_VAL_PLANO)
              and component_id in (SELECT to_number(COMPONENT_ID)FROM GVT_VAL_PLANO_DADOS)
              --and (component_id in (SELECT component_id FROM BQ_TP_ARBOR_LOCAL) or component_id in (SELECT component_id FROM BQ_TP_ARBOR_FRANQUIA));

              
              
              select * from product where component_ID in (23297,27440,24980)
              
              
              select * from COMPONENT_DEFINITION_VALUES
              
              select * from all_tables where table_name like '%COMPONENT%' 
                                         
         -- Valida Planos
         
           select *
             from CMF_PACKAGE_COMPONENT
            where parent_account_no = 7529061
              and inactive_dt is null
              and component_id not in (SELECT to_number(COMPONENT_ID)FROM GVT_VAL_PLANO)
          
         
          select * from bill_invoice where account_no = 7529061
                                    
           -- order by 7
           
           
           -- delete GVT_VAL_PLANO where COMPONENT_ID = 'Component_id'
           
           select * from GVT_VAL_PLANO
           
           
           select * from bq_tp_arbor_local

           select (select tira_acento(description_text) from descriptions dt where dt.description_code = d.description_code and dt.language_code = 2) "PRODUTO", d.* from bill_invoice_detail d where d.bill_ref_no = 188385851 and COMPONENT_ID in (SELECT to_number(COMPONENT_ID) FROM GVT_VAL_PLANO)
           
           
           
           DROP TABLE G0023421SQL.GVT_VAL_PLANO_DADOS CASCADE CONSTRAINTS;

CREATE TABLE G0023421SQL.GVT_VAL_PLANO_DADOS
(
  PLANO                VARCHAR2(150 BYTE),
  COMPONENT_ID         VARCHAR2(150 BYTE),
  COMPONENTE           VARCHAR2(250 BYTE),
  ELEMENTOSCOMPONENTE  VARCHAR2(150 BYTE),
  ELEMENTO             VARCHAR2(450 BYTE),
  TIPOELEMENTO         VARCHAR2(250 BYTE),
  ARQUIVO              VARCHAR2(250 BYTE)

);


 select * from GVT_VAL_PLANO;
 
 select * from GVT_VAL_PLANO_DADOS
 
 --delete GVT_VAL_PLANO_DADOS where COMPONENT_ID = 'Component_id'


SELECT   MAP.EXTERNAL_ID,
         MAP.ACCOUNT_NO,
           B.BILL_PERIOD,
           C.BILL_STATE,
           d.bill_ref_no,
           eq.external_id "EQUIP",
           EQ.EXTERNAL_ID_TYPE,
           d.type_code,
           d.subtype_code,
           D.COMPONENT_ID,
           d.element_id,
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
           and EQ.EXTERNAL_ID_TYPE <> 1
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
           AND B.BILL_PERIOD = 'M02'-- AUX_CICLO
           AND B.PREP_DATE > sysdate - 45
           AND B.PREP_STATUS = 1 --> 4 proforma 1 production
           AND B.PREP_ERROR_CODE is null
           AND EQ.SUBSCR_NO = D.SUBSCR_NO
           AND MAP.EXTERNAL_ID = 999979865472
           
           
           AND D.COMPONENT_ID in (SELECT to_number(COMPONENT_ID)
                                    FROM GVT_VAL_PLANO)
                                    
           
           select * from customer_id_equip_map where subscr_no in (           
           select PARENT_subscr_no
             from CMF_PACKAGE_COMPONENT
            where parent_account_no = 7529061
              and inactive_dt is null)

           select count(1), PARENT_SUBSCR_NO
             from CMF_PACKAGE_COMPONENT
            where parent_account_no = 7529061
              and inactive_dt is null
            group by PARENT_SUBSCR_NO


           select COMPONENT_ID,PARENT_SUBSCR_NO, count(1)
             from CMF_PACKAGE_COMPONENT
            where parent_account_no = 7529061
              and inactive_dt is null
             group by (COMPONENT_ID,PARENT_SUBSCR_NO)



     select * from all_tables where table_name like '%PACKAGE%' 
                                    
           select * from bill_invoice where account_no = 7529061
                                    
           -- order by 7
           
           
           -- delete GVT_VAL_PLANO where COMPONENT_ID = 'Component_id'
           
           select * from GVT_VAL_PLANO
           
           select * from all_tables where table_name like '%BQ_TP_ARBOR%' 
           
           SELECT component_id FROM BQ_TP_ARBOR_LOCAL
           
           SELECT component_id FROM BQ_TP_ARBOR_FRANQUIA

           select (select tira_acento(description_text) from descriptions dt where dt.description_code = d.description_code and dt.language_code = 2) "PRODUTO", d.* from bill_invoice_detail d where d.bill_ref_no = 188385851 and COMPONENT_ID in (SELECT to_number(COMPONENT_ID) FROM GVT_VAL_PLANO)
           
           
           
           ---------------------------
           
                      select eq.*
             from CMF_PACKAGE_COMPONENT pk, customer_id_equip_map eq 
            where pk.parent_account_no in (
                                        SELECT   distinct(MAP.ACCOUNT_NO)
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
                                       AND B.BILL_PERIOD = 'M28'-- AUX_CICLO
                                       AND B.PREP_DATE > sysdate - 15
                                       AND B.PREP_STATUS = 4 --> 4 proforma 1 production
                                       AND B.PREP_ERROR_CODE is null
                                       --AND MAP.EXTERNAL_ID = 999979865472
                                       AND D.COMPONENT_ID in (SELECT to_number(COMPONENT_ID)
                                                                FROM GVT_VAL_PLANO)
            )
              and pk.inactive_dt is null
              and EQ.SUBSCR_NO = PK.PARENT_SUBSCR_NO
              and EQ.EXTERNAL_ID_TYPE = 6
              and EQ.INACTIVE_DATE is null
              and EQ.SUBSCR_NO_RESETS = PK.PARENT_SUBSCR_NO_RESETS
            and (pk.component_id in (SELECT component_id FROM BQ_TP_ARBOR_LOCAL) or component_id in (SELECT component_id FROM BQ_TP_ARBOR_FRANQUIA) or component_id in (SELECT to_number(COMPONENT_ID)FROM GVT_VAL_PLANO) or  component_id in (SELECT to_number(COMPONENT_ID)FROM GVT_VAL_PLANO_DADOS))
            and PK.PARENT_ACCOUNT_NO = 2678869

-----------------------

           select 
                  EQ.EXTERNAL_ID,
                  pk.COMPONENT_ID,
                  pk.PARENT_SUBSCR_NO,
                  pk.PARENT_ACCOUNT_NO,
                   count(1)
             from CMF_PACKAGE_COMPONENT pk, customer_id_equip_map eq 
            where pk.parent_account_no in (
                                        SELECT   distinct(MAP.ACCOUNT_NO)
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
                                       AND B.BILL_PERIOD = 'M28'-- AUX_CICLO
                                       AND B.PREP_DATE > sysdate - 15
                                       AND B.PREP_STATUS = 4 --> 4 proforma 1 production
                                       AND B.PREP_ERROR_CODE is null
                                       --AND MAP.EXTERNAL_ID = 999979865472
                                       AND D.COMPONENT_ID in (SELECT to_number(COMPONENT_ID)
                                                                FROM GVT_VAL_PLANO)
            )
              and pk.inactive_dt is null
              and EQ.SUBSCR_NO = PK.PARENT_SUBSCR_NO
              and EQ.EXTERNAL_ID_TYPE = 6
              and EQ.INACTIVE_DATE is null
              and EQ.SUBSCR_NO_RESETS = PK.PARENT_SUBSCR_NO_RESETS
            group by (pk.COMPONENT_ID,pk.PARENT_SUBSCR_NO,pk.PARENT_ACCOUNT_NO,EQ.EXTERNAL_ID)
            HAVING count(1) > 1
            and (pk.component_id in (SELECT component_id FROM BQ_TP_ARBOR_LOCAL) or component_id in (SELECT component_id FROM BQ_TP_ARBOR_FRANQUIA) or component_id in (SELECT to_number(COMPONENT_ID)FROM GVT_VAL_PLANO) or  component_id in (SELECT to_number(COMPONENT_ID)FROM GVT_VAL_PLANO_DADOS))
            --and PK.PARENT_ACCOUNT_NO = 2678869




SELECT   MAP.EXTERNAL_ID,
           B.BILL_PERIOD,
           C.BILL_STATE,
           d.element_id,
           d.bill_ref_no,
           eq.external_id "EQUIP",
           d.type_code,
           d.subtype_code,
           D.COMPONENT_ID,
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
           and EQ.EXTERNAL_ID_TYPE <> 1
           and EQ.EXTERNAL_ID_TYPE = 6
           AND D.SUBSCR_NO = EQ.SUBSCR_NO
           AND D.SUBSCR_NO_RESETS = EQ.SUBSCR_NO_RESETS
           AND MAP.ACCOUNT_NO = B.ACCOUNT_NO
           AND MAP.INACTIVE_DATE is null
           and EQ.INACTIVE_DATE is null
           AND C.ACCOUNT_NO = MAP.ACCOUNT_NO
           AND D.PROFILE_ID = PY.PROFILE_ID
           AND C.ACCOUNT_CATEGORY in (10,11)
           AND MAP.EXTERNAL_ID_TYPE = 1
           AND B.BILL_REF_NO = D.BILL_REF_NO
           AND B.BILL_REF_RESETS = D.BILL_REF_RESETS
           AND B.BILL_PERIOD = 'M28'
           and D.TYPE_CODE = 2
           AND B.PREP_DATE > sysdate - 15
           AND B.PREP_STATUS = 4 --> 4 proforma 1 production
           AND B.PREP_ERROR_CODE is null
           --AND MAP.EXTERNAL_ID = '999979865472'
           and MAP.ACCOUNT_NO = 1611086
           AND EQ.SUBSCR_NO = D.SUBSCR_NO
           order by 9
           
      select * from bill_invoice where account_no = 1611086 order by 2
           
           --AND EQ.SUBSCR_NO_RESETS = D.SUBSCR_NO_RESETS order by 6
           
      select * from product where parent_account_no = 1611086 
           
      select component_id,
      --max((select tira_acento(dt.DISPLAY_VALUE) from COMPONENT_DEFINITION_VALUES dt where CM.COMPONENT_ID = DT.COMPONENT_ID and dt.language_code = 2)) "COMPONENTE",
       count(1)
       from product cm where cm.parent_account_no = 1611086 and cm.PRODUCT_INACTIVE_DT is null 
       group by cm.component_id
       
       
       select *
       from product cm where cm.parent_account_no = 1611086 and cm.PRODUCT_INACTIVE_DT is null and COMPONENT_ID in (30679,29399) and OPEN_ITEM_ID = 1
       
       select * from COMPONENT_DEFINITION_VALUES dt where DT.COMPONENT_ID = 30679 and dt.language_code = 2
       
       select * from customer_id_equip_map where subscr_no in (2364852,2364853) and external_id_type = 6
       
      
      ---------------------------
      -- Produto faltando 
	  
	       select pk.COMPONENT_ID, EQ.EXTERNAL_ID , VL.DISPLAY_VALUE, count(1) total
             from CMF_PACKAGE_COMPONENT pk,
                  customer_id_equip_map eq,
                  COMPONENT_DEFINITION_VALUES vl
            where 1=1 --pk.parent_account_no = 7529061
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
            having count(1) > 2;
            
      -----------------------------------------
      -- busca produtos fora do Lavoisier
                select cm.*,
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
