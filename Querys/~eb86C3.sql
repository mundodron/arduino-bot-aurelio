    SELECT bill_sequence_num,         bill_name_pre,       bill_fname,           bill_minit,              bill_lname,
             bill_title,                bill_company,        bill_address1,        bill_address2,           bill_city,
             bill_state,                bill_zip,            BC.display_value,     contact1_phone,          contact1_name,
             contact2_name,             statement_to_faxno,  bill_fmt_opt,         cust_franchise_tax_code, msg_grp_id,
             insert_grp_id,             c.mkt_code,          p.ownr_lname,         p.card_carrier,          p.card_account, 
             p.card_expire,             purchase_order,      bill_address3,        bill_geocode,            c.language_code,
             bill_country_code,         c.account_category,  statement_to_email,   c.cust_email,            collection_status,
             collection_indicator,      mkv.display_value,   c.rate_class_default, c.bill_disp_meth,        c.date_active,
             c.codeword,                c.remark,            p.pay_method,         p.clearing_house_id,     c.cust_address1,
             c.cust_address2,           c.cust_address3,     c.cust_city,          c.cust_county,           c.cust_state,
             c.cust_zip,                CC.display_value,    c.cust_geocode,       c.cust_phone1,           c.cust_phone2,
             p.cust_bank_sort_code,     p.cust_bank_acc_num, c.account_type,       c.bill_hold_code,        c.parent_id p,
             c.bill_franchise_tax_code, c.account_no,        r.description_code,   cm.external_id,          c.bill_name_generation,
             c.bill_county,             c.hierarchy_id,      c.ssn,                a.is_business
      FROM   CMF c, PAYMENT_PROFILE p, COUNTRY_CODE_VALUES BC, COUNTRY_CODE_VALUES CC, MKT_CODE_VALUES mkv, RATE_CLASS_DESCR r,
             CUSTOMER_ID_ACCT_MAP cm, ACCOUNT_CATEGORY_REF a
      WHERE  (((((((((((((
             c.account_no            = 9318462          )
        AND  c.account_no            = p.account_no       (+) )
        AND  c.payment_profile_id    = p.profile_id       (+) )
        AND  c.bill_country_code     = BC.country_code    (+) )
        AND  c.language_code         = BC.language_code   (+) )
        AND  c.cust_country_code     = CC.country_code    (+) )
        AND  c.language_code         = CC.language_code   (+) )
        AND  c.mkt_code              = mkv.mkt_code       (+) )
        AND  c.language_code         = mkv.language_code  (+) )
        AND  c.rate_class_default    = r.rate_class       (+) )
        AND  c.account_no            = cm.account_no      (+) )
        AND  cm.external_id_type (+) = 1                      )
        AND  c.account_category      = a.account_category (+) )