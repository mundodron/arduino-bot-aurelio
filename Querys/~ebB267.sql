-- 130859427  
-- 133708328  

select * from cmf_balance where bill_ref_no in (130859427,133708328)

--6534449

select * from bill_invoice_detail where bill_ref_no in (130859427,133708328) and type_code = 7 and subtype_code = 360



select D.DESCRIPTION_TEXT, e.*
   from product P,
              DESCRIPTIONS d,
              product_elements E
         where parent_account_no = 6534449
           and E.ELEMENT_ID = P.ELEMENT_ID
           and P.ELEMENT_ID = D.DESCRIPTION_CODE
           and D.LANGUAGE_CODE = 2
           and P.BILLING_INACTIVE_DT is null
           and TYPE_GROUP_USG <> 0
           

Insert into GVT_DURATION_USG_VARIABLE
   (TYPE_ID_USG, ELEMENT_ID, ACCT_CATEGORY, USG_MIN_RATE_VARIABLE, USG_CADENCE_2, SET_UNITS_2)
 Values
   (360, 11783, 0, 30, 6, 'S');

COMMIT;


         
select * from DESCRIPTIONS where description_code in (11658,11780, 11783, 16360)
and language_code = 2           
           
select v.* from gvt_duration_usg_variable V,
              DESCRIPTIONS D
         where V.ELEMENT_ID = D.DESCRIPTION_CODE
         and type_id_usg = 360 

select * from DESCRIPTIONS

select * from all_tables where table_name like '%USEG%'

 
select * from gvt_duration_usg_variable where TYPE_ID_USG = 360 


select * from customer_id_acct_map where external_id = '999983331035'

select * from cmf_balance where account_no = 4354028


144793732,144788930,144780113,142439516,138151902,126892194,136348943