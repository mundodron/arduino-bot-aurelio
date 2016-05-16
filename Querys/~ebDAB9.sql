select S.FULL_SIN_SEQ FULL_SIN_SEQ_ssn,
       S.BILL_REF_NO bill_ref_no_ssn,
       S.OPEN_ITEM_ID OPEN_ITEM_ID_ssn,
       C.BILL_REF_NO bill_ref_no_cbd,
       C.OPEN_ITEM_ID  OPEN_ITEM_ID_cbd ,
       c.external_id
from sin_seq_no s, 
     cmf_balance_detail c
where C.BILL_REF_NO = S.BILL_REF_NO (+)
and c.bill_ref_no in (0010109762,0097984621,0098259575,0098759862,0099163355,0099572897,0100333484,0100927870,0101461825,0101480586,100016523,100021273,100021273,100023971,100027058,100036384,100127968,100130727,100144993,100150308,100156678,100203375,100213583,100219561,100223441,100227707,100231206,100234704,100237303,100241469,100241591,100243276,100243318,100251375,100253004,100257020,100258475,100258731,100260339,100267738,100267933,100271528,100276162,100277666,100283933,100319239,100331874,100333484,100334262,100338047,100338047,100338240,100345221,100435571,100442994,100451418,100458905,100463678,100474126,100476379,100502093,100504261,100527967,100551064,100559471,100562088,100563233,100575297,100591065,100591249,100601348,100609941,100614514,100614514,100637141,100637141,100638283,100679223,100697946,100706081,100706710,100731947,100748965,100757329,100886069,100892482,100892482,100892595,100893358,100897652,100899892,100902302,100919725,100927870,100930327,100933462,100936059,100936060,100945942,101056431,101058361,101063451,101063931,101072358,101095975,101098394,101112436,101117516,101121862,101125526,101147998,101149100,101152434,101154141,101154629,101155355,101156502,101179576,101179576,101211386,101309556,101315912,101318235,101319687,101331430,101339397,101341810,101360466,101362356,101476138,101476552,101479784,101480586,101484109,101485103,101491482,101494004,101496309,101508145,101508481,101511887,101527376,101536175,101541225,101568089,101579600,101579600,101590619,101591749,101596935,101716110,101716110,101728636,101729196,101734961,101741250,101741523,101746396,101749535,101752316,101797140,101819400,101830374,101833397,101835227,101843889,101847434,101848736,101853049,101853447,101859736,101861235,101861805,101862318,101876352,101887911,101891406,101894008,101916523,101958194,102015723,102042179,102046323,102050139,102070745,102071687,102110169,102122319,102137674,102145461,102154575,102165421,102189693,102222027,102232248,102234312,102245332,102251802,102256385,102393613,102407698,102496211,102516707,102520376,102522891,102568144,102592605,102593591,102595216,102733724,102790687,102794711,102816934,102844360,102856875,102866452,102887110,102893725,103012346,103133681,103369312,103387976,103418821,89274365,91280168,92536471,92842771,93752799,93882512,93946601,94095477,94452666,94460752,94505775,94605342,94629139,94796174,94943851,95024076,95033990,95054011,95196146,95298842,95301677,95314383,95356490,95405504,95484648,95544918,95592855,95608690,95810689,95819255,95820591,95821702,95839113,95849702,95849845,95870451,95873872,95877807,95881605,95893366,95938036,95966002,95966250,95967435,95979664,95981031,95987385,95993314,96071347,96087362,96118488,96143148,96215221,96241360,96248368,96309133,96372863,96421750,96424512,96553625,96555805,96556264,96565642,96611120,96628561,96664428,96737877,96744840,96781165,96782651,96977993,96981559,97002248,97003010,97029487,97051092,97093550,97142005,97142005,97193828,97194318,97350277,97367883,97384441,97403913,97423254,97505732,97531092,97636862,97648189,97649106,97659183,97665160,97668911,97737362,97778848,97791386,97797296,97818744,97844560,97844968,97853516,97940334,97943518,97944430,97944912,97945636,97946377,97947678,97948805,97949163,97949423,97950690,97953139,97953313,97954219,97958067,97958663,97959097,97960508,97960807,97960991,97961006,97962627,97963302,97968241,97969246,97969594,97969668,97970221,97971042,97972336,97973219,97974361,97975325,97975706,97975792,97975869,97976926,97978032,97979949,97979965,97980067,97980630,97980990,97982151,97982690,97982923,97983881,97984621,97985158,97985428,97985470,97986338,97986651,97987313,97988239,97988295,97988720,97989266,97990915,97991292,97994145,97994790,97995058,97997620,97997936,97998718,98002166,98002789,98003326,98006159,98007531,98012180,98012784,98012990,98014158,98015705,98016127,98041177,98043581,98046138,98054347,98059103,98061696,98073877,98078274,98085922,98088822,98109252,98133734,98142875,98147850,98172294,98259575,98261792,98263165,98272206,98277086,98287086,98299124,98312708,98316722,98318636,98323203,98345269,98356078,98376512,98383106,98407692,98425995,98440993,98448303,98484269,98487476,98508730,98509201,98518597,98559422,98607978,98713362,98722880,98727327,98728648,98759862,98764075,98765125,98768251,98776704,98860685,98903868,98906930,98922970,98923132,98924115,98934629,98939143,98939143,98942634,98942992,98971827,98974325,98978197,98978372,98978372,99023701,99045344,99121376,99121926,99132472,99148269,99163355,99178446,99178564,99179468,99182885,99187158,99189676,99201424,99207194,99220423,99241561,99254735,99278387,99294412,99324291,99327228,99329135,99329135,99346540,99505887,99513509,99513509,99517871,99531426,99538761,99561527,99568018,99568801,99568839,99572897,99581979,99584713,99586742,99588480,99595378,99595706,99611106,99611187,99611188,99612118,99670926,99680283,99680283,99681283,99694038,99698391,99698945,99704707,99726580,99794812,99796411,99802200,99811126,99826771,99827516,99831934,99833733,99902795,99909352,99912258,99916832,99920938,99933341,99948816,99964486,99985112,99999636)
and C.OPEN_ITEM_ID not in (2,3,91,92)
and S.OPEN_ITEM_ID(+) = decode(C.OPEN_ITEM_ID,1,0,C.OPEN_ITEM_ID)