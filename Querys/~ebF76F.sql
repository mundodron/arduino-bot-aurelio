--Natália Oliveira - SLM (G0029935)


select distinct y.account_no,
               y.external_id,
               y.bill_ref_no,
               y.image_number,
               y.valor_boleto,
               y.valor_fatura,
               y.data_de_ajuste,
               y.codigo,
               y.motivo
from (
      select distinct z.account_no,
                      z.external_id,
                      z.bill_ref_no,
                      z.image_number,
                      z.valor_boleto,
                      z.valor_fatura,
                      z.data_de_ajuste,
                      z.codigo,
                      z.motivo      
      from ( 
            select account_no,
                external_id,
                bill_ref_no,
                image_number,
                valor_boleto,
                valor_fatura,
                to_char(data_ajuste, 'dd/mm/yyyy') || ', ' || to_char(data_ajuste, 'Day', 'nls_date_language=portuguese') data_de_ajuste,
                motivo codigo,
                case
                  when motivo = 1 then
                   'Não consta ajuste no Kenan para a fatura; ' 
                  when motivo = 2 then
                   'O ajuste foi cancelado; ' 
                  when motivo = 3 then
                   'Ajustes para o tipo ' || tipo_ajuste || ' não geram boleto; ' 
                  when motivo = 4 then
                   'O valor do boleto é menor que R$ 5,00 (R$ ' || valor_boleto || '); ' 
                  when motivo = 5 then
                   'A fatura não foi enviada para a ABNC; ' 
                  when motivo = 6 then
                   'A Fatura já foi Paga.'  
                  when motivo = 7 then
                   'Arquivo de retorno da ABNC está corrompido.'  
                  when motivo = 8 then
                   'Boleto não retornou da ABNC;'
                  when motivo = 9 then
                   'Ajuste concedido no dia ' || trim(to_char(data_ajuste, 'dd/mm/yyyy, Day', 'nls_date_language=portuguese')) ||
                   '. Aguarde até o dia ' ||
                   trim(to_char(data_ajuste + decode(to_char(data_ajuste, 'd'), 6, 4, 7, 3, 2), 'dd/mm/yyyy, Day', 'nls_date_language=portuguese')) || '; '  
                  when motivo = 10 then
                   'Boleto está disponível no Visualizador. Verifique novamente.'  
                else
                   'Cenário não Mapeado.'  
                end motivo
            from (
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
                             and trunc(sysdate) - max(trunc(adj.transact_date)) < 20 then
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
                 where cba.bill_ref_no in (138208536,138498800,138681558,138697373,138704996,138704996,138817758,139104348,139107806,139251066,140177057,140901746,141071058,132178188,135234409,135234409,135392568,137628496,137641759,137680146,137693422,137715858,137769015,137795005,137901921,137955643,138031951,138084925,138176882,138188289,138199861,138239317,138255333,138294168,138311972,138332657,138407645,138675810,138692953,138704747,138704996,138705892,138709591,138744019,138744885,138776657,138779800,138782439,138864710,138879056,138907636,138971887,138971887,139104103,139107560,139108760,139108826,139111332,139111332,139111967,139114367,139116885,139122020,139129006,139136606,139141374,139148743,139149767,139150198,139156423,139167003,139177794,139182550,139219931,139223723,139224617,139231283,139242720,139244544,139246565,139248505,139249119,139286684,139287995,139296679,139328893,139335884,139352486,139355507,139359237,139410735,139410735,139410788,139434064,139434064,139592504,139601322,139602616,139662665,139668491,139682863,139687993,139736755,139741572,140023828,140026928,140027550,140030798,140032105,140033221,140036728,140059966,140103947,140116914,140147849,140163571,140167255,140464075,140477632,140507024,140528579,140533984,140692746,140717193,140717260,140985832)
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
                 order by motivo)
      where motivo is not null
      --and rownum=1
      order by motivo) z
      union
      select distinct x.account_no,
                       x.external_id,
                       x.bill_ref_no,
                       x.image_number,
                       x.valor_boleto,
                       x.valor_fatura,
                       x.data_de_ajuste,
                       x.codigo,
                       x.motivo
      from (
            select account_no,
                   external_id,
                   bill_ref_no,
                   image_number,
                   valor_boleto,
                   valor_fatura,
                   to_char(data_ajuste, 'dd/mm/yyyy') || ', ' || to_char(data_ajuste, 'Day', 'nls_date_language=portuguese') data_de_ajuste,
                   motivo codigo,
                   case
                          when motivo = 1 then
                           'Não consta ajuste no Kenan para a fatura; '
                          when motivo = 2 then
                           'O ajuste foi cancelado; '
                          when motivo = 3 then
                           'Ajustes para o tipo ' || tipo_ajuste || ' não geram boleto; '
                          when motivo = 4 then
                           'O valor do boleto é menor que R$ 5,00 (R$ ' || valor_boleto || '); '
                          when motivo = 5 then
                           'A fatura não foi enviada para a ABNC; '
                          when motivo = 6 then
                           'A fatura já foi paga.'
                          when motivo = 7 then
                           'Arquivo de retorno da ABNC está corrompido.'
                          when motivo = 8 then
                           'Boleto não retornou da ABNC;'
                          when motivo = 9 then
                           'Ajuste concedido no dia ' || trim(to_char(data_ajuste, 'dd/mm/yyyy, Day', 'nls_date_language=portuguese')) ||
                           '. Aguarde até o dia ' || trim(to_char(data_ajuste + decode(to_char(data_ajuste, 'd'), 6, 4, 7, 3, 2),
                                                                  'dd/mm/yyyy, Day',
                                                                  'nls_date_language=portuguese')) || '; '
                          when motivo = 10 then
                           'Boleto está disponível no visualizador. Verifique...'
                   else
                           'Cenário não mapeado. Verifique o arquivo de envio e de retorno da ABNC com a Produção Billing.'
                   end motivo
            from (
                  select /*+ ordered */
                        distinct cba.account_no,
                        eam.external_id,
                        b.orig_bill_ref_no bill_ref_no,
                        cba.new_charges / 100 valor_fatura,
                        max(trunc(b.trans_date)) data_ajuste,
                        d.description_text tipo_ajuste,
                        gvt.bill_draft_amount / 100 valor_boleto,
                        max(cuc.image_number) image_number,
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
                             and trunc(sysdate) - max(trunc(b.trans_date)) < 20 then
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
                   where cba.bill_ref_no in (138208536,138498800,138681558,138697373,138704996,138704996,138817758,139104348,139107806,139251066,140177057,140901746,141071058,132178188,135234409,135234409,135392568,137628496,137641759,137680146,137693422,137715858,137769015,137795005,137901921,137955643,138031951,138084925,138176882,138188289,138199861,138239317,138255333,138294168,138311972,138332657,138407645,138675810,138692953,138704747,138704996,138705892,138709591,138744019,138744885,138776657,138779800,138782439,138864710,138879056,138907636,138971887,138971887,139104103,139107560,139108760,139108826,139111332,139111332,139111967,139114367,139116885,139122020,139129006,139136606,139141374,139148743,139149767,139150198,139156423,139167003,139177794,139182550,139219931,139223723,139224617,139231283,139242720,139244544,139246565,139248505,139249119,139286684,139287995,139296679,139328893,139335884,139352486,139355507,139359237,139410735,139410735,139410788,139434064,139434064,139592504,139601322,139602616,139662665,139668491,139682863,139687993,139736755,139741572,140023828,140026928,140027550,140030798,140032105,140033221,140036728,140059966,140103947,140116914,140147849,140163571,140167255,140464075,140477632,140507024,140528579,140533984,140692746,140717193,140717260,140985832)
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
                   order by motivo)
      where motivo is not null
      --and rownum=1
      order by motivo) x) y
--where rownum = 1;
