select sum(B.GL_AMOUNT), sum(B.DISTRIBUTED_AMOUNT), sum(replace(substr(MSG,58,6),',')) as total 
  from GVT_ERRO_SANTANDER S,
       bmf b
 where S.account_no is not null
   and S.ACCOUNT_NO = B.ACCOUNT_NO
   and B.ORIG_BILL_REF_NO = S.BILL_REF_NO
   and B.DISTRIBUTED_AMOUNT is not null
   --and B.BILL_REF_NO = 0
   and S.TELEFONE = 'ND'
   and B.NO_BILL = 0
   and B.DISTRIBUTED_AMOUNT <> 0
   --and S.bill_ref_no = 112144018
      and b.TRACKING_ID not in (4339909,3576471,4289430,4289430,2716996,3924973,4428504,4054615,3628651,3791614,4354403,3643393,2680536,4099388,4288153,3991681,4363825,3416158,2508645,4418800,4335316,4335316,4155896,3757616,4037126,4239464,4198687,4019353,3158073,3863199,4065621,4429382,3814922,4231818,4298397,4391566,3319554,2765476,4328142,3318629,3929781,3875880,4100733,3240295,4152393,4391290,1359314,1170139,3208556,3990990,3891169,3429522,3659750,4203557,4304510,4034935,4040206,4430895,4124129,4137627,3552117,2809089,2670959,3708033,3187256,4060290,4438147,4352430,4352430,4248908,3555826,3848813,4219889,  90043,3966500,4106802,3327487,4104466,4185407,4326500,2545901,3278403,3278403,4352080,4268081,4385211,4385211,3168026,4310190,4233810,4403159,4236334,4106007,4312643,4293102,4325848,4325848,4102198,4061317,3518463,4405889,4126926,4345343,4104229,1275185,3827632,4422936,3989968,3978564,4057931,2771140,4026063,4026063,4026063,4107249, 812500,4289430,4289430,2716996,3924973,4288153,4099388,4288153,4288153,3991681,3444341,4363825,3416158,4251008,2508645,3898529,4418800,2783760,3993334,3245799,4119876,4415099,3759357,4198687,4118070,3158073,3158073,3771244,3943354,4228526,3291109,4429382,3921018,3921018,4111281,3952426,4231818,4298397,4391566,4272462,3684907,3713159,3319554,3319554,2765476,4155896,4368201,4056597,3497743,3875880,4100733,4252120,4391290,4391290,3875880,2500600,4368878,4368878,3579682,3429522,4346980,4346980,4325433,3659720,3665831,3666358,3666358,4034935,4397887,4277821,4368798,4285211,4285211,3898555,4128904,2670959,4173990,3838617,4205110,4413472,4438147,4039006,4205091,4205091,2877524,4397162,4030419,4030419,4164504,3966500,3213341,4298163,4047397,3321277,2821737,1793271,3468443,3390126,4104466,4185407,4306593,3198449,3642392,3168026,4118451,4310190,4095061,4397106,4397106,4266378,4106007,2303493,4314548,4142178,2015391,3936574,4265288,1275185,4342886,4250053,3311460,4203446,3972472,4283699,4283699,4107249,4265521, 218756,4339909,4339909,3576471,2716996,4054570,4152339,4152339,3628651,3628651,3791614,3896532,4288153,3416158,3907377,4418800,3075271,2746661,3245799,3245799,4590830,4031052,3757616,3759357,3629715,3629715,4198687,4019353,4051719,4055967,4055967,3863199,4108120,4108120,3225063,4065621,4217812,4250241,4250241,3128566,3921018,4111281,4379120,4391566,4099271,3684907,4054749,4054749,4386946,4095657,3343134,3980646,4105695,4371675,3151584,3318629,4019804,3860364,3860364,4100733,3195869,4252120,4325416,3891169,3891169,4203557,3665831,3665831,4034935,4040206,4277821,4102315,4102315,4102315,4368798,4122690,4331889,2646538,3196434,3829825,4366272,4553160,4352430,3555826,4205091,2877524,4256650,4215662,3994398,3826502,3394223,4483810,3390126,4231232,4281306,4057866,4267602,4306593,3198449,3946631,4326771,4135237,3848830,4306988,4403159,3206978,4106007,3268047,3251225,2303493,4100043,2015391,3668577,4276077,4265288,4342886,3912605,4248641,4397048,3591520,4343105,4420011,4289363, 812500, 812500,4106131,4339909,2716996,4152339,3444341,3444341,3946613,3993562,3075271,3075271,2783760,2783760,4335316,4119876,4590830,4155896,4037126,4239464,4055967,3225063,3771244,3378325,3291109,2781638,4429382,4429382,3921018,2880905,4111281,3941546,3952426,4095657,4155896,4155896,4213064,4368201,4056597,4056597,3497743,3497743,4246645,4366647,3838239,3838239,4183393,3151584,3318629,3318629,3929781,3584188,3195869,4252120,2500600,4197378,1170139,4325416,4325416,4325416,3645098,3659750,4192215,3665831,4040206,4397887,4277821,2727115,4397164,4166354,2670959,4344948,4134935,3848813,4325288,4407537,4219889,4071504,4199315,4164504,4215662,4244108,4120131,4106802,3213341,3921984,4162713,4329660,4329660,3297069,4432666,3774885,4231232,4231232,4425606,3250222,4267602,4326500,3278403,4268081,4325799,4325799,4054521,4054521,4118451,4046336,4046336,4046336,4135237,4216547,3998906,4287270,4312643,4327341,4294904,4294904,4102198,3923366,3855917,4377458,4248641,3652262,3386433,  76137,3576471,3924973,4054570,3628651,3991681,4251008,3898529,3907377,3907377,4021458,4120494,4590830,4155896,4031052,4239464,3626798,3626798,3626798,4118070,4118070,3863199,3863199,4217812,3943354,2781638,2880905,4111281,3941546,4110688,4110688,3952426,4298397,4099271,4099271,4272462,3684907,4054749,4386946,4386946,4095657,4213064,4246645,4246645,4366647,4366647,2990354,2990354,3178352,4152393,4152393,3201641,3201641,3579682,3579682,3990990,3429522,3429522,3645098,3659750,3626356,3626356,4368798,3477064,3477064,3780980,2740340,4062454,3420929,4180406,4438147,4325288,4071504,4215662,4120131,4329660,3321277,3157922,3394223,2821737,2821737,3468443,2914671,3642392,4274832,4274832,4274832,4325799,4221668,4215003,3947566,4266378,3314297,4348444,4253276,4338233,4325848,4314548,3518463,4403365,4749239,2701421,3855917,4126926,4397878,4281674,4303903,4377458,3283078,3989968,4428975,4428975,4113582,3329960,3386433,4057931,3318524,4054570,4054570,4428504,4354403,4354403,3643393,4288153,2680536,4120494,2639847,2639847,2783760,3993334,2746661,3245799,4119876,4119876,4031052,4037126,4239464,3759357,3629715,2706958,4051719,4108120,4065621,3771244,2684653,2684653,4359202,3291109,4231818,4379120,4391566,4099271,4272462,4054749,2765476,4255624,4328142,3929781,4019804,3875880,3584188,4388425,3240295,3240295,4217829,4217829,3178352,3201641,4346980,3645098,3626356,3626356,4304510,4304510,3666358,4040206,4222882,4102315,4430895,4430895,1920397,4313529,4132439,3892029,4407280,3708033,4406355,2776656,4180406,4180406,4352430,4248908,3848813,4161370,4338085,4082058,4082058,4199315,3996691,4215662,4265420,4244108,4120131,3213341,4162713,3826502,3700463,3297069,1793271,3850508,3850508,4281306,4057866,4104466,3250222,4306593,2914671,3642392,3284652,3284652,4385211,4326771,3631302,4118451,4095061,4215003,3249380,4750328,4750328,3206978,4287270,4338233,4327341,3668527,4403365,4749239,4366993,2015391,4281674,3311460,4203446,4422936,4428975,2659845,3246172,3386433,3320209,3154923,3692361,3924973,4428504,4054615,4054615,3896532,3896532,4288153,2680536,4288153,3946613,2508645,3907377,4418800,4021458,4335316,4031052,4198687,4108120,3378325,3378325,4250241,4228526,3291109,2781638,3941546,4385062,4328142,1693167,4105695,2721290,3838239,4183393,3151584,3860364,3584188,3240295,3178352,4152393,1359314,4197378,3990990,3659750,4325433,4203557,3659720,4192215,4397887,4397887,4222882,4430895,4067795,3858378,4166354,3311749,3670378,4217792,4135748,4344948,3708033,  90043,4256650,4397162,4180798,4180798,4164504,4265420,4244108,3285113,3327487,4298163,4047397,3321277,3700463,3157922,4483810,3850508,4425606,3667202,4326500,2545901,3946631,3652027,3575368,4216547,4306988,4286173,3998906,3947566,3314297,2657918,3924025,4348444,3268047,3251225,4293102,3898329,3923366,3923366,4237420,4104229,3912605,2659845,3246172,3420887,4057931,3893260,2716996,4152339,4054615,3791614,4354403,3896532,4099388,3991681,3444341,4363825,3416158,4251008,3993562,3993562,4120494,4415099,3757616,4051719,3158073,3225063,3225063,4217812,4217812,3378325,4250241,4359202,4110688,4272462,4385062,3713159,3713159,4255624,4213064,3343134,3980646,4105695,4368201,2721290,3497743,4183393,3860364,3195869,3875880,3875880,3201641,2500600,4368878,4197378,4197378,3208556,3891169,4325433,3659720,4368798,4049801,3390394,3311749,4371146,4173990,4053578,3807327,4248908,3555826,4039006,2877524,4338085,4219889,4397162,3996691,3285113,3921984,3327487,3994398,3700463,3774885,4267602,4185407,3667202,4352080,4352080,4268081,4054521,3168026,4252222,3575368,4233810,3249380,3848830,4306988,4286173,2755530,4236334,2657918,4348444,4293102,3175780,4366782,3694505,2701421,4276077,4370733,4345343,1275185,4250053,4303903,4203446,2541908,2541908,4079904,4207739,3838126,3929143,4106092,4284032)

select B.ORIG_BILL_REF_NO ,sum(B.GL_AMOUNT), sum(B.DISTRIBUTED_AMOUNT), sum(replace(substr(MSG,58,6),',')) as total 
  from GVT_ERRO_SANTANDER S,
       bmf b
 where S.account_no is not null
   and S.ACCOUNT_NO = B.ACCOUNT_NO
   and B.ORIG_BILL_REF_NO = S.BILL_REF_NO
   and B.DISTRIBUTED_AMOUNT is not null
   --and B.BILL_REF_NO = 0
   and S.TELEFONE = 'ND'
   and B.NO_BILL = 0
   and B.DISTRIBUTED_AMOUNT <> 0
   --and S.bill_ref_no = 112144018
   group by B.ORIG_BILL_REF_NO
   
   select * from cmf_balance where bill_ref_no = 111897959
   
   select * from cmf_balance where account_no = 4511465
   
   select * from bmf where account_no = 3818523 and bill_ref_no = 111923056
   
   select b.*
     from GVT_ERRO_SANTANDER S,
          cmf_balance b
    where S.ACCOUNT_NO = B.ACCOUNT_NO
      and B.BILL_REF_NO = 0
      and S.TELEFONE = 'ND'
      
      
 select replace('123123tech', '123') from dual
 
 
 select B.* --sum(B.GL_AMOUNT), sum(B.DISTRIBUTED_AMOUNT), sum(replace(substr(MSG,58,6),',')) as total 
  from GVT_ERRO_SANTANDER S,
       bmf b
 where S.account_no is not null
   and S.ACCOUNT_NO = B.ACCOUNT_NO
   and B.ORIG_BILL_REF_NO = S.BILL_REF_NO
   and B.DISTRIBUTED_AMOUNT is not null
   --and B.BILL_REF_NO = 0
   and S.TELEFONE = 'ND'
   and B.NO_BILL = 0
   and B.DISTRIBUTED_AMOUNT <> 0
   --and S.bill_ref_no = 112144018

select * from bmf where account_no = 3643393 and bill_ref_no = 114621241

select * from cmf_balance where account_no = 3643393 --and bill_ref_no = 114621241

 select S.EXTERNAL_ID, S.BILL_REF_NO, 
  from GVT_ERRO_SANTANDER S,
       cmf_balance b,
       ( select to_char(s2.x_acct_id_num) CLIENTE,
to_char(s.x_acct_id_num) COBRAN�A
from s_org_ext s,
     s_org_ext s2,
     s_org_ext s3
where s.master_ou_id = s2.row_id
and s.par_ou_id = s3.row_id) as tb_siebel
 where S.account_no is not null
   and S.ACCOUNT_NO = B.ACCOUNT_NO
   and B.BILL_REF_NO = 0
   and S.external_id = tb_siebel.cliente
   --and B.DISTRIBUTED_AMOUNT is not null
   --and B.BILL_REF_NO = 0
   and S.TELEFONE = 'ND'
   --and B.NO_BILL = 0
   --and B.DISTRIBUTED_AMOUNT <> 0
   --and S.bill_ref_no = 112144018
   
   
select S.EXTERNAL_ID, S.BILL_REF_NO, se.x_acct_id_num
  from GVT_ERRO_SANTANDER S,
       cmf_balance b,
       s_org_ext se,
       s_org_ext s2,
       s_org_ext s3
 where S.account_no is not null
   and S.ACCOUNT_NO = B.ACCOUNT_NO
   and B.BILL_REF_NO = 0
   and S.TELEFONE = 'ND'
   and se.master_ou_id = s2.row_id
   and se.par_ou_id = s3.row_id
   and se.x_acct_id_num = S.EXTERNAL_ID  
   
   
 select to_char(s2.x_acct_id_num) CLIENTE,
to_char(s.x_acct_id_num) COBRAN�A
from s_org_ext s,
     s_org_ext s2,
     s_org_ext s3
where s.master_ou_id = s2.row_id
and s.par_ou_id = s3.row_id


 select to_char(s2.x_acct_id_num) CLIENTE,
to_char(s3.x_acct_id_num)AGREGADORA,
to_char(s.x_acct_id_num) COBRAN�A, 
     s.master_ou_id MASTER_OU_ID, s.par_ou_id PAR_OU_ID, s.row_id ROW_ID, 
     s2.x_acct_billable_status CLIENTE, s3.x_acct_billable_status AGREG, s.x_acct_billable_status COB
from s_org_ext s,
     s_org_ext s2,
     s_org_ext s3
-- where s.x_acct_id_num in ('999982152279')
where s.master_ou_id = s2.row_id
and s.par_ou_id = s3.row_id;


select * from customer_id_acct_map 


update GVT_ERRO_SANTANDER SS set SS.telefone = (
select C.EXTERNAL_ID
    from bill_invoice_detail B,
          customer_id_equip_map c,
          service s,
          GVT_ERRO_SANTANDER G
   where B.SUBSCR_NO = C.SUBSCR_NO
     and C.EXTERNAL_ID_type = 1
     and C.INACTIVE_DATE is null
     and B.SUBSCR_NO = S.SUBSCR_NO
     and B.SUBSCR_NO_RESETS = S.SUBSCR_NO_RESETS
     and G.ACCOUNT_NO = S.PARENT_ACCOUNT_NO
     and G.BILL_REF_NO = B.BILL_REF_NO
     and SS.ACCOUNT_NO = G.ACCOUNT_NO
     and SS.BILL_REF_NO = G.BILL_REF_NO)