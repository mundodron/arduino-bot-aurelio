update gvt_bankslip set status = 'T' where bill_ref_no in (129383376,133654537,135066965,135121718,135578277,135624179,135624179,135659949,135871392,135897003,136105576,131175789,131572458,132502113,132956157,133162342,133164151,133167597,133199166,133662808,133675976,133687745,133703543,133751742,133751742,133758478,133861957,133873430,134216358,134233154,134293349,134577461,134577754,134586543,134586543,134645805,134672106,134721495,134730270,134737530,134820727,134839481,134839481,135062996,135064922,135065959,135066965,135068544,135069774,135076023,135077389,135095686,135098865,135103211,135103211,135114915,135115016,135121718,135121718,135124809,135125850,135126648,135130392,135130578,135161143,135164123,135193068,135199023,135202681,135204370,135224865,135230140,135242375,135256599,135330515,135575150,135578277,135578682,135579192,135583626,135584864,135587250,135597625,135612254,135613929,135614419,135617377,135621906,135622751,135628368,135628799,135636025,135639331,135667519,135667772,135669640,135670644,135675102,135686611,135691012,135701163,135707689,135714825,135720317,135726934,135759935,135777131,135788170,135878528,135881335,135891992,135897003,135907070,135907561,135921178,135935348,135945704,135973524,135997919,135997919,135997919,136006705,136008804,136023998,136030075,136030075,136068479,136082155,136127829,136128131,136170570);

commit;

select count(*) from gvt_bankslip where sequencial = 1170


select to_date ('2011/01/01 20:00:00','yyyy/mm/dd hh24:mi:ss') from dual