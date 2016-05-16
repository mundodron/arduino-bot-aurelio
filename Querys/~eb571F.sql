select * from bill_invoice_detail where bill_ref_no = 130859427

select de.description_text,
b.type_id_usg,
       b.point_origin,
       b.point_target,
       b.billed_amount,
       b.billed_base_amt,
       b.amount_credited
  from descriptions de,
       cdr_billed b
 where b.bill_ref_no = 130859427  -- AQUI COLOCAR NR DA FATURA
   and b.bill_ref_resets = 0
   and b.type_id_usg +16000 = de.description_code(+)
   and de.language_code(+) = 2
   and B.TYPE_ID_USG = 360
 order by 2,
          4;
          
          
select bill_fmt_opt from cmf where account_no = 6534449

update cmf set bill_fmt_opt = 2 where account_no = 6534449




select e.*
   from product P,
              DESCRIPTIONS d,
              product_elements E
         where parent_account_no = 6534449
           and E.ELEMENT_ID = P.ELEMENT_ID
           and P.ELEMENT_ID = D.DESCRIPTION_CODE
           and D.LANGUAGE_CODE = 2
           and P.BILLING_INACTIVE_DT is null
           and E.DESCRIPTION_CODE = 11783

select * from gvt_duration_usg_variable where TYPE_ID_USG = 360 and element_id = 11005


Insert into GVT_DURATION_USG_VARIABLE
   (TYPE_ID_USG, ELEMENT_ID, ACCT_CATEGORY, USG_MIN_RATE_VARIABLE, USG_CADENCE_2, SET_UNITS_2)
 Values
   (360, 11783, 0, 30, 6, 'S')
    
COMMIT;

