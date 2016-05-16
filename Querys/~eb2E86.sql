select CDV.DISPLAY_VALUE, p.* --P.PARENT_SUBSCR_NO, P.PARENT_ACCOUNT_NO, P.COMPONENT_ID, 
from product p, component_definition_values cdv
where p.component_id = cdv.component_id
and cdv.language_code = 2
and P.PRODUCT_INACTIVE_DT is null      
and p.parent_account_no = 9321309
 

SELECT billing_account_no
FROM product p
where p.component_id = 31080
and P.PRODUCT_INACTIVE_DT is null
and not exists(select 1
                from product p1
                where P1.PARENT_ACCOUNT_NO = P.PARENT_ACCOUNT_NO
                and P1.PRODUCT_INACTIVE_DT is null
                and P1.COMPONENT_ID = 31075
                )