 select bill_ref_no, prep_date, substr(file_name,8,4) Dia_Mes,file_name  ,prep_status,prep_error_code, 
case 
           when (length(bi.bill_ref_no) = 8) then 
                   (select distinct '00'||bill_ref_no||'-0' from bill_invoice bil, customer_care cc
                     where 
                     bil.bill_ref_no =bi.bill_ref_no
                     and bil.prep_status = 1
                     and substr(bil.file_name,-6) like '%F%'
                     and cc.numero_fatura = '00'||bil.bill_ref_no||'-0')         
           when (length(bi.bill_ref_no) = 9) then 
                   (select distinct '0'||bill_ref_no||'-0' from bill_invoice bil, customer_care cc
                     where 
                     bil.bill_ref_no =bi.bill_ref_no
                     and bil.prep_status = 1
                     and substr(bil.file_name,-6) like '%F%'
                     and cc.numero_fatura = '0'||bil.bill_ref_no||'-0')   
                                                                              
      end gerou_fat
from bill_invoice bi
where bill_ref_no in(100027058,100030202,100051422,100127968,100144993,
100150308,100156678,100231206,100235566,100237303,
100241591,100258475,100258731,100267261,100271528,
100293460,100333495,100338047,100451418,100474126,
100502093,100563233,100591065,100601348,100637141,
100679223,100697946,100706710,100897652,100927870,
100940617,101095975,101098394,101125526,101152434,
101154629,101485103,101524572,101568089,89274365,91280168,
92536471,93320977,94401445,94403557,94412575,94435337,
94445517,94460752,94505775,94605342,94629139,94796174,
94825734,94851295,94868913,94871506,94943851,95024076,
95054011,95196146,95198422,95203976,95298842,95301677,
95314383,95356490,95405504,95484648,95544918,95561581,
95592855,95608690,95798745,95806478,95810689,95819255,
95820591,95821702,95830407,95830849,95839113,95849702,
95860328,95863416,95870451,95873872,95877807,95888094,
95893366,95907429,95911606,95938036,95966002,95966250,
95967435,95979664,95981031,95987385,95993314,96087362,
96118488,96143148,96215221,96241360,96248368,96372863,
96402116,96421750,96424512,96553625,96555805,96556264,
96565642,96611120,96628561,96664428,96737877,96744840,
96781165,96782651,96977993,96981559,97002248,97003010,
97029487,97051092,97093550,97142005,97142005,97193828,
97194318,97350277,97384441,97403913,97423254,97431753,
97505732,97531092,97628209,97636862,97648189,97649106,97659183,97665160,97668911,97669562,
97737362,97778848,97791386,97797296,97818744,97844560,97844968,97853516,97936349,97938507,
97940334,97942739,97942755,97943096,97943188,97943339,97943518,97943563,97943848,97944049,
97944430,97944510,97944709,97944717,97944720,97944912,97944979,97945016,97945042,97945079,
97945636,97945655,97945791,97945800,97945896,97945901,97945994,97946094,97946286,97946377,
97946546,97946738,97947344,97947678,97947815,97947868,97948049,97948085,97948125,97948260,
97948267,97948884,97949032,97949086,97949103,97949163,97949423,97949541,97949769,97949846,
97950035,97950503,97950642,97950643,97950690,97950939,97951097,97951676,97951715,97951734,
97952148,97952210,97952618,97952854,97952921,97952929,97952940,97952999,97953075,97953106,
97953139,97953181,97953313,97953457,97953585,97953906,97953934,97953998,97954030,97954219,
97954384,97954757,97954760,97954879,97955856,97955895,97956002,97956112,97956256,97956276,
97956918,97956940,97956960,97957259,97957285,97957389,97957500,97957536,97957703,97957820,
97957904,97957981,97958067,97958204,97958217,97958229,97958255,97958526,97958553,97958566,
97958663,97958721,97959019,97959097,97959267,97959461,97960353,97960406,97960508,97960551,
97960595,97960763,97960791,97960807,97960991,97960994,97961006,97961170,97961210,97961265,
97961487,97961503,97961719,97961805,97961889,97961933,97962053,97962152,97962245,97962627,
97962796,97962859,97962966,97963062,97963201,97963302,97963387,97963408,97963420,97963435,
97963771,97963879,97964335,97964824,97964877,97964997,97965266,97965499,97965912,97966030,
97966097,97966270,97966405,97966497,97966515,97966541,97966597,97966667,97966749,97966828,
97967032,97967352,97967423,97967467,97967724,97968241,97968463,97968693,97969065,97969076,
97969143,97969149,97969166,97969208,97969246,97969250,97969295,97969372,97969375,97969463,
97969546,97969594,97969650,97969971,97970011,97970117,97970221,97970436,97970593,97970746,
97971181,97971337,97971746,97972160,97972207,97972336,97972481,97972535,97972752,97973119,
97973215,97973219,97973746,97973788,97973837,97973887,97974111,97974209,97974213,97974273,
97974335,97974346,97974361,97974762,97974820,97974907,97974995,97975000,97975019,97975224,
97975705,97975706,97975792,97975869,97976052,97976095,97976099,97976540,97976779,97976926,
97977052,97977361,97977462,97977462,97977497,97978032,97978414,97978890,97978895,97978969,
97979037,97979085,97979113,97979202,97979288,97979340,97979440,97979466,97979554,97979587,
97979642,97979965,97980065,97980066,97980118,97980372,97980454,97980487,97980566,97980630,
97980650,97980729,97980753,97980926,97980990,97981268,97981271,97981274,97981360,97981432,
97981675,97981738,97981760,97981814,97981875,97981877,97981959,97982151,97982153,97982397,
97982488,97982690,97982893,97982893,97983043,97983248,97983571,97983622,97983752,97983810,
97983881,97984099,97984292,97984517,97984526,97984549,97984621,97985158,97985172,97985324,
97985428,97985470,97985492,97985727,97985774,97985786,97985844,97985920,97985987,97986127,
97986281,97986338,97986439,97986602,97986651,97986912,97987195,97987313,97987359,97987415,
97987504,97987518,97987609,97987674,97987702,97988017,97988064,97988239,97988269,97988295,
97988326,97988691,97988739,97988827,97988889,97988939,97989190,97989266,97989302,97989311,
97989365,97989569,97989612,97990215,97990545,97990619,97990839,97990915,97991139,97991159,
97991292,97991465,97991956,97991983,97992104,97992145,97992693,97992835,97992897,97993129,
97993249,97993784,97993978,97994057,97994145,97994603,97994750,97994784,97994790,97994826,
97995058,97995095,97995526,97995531,97995754,97995792,97995882,97995909,97995964,97996086,
97997620,97998073,97998390,97998549,97998593,97998718,97999158,97999176,97999218,97999536,
97999536,98000006,98000031,98000066,98000413,98000514,98000517,98000573,98000627,98001130,
98001415,98001912,98002114,98002166,98002344,98002409,98002518,98002545,98002615,98002789,
98002949,98003309,98003326,98003462,98003506,98003557,98003624,98003808,98003814,98004110,
98004508,98004921,98005137,98005178,98005559,98005785,98005817,98005828,98006140,98006180,
98006716,98006955,98007096,98007956,98008310,98008939,
98009051,98009109,98011176,98011504,98011913,98012074,
98012180,98012747,98012784,98012990,98013128,98013670,
98014158,98014308,98014795,98014796,98015113,98015705,
98015917,98016127,98017111,98017329,98017571,98017617,
98041177,98043581,98046138,98054347,98059103,98061696,
98073877,98078274,98085922,98088822,98109252,98133734,98142875,
98147850,98172294,98259575,98261792,98263165,98272206,
98277086,98287086,98299124,98312708,98316722,98376512,98383106,
98407692,98425995,98431525,98440993,98448303,98484269,
98487476,98508730,98509201,98518597,98559422,98607978,98713362,
98722880,98727327,98728648,98759862,98764075,98765125,
98768251,98776704,98791504,98860685,98903868,98906930,98922970,
98923132,98924115,98934629,98939143,98939143,98942634,
98971827,98974325,98978197,98978372,98978372,99023701,99045344,
99121376,99121926,99148269,99163355,99178446,99178564,99179468,99182885,99187158,99189676,99201424,99207194,99220423,
99241561,99254735,99278387,99294412,99324291,99327228,99329135,99346540,99505887,99513509,99513509,99517871,99531426,
99538761,99561527,99568018,99568801,99568839,99572897,99588480,99670926,99680283,99681283,99694038,99698391,99704707,
99726580,99811126,99826771,99831934,99909352,99948816,99964486,99999636);