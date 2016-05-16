select A.BMF_TRANS_TYPE, D.DESCRIPTION_TEXT
  from lbx_payment_types a,
       bmf_trans_descr b,
       descriptions d
 where 1 = 1 --A.SOURCE_ID = 745
   and A.BMF_TRANS_TYPE in (select B.BMF_TRANS_TYPE
  from g0023421sql.VERIPARCELAMENTO A,
       bmf B
 where A.ACCOUNT_NO = B.ACCOUNT_NO
   and A.BILL_REF_NO = B.BILL_REF_NO
   and B.PAY_METHOD = 1)
   and A.EXT_CATEGORY = 2
   and A.BMF_TRANS_TYPE = B.BMF_TRANS_TYPE
   and B.DESCRIPTION_CODE = D.DESCRIPTION_CODE
   and D.LANGUAGE_CODE = 2

select * from cmf_balance where bill_ref_no in (135122162,134648024,134711886,135198281,134278606,135129657,135065911,132927018,135630652,135146945,135686922,135646704,133766162,135188130,134634529,134267045,131789009,134680821,134685964,134697915,134190632,133885153,133849132,135222537,132323037,133228367,133739213,135674163,135140146,135696063,135772944,135680008,135642107,134724718,135117369,134720531,132298536,133804989,135201343,133200479,135063666,135737391,135151089,134256777,133821797,135660525,133718424,134678094,135688858,132783811,133345431,134635064,133781391,133788796,135702118,132793750,134664740,133523316,130714445,134128014,135467162,134455446,134506309,134951093,134980488,135512112,134949834,134953088,134127781,133460023,134386461,135023012,134387509,134144132,135010475,132578797,133537049,134952451,134997152,134994457,134996813,134946311,134019210,134951309,135002529,133549330,134924241,134993987,134470518,134466933,133039690,135987997,133105923,134419499,134014957,134447133,133119646,135413196,134481233,134111423,135446703,134989692,135435464,132564161,134462107,135025183,132187365,134922505,135503122,135494908,134553300,133083944,133970971,135033965,134437235,134453556,135392751,133467677,135524832,134536906,135042228,133543370,134000086,134070677,133564998,133499663,134860477,134457092,132623183,133085843)

select * from all_tables where table_name like '%VALUES%' 

select * from TRANS_SOURCE_VALUES where display_value like '%CITIBANK%' and language_code = 2

select * from TRANS_SOURCE_VALUES where display_value like '%Safra%' and language_code = 2

select * from BMF_TRANS_DESCR where description_code = 23501

select * from descriptions where description_code = 23501

select * from descriptions where upper(description_text) like '%CITIBANK%' and language_code = 2

select * from DEPOSIT_TYPE_VALUES

select * from LBX_payment_types

select * from bmf_trans_descr

select * from lbx_payment_types where source_id = 745 and ext_category = 2

select * from descriptions where description_code = 