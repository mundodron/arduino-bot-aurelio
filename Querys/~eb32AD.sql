             NRC_INSERT (
                v_account_no                => 442642,
                v_subscr_no                 => 407888,
                v_subscr_no_resets          => 0,
                v_element_id                => NULL,
                v_sales_channel_id          => 1, --> canal de vendas 1
                v_type_id_nrc               => n.nrc, --> tipo da NRC
                v_rate                      => 300,
                v_eff_date                  => TO_DATE(TO_CHAR(SYSDATE,'DD/MM/YYYY')||' 12:25:00','DD/MM/YYYY HH24:MI:SS'), --> EFFECTV_DT
                v_chg_who                   => 'PL_GERA_INTERRUPCAO_NRC', --RFC 426127
                v_annotation                => 'PL_GERA_INTERRUPCAO_NRC '||TO_CHAR(SYSDATE,'DD/MM/YYYY HH24:MI:SS'), --RFC 426127
                v_component_id              => 0,
                v_tracking_id               => v_tracking_id,
                v_tracking_id_serv          => v_tracking_id_serv,
                v_open_item_id              => n.open_item_id, --RFC 426127
                v_request_status            => 1,
                v_contract_tracking_id      => NULL,
                v_contract_tracking_id_serv => NULL,
                v_contract_association_type => 0
             );



insert into ARBORGVT_BILLING.gvt_credito_interrupcao_carga
select  NUM_SS,
        EXTERNAL_ID,
        DT_ABERTURA,
        DT_FECHAMENTO,
        null TIPO_ID,
        null TIPO,
        TIPO_PRODUTO,
        null DESCRICAO,
        DESC_SS,
        DT_INCLUSAO
 from ARBORGVT_BILLING.GVT_CREDITO_INTERRUPCAO_bkp

select * from ARBORGVT_BILLING.gvt_credito_interrupcao_carga

select * from ARBORGVT_BILLING.GVT_CREDITO_INTERRUPCAO_LOG
