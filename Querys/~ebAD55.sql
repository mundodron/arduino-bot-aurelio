select external_id, bi.account_no, bill_ref_no
from bill_invoice bi,customer_id_acct_map ciam  
where bill_ref_no in (190349903,190349102,183515543,187290800,191176758,187272505,191222169,172522516,176167330,179784106,183667375,187271907,191156707,179784302,183667374,190617336,183515542,187290799,191191556,195260549,195337363,195257907,195289761,195289738,195289762,195259105)
and ciam.account_no = bi.account_no
and external_id_type = 1
and not exists ( select 1 from GVT_FEBRABAN_PONTA_B_ARBOR pont
                 where pont.cmf_ext_id = ciam.external_id )
order by 1, 2, 3