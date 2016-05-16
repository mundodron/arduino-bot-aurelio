        SELECT   A.COMPONENT_ID, tira_acento(A.COMPONENTE) as COMPONENTE
          FROM   g0023421sql.gvt_val_plano a
         WHERE   a.plano = (select plano from gvt_val_plano where component_id = 30368) 
           AND a.tipoelemento = 'RC - Conta'
                 AND NOT EXISTS
                       (SELECT   1
                          FROM   cmf_package_component cpc
                         WHERE       cpc.parent_account_no = 4623292
                                 AND CPC.INACTIVE_DT IS NULL
                                 AND a.component_id = cpc.component_id)
        UNION
       SELECT   A.COMPONENT_ID, tira_acento(A.COMPONENTE) as COMPONENTE
          FROM   g0023421sql.gvt_val_plano a
         WHERE   a.plano = (select plano from gvt_val_plano where component_id = 30368) 
           AND a.tipoelemento <> 'RC - Conta'
                 AND NOT EXISTS
                       (SELECT   1
                          FROM   cmf_package_component cpc
                         WHERE       cpc.parent_subscr_no = 12350600
                                 AND CPC.INACTIVE_DT IS NULL
                                 AND a.component_id = cpc.component_id);
                                 
                                 
                                 
select * from gvt_val_plano where component_id = 30368  ;        


select *
from gvt_val_plano
where plano = 'GVT Ilimitado Local Casa';                       