SELECT   *
  FROM   g0023421sql.gvt_val_plano a
 WHERE   a.plano = 'GVT - Na Medida Casa' AND a.tipoelemento = 'RC - Conta'
         AND NOT EXISTS
               (SELECT   1
                  FROM   cmf_package_component cpc
                 WHERE       cpc.parent_account_no = 7345220
                         AND CPC.INACTIVE_DT IS NULL
                         AND a.component_id = cpc.component_id)
UNION
SELECT   *
  FROM   g0023421sql.gvt_val_plano a
 WHERE   a.plano = 'GVT - Na Medida Casa' AND a.tipoelemento <> 'RC - Conta'
         AND NOT EXISTS
               (SELECT   1
                  FROM   cmf_package_component cpc
                 WHERE       cpc.parent_subscr_no = 19535443
                         AND CPC.INACTIVE_DT IS NULL
                         AND a.component_id = cpc.component_id)
                         
                         
                     select * from gvt_val_plano