select * from cmf_balance where bill_ref_no = 133708328  

select e.*
   from product P,
              DESCRIPTIONS d,
              product_elements E
         where parent_account_no = 6534449
           and E.ELEMENT_ID = P.ELEMENT_ID
           and P.ELEMENT_ID = D.DESCRIPTION_CODE
           and D.LANGUAGE_CODE = 2
           and P.BILLING_INACTIVE_DT is null