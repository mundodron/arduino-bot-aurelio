select a.cod_parce, a.des_regis, a.des_contr, a.ind_pagto, i.cod_conteudo_indicador from tbl_parcelamento a, tbl_registros_indicadores i
where a.cod_produ = '1'
and i.cod_campa = '1'
and i.des_regis = a.des_regis
--and i.cod_indicador = 'MIGCYBER'
--and a.ind_pagto = 'Q'--quebrada
-- A caixa � enorme hem.... quanto me cobra o carreto ?
and exists (select 1 from tbl_produto_pendencia b
                  where b.cod_produ = '1'
                  and b.cod_carte = 'PARC'
                  and b.des_regis = a.des_regis
                  and b.des_contr = a.cod_parce
                  and exists (select 1 from tbl_dados_faturas c
                              where c.cod_campa = '1'
                              and c.num_prest = b.num_prest
                              and c.des_regis = b.des_regis
                              and c.des_contr in ('999992839270','999992851559','999992829436','999993155159','999993507706','999993184994','999993263675','999995668507','999993382852','999995032127','999997394146','999995665541','999993513240','999993753786','999993899383','999993902724','999993986833','999994001051','999995960446','999995186017','999994071739','999994122867','999994139616','999994201126','999994255165','999994430043','999994650154','999994767409','999994822896','999998366058','999996764429','999996811064','999996807538','999996815303','999997220067','999997398658','999998809295','999998396157','999998668372','999998766781','999998891441','999999303264','999986326109','999986265779','999986293048','999986710523','999986744601','999986762727','999992636844','999986948598','999987052861','999987146029','999987156038','999989171506','999987386665','999987340971','999987373540','999987533430','999987548013','999987572679','999987573849','999987600295','999992194404','999990454410','999990145564','999995246037','999988027910','999989800376','999987888603','999987796805','999987840386','999987833054','999987834907','999987843171','999987821508','999987890608','999987874409','999988020668','999988034824','999995295572','999988263226','999988193433','999989095884','999988298168','999994278496','999988345312','999988388425','999988350758','999988442551','999988538781','999988507821','999988553340','999988817543','999988833548','999988816541','999988859138','999988808593','999989060748','999988977242','999989025704','999989173580','999989180674','999992355057','999989281306','999989345292','999995573682','999989339894','999989349255','999989689540','999989508832','999989497903','999989531684','999989688549','999989739904','999989862094','999989979204','999989986451','999990014551','999990007124','999990041298','999990157200','999990148601','999990173207','999987623879','999994038302','999990406417','999991488544','999990519803','999990500779','999990713279','999990579708','999990697359','999992003711','999990729567','999990942005','999991000881','999990975798','999995799303','999991040609','999991043962','999991189380','999991235129','999991237177','999991310013','999991269433','999991306233','999991319450','999991407012','999991412753','999991426361','999991498081','999991671018','999991684483','999991632024','999991706623','999991746599','999991781276','999991808569','999991914758','999991953275','999991984795','999992092545','999992146722','999992161815','999992178155','999992180226','999992207305','999992234994','999992277869','999992442681','999992466835','999992579321','999992668761','999992700455','999995051959','999992872427','999994374874','999992953448','999994407835','999994996696','999993114846','999993438058','999993973642','999993223099','999996108072','999993232911','999993296989','999993301079','999996616040','999999633661','999993411197','999993471429','999993539510','999994267219','999994005709','999994129704','999994225252','999996242746','999994294990','999996052344','999996420010','999994457624','999994779986','999994783649','999994815603','999996729107','999996690479','999996817178','999998767990','999996883667','999997203734','999997089491','999997271136','999997396048','999997411362','999998149943','999998139034','999998149032','999998271626','999999041199','999998750106','999999108735','999999770505','999999885709','999986226201','999986370924','999986500544','999986551240','999986535556','999986600589','999986721045','999986768303','999986766402','999986937516','999986959170','999987092494','999986990199','999987084230','999987129022','999994904215','999987252638','999987295641','999987356543','999987509128','999987373925','999987397897','999987439010','999987575818','999987555958','999987790325','999987810500','999987901454','999987895623','999988027613','999988013128','999988004962','999987981696','999987990027','999988182876','999988010568','999988127828','999988300776','999988174914','999988186486','999988180928','999988438554','999988237744','999988280814','999989822917','999988349861','999988348873','999988373959','999995207052','999988546771','999988371304','999988433275','999988507635','999988618390','999988600841','999988686027','999994888275','999988662950','999988688714','999988714806','999988758918','999988750035','999988702641','999988727646','999988750239','999988903367','999988780048','999988806245','999988836156','999988856728','999988921189','999989009393','999988975806','999989016850','999989015409','999989061277','999989156941','999995438297','999989172123','999989362890','999989355870','999996034304','999989656733','999989504883','999989622300','999989575183','999989684742','999989714105','999989683062','999989712213','999989871536','999989839037','999990161183','999990153816','999990217018','999990271065','999990273510','999990262265','999990311885','999990303507','999990312207','999990328187','999990396228','999990395455','999991329110','999990437846','999992428814','999990587449','999990661144','999990725913','999990775455','999990800055','999990794711','999994796692','999990941820','999990888815','999990932558','999990983415','999991049782','999991213828','999991185244','999991233344','999991211879','999991217192','999991322566','999991278027','999991348323','999991362730','999991422572','999991450255','999991573983','999991668043','999991686057')--conta
                              and c.des_fatura in (147198070,147219712,147212005,147210881,147227939,147213661,147228317,147233519,147221011,147229757,147212885,147219775,147210070,147219785,147243306,147231150,147222999,147212098,147233037,147228000,147226575,147212478,147241945,147212485,147226592,147215656,147236751,147237554,147233098,147231219,147241993,147223059,147214298,147255136,147232098,147242823,147255702,147241223,147255187,147242252,147255195,147240607,146992785,146993831,146995341,146997464,146996843,146997030,147000011,146993461,146998846,146998061,147000443,147020593,147021935,147021336,147028733,146891936,147037140,147021205,147040502,147035953,147030029,147037768,147037405,147039057,147020256,147038040,147037223,147064323,147022057,147032415,147037660,147019874,147065921,147022085,147040215,147039232,147036083,147068548,147074128,147060387,147064185,147069549,147067641,147064436,147064213,147064210,147083918,147069615,147068807,147067226,147068881,147094989,147083221,147107587,147112551,147082294,147110132,147118147,147107998,147120731,147095067,147109816,147109412,147108590,147106251,147123340,147111988,147107089,147108048,147112676,147110850,147141343,147111048,147151541,147137006,147112097,147142557,147143951,147123245,147120884,147137821,146990406,147137867,147162147,147138218,147144036,147152761,147141829,147152425,147176960,147154172,147177931,147149866,147150450,147162240,147183312,147177325,147177014,147158042,147175828,147177611,147183972,147182573,147185757,147177398,147180426,147181447,147186511,147187559,147180819,147173880,147180025,147200373,147184219,147179288,147185461,147197790,147180898,147206330,147188667,147211929,147203546,147195005,147200457,147182261,147200201,147206371,147209962,147212514,147212205,147232927,147188099,147209846,147197686,147213790,147211616,147215567,147306457,147212036,147211216,147229737,147211643,147226523,147210048,147204663,147219221,147212411,147202470,147204669,147219235,147242123,147211276,147233036,147236726,147229809,147237529,147240118,147240522,147233390,147214272,147233095,147242194,147228042,147214294,147226643,147244180,147223062,147240567,147243006,147241202,147251120,147244402,147235660,147235670,147235669,147223099,147241014,147259907,147253133,147242050,147235300,147266311,146990774,146999523,146993862,146995634,146996023,146997777,146996221,146996847,146999576,147019352,146994294,147020529,147000411,146997673,146992674,147028712,147000457,147000093,147021128,146999098,147019931,147028736,146850216,147021175,147023968,147067509,147020027,147019683,147067533,147024481,147058984,147024493,147033071,147038868,147067712,147039249,147082528,147041851,147082541,147065208,147066941,147060412,147079327,147068400,147074170,147065653,147083130,147064219,147071191,147074182,147071189,147065430,147067991,147065469,147064880,147066091,147104116,147065063,147094803,147069667,147083783,147068495,147105540,147094813,147070626,147107741,147094819,147107746,147071493,147083628,147104757,147111908,147099524,147098181,147108362,147105221,147083872,147108383,147108194,147104994,147095100,147121536,147123362,147124975,146847109,147108640,147106672,147112046,147124573,147141341,147151516,147136350,147124090,147136247,147124657,147124101,147153371,147123274,147145219,147139210,147142606,147147751,147147755,147140872,147151366,147136647,147167968,147177907,147153637,147139300,147151426,147140491,147147476,147151434,147162224,147169170,147152047,147180518,147178359,147183705,147176613,147147895,147154485,147307256,147174830,147181405,147177090,147179964,147182600,147185406,147182653,147200517,147188582)--fatura
                              )
                  );                  
                  