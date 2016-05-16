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
                 where cba.bill_ref_no in (134584164,134670167,135369307,135387827,135614272,135669677,135866883,135900840,135930665,135930665,136015711,136284732,136303028,136310656,136864642,137325460,137362731,137394967,137481600,137556010,137687958,121616814,130017872,133177164,133570279,133713448,133737546,133758192,133764533,133764533,133855513,133986501,134046400,134190027,134862509,134901676,134941735,135075849,135099148,135187276,135240895,135251720,135262202,135371948,135372536,135387827,135478580,135573979,135581884,135582523,135592195,135594886,135607282,135609964,135617397,135619253,135619327,135622033,135630267,135646554,135649166,135653468,135660734,135678799,135689177,135690584,135690584,135697918,135711334,135734786,135739557,135742567,135745058,135756192,135759152,135857170,135870812,135872736,135877558,135882387,135895318,135902974,135923351,135923721,135926769,135928282,135945241,135949075,136006630,136021984,136045624,136047565,136081885,136147918,136147918,136169337,136181288,136289639,136295439,136298957,136302470,136303144,136310327,136317368,136319902,136321143,136326215,136326432,136326820,136326820,136339238,136349682,136349850,136363697,136363697,136363884,136375621,136386796,136388487,136405155,136416761,136420060,136422337,136442668,136503354,136503570,136506877,136518678,136519432,136528015,136535124,136541176,136554550,136556324,136570975,136586419,136593412,136607587,136651812,136669142,136691246,136792107,136793555,136797462,136828032,136828478,136831845,136904376,136905649,136919255,136923246,136979178,136983685,136991541,137007621,137014655,137042625,137042625,137051016,137052754,137053305,137053305,137085388,137097220,137117427,137202522,137203011,137206519,137206936,137212630,137230827,137246506,137272499,137275561,137275561,137286358,137287671,137292867,137305936,137359290,137371003,137390924,137393508,137395914,137408148,137423362,137428565,137441060,137445748,137471259,137516925,137517094,137522928,137529948,137552137,137557637,137632468,137632929,137638655,137660508,137660508,137664112,137728041,137728041,137730020,137748595,137750182,137764316,137769964,137772652,137779112,137783872,137786225,137791420,137803790,137803790,137850236,137894243,137932478,137941072,137967508,137979505,138010116,138037367,138095747,138199206,138217004,138221295,138221295,138306805,138412416,138421328,138427057,138440631,138563689,138567115,138585727)
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
                             and cuc.data_emissao - max(trunc(b.trans_date)) < 20 then
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
                   where cba.bill_ref_no in (134584164,134670167,135369307,135387827,135614272,135669677,135866883,135900840,135930665,135930665,136015711,136284732,136303028,136310656,136864642,137325460,137362731,137394967,137481600,137556010,137687958,121616814,130017872,133177164,133570279,133713448,133737546,133758192,133764533,133764533,133855513,133986501,134046400,134190027,134862509,134901676,134941735,135075849,135099148,135187276,135240895,135251720,135262202,135371948,135372536,135387827,135478580,135573979,135581884,135582523,135592195,135594886,135607282,135609964,135617397,135619253,135619327,135622033,135630267,135646554,135649166,135653468,135660734,135678799,135689177,135690584,135690584,135697918,135711334,135734786,135739557,135742567,135745058,135756192,135759152,135857170,135870812,135872736,135877558,135882387,135895318,135902974,135923351,135923721,135926769,135928282,135945241,135949075,136006630,136021984,136045624,136047565,136081885,136147918,136147918,136169337,136181288,136289639,136295439,136298957,136302470,136303144,136310327,136317368,136319902,136321143,136326215,136326432,136326820,136326820,136339238,136349682,136349850,136363697,136363697,136363884,136375621,136386796,136388487,136405155,136416761,136420060,136422337,136442668,136503354,136503570,136506877,136518678,136519432,136528015,136535124,136541176,136554550,136556324,136570975,136586419,136593412,136607587,136651812,136669142,136691246,136792107,136793555,136797462,136828032,136828478,136831845,136904376,136905649,136919255,136923246,136979178,136983685,136991541,137007621,137014655,137042625,137042625,137051016,137052754,137053305,137053305,137085388,137097220,137117427,137202522,137203011,137206519,137206936,137212630,137230827,137246506,137272499,137275561,137275561,137286358,137287671,137292867,137305936,137359290,137371003,137390924,137393508,137395914,137408148,137423362,137428565,137441060,137445748,137471259,137516925,137517094,137522928,137529948,137552137,137557637,137632468,137632929,137638655,137660508,137660508,137664112,137728041,137728041,137730020,137748595,137750182,137764316,137769964,137772652,137779112,137783872,137786225,137791420,137803790,137803790,137850236,137894243,137932478,137941072,137967508,137979505,138010116,138037367,138095747,138199206,138217004,138221295,138221295,138306805,138412416,138421328,138427057,138440631,138563689,138567115,138585727)
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
      order by motivo) x) y;
--where rownum = 1;
