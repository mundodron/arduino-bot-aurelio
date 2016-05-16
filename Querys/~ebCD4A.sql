select e.*
   from product P,
              DESCRIPTIONS d,
              product_elements E
         where parent_account_no = 6534449
           and E.ELEMENT_ID = P.ELEMENT_ID
           and P.ELEMENT_ID = D.DESCRIPTION_CODE
           and D.LANGUAGE_CODE = 2
           and P.BILLING_INACTIVE_DT is null
           and E.TYPE_GROUP_USG <> 0
           order by d.DESCRIPTION_CODE