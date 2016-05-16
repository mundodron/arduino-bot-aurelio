 select /*+ ordered */
                    cba.account_no,
                    trim(eam.external_id) external_id,
                    adj.orig_bill_ref_no bill_ref_no,
                    cba.new_charges / 100 valor_fatura,
                    max(trunc(adj.transact_date)) data_ajuste,
                    arv.display_value tipo_ajuste,
                    gvt.bill_draft_amount/100 valor_boleto,
                    max(cuc.image_number) image_number,
                    case
                        when adj.orig_bill_ref_no is null then
                        01
                        when adj.no_bill = 1 then
                        02
                        when adj.adj_reason_code between 0 and 899 then
                        03
                        when cba.new_charges + nvl(cba.total_adj, 0) between 001 and 500 then
                        04
                        when gvt.status in ('P', 'R', 'T') then
                        05
                        when (cba.new_charges + nvl(cba.total_adj, 0) + cba.total_paid) / 100 = 0 then
                        06
                        when rcb.full_sin_seq = nfst.full_sin_seq then
                        07
                        when cuc.numero_fatura is null and cuc.image_type = 2 then
                        08
                        when (trunc(sysdate) - max(trunc(adj.transact_date))) <= decode(to_char(max(trunc(adj.transact_date)), 'd'), 6, 4, 7, 3, 2) then
                        09
                        when cuc.valor_fatura * 100 = gvt.bill_draft_amount
                             and cuc.data_emissao - max(trunc(adj.transact_date)) < 20 then
                        10
                        else
                        20
                    end motivo
                 from cmf_balance                cba,
                      adj                        adj,
                      adj_reason_code_values     arv,
                      customer_id_acct_map       eam,
                      customer_care              cuc,
                      gvt_bankslip               gvt,
                      gvt_bill_invoice_nfst      nfst,
                      retorno_corrompidas_bankslip rcb
                 where cba.bill_ref_no = 137420873 -- (select bill_ref_no from gvt_bankslip where sequencial = 1195)
                 and cba.bill_ref_resets = 0
                 and cba.account_no = adj.account_no(+)
                 and cba.bill_ref_no = adj.orig_bill_ref_no(+)
                 and cba.bill_ref_resets = adj.orig_bill_ref_resets(+)
                 and arv.adj_reason_code(+) = adj.adj_reason_code
                 and arv.language_code(+) = 2
                 and  eam.account_no(+) = cba.account_no
                 and eam.external_id_type(+) = 1
                 and adj.orig_bill_ref_no = gvt.bill_ref_no(+)
                 and adj.orig_bill_ref_resets = gvt.bill_ref_resets(+)
                 and adj.account_no = gvt.account_no(+)
                 and cuc.codigo_cliente(+) = trim(gvt.external_id_a)
                 and cuc.image_type(+) = 2
                 and nfst.bill_ref_no = cba.bill_ref_no
                 and nfst.full_sin_seq = rcb.full_sin_seq(+)
                 --and motivo = 20
                 group by cba.account_no,
                      eam.external_id,
                      adj.orig_bill_ref_no,
                      cuc.valor_fatura,
                      gvt.bill_draft_amount,
                      adj.no_bill,
                      adj.transact_date,
                      arv.display_value,
                      adj.adj_reason_code,
                      cba.new_charges,
                      cba.total_adj,
                      cba.total_paid,
                      cuc.data_emissao,
                      rcb.full_sin_seq,
                      nfst.full_sin_seq,
                      gvt.status,
                      cuc.numero_fatura,
                      cuc.image_type,
                      gvt.bill_ref_no,
                      gvt.external_id_a
                 order by motivo