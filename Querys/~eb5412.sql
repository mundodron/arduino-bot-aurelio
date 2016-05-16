--Produto fora do Plano         
 select cm.*,EQ.EXTERNAL_ID,
                  (select tira_acento(dt.DISPLAY_VALUE) from COMPONENT_DEFINITION_VALUES dt where CM.COMPONENT_ID = DT.COMPONENT_ID and dt.language_code = 2) "COMPONENTE"
             from CMF_PACKAGE_COMPONENT cm, 
                  customer_id_equip_map eq
            where cm.parent_account_no = 7345220
              and cm.inactive_dt is null
              and EQ.INACTIVE_DATE is null
              and EQ.EXTERNAL_ID_TYPE <> 1
              and EQ.EXTERNAL_ID_TYPE in (6,7)
              and CM.PARENT_SUBSCR_NO = EQ.SUBSCR_NO
              and CM.PARENT_SUBSCR_NO_RESETS = EQ.SUBSCR_NO_RESETS
              --and component_id not in (SELECT to_number(COMPONENT_ID)FROM GVT_VAL_PLANO)
              --and component_id not in (SELECT to_number(COMPONENT_ID)FROM GVT_VAL_PLANO_DADOS)
              --and (component_id in (SELECT component_id FROM BQ_TP_ARBOR_LOCAL) or component_id in (SELECT component_id FROM BQ_TP_ARBOR_FRANQUIA))
              
              
          -- C_BUSCA_PROD_FALTANDO    
          select cm.*,EQ.EXTERNAL_ID,
                  (select tira_acento(dt.DISPLAY_VALUE) from COMPONENT_DEFINITION_VALUES dt where CM.COMPONENT_ID = DT.COMPONENT_ID and dt.language_code = 2) "COMPONENTE"
             from CMF_PACKAGE_COMPONENT cm, 
                  customer_id_equip_map eq
            where cm.parent_account_no = 7345220
              and cm.inactive_dt is null
              and EQ.INACTIVE_DATE is null
              and EQ.EXTERNAL_ID_TYPE <> 1
              and EQ.EXTERNAL_ID_TYPE in (6,7)
              and CM.PARENT_SUBSCR_NO = EQ.SUBSCR_NO
              and CM.PARENT_SUBSCR_NO_RESETS = EQ.SUBSCR_NO_RESETS
              --and (component_id in (SELECT to_number(COMPONENT_ID)FROM GVT_VAL_PLANO) or component_id in (SELECT to_number(COMPONENT_ID)FROM GVT_VAL_PLANO_DADOS))
              --and (component_id in (SELECT component_id FROM BQ_TP_ARBOR_LOCAL) or component_id in (SELECT component_id FROM BQ_TP_ARBOR_FRANQUIA));
              
              select * 
                from gvt_val_plano
                
              select * 
                from gvt_val_plano_dados
                where component_id = 23297 -- (nao)
                
               
              
              select * from gvt_val_plano_dados
              
              
              select * from GVT_VAL_PLANO where plano = 'GVT - Na Medida Casa'
              
              select * from gvt_val_plano where component_id = 30367
              
