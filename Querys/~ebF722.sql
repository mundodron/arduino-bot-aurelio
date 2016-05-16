select /*+ ordered */
                        distinct cba.account_no,
                        eam.external_id,
                        b.orig_bill_ref_no bill_ref_no,
                        cba.new_charges / 100 valor_fatura,
                        max(trunc(b.trans_date)) data_ajuste,
                        d.description_text tipo_ajuste,
                        gvt.bill_draft_amount / 100 valor_boleto,
                        max(cuc.image_number) image_number,
                        cuc.data_emissao,
                        case
                             when b.orig_bill_ref_no is null then
                             01
                             when b.no_bill = 1 then
                             02
                             when b.bmf_trans_type not in
                             (-278, -277, -276, -275, -274, -224, -223, -262, -261, -260, -259, -258, -257, -256, -255) then
                             03
                             when gvt.bill_draft_amount between 001 and 500 then
                             04
                             when gvt.status in ('P', 'R', 'T') then
                             05
                             when (cba.new_charges + nvl(cba.total_adj, 0) + cba.total_paid) / 100 = 0 then
                             06
                             when rcb.full_sin_seq = nfst.full_sin_seq then
                             07
                             when cuc.numero_fatura is null
                             and cuc.image_type = 2 then
                             08
                             when (trunc(sysdate) - max(trunc(b.trans_date))) <= decode(to_char(max(trunc(b.trans_date)), 'd'), 6, 4, 7, 3, 2) then
                             09
                             when cuc.valor_fatura * 100 = gvt.bill_draft_amount
                             and cuc.data_emissao - max(trunc(b.trans_date)) < 28
                             --and to_date('20/03/2013', 'DD/MM/YYYY') - max(trunc(b.trans_date)) < 20 
                              then
                             10
                        else
                             20
                        end motivo
                  from cmf_balance                              cba,
                       bmf                                      b,
                       customer_id_acct_map                     eam,
                       customer_care                            cuc,
                       gvt_bankslip                             gvt,
                       gvt_bill_invoice_nfst                    nfst,
                       retorno_corrompidas_bankslip             rcb,
                       bmf_trans_descr                          btd,
                       descriptions                             d
                   where cba.bill_ref_no = 137420873-- in (select bill_ref_no from gvt_bankslip where sequencial = 1195)
                   and cba.bill_ref_resets = 0
                   and cba.account_no = b.account_no
                   and cba.bill_ref_no = b.orig_bill_ref_no
                   and b.bmf_trans_type in (-289,-288,-287,-286,-285,-278,-277,-276,-275,-274,
                                            -234,-235,-236,-237,-238,-239,-246,-247,-248,-249,
                                            -224,-223,-262,-261,-260,-259,-258,-257,-256,-255)
                   and b.bmf_trans_type = btd.bmf_trans_type
                   and btd.description_code = d.description_code
                   and d.language_code = 2
                   and eam.account_no = cba.account_no
                   and eam.external_id_type = 1
                   and b.orig_bill_ref_no = gvt.bill_ref_no(+)
                   and b.orig_bill_ref_resets = gvt.bill_ref_resets(+)
                   and b.account_no = gvt.account_no(+)
                   and cuc.codigo_cliente(+) = trim(gvt.external_id_a)
                   and cuc.image_type(+) = 2
                   and nfst.bill_ref_no = cba.bill_ref_no
                   and nfst.full_sin_seq = rcb.full_sin_seq(+)
                   group by cba.account_no,
                            eam.external_id,
                            b.orig_bill_ref_no,
                            cuc.valor_fatura,
                            gvt.bill_draft_amount,
                            b.no_bill,
                            b.bmf_trans_type,
                            b.trans_date,
                            d.description_text,
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