select distinct(C.BILL_REF_NO)
from sin_seq_no s, 
    cmf_balance_detail c
where C.BILL_REF_NO = S.BILL_REF_NO(+)
and (c.bill_ref_no in (97983248,97983285,97983319,97983340,97983381,97983393,97983571,97983622,97983664,97983692,97983696,97983752,97983810,97983869,97983881,97983900,97984099,97984105,97984108,97984172,97984292,97984334,97984351,97984517,97984526,97984540,97984549,97984577,97984621,97984728,97984785,97984891,97984910,97984945,97985024,97985054,97985158,97985172,97985204,97985220,97985324,97985344,97985428,97985470,97985489,97985492,97985495,97985548,97985637,97985709,97985727,97985774,97985786,97985787,97985790,97985826,97985844,97985920,97985980,97985985,97985987,97986079,97986099,97986127,97986168,97986218,97986219,97986281,97986338,97986342,97986439,97986529,97986573,97986575,97986602,97986616,97986620,97986651,97986669,97986912,97987195,97987221,97987272,97987274,97987313,97987359,97987364,97987415,97987417,97987450,97987504,97987518,97987523,97987569,97987606,97987609,97987656,97987674,97987680,97987702,97987736,97987989,97988017,97988064,97988227,97988239,97988269,97988295,97988326,97988329,97988348,97988429,97988440,97988691,97988720,97988739,97988749,97988827,97988875,97988889,97988939,97988950,97988966,97988972,97988976,97989031,97989111,97989190,97989252,97989266,97989302,97989311,97989327,97989347,97989364,97989365,97989478,97989569,97989594,97989609,97989612,97989660,97989803,97989899,97989930,97990101,97990113,97990117,97990121,97990215,97990328,97990341,97990389,97990401,97990427,97990513,97990545,97990619,97990703,97990759,97990792,97990839,97990877,97990915,97991013,97991139,97991140,97991159,97991169,97991292,97991300,97991305,97991465,97991531,97991571,97991625,97991721,97991741,97991922,97991932,97991956,97991983,97992104,97992106,97992145,97992282,97992296,97992350,97992356,97992529,97992541,97992575,97992693,97992835,97992870,97992897,97993129,97993154,97993212,97993240,97993249,97993257,97993262,97993410,97993446,97993456,97993559,97993570,97993764,97993784,97993821,97993913,97993931,97993978,97993999,97994057,97994133,97994145,97994168,97994235,97994263,97994337,97994349,97994374,97994547,97994579,97994603,97994750,97994754,97994784,97994790,97994826,97994838,97994853,97995058,97995095,97995238,97995271,97995526,97995531,97995533,97995534,97995591,97995754,97995790,97995792,97995875,97995882,97995909,97995930,97995964,97995966,97995992,97996086,97996137,97996201,97996304,97996311,97996351,97996384,97996396,97996435,97996479,97996635,97996639,97996696,97996708,97996733,97996768,97996793,97996934,97996961,97996979,97997052,97997062,97997091,97997144,97997167,97997213,97997287,97997538,97997596,97997608,97997620,97997921,97997936,97998039,97998073,97998097,97998109,97998188,97998216,97998227,97998317,97998390,97998532,97998546,97998549,97998593,97998602,97998690,97998718,97998736,97998738,97998995,97999143,97999158,97999176,97999181,97999205,97999218,97999267,97999270,97999271,97999304,97999414,97999519,97999536,97999556,97999659,97999706,97999730,97999744,97999781,97999805,97999967,97999983,97999998,98000006,98000031,98000066,98000111,98000133,98000296,98000309,98000400,98000413,98000437,98000445,98000460,98000514,98000517,98000544,98000550,98000573,98000597,98000627,98000631,98000643,98000723,98000812,98000832,98000848,98000904,98000913,98000958,98001126,98001130,98001368,98001415,98001515,98001644,98001684,98001693,98001703,98001731,98001783,98001796,98001802,98001833,98001849,98001912,98001989,98002005,98002114,98002141,98002166,98002188,98002192,98002260,98002312,98002344,98002384,98002409,98002518,98002535,98002541,98002542,98002545,98002568,98002607,98002615,98002646,98002728,98002789,98002831,98002860,98002869,98002923,98002935,98002949,98003066,98003309,98003326,98003462,98003469,98003506,98003519,98003539,98003557,98003566,98003624,98003729,98003808,98003814,98003843,98003944,98004073,98004076,98004083,98004103,98004110,98004286,98004298,98004319,98004350,98004465,98004508,98004569,98004671,98004757,98004795,98004921,98004949,98005064,98005137,98005178,98005200,98005214,98005257,98005340,98005408,98005539,98005559,98005728,98005744,98005776,98005785,98005795,98005801,98005808,98005817,98005828,98005840,98005856,98005977,98006015,98006040,98006060,98006140,98006159,98006180,98006217,98006374,98006528,98006546,98006548,98006565,98006712,98006716,98006812,98006824,98006829,98006955,98007074,98007096,98007144,98007252,98007531,98007709,98007734,98007956,98008310,98008325,98008401,98008538,98008820,98008825,98008939,98009034,98009035,98009051,98009060,98009109,98009212,98009557,98009623,98009947,98010017,98010441,98010969,98011176,98011325,98011328,98011354,98011504,98011602,98011679,98011703,98011913,98012074,98012144,98012180,98012406,98012537,98012704,98012747,98012784,98012941,98012990,98013011,98013110,98013128,98013347,98013503,98013584,98013634,98013670,98013693,98014132,98014158,98014204,98014308,98014613,98014732,98014737,98014795,98014796,98014818,98015113,98015378,98015705,98015805,98015917,98015923,98016026,98016127,98016412,98016520,98016542,98016859,98017111,98017220,98017329,98017571,98017617,98017758,98017941,98018111,98018546,98019310,98019703,98721720,99205500)
or c.bill_ref_no in (95039741,97935532,97935746,97936349,97938507,97938905,97940334,97940746,97942534,97942535,97942541,97942739,97942755,97943096,97943168,97943175,97943188,97943194,97943339,97943518,97943563,97943737,97943848,97943870,97944049,97944430,97944510,97944607,97944631,97944709,97944717,97944720,97944747,97944912,97944918,97944979,97944999,97945016,97945027,97945042,97945057,97945079,97945170,97945209,97945270,97945457,97945558,97945631,97945636,97945655,97945768,97945791,97945800,97945896,97945901,97945994,97946067,97946094,97946131,97946155,97946267,97946269,97946270,97946286,97946377,97946384,97946408,97946475,97946490,97946546,97946632,97946738,97946753,97946936,97946957,97947090,97947091,97947196,97947344,97947596,97947661,97947701,97947743,97947815,97947855,97947861,97947868,97947919,97947980,97948013,97948049,97948085,97948125,97948188,97948198,97948260,97948267,97948702,97948884,97949032,97949086,97949103,97949134,97949163,97949170,97949235,97949248,97949391,97949418,97949423,97949515,97949541,97949694,97949707,97949769,97949808,97949846,97949940,97950035,97950503,97950642,97950643,97950689,97950690,97950939,97950943,97951097,97951099,97951140,97951307,97951329,97951346,97951676,97951705,97951715,97951730,97951734,97951919,97952148,97952210,97952397,97952401,97952403,97952443,97952618,97952676,97952830,97952854,97952921,97952925,97952929,97952940,97952999,97953055,97953075,97953106,97953139,97953181,97953270,97953313,97953432,97953434,97953457,97953525,97953556,97953585,97953599,97953906,97953934,97953998,97954030,97954034,97954153,97954193,97954219,97954299,97954384,97954542,97954757,97954760,97954831,97954875,97954879,97955445,97955541,97955699,97955712,97955725,97955856,97955892,97955895,97955995,97956002,97956060,97956081,97956112,97956120,97956256,97956276,97956280,97956343,97956422,97956425,97956438,97956590,97956613,97956731,97956913,97956918,97956934,97956940,97956960,97957139,97957225,97957249,97957259,97957264,97957285,97957389,97957536,97957593,97957616,97957703,97957820,97957904,97957937,97957956,97957971,97957981,97958067,97958091,97958204,97958217,97958229,97958255,97958258,97958269,97958396,97958494,97958499,97958526,97958544,97958553,97958566,97958594,97958639,97958662,97958663,97958692,97958721,97958759,97958851,97958881,97958886,97959019,97959041,97959097,97959134,97959186,97959267,97959461,97959464,97959757,97959856,97959870,97959899,97959947,97960061,97960116,97960245,97960288,97960316,97960329,97960353,97960406,97960508,97960537,97960551,97960574,97960595,97960713,97960763,97960791,97960795,97960807,97960890,97960991,97960994,97961006,97961097,97961170,97961179,97961210,97961265,97961291,97961446,97961487,97961503,97961719,97961805,97961841,97961864,97961889,97961933,97962053,97962106,97962150,97962152,97962180,97962190,97962215,97962245,97962299,97962379,97962523,97962552,97962627,97962716,97962737,97962760,97962765,97962796,97962801,97962859,97962953,97962966,97963027,97963062,97963078,97963116,97963201,97963273,97963302,97963343,97963381,97963387,97963408,97963420,97963435,97963562,97963572,97963585,97963604,97963694,97963720,97963771,97963831,97963879,97963940,97964082,97964335,97964417,97964461,97964551,97964693,97964824,97964856,97964877,97964949,97964997,97965006,97965096,97965137,97965149,97965253,97965266,97965405,97965499,97965713,97965912,97965941,97966027,97966030,97966097,97966100,97966139,97966172,97966270,97966381,97966405,97966497,97966515,97966541,97966597,97966667,97966749,97966828,97966840,97966903,97967029,97967032,97967083,97967145,97967283,97967341,97967352,97967380,97967382,97967394,97967423,97967457,97967467,97967573,97967610,97967648,97967680,97967686,97967724,97967737,97967774,97967809,97967946,97968003,97968012,97968018,97968061,97968101,97968108,97968241,97968367,97968369,97968384,97968412,97968463,97968472,97968479,97968507,97968643,97968693,97968759,97968778,97968863,97969065,97969076,97969117,97969143,97969149,97969166,97969208,97969246,97969250,97969265,97969267,97969295,97969330,97969363,97969372,97969375,97969450,97969463,97969488,97969546,97969586,97969594,97969645,97969650,97969668,97969793,97969861,97969971,97970011,97970098,97970117,97970197,97970216,97970221,97970340,97970378,97970436,97970480,97970593,97970686,97970700,97970743,97970746,97970750,97970912,97970962,97971020,97971026,97971042,97971181,97971187,97971214,97971337,97971351,97971553,97971566,97971746,97971887,97972020,97972139,97972157,97972160,97972162,97972207,97972325,97972336,97972407,97972481,97972488,97972535,97972752,97972957,97973119,97973208,97973219,97973251,97973418,97973566,97973746,97973788,97973837,97973887,97973986,97973994,97974111,97974209,97974213,97974230,97974273,97974335,97974346,97974361,97974386,97974481,97974546,97974637,97974676,97974762,97974820,97974821,97974907,97974930,97974995,97975000,97975019,97975141,97975224,97975325,97975388,97975609,97975624,97975684,97975705,97975706,97975719,97975752,97975792,97975865,97975869,97976052,97976075,97976095,97976099,97976100,97976101,97976540,97976619,97976620,97976632,97976750,97976779,97976926,97976984,97977052,97977054,97977056,97977096,97977187,97977240,97977274,97977285,97977327,97977361,97977391,97977402,97977462,97977497,97977548,97977626,97977627,97977718,97977757,97977897,97977922,97978017,97978032,97978041,97978055,97978170,97978222,97978357,97978406,97978414,97978441,97978442,97978456,97978624,97978639,97978661,97978739,97978780,97978856,97978888,97978890,97978895,97978898,97978969,97979037,97979048,97979078,97979085,97979113,97979144,97979202,97979254,97979288,97979340,97979410,97979440,97979455,97979466,97979487,97979554,97979587,97979609,97979642,97979665,97979949,97979965,97980019,97980026,97980036,97980065,97980066,97980067,97980073,97980116,97980118,97980225,97980344,97980372,97980454,97980487,97980630,97980650,97980729,97980753,97980774,97980869,97980926,97980947,97980975,97980990,97981058,97981142,97981146,97981207,97981268,97981271,97981274,97981288,97981298,97981301,97981338,97981360,97981374,97981432,97981486,97981568,97981619,97981631,97981675,97981738,97981760,97981783,97981802,97981814,97981829,97981875,97981877,97981914,97981959,97981985,97982151,97982153,97982240,97982245,97982272,97982376,97982397,97982488,97982537,97982542,97982595,97982690,97982893,97982923,97982931,97983043,97983055,97983092,97983173)
)and C.OPEN_ITEM_ID not in (2,3)
and S.OPEN_ITEM_ID = decode(C.OPEN_ITEM_ID,1,0,C.OPEN_ITEM_ID)