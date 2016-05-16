select e.*
   from product P,
              DESCRIPTIONS d,
              product_elements E
         where parent_account_no = 6534449
           and E.ELEMENT_ID = P.ELEMENT_ID
           and P.ELEMENT_ID = D.DESCRIPTION_CODE
           and D.LANGUAGE_CODE = 2
           and P.BILLING_INACTIVE_DT is null
           
select * from GVT_DURATION_USG_VARIABLE where TYPE_ID_USG = '360'


select * from cmf_balance where bill_ref_no in (140209709,142867113,145828712,137367509,145797708,145797710,145797709)