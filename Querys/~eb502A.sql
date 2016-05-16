--÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷ ¤¤°°±±
-- Mostra o motivo pelo qual o PDF do boleto não está disponível no Visualizador.
-- -----------------------------------------------------------------------------
--÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷

Select
  cba_account_no
, external_id
, adj_orig_bill_ref_no   bill_ref_no
, valor_boleto
, nvl((select -sum(nvl(dis.amount,0)) from bmf_distribution dis  where dis.orig_bill_ref_no = adj_orig_bill_ref_no),0)  valor_creditos
, to_char(data_ajuste,'dd/mm/yyyy')||', '||to_char(data_ajuste, 'Day', 'nls_date_language=portuguese') data_de_ajuste
, to_char(data_envio_abnc,'dd/mm/yyyy')  data_prov_envio
, data_pgto
--, substr(motivo,1,2) motivo
, case 
			 when (Select 1 
			         from customer_care cuc, sin_seq_no sin 
							where sin.bill_ref_no = adj_orig_bill_ref_no
							  and trim(cuc.numero_fatura) = sin.full_sin_seq
                and cuc.codigo_cliente = trim(external_id)
                and cuc.image_type = 2
								and rownum = 1) = 1 then 'Boleto está no Visualizador. Verifique...'
       -------------
       when (Select max(menor.quando) quando
               from gvt_log_cmf menor
              where menor.old_no_bill = 0
                and menor.new_no_bill = 1
                and menor.account_no = cba_account_no
                and menor.quando <= data_ajuste + decode(to_char(data_ajuste,'d'),6,3,7,2,1)
                and not exists (
                                 Select maior.quando
                                   from gvt_log_cmf maior
                                  where maior.old_no_bill = 1
                                    and maior.new_no_bill = 0
                                    and maior.account_no = cba_account_no
                                    and maior.quando <= data_ajuste + decode(to_char(data_ajuste,'d'),6,3,7,2,1)
                                    and maior.quando >= menor.quando
                                )  ) is not null  then 'A conta estava em NO_BILL quando houve o ajuste;'
       -------------
       when nvl((select -sum(nvl(dis.amount,0)) from bmf_distribution dis  where dis.orig_bill_ref_no = adj_orig_bill_ref_no),0) > 0 and
            nvl((select -sum(nvl(dis.amount,0)) from bmf_distribution dis  where dis.orig_bill_ref_no = adj_orig_bill_ref_no),0) = valor_boleto
                         then 'Foi distribuido um crédito que zerou a fatura;'
       -------------
       else substr(motivo,5)
  end   motivo_descr
From (
Select /*+ ordered */
  cba.account_no                 cba_account_no
, trim(eam.external_id)          external_id
, adj.orig_bill_ref_no           adj_orig_bill_ref_no
, max(trunc(adj.transact_date))  data_ajuste
, max(trunc(adj.transact_date))   + decode(to_char(max(trunc(adj.transact_date)),'d'),6,3,7,2,1)   data_envio_abnc
, cba.ppdd_date                  data_pgto
, arv.display_value              tipo_ajuste
, (cba.NEW_CHARGES + nvl(cba.TOTAL_ADJ,0))  valor_boleto
  ---------------- acumulado solução
, case when adj.orig_bill_ref_no is null                                        then '01 - Não consta ajuste no Kenan para a fatura; '
       when (cba.NEW_CHARGES + nvl(cba.TOTAL_ADJ,0) + cba.TOTAL_PAID) /100 = 0  then '06 - A Fatura já foi Paga. Portanto não será gerado o Boleto;'
       when adj.adj_reason_code between 0 and 899                               then '03 - Ajustes para o tipo "'||arv.display_value||'" não geram Boleto; '
       when (trunc(sysdate) - max(trunc(adj.transact_date))) <= 
            decode(to_char(max(trunc(adj.transact_date)),'d'),6,4,7,3,2)        then '09 - Ajuste concedido no dia '||trim(to_char(max(trunc(adj.transact_date)),'dd/mm/yyyy, Day', 'nls_date_language=portuguese'))||'. Aguarde até o dia '||trim(to_char(max(trunc(adj.transact_date))+decode(to_char(max(trunc(adj.transact_date)),'d'),6,4,7,3,2),'dd/mm/yyyy, Day', 'nls_date_language=portuguese'))||'; '
       when cba.NEW_CHARGES + nvl(cba.TOTAL_ADJ,0) between 000 and 500          then '04 - O valor do boleto é Menor que R$ 5,01 (R$ '||(cba.NEW_CHARGES + nvl(cba.TOTAL_ADJ,0))||'); '
       when ban.status = '5'                                                    then '52 - O valor do boleto é Menor que R$ 5,01 (pl0201); '
       when ban.status = 'P'                                                    then '51 - A pl0201 encontrou um problema neste boleto... esperando reprocessamento para corrigir; '
       when ban.status = 'D'                                                    then '53 - A pl0201 detectou uma re-geração do mesmo Boleto, e abortou a geração deste; '
       when max(trunc(adj.transact_date)) > to_date('131009','ddmmrr') and
            gid.external_id is null                                             then '05 - A fatura não enviada para ABNC; '
       when max(trunc(adj.transact_date)) > to_date('23112009','ddmmyyyy') and
            gic.tot_contas_perdidas = 0                                         then '07 - Arquivo de retorno da ABNC pode estar corrompido;'
       when max(trunc(adj.transact_date)) > to_date('23112009','ddmmyyyy') and
            nvl(gid.gvt_file_name,'.') <> 'YES'                                 then '08 - Boleto não retornou da ABNC;'
     --when ban.bill_ref_no is null                                             then '50 - Boleto não foi gerado pela pl0201; '
       else                                                                          '20 - Cenário não Mapeado. Verifique: o arquivo de envio e de retorno da ABNC com a Produção.'
  end   motivo
  ----------------
from CMF_BALANCE             cba
    ,gvt_bankslip            ban
    ,ADJ                     adj
    ,cmf                     cmf
    ,GVT_BILL_INVOICE_TOTAL  gbi
    ,GVT_INVOICE_CONTROL     gic
    ,gvt_invoice_control_detail gid
    ,adj_reason_code_values  arv
    ,customer_id_acct_map    eam
where cba.bill_ref_no in (134951053,135063274,135063310,135069756,135069756,135073435,135074156,135075442,135092785,135097439,135100279,135100307,135101987,135103031,135113526,135114161,135152165,135153357,135154492,135167611,135187276,135187488,135218665,135225948,135228184,135230151,135240895,135243962,135262202,135354783,135366469,135371948,135387827,135423775,135369307,135387827,135591389,135614272,135621247,135666773,135669677,135866883,135900840,135930665,135930665,136015711,136284732,136303028,136386988,136581556,136864642,137325460,137362731,137394967,137409397,137415776,137556010,137687958,121616814,132294486,133470772,133570279,133675290,133691545,133713448    ,133737546,133784091,133884786,134171527,134174396,134239969,134393512,134582929,134627636,134642699,134661709,134733146,134739374,134746773,134836456,134839693,134850119,134862509,134901676,134941735,135923721,135927715,135928282,135929040,135929871,135930375,135945241,135949075,135956674,135975189,135980477,135982400,135996089,136006630,136013757,136021984,136023700,136045624,136047565,136047565,136072493,136081885,136091932,136099516,136101351,136120994,136131156,136147918,136147918,136162027,136181288,136184706,136282041,136286704,136289639,136294751,136298398,136298957,136302470,136303144,136309240,136310327,136310695,136310806,136317024,136319902,136320736,136321143,136322571,136326432,136326820,135508110,135510356,135569710,135569710,135573979,135576794,135582523,135585927,135591358,135592195,135594886,135598388,135598597,135602149,135602663,135604246,135607282,135609964,135611775,135615014,135615014,135617397,135618983,135619253,135619327,135621851,135625270,135630267,135638177,135640770,135640777,135643536,135646554,135649763,135651726,135651808,135653468,135659092,135663392,135663392,135663392,135668470,135678799,135690584,135690584,135697918,135721726,135731204,135732110,135732429,135734786,135737175,135739557,135742567,135742794,135742794,135750030,135750030,135756192,135757890,135759152,135760962,135850870,135851209,135858627,135859391,135859391,135859520,135865511,135870812,135871599,135872736,135874304,135876701,135878515,135881942,135892548,135893772,135895318,135901916,135903830,135903830,135914938,135916411,135923351,136395831,136401235,136405155,136409028,136413269,136415601,136416008,136416713,136416761,136420060,136421812,136422337,136442668,136445533,136450957,136451767,136461516,136462654,136687878,136691246,136697596,136699196,136713883,136735526,136792107,136800361,136814276,136820274,136836355,136899223,136904376,136904621,136905649,136919255,136920989,136923246,136934533,136979178,136980155,136983685,136984386,136988615,137007399,137007621,137007621,137014979,137014979,137017004,137023097,137032243,137034535,137052754,137053305,137053305,137055819,137066173,137083668,137085388,137088927,137097220,137117427,137143508,137197001,137199167,137201076,137202156,137203011,137206936,136477232,136479841,136484447,136502464,136503570,136505834,136506877,136508577,136512553,136512748,136512855,136518678,136522860,136528015,136535124,136541176,136554550    ,136555909,136568563,136570975,136575476,136577194,136586419,136591904,136594464,136594464,136607587,136610055,136619792,136651812,136652562,136656434,136662796,136669142,136326820,136339238,136349682,136349850,136355118,136363697,136363697,136370125,136372046,136372122,136375621,136376022,136377090,136383320,136388877,136394629,136395064,137932478,137941072,137967508,137979505,137984468,137995802,138001456,138019232,138042986,138059788,138072102,138074512,138181291,138186431,138196584,138199206,138217004,138221295,138221295,138412416,138413126,138421328,138427057,138440631,138563689,138567115,138585727,137207612,137212630,137230827,137244552,137246506,137257117,137271544,137272499,137275561,137286358,137287671,137292867,137305936,137359290,137366386,137390535,137390535,137395914,137410500,137412569,137423362,137428565,137429351,137441060,137445748,137461736,137470958,137489589,137491841,137516925,137527200,137531037,137541216,137551195,137552137,137557637,137632468,137632929,137636135,137638447,137638447,137638655,137647840,137658767,137674257,137685505,137691051,137699366,137700198,137706263,137720603,137722211,137728041,137728041,137730020,137732352,137737270,137750182,137760775,137761739,137763958,137764316,137764316,137765452,137769141,137769141,137772652,137779112,137779960,137780137,137783872,137786225,137790084,137791420,137793531,137795278,137806811,137809384,137829387,137850236,137872661,137894243,137903954,137915851,137932478)
  and cba.bill_ref_resets = 0
  ---
  and ban.bill_ref_no(+) = cba.bill_ref_no
  and ban.bill_ref_resets(+) = cba.bill_ref_resets
  ---
  and cba.account_no       = adj.account_no(+)
  and cba.bill_ref_no      = adj.orig_bill_ref_no(+)
  and cba.bill_ref_resets  = adj.orig_bill_ref_resets(+)
  ---
  and adj.orig_bill_ref_no = gbi.bill_ref_no(+)
  and adj.orig_bill_ref_resets = gbi.bill_ref_resets(+)
  and adj.account_no = cmf.account_no(+)
  and gic.bill_period(+) = gid.bill_period
  and gic.gvt_account_type(+) = gid.gvt_account_type
  and gic.gvt_date(+) = gid.gvt_date
  and gic.gvt_mode(+) = gid.gvt_mode
  ---
  and gid.gvt_mode(+) = 'BOLETO'
  and cba.bill_ref_no = gid.bill_ref_no(+)
  and cba.bill_ref_resets = gid.bill_ref_resets(+)
  ---
  and arv.adj_reason_code(+) = adj.adj_reason_code
  and arv.language_code(+) = 2
  ---
  and eam.account_no(+) = cba.account_no
  and eam.external_id_type(+) = 1
  ---
group by 
  cba.account_no
, trim(eam.external_id) --external_id
, adj.orig_bill_ref_no  --bill_ref_no
, adj.orig_bill_ref_no
, cba.ppdd_date
, adj.no_bill
, adj.adj_reason_code
, cba.NEW_CHARGES
, nvl(cba.TOTAL_ADJ,0)
--, max(trunc(adj.transact_date))
, gid.external_id
--, trunc(sysdate) - max(trunc(adj.transact_date)) 
, (cba.NEW_CHARGES + nvl(cba.TOTAL_ADJ,0) + cba.TOTAL_PAID) /100
, arv.display_value
, gic.tot_contas_perdidas
, gid.gvt_file_name
, ban.bill_ref_no
, ban.status
order by adj.orig_bill_ref_no
)
where motivo is not null
order by motivo_descr

