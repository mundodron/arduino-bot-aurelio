SELECT   distinct(MAP.EXTERNAL_ID),
         MAP.ACCOUNT_NO,
           d.BILL_REF_NO,
           D.SUBSCR_NO,
           D.COMPONENT_ID,
           B.PREP_DATE,
           B.PREP_STATUS,
           B.BILL_PERIOD  
    FROM   bill_invoice b,
           bill_invoice_detail d,
           cmf c,
           customer_id_acct_map map,
           customer_id_equip_map eq
   WHERE   d.bill_ref_resets = b.bill_ref_resets
           AND d.type_code IN (2)
           AND MAP.ACCOUNT_NO = B.ACCOUNT_NO
           AND MAP.INACTIVE_DATE is null
           AND C.ACCOUNT_NO = MAP.ACCOUNT_NO
           AND C.ACCOUNT_CATEGORY in (10,11) -- Retail
           AND MAP.EXTERNAL_ID_TYPE = 1
           AND EQ.SUBSCR_NO = D.SUBSCR_NO
           AND EQ.SUBSCR_NO_RESETS = D.BILL_REF_RESETS
           AND EQ.INACTIVE_DATE is null
           AND EQ.IS_CURRENT = 1
           AND EQ.EXTERNAL_ID_TYPE in (6,7)
           AND MAP.IS_CURRENT = 1
           AND B.BILL_REF_NO = D.BILL_REF_NO
           AND B.BILL_REF_RESETS = D.BILL_REF_RESETS
           --AND B.BILL_PERIOD = AUX_CICLO
           AND B.PREP_DATE > sysdate - 15
           AND B.PREP_STATUS = 4 --> 4 proforma 1 production
           AND B.PREP_ERROR_CODE is null
           -- AND B.BILL_REF_NO = 202065847
           -- AND MAP.EXTERNAL_ID in ('899999360809')
           AND MAP.ACCOUNT_NO in (9070935,8903533,9027891,7774736,9112753,9443460,8825590,9061133,8988520,9073149,8930385,9279304,3964733,8448581,9129966,8968199,7029933,3760499,2399641,9319310,8988391,3175450,9340510,9192401,9298827,8992569,9322479,9244522,9089824,6496832,9370783,7538162,9151506,3835420,9106342,9161081,8763777,8858650,8974849,8810135,3453948,8984389,8975443,2596671,9014553,7581672,8041825,2066222,8046999,9072617,4823656,2424293,3078416,8815423,4777815,4277484,8792226,9092937,1755695,1755695,8960902,8720595,8910258,7528216,1583022,1583022,8826554,8829749,9303802,8968474,9142966,6970919,9437677,1298076,9231157,8928982,8861624,8680551,9042431,8901733,9127301,8890653,6893339,8929935,8930790,9149742,7388184,8825508,8069701,9055435,9230835,7972961,8927290,9146688,8615948,8615948,2656161,9113313,9345946,8982146,2482138,3065435,8133638,8936016,8967646,8949881,4814190,4814190,2469670,8904285,4321885,9165461,8956717,7872695,8005934,7442874,9287551,8825429,198784,4558001,9160243,4451530,8957899,9340392,8854488,7543049,7543049,8126101,8910663,9071866,9332785,1779699,1565793,3355388,9187785,9176769,9145053,9115324,9169237,7626934,8869998,1700856,3616551,8930354,8434762,8706031,9118145,8927044,8781757,8994803,8929503,7236958,8666131,9195725,8925841,8980976,8787505,8790996,8968198,9281409,7624644,8956746,8903822,3756658,8875384,2617522,4609551,8187051,9186579,9187357,8759842,8872254,8660630,9357551,9103768,7527929,9119875)
           -- AND D.COMPONENT_ID in (30367,30368,30369,30370) -- LAVOISIER
           AND D.COMPONENT_ID in (31072,31073,31074,31075,31076,31077,31078,31079,31080,31081,31082,31083,31084) -- Touche
           AND D.FROM_DATE = B.FROM_DATE;