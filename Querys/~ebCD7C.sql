select sequencial, count(*) from gvt_bankslip where bill_ref_no in (134584164,134670167,135656420,136310656,136409845,136823673,136920947,137336336,137340918,137367862,137481600,137951224,138493894,130017872,131750300,133177164,133246670,133737546,133758192,133764533,133764533,133855513,133986501,134046400,134190027,134405755,134678848,135075849,135099148,135106166,135111996,135134580,135158318,135165799,135175473,135188113,135251720,135354252,135361113,135372536,135381530,135387827,135388856,135446500,135450453,135478580,135581884,135585623,135607371,135622033,135622633,135641952,135643507,135646836,135646836,135649166,135657727,135659102,135660734,135670556,135689177,135698452,135725156,135739557,135740736,135745058,135857170,135861376,135870812,135871756,135877558,135882387,135891625,135897667,135902974,135906802,135913423,135926181,135926769,135945241,135945468,135995072,136024089,136080070,136099653,136126278,136279232,136294504,136295439,136302771,136303144,136308632,136308761,136310327,136311842,136317368,136326215,136348743,136348743,136349591,136349682,136354067,136358372,136363884,136377711,136386796,136388487,136389956,136391818,136405155,136412863,136416736,136420060,136420547,136435662,136503354,136509101,136519432,136533273,136556324,136565597,136582337,136593412,136627706,136651812,136658894,136660719,136664708,136678981,136701515,136705394,136711840,136793555,136796768,136797323,136797462,136805718,136828032,136828478,136830959,136831845,136837300,136862913,136864642,136881174,136896397,136914054,136916581,136919255,136922149,136924750,136957320,136975350,136975412,136977346,136979178,136991541,137014655,137042625,137042625,137051016,137053193,137097220,137106159,137119245,137199847,137200694,137202522,137204841,137205092,137206519,137212630,137216606,137237663,137244631,137254819,137260542,137275561,137304785,137305936,137331212,137332649,137348671,137371003,137385829,137390924,137393508,137395591,137398545,137408148,137414774,137420873,137426694,137431623,137471259,137475144,137475144,137475144,137481124,137493975,137516925,137517094,137520227,137529948,137637178,137638450,137652719,137660508,137660508,137664112,137689563,137689563,137697422,137697664,137748595,137763522,137767576,137769964,137794501,137797328,137803790,137803790,137809173,137809421,137833314,137833314,137848023,137854852,137862921,137880672,137894997,137907518,137927358,137935042,137954229,137963335,137966388,137975108,137979259,137982349,137989346,138019147,138037367,138043613,138055458,138061979,138082114,138095747,138280777,138306805,138412416,138412633,138415213,138419164,138427299,138432832,138453835,138486657,138486657,138513679,138524699,138533866,138537500,138567115)
group by sequencial

update gvt_bankslip set status = 'T' where sequencial = 1188;

commit;


select * from gvt_bankslip where bill_ref_no = 138504818

select NUMERO_FATURA,IMAGE_NUMBER,IMAGE_TYPE  from customer_care where numero_fatura = '0136172400-0'

select CODIGO_CLIENTE, NUMERO_FATURA,IMAGE_NUMBER,IMAGE_TYPE,DATA_EMISSAO, DATA_VENCIMENTO from customer_care where codigo_cliente = '999984862184' and image_type = 02

select * from gvt_bankslip b where B.EXTERNAL_ID_A = 999984839755

