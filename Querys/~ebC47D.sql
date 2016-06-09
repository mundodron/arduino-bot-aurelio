select 
    ciam.external_id, cmf.account_no, cmf.bill_period, 
    nk.bill_ref_no,
    gvt.dt_abertura, gvt.dt_fechamento, gvt.num_ss, gvt.desc_ss, gvt.dt_inclusao,
    gvt.valor_ressarc, nrc.rate, nrc.no_bill, nrc.annotation, nrc.annotation2, nrc.effective_date,
    nrc.tracking_id, nrc.tracking_id_Serv, nrc.view_id,
    'update nrc_view set rate = '||gvt.valor_ressarc||', annotation2 = ''Cen_xx - Valor Incorreto'' where view_id = '||nrc.view_id||';'
from arborgvt_billing.gvt_credito_interrupcao_log gvt
    join customer_id_acct_map ciam on ciam.external_id = gvt.external_id
    join cmf on cmf.account_no = ciam.account_no
    join nrc on nrc.billing_account_no = cmf.account_no and nrc.tracking_id = gvt.tracking_id and nrc.tracking_id_serv = gvt.tracking_id_serv and nrc.rate <> gvt.valor_ressarc
    join nrc_key nk on nk.tracking_id = nrc.tracking_id and nk.tracking_id_serv = nrc.tracking_id_serv and nk.bill_ref_no = 0
;


 select * from arborgvt_billing.gvt_credito_interrupcao_bkp
 
 select * from arborgvt_billing.gvt_credito_interrupcao_log