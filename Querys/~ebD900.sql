          select cm.*,EQ.EXTERNAL_ID,
                  (select tira_acento(dt.DISPLAY_VALUE) from COMPONENT_DEFINITION_VALUES dt where CM.COMPONENT_ID = DT.COMPONENT_ID and dt.language_code = 2) "COMPONENTE"
             from bill_invoice_detail cm, 
                  customer_id_equip_map eq
            where cm.bill_ref_no = 197039119
              and CM.SUBSCR_NO = 22828073
              and EQ.INACTIVE_DATE is null
              and EQ.EXTERNAL_ID_TYPE <> 1
              and CM.TYPE_CODE = 2
              and EQ.EXTERNAL_ID_TYPE in (6,7)
              and CM.SUBSCR_NO = EQ.SUBSCR_NO
              and CM.SUBSCR_NO_RESETS = EQ.SUBSCR_NO_RESETS
              and cm.component_id not in (SELECT to_number(COMPONENT_ID)FROM g0023421sql.GVT_VAL_PLANO)
              and cm.component_id not in (SELECT to_number(COMPONENT_ID)FROM g0023421sql.GVT_VAL_PLANO_DADOS)
              and (cm.component_id in (SELECT component_id FROM BQ_TP_ARBOR_LOCAL) or component_id in (SELECT component_id FROM BQ_TP_ARBOR_FRANQUIA))
              and EXISTS (SELECT 1 FROM CMF_PACKAGE_COMPONENT pk WHERE CM.COMPONENT_ID = PK.COMPONENT_ID and PK.PARENT_SUBSCR_NO = 22828073 and PK.INACTIVE_DT is null );
              
              select * from product where billing_account_no = 1475811 and COMPONENT_ID = 30362
              
              select * from bill_invoice_detail where subscr_no = 22828073 and bill_ref_no = 197039119 and COMPONENT_ID = 30490 
              
              --C3 Produto fora do Plano;899998913679;8253644;4135572313;197039119;29509;Assinatura Mensal sem Minutos - Max GVT,22828073
              
              --C2 Duplicidade;999993332892;1475811;5430284841;198581342;30362;GVT Ilimitado Local Casa - Franquia Mensal; Total=2
              --C2 Duplicidade;999993332892;1475811;5430284841;198581342;30490;25 Cidade Local - Instância; Total=2
              
              