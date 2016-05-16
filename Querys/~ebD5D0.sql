select *
from (
    select /*+ parallel(cdu 16) full(cdu) use_nl(cdu,cmf) */ 
        -- informações padrão 
        ciam.external_id conta, 
        cmf.bill_period ciclo,
        to_number(substr(dbms_reputil.global_name,-1)) kenan_db_id,
           account_category segmento,
           cdu.msg_id, 
           cd.msg_id2, 
           cdu.msg_id_serv,
           cdu.account_no,
           cdu.subscr_no, 
           cd.point_origin origem,
           cd.point_target destino,
           cdu.trans_dt data_chamada,
           cd.second_units duracao,
           cd.type_id_usg uso,
           row_number () over(partition by cd.point_target order by cd.point_target) rank
    from  
        cdr_data  cd,
        cdr_unbilled cdu,   
        cmf, 
        customer_id_acct_map ciam
    where 1=1
    and cdu.type_id_usg in(925,926,927)
    and cdu.rate_dt >= trunc(sysdate-90)
    and cdu.account_no = cmf.account_no
    and cd.msg_id = cdu.msg_id
    and cd.msg_id2 = cdu.msg_id2
    and cd.msg_id_serv = cdu.msg_id_serv
    and cd.split_row_num = cdu.split_row_num
    and cd.account_no = cmf.account_no
    and cd.no_bill = 0
    and cmf.account_category in (10,11)
    AND UPPER(cmf.bill_period) in (SELECT BILL_PERIOD FROM GVT_PROCESSAMENTO_CICLO WHERE PROCESSAMENTO = UPPER('P19')) --&2
    --and cmf.bill_period in (##ciclos##)
    and ciam.account_no = cmf.account_no
    and ciam.external_id_type = 1
    and ciam.is_current = 1
)
where rank > 1;