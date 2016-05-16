 select distinct map.external_id, P.Parent_Account_No, P.Element_Id, cdv.display_value
from product p, Component_Definition_Values cdv, customer_id_acct_map map
where p.component_id=Cdv.Component_Id
and p.element_id in (10621,10624,10627,10630,10633,10636,10639,10642,10645,10648,10658,10661,10664,10667,10670)
  and Product_Inactive_Dt is null 
  and P.PARENT_ACCOUNT_NO = MAP.ACCOUNT_NO
  and external_id_type = 1
 and Cdv.Language_Code=2
 order by Element_Id;